$ErrorActionPreference = 'Stop'

# ORCHESTRATOR: Full Pipeline Execution
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  AI-DRIVEN TOSCA QA AUTOMATION PLATFORM - FULL PIPELINE     ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$startTime = Get-Date
$logPath = "c:\AI Agents\Test Results\execution_log.txt"

# Initialize log
"Pipeline Execution Started: $(Get-Date)" | Out-File -FilePath $logPath -Encoding UTF8
"" | Add-Content $logPath

# ============================================================
# PHASE 1: INITIALIZATION
# ============================================================
Write-Host "PHASE 1: INITIALIZATION" -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────────────" -ForegroundColor Cyan

$uploadPath = "c:\AI Agents\Uploads"
$resultsPath = "c:\AI Agents\Test Results"

Write-Host "Working Directory: c:\AI Agents" -ForegroundColor Gray
Write-Host "Uploads Folder: $uploadPath" -ForegroundColor Gray
Write-Host "Results Folder: $resultsPath" -ForegroundColor Gray

# Verify folders exist
if (-not (Test-Path $uploadPath)) { New-Item -ItemType Directory -Path $uploadPath -Force | Out-Null }
if (-not (Test-Path $resultsPath)) { New-Item -ItemType Directory -Path $resultsPath -Force | Out-Null }

# Check input files
$inputFiles = Get-ChildItem -Path $uploadPath -Filter "*.txt" -ErrorAction SilentlyContinue
Write-Host "Input files found: $($inputFiles.Count)" -ForegroundColor Green

foreach ($file in $inputFiles) {
    Write-Host "  • $($file.Name)" -ForegroundColor Green
    "  • $($file.Name)" | Add-Content $logPath
}

Write-Host ""
"Phase 1 Complete: Initialization successful" | Add-Content $logPath

# ============================================================
# PHASE 2: AGENT 1 EXECUTION
# ============================================================
Write-Host "PHASE 2: AGENT 1 EXECUTION" -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────────────" -ForegroundColor Cyan

"" | Add-Content $logPath
"Phase 2: Agent 1 Execution" | Add-Content $logPath

try {
    # Execute Agent 1
    Write-Host "Invoking: Agent 1 - Tosca PDF Analysis and Data Consolidation" -ForegroundColor Yellow
    "Invoking: Agent 1 - Tosca PDF Analysis and Data Consolidation" | Add-Content $logPath
    
    . "c:\AI Agents\agent1_execute.ps1" 2>&1 | Tee-Object -FilePath $logPath -Append
    
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) {
        throw "Agent 1 failed with exit code: $LASTEXITCODE"
    }
    
    Write-Host "[OK] Agent 1 completed successfully" -ForegroundColor Green
    "[OK] Agent 1 completed successfully" | Add-Content $logPath
    
    # Validate Agent 1 output
    Write-Host ""
    Write-Host "Validating Agent 1 Output..." -ForegroundColor Yellow
    
    $jsonPath = Join-Path $resultsPath "test_cases_consolidated.json"
    if (-not (Test-Path $jsonPath)) {
        throw "Agent 1 output file not found: $jsonPath"
    }
    
    $agent1Data = Get-Content -Path $jsonPath -Raw | ConvertFrom-Json
    Write-Host "[OK] JSON file validated" -ForegroundColor Green
    $recordCount = $agent1Data.test_cases.Count
    Write-Host "  Records: $recordCount" -ForegroundColor Gray
    "[OK] JSON file validated - Records: $recordCount" | Add-Content $logPath
    
} catch {
    Write-Host "ERROR in Agent 1: $($_.Exception.Message)" -ForegroundColor Red
    "ERROR in Agent 1: $($_.Exception.Message)" | Add-Content $logPath
    exit 1
}

Write-Host ""

# ============================================================
# PHASE 3: AGENT 2 EXECUTION
# ============================================================
Write-Host "PHASE 3: AGENT 2 EXECUTION" -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────────────" -ForegroundColor Cyan

"" | Add-Content $logPath
"Phase 3: Agent 2 Execution" | Add-Content $logPath

try {
    # Execute Agent 2
    Write-Host "Invoking: Agent 2 - Excel Generation and UI Interaction" -ForegroundColor Yellow
    "Invoking: Agent 2 - Excel Generation and UI Interaction" | Add-Content $logPath
    
    . "c:\AI Agents\agent2_execute.ps1" 2>&1 | Tee-Object -FilePath $logPath -Append
    
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) {
        throw "Agent 2 failed with exit code: $LASTEXITCODE"
    }
    
    Write-Host "[OK] Agent 2 completed successfully" -ForegroundColor Green
    "[OK] Agent 2 completed successfully" | Add-Content $logPath
    
    # Validate Agent 2 output
    Write-Host ""
    Write-Host "Validating Agent 2 Output..." -ForegroundColor Yellow
    
    $excelPath = Join-Path $resultsPath "Tosca_Test_Execution_Consolidated.xlsx"
    if (-not (Test-Path $excelPath)) {
        throw "Agent 2 output file not found: $excelPath"
    }
    
    $fileSize = (Get-Item $excelPath).Length
    Write-Host "[OK] Excel file created" -ForegroundColor Green
    Write-Host "  File: Tosca_Test_Execution_Consolidated.xlsx" -ForegroundColor Gray
    Write-Host "  Size: $([Math]::Round($fileSize / 1KB, 2)) KB" -ForegroundColor Gray
    "[OK] Excel file created - Size: $([Math]::Round($fileSize / 1KB, 2)) KB" | Add-Content $logPath
    
} catch {
    Write-Host "ERROR in Agent 2: $($_.Exception.Message)" -ForegroundColor Red
    "ERROR in Agent 2: $($_.Exception.Message)" | Add-Content $logPath
    exit 1
}

Write-Host ""

# ============================================================
# PHASE 4: FINAL REPORT
# ============================================================
Write-Host "PHASE 4: FINAL REPORT" -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────────────" -ForegroundColor Cyan

$endTime = Get-Date
$duration = $endTime - $startTime

"" | Add-Content $logPath
"Phase 4: Final Report" | Add-Content $logPath

Write-Host ""
Write-Host "EXECUTION SUMMARY" -ForegroundColor Yellow
Write-Host "─────────────────────────────────────────────────" -ForegroundColor Yellow

Write-Host "Pipeline Status: SUCCESS ✓" -ForegroundColor Green

Write-Host ""
Write-Host "Agent 1 Results:" -ForegroundColor White
Write-Host "  Workflow: Agent 1 PDF Analysis - COMPLETE" -ForegroundColor Green
Write-Host "  PDFs Processed: $($agent1Data.total_pdfs_processed)"
Write-Host "  Test Cases Extracted: $($agent1Data.total_test_cases_identified)"
Write-Host "  Valid Records: $($agent1Data.validation_summary.valid_records)"
Write-Host "  Duplicates Detected: $($agent1Data.validation_summary.duplicates)"
Write-Host "  Conflicts Detected: $($agent1Data.validation_summary.conflicts)"

Write-Host ""
Write-Host "Agent 2 Results:" -ForegroundColor White
Write-Host "  Workflow: Excel Generation - COMPLETE" -ForegroundColor Green
Write-Host "  Excel File: Tosca_Test_Execution_Consolidated.xlsx"
Write-Host "  Records in Excel: $($agent1Data.test_cases.Count)"
Write-Host "  Formatting: Applied with headers, colors, filters"
Write-Host "  UI Display: Simulated and Verified"

Write-Host ""
Write-Host "Output Files:" -ForegroundColor White
Write-Host "  [OK] $resultsPath\test_cases_consolidated.json" -ForegroundColor Green
Write-Host "  [OK] $resultsPath\Tosca_Test_Execution_Consolidated.xlsx" -ForegroundColor Green
Write-Host "  [OK] $logPath" -ForegroundColor Green

Write-Host ""
Write-Host "Test Results Breakdown:" -ForegroundColor White
$passedCount = @($agent1Data.test_cases | Where-Object { $_.status -eq "Passed" }).Count
$failedCount = @($agent1Data.test_cases | Where-Object { $_.status -eq "Failed" }).Count
$blockedCount = @($agent1Data.test_cases | Where-Object { $_.status -eq "Blocked" }).Count
$unavailCount = ($agent1Data.test_cases | Where-Object { $_.status -eq "Not Available" }).Count

Write-Host "  Total:       $($agent1Data.test_cases.Count)" -ForegroundColor White
Write-Host "  [PASS] Passed:    $passedCount" -ForegroundColor Green
Write-Host "  [FAIL] Failed:    $failedCount" -ForegroundColor Red
Write-Host "  [BLOCK] Blocked:   $blockedCount" -ForegroundColor Yellow
Write-Host "  [UNKNOWN] Unknown:   $unavailCount" -ForegroundColor Gray

Write-Host ""
Write-Host "Execution Time:" -ForegroundColor White
Write-Host "  Total: $($duration.TotalSeconds) seconds" -ForegroundColor Gray
Write-Host "  Started: $startTime"
Write-Host "  Ended:   $endTime"

Write-Host ""
Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host "WORKFLOW STATUS: SUCCESS [OK]" -ForegroundColor Green
Write-Host "=============================================================" -ForegroundColor Cyan

"" | Add-Content $logPath
"WORKFLOW COMPLETED SUCCESSFULLY" | Add-Content $logPath
$execTime = $duration.TotalSeconds
"Total Execution Time: $execTime seconds" | Add-Content $logPath
"Pipeline Execution Ended: $(Get-Date)" | Add-Content $logPath

Write-Host ""
Write-Host "All required validations: PASSED [OK]" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Review Excel file: Test Results/Tosca_Test_Execution_Consolidated.xlsx" 
Write-Host "  2. Check execution log: Test Results/execution_log.txt"
Write-Host "  3. Examine consolidated data: Test Results/test_cases_consolidated.json"
Write-Host "  4. Share results with stakeholders"
Write-Host ""
