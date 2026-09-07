$ErrorActionPreference = 'Stop'

Write-Host ""
Write-Host "AI-DRIVEN TOSCA QA AUTOMATION PLATFORM - FULL PIPELINE" -ForegroundColor Cyan
Write-Host ""

$startTime = Get-Date
$uploadPath = "c:\AI Agents\Uploads"
$resultsPath = "c:\AI Agents\Test Results"
$logPath = Join-Path $resultsPath "execution_log.txt"

"Pipeline Started: $(Get-Date)" | Out-File -FilePath $logPath

Write-Host "Phase 1: Initialization" -ForegroundColor Yellow
if (-not (Test-Path $uploadPath)) { New-Item -ItemType Directory -Path $uploadPath -Force | Out-Null }
if (-not (Test-Path $resultsPath)) { New-Item -ItemType Directory -Path $resultsPath -Force | Out-Null }

$inputFiles = @(Get-ChildItem -Path $uploadPath -Filter "*.txt" -ErrorAction SilentlyContinue)
Write-Host "Input files found: $($inputFiles.Count)"

Write-Host ""
Write-Host "Phase 2: Agent 1 - PDF Analysis" -ForegroundColor Yellow

try {
    Write-Host "Running Agent 1 PDF Analysis..." -ForegroundColor Green
    . "c:\AI Agents\agent1_execute.ps1" 2>&1 | Tee-Object -FilePath $logPath -Append
    Write-Host "Agent 1 completed successfully" -ForegroundColor Green
} catch {
    Write-Host "ERROR in Agent 1: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Phase 3: Agent 2 - Excel Generation" -ForegroundColor Yellow

try {
    Write-Host "Running Agent 2 Excel Generation..." -ForegroundColor Green
    . "c:\AI Agents\agent2_execute.ps1" 2>&1 | Tee-Object -FilePath $logPath -Append
    Write-Host "Agent 2 completed successfully" -ForegroundColor Green
} catch {
    Write-Host "ERROR in Agent 2: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Phase 4: Final Report" -ForegroundColor Yellow

$jsonPath = Join-Path $resultsPath "test_cases_consolidated.json"
$agent1Data = Get-Content -Path $jsonPath -Raw | ConvertFrom-Json

$passedCount = @($agent1Data.test_cases | Where-Object { $_.status -eq "Passed" }).Count
$failedCount = @($agent1Data.test_cases | Where-Object { $_.status -eq "Failed" }).Count
$blockedCount = @($agent1Data.test_cases | Where-Object { $_.status -eq "Blocked" }).Count

Write-Host ""
Write-Host "WORKFLOW RESULTS" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "Total Test Cases: $($agent1Data.test_cases.Count)" -ForegroundColor White
Write-Host "Passed: $passedCount" -ForegroundColor Green
Write-Host "Failed: $failedCount" -ForegroundColor Red
Write-Host "Blocked: $blockedCount" -ForegroundColor Yellow
Write-Host ""
Write-Host "Output Files:" -ForegroundColor White
Write-Host "- JSON: $resultsPath\test_cases_consolidated.json"
Write-Host "- Excel: $resultsPath\Tosca_Test_Execution_Consolidated.xlsx"
Write-Host "- Log: $logPath"
Write-Host ""
Write-Host "STATUS: SUCCESS" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""
