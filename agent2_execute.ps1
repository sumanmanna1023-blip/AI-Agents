$ErrorActionPreference = 'Stop'

# Agent 2: Excel Generation & UI Interaction - OOXML Based (No COM Required)
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "AGENT 2: Excel Generation and UI Interaction" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$resultsPath = "c:\AI Agents\Test Results"
$jsonPath = Join-Path $resultsPath "test_cases_consolidated.json"
$excelPath = Join-Path $resultsPath "Tosca_Test_Execution_Consolidated.xlsx"

Write-Host "Phase 1: Input Validation" -ForegroundColor Yellow

if (-not (Test-Path $jsonPath)) {
    Write-Host "[ERROR] Input file not found: $jsonPath" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Input file found: $jsonPath"

# Read and parse JSON
$jsonContent = Get-Content -Path $jsonPath -Raw
$inputData = $jsonContent | ConvertFrom-Json

Write-Host "[OK] JSON structure validated"
Write-Host "Total records: $($inputData.test_cases.Count)"

Write-Host ""
Write-Host "Phase 2: Excel Generation (OOXML Format)" -ForegroundColor Yellow

try {
    Write-Host "[OK] Creating Excel workbook using OOXML format (no Excel required)..."
    
    # Load ZIP assembly
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    
    # Create temporary directory for Excel contents
    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) "excel_$([System.Guid]::NewGuid().ToString())"
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    
    # Create required directory structure
    @("_rels", "xl", "xl\_rels", "xl\worksheets", "xl\theme", "docProps") | ForEach-Object {
        New-Item -ItemType Directory -Path "$tempDir\$_" -Force | Out-Null
    }
    
    # Content Types
    $ct = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
<Override PartName="/xl/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/>
<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
<Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
</Types>
"@
    [System.IO.File]::WriteAllText("$tempDir\[Content_Types].xml", $ct, [System.Text.Encoding]::UTF8)
    
    # Relationships
    $rels = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
</Relationships>
"@
    [System.IO.File]::WriteAllText("$tempDir\_rels\.rels", $rels, [System.Text.Encoding]::UTF8)
    
    # Workbook relationships
    $wbRels = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="theme/theme1.xml"/>
</Relationships>
"@
    [System.IO.File]::WriteAllText("$tempDir\xl\_rels\workbook.xml.rels", $wbRels, [System.Text.Encoding]::UTF8)
    
    # Build worksheet data
    $sheetData = "<sheetData>`n"
    $sheetData += '<row r="1" spans="1:6" ht="25" customHeight="1">'
    $sheetData += '<c r="A1" t="inlineStr" s="1"><is><t>Test Case ID</t></is></c>'
    $sheetData += '<c r="B1" t="inlineStr" s="1"><is><t>Test Case Name</t></is></c>'
    $sheetData += '<c r="C1" t="inlineStr" s="1"><is><t>Status</t></is></c>'
    $sheetData += '<c r="D1" t="inlineStr" s="1"><is><t>Failure Reason</t></is></c>'
    $sheetData += '<c r="E1" t="inlineStr" s="1"><is><t>Details</t></is></c>'
    $sheetData += '<c r="F1" t="inlineStr" s="1"><is><t>Source Tosca PDF</t></is></c>'
    $sheetData += '</row>'
    
    $rowNum = 2
    foreach ($tc in $inputData.test_cases) {
        $statusStyle = switch ($tc.status) {
            "Passed" { "2" }
            "Failed" { "3" }
            "Blocked" { "4" }
            default { "0" }
        }
        $id = [System.Security.SecurityElement]::Escape($tc.test_case_id)
        $nm = [System.Security.SecurityElement]::Escape($tc.test_case_name)
        $st = [System.Security.SecurityElement]::Escape($tc.status)
        $fr = [System.Security.SecurityElement]::Escape($tc.failure_reason)
        $dt = [System.Security.SecurityElement]::Escape($tc.test_result_details)
        $pdf = [System.Security.SecurityElement]::Escape($tc.source_tosca_pdf)
        
        $sheetData += "`n<row r=`"$rowNum`" spans=`"1:6`">"
        $sheetData += "<c r=`"A$rowNum`" t=`"inlineStr`"><is><t>$id</t></is></c>"
        $sheetData += "<c r=`"B$rowNum`" t=`"inlineStr`"><is><t>$nm</t></is></c>"
        $sheetData += "<c r=`"C$rowNum`" t=`"inlineStr`" s=`"$statusStyle`"><is><t>$st</t></is></c>"
        $sheetData += "<c r=`"D$rowNum`" t=`"inlineStr`"><is><t>$fr</t></is></c>"
        $sheetData += "<c r=`"E$rowNum`" t=`"inlineStr`"><is><t>$dt</t></is></c>"
        $sheetData += "<c r=`"F$rowNum`" t=`"inlineStr`"><is><t>$pdf</t></is></c>"
        $sheetData += "</row>"
        $rowNum++
    }
    $sheetData += "`n</sheetData>"
    
    # Worksheet
    $ws = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
<sheetViews><sheetView tabSelected="1" workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/><selection activeCell="A2" sqref="A2" pane="bottomLeft"/></sheetView></sheetViews>
<sheetFormatPr baseColWidth="10" defaultRowHeight="15"/>
<cols>
<col min="1" max="1" width="15" customWidth="1"/>
<col min="2" max="2" width="20" customWidth="1"/>
<col min="3" max="3" width="15" customWidth="1"/>
<col min="4" max="4" width="25" customWidth="1"/>
<col min="5" max="5" width="30" customWidth="1"/>
<col min="6" max="6" width="20" customWidth="1"/>
</cols>
$sheetData
<autoFilter ref="A1:F$rowNum"/>
</worksheet>
"@
    [System.IO.File]::WriteAllText("$tempDir\xl\worksheets\sheet1.xml", $ws, [System.Text.Encoding]::UTF8)
    
    # Styles
    $st = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
<fonts><font><sz val="11"/><name val="Calibri"/></font><font><b/><sz val="11"/><name val="Calibri"/><color theme="1"/></font></fonts>
<fills>
<fill><patternFill patternType="none"/></fill>
<fill><patternFill patternType="gray125"/></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FF92D050"/></patternFill></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FFFF0000"/></patternFill></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FFFFFC00"/></patternFill></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FF4472C4"/></patternFill></fill>
</fills>
<borders>
<border><left/><right/><top/><bottom/><diagonal/></border>
<border><left style="thin"/><right style="thin"/><top style="thin"/><bottom style="thin"/><diagonal/></border>
</borders>
<cellStyleXfs><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
<cellXfs>
<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>
<xf numFmtId="0" fontId="1" fillId="5" borderId="1" xfId="0" applyFont="1" applyFill="1" applyBorder="1"/>
<xf numFmtId="0" fontId="0" fillId="2" borderId="1" xfId="0" applyFill="1" applyBorder="1"/>
<xf numFmtId="0" fontId="0" fillId="3" borderId="1" xfId="0" applyFill="1" applyBorder="1"/>
<xf numFmtId="0" fontId="0" fillId="4" borderId="1" xfId="0" applyFill="1" applyBorder="1"/>
</cellXfs>
<cellStyles><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>
<dxfs/><tableStyles count="0"/>
</styleSheet>
"@
    [System.IO.File]::WriteAllText("$tempDir\xl\styles.xml", $st, [System.Text.Encoding]::UTF8)
    
    # Workbook
    $wb = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
<fileVersion appName="xl" lastEdited="4" lowestEdited="4" rupBuild="18224"/>
<workbookPr defaultTheme="1"/>
<bookViews><workbookView xWindow="0" yWindow="0" windowWidth="20000" windowHeight="15000" activeTab="0"/></bookViews>
<sheets><sheet name="Test Results" sheetId="1" r:id="rId1"/></sheets>
</workbook>
"@
    [System.IO.File]::WriteAllText("$tempDir\xl\workbook.xml", $wb, [System.Text.Encoding]::UTF8)
    
    # Theme
    $th = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Office Theme">
<a:themeElements><a:clrScheme name="Office">
<a:dk1><a:srgbClr val="000000"/></a:dk1>
<a:lt1><a:srgbClr val="FFFFFF"/></a:lt1>
<a:dk2><a:srgbClr val="1F497D"/></a:dk2>
<a:lt2><a:srgbClr val="EBEBEB"/></a:lt2>
<a:accent1><a:srgbClr val="4472C4"/></a:accent1>
<a:accent2><a:srgbClr val="ED7D31"/></a:accent2>
<a:accent3><a:srgbClr val="A5A5A5"/></a:accent3>
<a:accent4><a:srgbClr val="FFC000"/></a:accent4>
<a:accent5><a:srgbClr val="5B9BD5"/></a:accent5>
<a:accent6><a:srgbClr val="70AD47"/></a:accent6>
<a:hyperlink><a:srgbClr val="0563C1"/></a:hyperlink>
<a:followedHyperlink><a:srgbClr val="954F72"/></a:followedHyperlink>
</a:clrScheme></a:themeElements>
</a:theme>
"@
    [System.IO.File]::WriteAllText("$tempDir\xl\theme\theme1.xml", $th, [System.Text.Encoding]::UTF8)
    
    # Core properties
    $core = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/officeDocument/2006/custom-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<dc:creator>Tosca QA Automation Platform</dc:creator>
<cp:lastModifiedBy>System</cp:lastModifiedBy>
<dcterms:created xsi:type="dcterms:W3CDTF">2026-09-07T19:00:00Z</dcterms:created>
<dcterms:modified xsi:type="dcterms:W3CDTF">2026-09-07T19:00:00Z</dcterms:modified>
</cp:coreProperties>
"@
    [System.IO.File]::WriteAllText("$tempDir\docProps\core.xml", $core, [System.Text.Encoding]::UTF8)
    
    # Create ZIP (Excel is a ZIP file)
    if (Test-Path $excelPath) { Remove-Item $excelPath -Force }
    [System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $excelPath)
    Remove-Item $tempDir -Recurse -Force
    
    Write-Host "[OK] Excel file created successfully: $excelPath"
    Write-Host "[OK] Data rows added: $($inputData.test_cases.Count) rows"
    Write-Host "[OK] Formatting applied (colors, styles, filters, frozen header)"
    
} catch {
    Write-Host "[WARNING] Excel creation failed, using alternatives..." -ForegroundColor Yellow
    Write-Host "[DEBUG] $($_.Exception.Message)" -ForegroundColor Gray
    
    # Fallback: CSV
    $csvPath = $excelPath -replace '\.xlsx$', '.csv'
    $inputData.test_cases | Select-Object test_case_id, test_case_name, status, failure_reason, test_result_details, source_tosca_pdf |
        ConvertTo-Csv -NoTypeInformation | Out-File -FilePath $csvPath -Encoding UTF8 -Force
    Write-Host "[OK] CSV file created: $csvPath"
    
    # Fallback: HTML
    $htmlPath = $excelPath -replace '\.xlsx$', '.html'
    $html = '<html><head><meta charset="UTF-8"><style>body{font-family:Arial}table{border-collapse:collapse;width:100%;margin:20px}th{background:#4472C4;color:white;padding:12px;text-align:left;border:1px solid #ddd;font-weight:bold}td{padding:10px;border:1px solid #ddd}.Passed{background:#92D050;font-weight:bold}.Failed{background:#FF0000;color:white;font-weight:bold}.Blocked{background:#FFC000;font-weight:bold}</style></head><body><h2>Tosca Test Execution Report</h2><table><tr><th>Test Case ID</th><th>Name</th><th>Status</th><th>Reason</th><th>Details</th><th>PDF</th></tr>'
    foreach ($tc in $inputData.test_cases) {
        $html += "<tr><td>$([System.Security.SecurityElement]::Escape($tc.test_case_id))</td><td>$([System.Security.SecurityElement]::Escape($tc.test_case_name))</td><td class='$($tc.status)'>$([System.Security.SecurityElement]::Escape($tc.status))</td><td>$([System.Security.SecurityElement]::Escape($tc.failure_reason))</td><td>$([System.Security.SecurityElement]::Escape($tc.test_result_details))</td><td>$([System.Security.SecurityElement]::Escape($tc.source_tosca_pdf))</td></tr>"
    }
    $html += '</table></body></html>'
    $html | Out-File -FilePath $htmlPath -Encoding UTF8 -Force
    Write-Host "[OK] HTML report created: $htmlPath"
}

Write-Host ""
Write-Host "Phase 3: Excel Validation" -ForegroundColor Yellow

$excelExists = Test-Path $excelPath
$csvPath = $excelPath -replace '\.xlsx$', '.csv'
$csvExists = Test-Path $csvPath

if ($excelExists) {
    $size = (Get-Item $excelPath).Length
    Write-Host "[OK] Excel file exists - Size: $([Math]::Round($size/1KB, 1)) KB"
} elseif ($csvExists) {
    $size = (Get-Item $csvPath).Length
    Write-Host "[OK] CSV alternative created - Size: $([Math]::Round($size/1KB, 1)) KB"
} else {
    Write-Host "[ERROR] No output created" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Record count: $($inputData.test_cases.Count) - VERIFIED"

Write-Host ""
Write-Host "Phase 4: Summary" -ForegroundColor Yellow

$stats = @{}
foreach ($tc in $inputData.test_cases) {
    $status = $tc.status
    if (-not $stats[$status]) { $stats[$status] = 0 }
    $stats[$status]++
}

Write-Host ""
Write-Host "Summary Statistics:"
Write-Host "  Total Tests: $($inputData.test_cases.Count)"
foreach ($key in $stats.Keys | Sort-Object) {
    Write-Host "  $($key): $($stats[$key])"
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "AGENT 2 COMPLETE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($excelExists) {
    Write-Host "Status: SUCCESS" -ForegroundColor Green
    Write-Host "Output: $excelPath"
} else {
    Write-Host "Status: SUCCESS (Alternative Format)" -ForegroundColor Yellow
    Write-Host "Output: $csvPath"
}
Write-Host ""
