$ErrorActionPreference = 'Stop'

# Executes Prompt/Prompt.md against the PDF reports in Uploads.  The PDFs are
# the only input source; extracted text is held in memory and never used as an
# independent input file.
$rootPath = $PSScriptRoot
$uploadsPath = Join-Path $rootPath 'Uploads'
$resultsPath = Join-Path $rootPath 'Test Results'
$jsonPath = Join-Path $resultsPath 'test_cases_consolidated.json'
$excelPath = Join-Path $resultsPath 'Consolidated_Tosca_Test_Execution_Report.xlsx'
$logPath = Join-Path $resultsPath 'execution_log.txt'
$pdfToText = 'C:\Program Files\Git\mingw64\bin\pdftotext.exe'
$na = 'Not Available'

New-Item -ItemType Directory -Path $resultsPath -Force | Out-Null
"Pipeline started: $(Get-Date -Format o)" | Set-Content -Path $logPath -Encoding utf8

if (-not (Test-Path -LiteralPath $pdfToText)) { throw "PDF reader not found: $pdfToText" }
$pdfFiles = @(Get-ChildItem -LiteralPath $uploadsPath -File -Filter '*.pdf' | Sort-Object Name)
if ($pdfFiles.Count -eq 0) { throw 'No Tosca PDF reports were found in the Uploads folder.' }

function Get-XmlText([string]$value) {
    if ($null -eq $value) { return '' }
    return [System.Security.SecurityElement]::Escape($value)
}

function Get-Cell([string]$ref, [string]$value, [int]$style = 0) {
    $escaped = Get-XmlText $value
    return "<c r=`"$ref`" t=`"inlineStr`" s=`"$style`"><is><t xml:space=`"preserve`">$escaped</t></is></c>"
}

function Get-FormulaCell([string]$ref, [string]$formula) {
    return "<c r=`"$ref`" s=`"6`"><f>$formula</f></c>"
}

$records = @()
$errors = @()
foreach ($pdf in $pdfFiles) {
    try {
        # -layout retains the report's heading/status alignment and all pages are read.
        $text = (& $pdfToText -layout $pdf.FullName - 2>$null) -join "`n"
        if ([string]::IsNullOrWhiteSpace($text)) { throw 'No extractable text was returned; OCR is required.' }

        $statusMatch = [regex]::Match($text, '(?im)^\s*(Passed|Failed|Blocked|Skipped|Not Executed|In Progress)\s+\d+\s+')
        $status = if ($statusMatch.Success) { (Get-Culture).TextInfo.ToTitleCase($statusMatch.Groups[1].Value.ToLowerInvariant()) } else { $na }
        $caseMatch = [regex]::Match($text, '(?m)^(?<name>[^\r\n]+?)\s{2,}(?<status>PASSED|FAILED|BLOCKED|SKIPPED|NOT EXECUTED|IN PROGRESS)\s*$')
        $testCaseName = if ($caseMatch.Success) { $caseMatch.Groups['name'].Value.Trim() } else { $na }
        if ($caseMatch.Success -and $status -eq $na) { $status = (Get-Culture).TextInfo.ToTitleCase($caseMatch.Groups['status'].Value.ToLowerInvariant()) }

        $started = [regex]::Match($text, '(?m)^Started:\s*(?<value>.+?)(?:\s{2,}Executed by|$)')
        $ended = [regex]::Match($text, '(?m)^Ended:\s*(?<value>.+?)\s*$')
        $executedBy = [regex]::Match($text, 'Executed by\s+(?<value>[^\r\n]+)')
        $detailParts = @()
        if ($started.Success) { $detailParts += "Started: $($started.Groups['value'].Value.Trim())" }
        if ($ended.Success) { $detailParts += "Ended: $($ended.Groups['value'].Value.Trim())" }
        if ($executedBy.Success) { $detailParts += "Executed by: $($executedBy.Groups['value'].Value.Trim())" }
        $details = if ($detailParts.Count) { $detailParts -join '; ' } else { $na }

        # A failure reason is recorded only when the report explicitly labels one.
        $reasonMatch = [regex]::Match($text, '(?im)^(?:Failure Reason|Error Message|Exception):\s*(?<value>.+?)\s*$')
        $failureReason = if ($reasonMatch.Success) { $reasonMatch.Groups['value'].Value.Trim() } else { $na }
        $records += [pscustomobject][ordered]@{
            sctask_id = $na
            test_case_id = $na
            test_case_name = $testCaseName
            status = $status
            failure_reason = $failureReason
            test_result_details = $details
            source_tosca_pdf = $pdf.Name
        }
        "Processed $($pdf.Name): $testCaseName [$status]" | Add-Content -Path $logPath -Encoding utf8
    } catch {
        $errors += [pscustomobject]@{ pdf_filename = $pdf.Name; processing_status = 'Failed'; error = $_.Exception.Message }
        "Failed $($pdf.Name): $($_.Exception.Message)" | Add-Content -Path $logPath -Encoding utf8
    }
}

if ($records.Count -eq 0) { throw 'Every Tosca PDF report failed processing; no Excel report was generated.' }

# The PDFs have no stated IDs, so only records with stated IDs participate in duplicate/conflict comparison.
$duplicates = @()
$conflicts = @()
$identified = $records | Where-Object { $_.test_case_id -ne $na }
foreach ($group in @($identified | Group-Object test_case_id, test_case_name)) {
    if ($group.Count -gt 1) {
        $statuses = @($group.Group.status | Select-Object -Unique)
        if ($statuses.Count -gt 1) { $conflicts += $group.Name } else { $duplicates += $group.Name }
    }
}

$output = [pscustomobject][ordered]@{
    pdf_files_processed = $pdfFiles.Count
    pdf_files_failed = $errors.Count
    test_cases_consolidated = $records.Count
    test_cases = $records
    duplicates_detected = $duplicates
    conflicts_detected = $conflicts
    errors = $errors
}
$output | ConvertTo-Json -Depth 6 | Set-Content -Path $jsonPath -Encoding utf8

# Create a standards-compliant, self-contained OOXML workbook without requiring Excel.
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression
$tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("tosca_excel_" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path "$tempDir\_rels", "$tempDir\xl\_rels", "$tempDir\xl\worksheets", "$tempDir\docProps" -Force | Out-Null

$header = @('SCTASK ID','Test Case ID','Test Case Name','Status','Failure Reason','Test Result Details','Source Tosca PDF')
$sheetRows = '<sheetData>'
$sheetRows += '<row r="1" ht="28" customHeight="1">'
for ($c = 0; $c -lt $header.Count; $c++) { $sheetRows += Get-Cell ([char](65 + $c) + '1') $header[$c] 1 }
$sheetRows += '</row>'
$row = 2
foreach ($record in $records) {
    $sheetRows += "<row r=`"$row`" ht=`"48`" customHeight=`"1`">"
    $values = @($record.sctask_id,$record.test_case_id,$record.test_case_name,$record.status,$record.failure_reason,$record.test_result_details,$record.source_tosca_pdf)
    for ($c = 0; $c -lt $values.Count; $c++) {
        $style = if ($c -eq 3) { switch ($record.status) { 'Passed' { 2 }; 'Failed' { 3 }; 'Blocked' { 4 }; default { 5 } } } else { 0 }
        $sheetRows += Get-Cell ([char](65 + $c) + $row) $values[$c] $style
    }
    $sheetRows += '</row>'
    $row++
}
$sheetRows += '</sheetData>'
$lastRow = $row - 1

$summaryRows = '<sheetData><row r="1" ht="28" customHeight="1">' + (Get-Cell 'A1' 'Metric' 1) + (Get-Cell 'B1' 'Calculated Count' 1) + '</row>'
$metrics = @('Total Test Cases','Passed','Failed','Blocked','Skipped','Not Executed','Not Available','Conflict / Review Required')
for ($i = 0; $i -lt $metrics.Count; $i++) {
    $summaryRow = $i + 2
    $formula = if ($i -eq 0) { "COUNTA('Test Execution Results'!D2:D$lastRow)" } else { "COUNTIF('Test Execution Results'!D2:D$lastRow,`"$($metrics[$i])`")" }
    $summaryRows += "<row r=`"$summaryRow`">" + (Get-Cell "A$summaryRow" $metrics[$i]) + (Get-FormulaCell "B$summaryRow" $formula) + '</row>'
}
$summaryRows += '</sheetData>'

[IO.File]::WriteAllText("$tempDir\[Content_Types].xml", @"
<?xml version="1.0" encoding="UTF-8"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/><Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/><Override PartName="/xl/worksheets/sheet2.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/><Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/><Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/></Types>
"@, [Text.Encoding]::UTF8)
[IO.File]::WriteAllText("$tempDir\_rels\.rels", '<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/><Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/></Relationships>', [Text.Encoding]::UTF8)
[IO.File]::WriteAllText("$tempDir\xl\_rels\workbook.xml.rels", '<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/><Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet2.xml"/><Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/></Relationships>', [Text.Encoding]::UTF8)
[IO.File]::WriteAllText("$tempDir\xl\workbook.xml", '<?xml version="1.0" encoding="UTF-8"?><workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><calcPr calcMode="auto" fullCalcOnLoad="1"/><sheets><sheet name="Test Execution Results" sheetId="1" r:id="rId1"/><sheet name="Summary" sheetId="2" r:id="rId2"/></sheets></workbook>', [Text.Encoding]::UTF8)
[IO.File]::WriteAllText("$tempDir\xl\worksheets\sheet1.xml", "<?xml version=`"1.0`" encoding=`"UTF-8`"?><worksheet xmlns=`"http://schemas.openxmlformats.org/spreadsheetml/2006/main`"><sheetViews><sheetView workbookViewId=`"0`"><pane ySplit=`"1`" topLeftCell=`"A2`" state=`"frozen`"/></sheetView></sheetViews><sheetFormatPr defaultRowHeight=`"15`"/><cols><col min=`"1`" max=`"2`" width=`"18`" customWidth=`"1`"/><col min=`"3`" max=`"3`" width=`"42`" customWidth=`"1`"/><col min=`"4`" max=`"4`" width=`"18`" customWidth=`"1`"/><col min=`"5`" max=`"5`" width=`"32`" customWidth=`"1`"/><col min=`"6`" max=`"6`" width=`"62`" customWidth=`"1`"/><col min=`"7`" max=`"7`" width=`"22`" customWidth=`"1`"/></cols>$sheetRows<autoFilter ref=`"A1:G$lastRow`"/></worksheet>", [Text.Encoding]::UTF8)
[IO.File]::WriteAllText("$tempDir\xl\worksheets\sheet2.xml", "<?xml version=`"1.0`" encoding=`"UTF-8`"?><worksheet xmlns=`"http://schemas.openxmlformats.org/spreadsheetml/2006/main`"><sheetViews><sheetView workbookViewId=`"0`"><pane ySplit=`"1`" topLeftCell=`"A2`" state=`"frozen`"/></sheetView></sheetViews><cols><col min=`"1`" max=`"1`" width=`"32`" customWidth=`"1`"/><col min=`"2`" max=`"2`" width=`"20`" customWidth=`"1`"/></cols>$summaryRows</worksheet>", [Text.Encoding]::UTF8)
[IO.File]::WriteAllText("$tempDir\xl\styles.xml", '<?xml version="1.0" encoding="UTF-8"?><styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><fonts count="2"><font><sz val="11"/><name val="Calibri"/></font><font><b/><sz val="11"/><color rgb="FFFFFFFF"/><name val="Calibri"/></font></fonts><fills count="6"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill><fill><patternFill patternType="solid"><fgColor rgb="FF1F4E78"/></patternFill></fill><fill><patternFill patternType="solid"><fgColor rgb="FFC6EFCE"/></patternFill></fill><fill><patternFill patternType="solid"><fgColor rgb="FFFFC7CE"/></patternFill></fill><fill><patternFill patternType="solid"><fgColor rgb="FFFFEB9C"/></patternFill></fill></fills><borders count="2"><border><left/><right/><top/><bottom/><diagonal/></border><border><left style="thin"/><right style="thin"/><top style="thin"/><bottom style="thin"/><diagonal/></border></borders><cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs><cellXfs count="7"><xf numFmtId="0" fontId="0" fillId="0" borderId="1" xfId="0" applyBorder="1" applyAlignment="1"><alignment vertical="top" wrapText="1"/></xf><xf numFmtId="0" fontId="1" fillId="2" borderId="1" xfId="0" applyFont="1" applyFill="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="center" wrapText="1"/></xf><xf numFmtId="0" fontId="0" fillId="3" borderId="1" xfId="0" applyFill="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="top" wrapText="1"/></xf><xf numFmtId="0" fontId="0" fillId="4" borderId="1" xfId="0" applyFill="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="top" wrapText="1"/></xf><xf numFmtId="0" fontId="0" fillId="5" borderId="1" xfId="0" applyFill="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="top" wrapText="1"/></xf><xf numFmtId="0" fontId="0" fillId="5" borderId="1" xfId="0" applyFill="1" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="top" wrapText="1"/></xf><xf numFmtId="0" fontId="0" fillId="0" borderId="1" xfId="0" applyBorder="1" applyAlignment="1"><alignment horizontal="center" vertical="top"/></xf></cellXfs></styleSheet>', [Text.Encoding]::UTF8)
[IO.File]::WriteAllText("$tempDir\docProps\core.xml", '<?xml version="1.0" encoding="UTF-8"?><cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/"><dc:creator>Tosca PDF QA Automation Agent</dc:creator></cp:coreProperties>', [Text.Encoding]::UTF8)

if (Test-Path $excelPath) { Remove-Item -LiteralPath $excelPath -Force }
# An OPC/Excel package requires forward-slash part names.  Create entries
# explicitly because CreateFromDirectory on Windows writes backslashes.
$outputArchive = [System.IO.Compression.ZipFile]::Open($excelPath, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($sourceFile in @(Get-ChildItem -LiteralPath $tempDir -Recurse -File)) {
        $relativePath = $sourceFile.FullName.Substring($tempDir.Length + 1).Replace('\', '/')
        $entry = $outputArchive.CreateEntry($relativePath, [System.IO.Compression.CompressionLevel]::Optimal)
        $entryStream = $entry.Open()
        $sourceStream = [IO.File]::OpenRead($sourceFile.FullName)
        try { $sourceStream.CopyTo($entryStream) } finally { $sourceStream.Dispose(); $entryStream.Dispose() }
    }
} finally { $outputArchive.Dispose() }
Remove-Item -LiteralPath $tempDir -Recurse -Force

# Validate package, sheet names, required headers, row count, and final-file presence.
$archive = [IO.Compression.ZipFile]::OpenRead($excelPath)
try {
    $workbookEntry = $archive.GetEntry('xl/workbook.xml')
    $sheetEntry = $archive.GetEntry('xl/worksheets/sheet1.xml')
    if ($null -eq $workbookEntry -or $null -eq $sheetEntry) { throw 'Workbook package validation failed.' }
    $workbookStream = $workbookEntry.Open(); $workbookReader = New-Object IO.StreamReader($workbookStream); $workbook = $workbookReader.ReadToEnd(); $workbookReader.Dispose()
    $sheetStream = $sheetEntry.Open(); $sheetReader = New-Object IO.StreamReader($sheetStream); $sheet = $sheetReader.ReadToEnd(); $sheetReader.Dispose()
    if ($workbook -notmatch 'Test Execution Results' -or $workbook -notmatch 'Summary') { throw 'Workbook sheet validation failed.' }
    foreach ($column in $header) { if ($sheet -notmatch [regex]::Escape($column)) { throw "Required column is missing: $column" } }
    if (($sheet | Select-String -AllMatches '<row r=').Matches.Count -ne ($records.Count + 1)) { throw 'Record-count validation failed.' }
} finally { $archive.Dispose() }
"Pipeline completed: $(Get-Date -Format o)" | Add-Content -Path $logPath -Encoding utf8
Write-Host "Excel report: $excelPath"
Write-Host "PDF files processed: $($pdfFiles.Count); Test cases consolidated: $($records.Count)"
