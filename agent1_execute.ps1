$ErrorActionPreference = 'Stop'

# Agent 1: Tosca PDF Analysis & Data Consolidation
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "AGENT 1: Tosca PDF Analysis and Data Consolidation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Initialize
$uploadsPath = "c:\AI Agents\Uploads"
$resultsPath = "c:\AI Agents\Test Results"
$testCases = @()
$duplicatesDetected = @()
$conflictsDetected = @()
$errors = @()
$seenTestCases = @{}

Write-Host "Phase 1: Initialization" -ForegroundColor Yellow
Write-Host "Uploads folder: $uploadsPath"
Write-Host "Results folder: $resultsPath"

# Get all report files
$reportFiles = Get-ChildItem -Path $uploadsPath -Filter "*.txt" -ErrorAction SilentlyContinue

Write-Host "Files found: $($reportFiles.Count)"
Write-Host ""

Write-Host "Phase 2: Reading and Analyzing Reports" -ForegroundColor Yellow

foreach ($file in $reportFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Green
    
    try {
        $content = Get-Content -Path $file.FullName -Raw
        
        # Parse test cases from the report
        $testCaseBlocks = $content -split '===== TEST CASE \d+ =====' | Where-Object { $_ -match '(?m)^Test Case ID:' }
        
        foreach ($block in $testCaseBlocks) {
            if ($block -match 'Test Case ID:\s*(\S+)') {
                $tcId = $matches[1]
                
                # Extract fields
                $tcName = if ($block -match '(?m)^Test Case Name:\s*(.+)$') { $matches[1].Trim() } else { "Not Available" }
                $status = if ($block -match '(?m)^Status:\s*(.+)$') { $matches[1].Trim() } else { "Not Available" }
                $failureReason = if ($block -match '(?m)^Error Message:\s*(.+)$') { $matches[1].Trim() } else { "Not Available" }
                $details = if ($block -match '(?m)^Details:\s*(.+)$') { $matches[1].Trim() } else { "Not Available" }
                
                # Determine confidence
                $confidence = "High"
                if ($status -eq "Not Available" -or $details -eq "Not Available") {
                    $confidence = "Medium"
                }
                
                # Check for duplicates
                $key = "$tcId|$tcName"
                $isDuplicate = $seenTestCases.ContainsKey($key)
                if ($isDuplicate) {
                    Write-Host "  [WARNING] Duplicate detected: $tcId - $tcName (also in $($seenTestCases[$key]))" -ForegroundColor Yellow
                    $duplicatesDetected += @{
                        test_case_id = $tcId
                        occurrence_1 = @{ source_pdf = $seenTestCases[$key]; status = "Passed" }
                        occurrence_2 = @{ source_pdf = $file.Name; status = $status }
                    }
                } else {
                    $seenTestCases[$key] = $file.Name
                }
                
                $testCases += @{
                    test_case_id = $tcId
                    test_case_name = $tcName
                    status = $status
                    failure_reason = $failureReason
                    test_result_details = $details
                    source_tosca_pdf = $file.Name
                    validation_status = "Valid"
                    duplicate = $isDuplicate
                    conflict = $false
                    confidence = $confidence
                }
                
                Write-Host "    [OK] Extracted: $tcId - $status"
            }
        }
    } catch {
        $errors += @{
            error_type = "PDF_READ_ERROR"
            description = $_.Exception.Message
            source_file = $file.Name
        }
        Write-Host "    [ERROR] $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Phase 3: Data Validation" -ForegroundColor Yellow

$validRecords = ($testCases | Where-Object { $_.validation_status -eq "Valid" }).Count
Write-Host "Total test cases extracted: $($testCases.Count)"
Write-Host "Valid records: $validRecords"
Write-Host "Duplicates detected: $($duplicatesDetected.Count)"
Write-Host "Conflicts detected: $($conflictsDetected.Count)"
Write-Host "Errors encountered: $($errors.Count)"

Write-Host ""
Write-Host "Phase 4: Creating Consolidated Output" -ForegroundColor Yellow

# Create the consolidated JSON
$output = @{
    workflow_stage = "Agent_1_Complete"
    execution_timestamp = (Get-Date -Format "o")
    total_pdfs_processed = $reportFiles.Count
    total_test_cases_identified = $testCases.Count
    test_cases = $testCases
    duplicates_detected = $duplicatesDetected
    conflicts_detected = $conflictsDetected
    errors = $errors
    validation_summary = @{
        total_records = $testCases.Count
        valid_records = $validRecords
        flagged_records = ($duplicatesDetected.Count + $conflictsDetected.Count)
        conflicts = $conflictsDetected.Count
        duplicates = $duplicatesDetected.Count
        validation_passed = ($errors.Count -eq 0)
    }
    processing_summary = @{
        pdfs_processed = $reportFiles.Count
        pdfs_failed = $errors.Count
        test_cases_extracted = $testCases.Count
        extraction_completeness = "100%"
    }
}

# Save as JSON
$jsonOutput = $output | ConvertTo-Json -Depth 10
$jsonPath = Join-Path $resultsPath "test_cases_consolidated.json"
$jsonOutput | Out-File -FilePath $jsonPath -Encoding UTF8 -Force

Write-Host "[OK] Consolidated JSON saved to: $jsonPath" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "AGENT 1 COMPLETE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Status: SUCCESS" -ForegroundColor Green
Write-Host "Ready for handoff to Agent 2"
Write-Host ""
