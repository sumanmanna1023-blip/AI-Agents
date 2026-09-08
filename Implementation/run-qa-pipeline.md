# RUN-QA-PIPELINE ORCHESTRATOR GUIDE
## Complete Workflow Execution & Validation

---

## OVERVIEW

The QA Pipeline is a 4-phase orchestrated workflow that:

1. **Phase 1 - Initialization**: Prepare directories and verify prerequisites
2. **Phase 2 - Agent 1 Execution**: Analyze Tosca PDFs and consolidate data
3. **Phase 3 - Agent 2 Execution**: Generate and validate Excel report
4. **Phase 4 - Final Reporting**: Summarize results and verify success

---

## PHASE 1: INITIALIZATION

### Objective
Prepare system for processing and verify all prerequisites.

### Steps

1. **Create/Verify Uploads Directory**
   - Path: `c:\AI Agents\Uploads\`
   - Action: Create if missing
   - Ensure readable/writable

2. **Create/Verify Test Results Directory**
   - Path: `c:\AI Agents\Test Results\`
   - Action: Create if missing
   - Ensure readable/writable

3. **Initialize Logging**
   - Create execution log: `c:\AI Agents\Test Results\execution_log.txt`
   - Timestamp start: `[YYYY-MM-DD HH:MM:SS] Pipeline Started`

4. **Verify Prerequisites**
   - Check Uploads folder accessible
   - Check Test Results folder writable
   - Check PowerShell version (5.1+)
   - Check .NET Framework (if needed)

5. **Verify Input Files**
   - Scan for PDF files in Uploads
   - Count found PDFs
   - Log: "PDF files found: [count]"
   - If count = 0: Log warning but continue (will handle gracefully)

### Success Criteria
- ✓ Uploads folder exists and accessible
- ✓ Test Results folder exists and writable
- ✓ Execution log created
- ✓ All prerequisites verified

### Failure Handling
- If directories don't exist: Create them
- If write permission denied: Log error and stop
- If no PDFs found: Continue (Agent 1 will report)

---

## PHASE 2: AGENT 1 EXECUTION

### Objective
Process Tosca PDFs and generate consolidated JSON data.

### Execution Command
```powershell
& "c:\AI Agents\agent1_execute.ps1"
```

### Expected Behavior

**Agent 1 Actions:**
1. Discover all PDF files in Uploads folder
2. Read each PDF (all pages)
3. Extract test case information
4. Determine status for each test case
5. Extract failure reasons
6. Extract execution details
7. Normalize data
8. Detect duplicates
9. Detect conflicts
10. Validate consolidated data
11. Create JSON output: `test_cases_consolidated.json`

**Agent 1 Output:**
- File: `c:\AI Agents\Test Results\test_cases_consolidated.json`
- Format: Valid JSON
- Contains: Complete consolidated dataset with metadata

**Agent 1 Logging:**
- Output status to console (real-time visibility)
- Log to execution_log.txt (persistent record)
- Report processing phase completion

### Success Criteria
- ✓ All PDFs processed or errors logged
- ✓ Test cases extracted: [count]
- ✓ JSON file created successfully
- ✓ JSON structure valid
- ✓ All required fields present
- ✓ Validation passed
- ✓ Ready for Agent 2

### Expected Output Example
```
========================================
AGENT 1: Tosca PDF Analysis
========================================

Phase 1: Initialization
  Uploads folder: c:\AI Agents\Uploads
  Results folder: c:\AI Agents\Test Results
  Files found: 3

Phase 2: Reading and Analyzing Reports
  Processing: TC-001.pdf
    [OK] Extracted: 3 test cases
  Processing: TC-002.pdf
    [OK] Extracted: 4 test cases
  Processing: TC-003.pdf
    [OK] Extracted: 2 test cases

Phase 3: Data Validation
  Total test cases extracted: 9
  Valid records: 9
  Duplicates detected: 0
  Conflicts detected: 0
  Errors encountered: 0

Phase 4: Creating Consolidated Output
  [OK] Consolidated JSON saved

========================================
AGENT 1 COMPLETE
Status: SUCCESS
Ready for handoff to Agent 2
========================================
```

### Error Handling
- If PDF fails to read: Log error, continue with others
- If extraction fails: Mark with error, continue
- If all PDFs fail: Generate empty report with error log
- If JSON creation fails: Stop and report error

---

## PHASE 3: AGENT 2 EXECUTION

### Objective
Generate professional Excel report from consolidated JSON data.

### Pre-execution Validation
Before starting Agent 2:
- [ ] test_cases_consolidated.json exists
- [ ] JSON file is readable
- [ ] JSON structure is valid
- [ ] Test cases array present
- [ ] At least 1 record to process

### Execution Command
```powershell
& "c:\AI Agents\agent2_execute.ps1"
```

### Expected Behavior

**Agent 2 Actions:**
1. Validate JSON input
2. Read JSON data
3. Create Excel workbook
4. Create "Test Execution Results" worksheet
5. Add headers and data
6. Format headers (bold, colored)
7. Apply status-based cell coloring
8. Create "Summary" worksheet
9. Add calculated summary statistics
10. Apply filtering and formatting
11. Validate Excel workbook
12. Verify all data present
13. Save Excel file
14. Final validation

**Agent 2 Output:**
- File: `c:\AI Agents\Test Results\Consolidated_Tosca_Test_Execution_Report.xlsx`
- Format: Excel 2007+ (.xlsx)
- Contains: Two worksheets (Test Execution Results, Summary)

**Agent 2 Logging:**
- Output status to console (real-time visibility)
- Log to execution_log.txt (persistent record)
- Report validation results

### Success Criteria
- ✓ Excel workbook created
- ✓ All worksheets present
- ✓ All columns present
- ✓ All data rows present
- ✓ All values match source JSON
- ✓ Formatting applied
- ✓ Summary worksheet created
- ✓ Validation passed
- ✓ File is readable

### Expected Output Example
```
========================================
AGENT 2: Excel Generation
========================================

Phase 1: Input Validation
  [OK] Input file found
  [OK] JSON structure validated
  Total records: 9

Phase 2: Excel Generation
  [OK] Workbook created
  [OK] Worksheet created
  [OK] Headers added
  [OK] Data rows added: 9 rows
  [OK] Formatting applied
  [OK] Summary worksheet created

Phase 3: Excel Validation
  [OK] Workbook exists
  [OK] All records present: 9 of 9
  [OK] Data integrity verified
  [OK] Formatting verified

========================================
AGENT 2 COMPLETE
Status: SUCCESS
========================================
```

### Error Handling
- If JSON invalid: Stop and report error
- If Excel creation fails: Try alternative format (CSV)
- If validation fails: Regenerate and validate again
- Comprehensive error reporting

---

## PHASE 4: FINAL REPORTING

### Objective
Summarize execution and verify overall success.

### Steps

1. **Read Consolidated Data**
   - Load test_cases_consolidated.json
   - Count total test cases
   - Count Passed
   - Count Failed
   - Count Blocked
   - Count other statuses

2. **Verify Output Files**
   - Verify JSON file exists
   - Verify Excel file exists
   - Verify execution log exists

3. **Generate Summary Report**
   ```
   WORKFLOW RESULTS
   ===============================================
   Total Test Cases: [count]
   Passed: [count]
   Failed: [count]
   Blocked: [count]
   
   Output Files:
   - JSON: c:\AI Agents\Test Results\test_cases_consolidated.json
   - Excel: c:\AI Agents\Test Results\Consolidated_Tosca_Test_Execution_Report.xlsx
   - Log: c:\AI Agents\Test Results\execution_log.txt
   
   STATUS: SUCCESS
   ===============================================
   ```

4. **Update Execution Log**
   - Log completion timestamp
   - Log final status
   - Log summary statistics

5. **Display Results**
   - Console output with summary
   - File paths for output documents
   - Next steps for user

### Success Criteria
- ✓ All phases completed
- ✓ Both output files exist
- ✓ File sizes reasonable (not empty)
- ✓ Execution log complete
- ✓ All required files in correct locations
- ✓ Summary statistics calculated
- ✓ Status = SUCCESS

---

## OVERALL PIPELINE SUCCESS CHECKLIST

**Before Execution:**
- [ ] PDFs in Uploads folder (optional)
- [ ] Sufficient disk space
- [ ] Folders not read-only
- [ ] No file locks

**After Phase 1:**
- [ ] Directories initialized
- [ ] Prerequisites verified
- [ ] Logging started

**After Phase 2:**
- [ ] JSON file created
- [ ] JSON is valid
- [ ] All test cases extracted
- [ ] Agent 1 status = SUCCESS

**After Phase 3:**
- [ ] Excel file created
- [ ] Excel is readable
- [ ] All data present
- [ ] Formatting applied
- [ ] Agent 2 status = SUCCESS

**After Phase 4:**
- [ ] Summary generated
- [ ] All files present
- [ ] Statistics accurate
- [ ] Log complete
- [ ] Overall status = SUCCESS

---

## FINAL QUALITY GATES

Before declaring success, verify:

```
[✓] All PDFs discovered
[✓] All readable PDFs processed
[✓] Test cases extracted: [count]
[✓] Statuses validated
[✓] Failure reasons validated
[✓] Duplicates checked
[✓] Conflicts checked
[✓] Source traceability preserved
[✓] Consolidated dataset validated
[✓] Excel generated
[✓] Excel validated
[✓] Final files exist
[✓] Summary statistics accurate
```

---

## EXECUTION COMMANDS

### To Run Complete Pipeline
```powershell
powershell -ExecutionPolicy Bypass -File "c:\AI Agents\run_simple_pipeline.ps1"
```

### To Run Agent 1 Only
```powershell
powershell -ExecutionPolicy Bypass -File "c:\AI Agents\agent1_execute.ps1"
```

### To Run Agent 2 Only
```powershell
powershell -ExecutionPolicy Bypass -File "c:\AI Agents\agent2_execute.ps1"
```

---

## EXPECTED TIMING

- Phase 1 (Initialization): < 1 second
- Phase 2 (Agent 1): 5-30 seconds (depends on PDF count and complexity)
- Phase 3 (Agent 2): 2-10 seconds (depends on record count)
- Phase 4 (Reporting): < 1 second
- **Total Estimated Time: 10-45 seconds**

---

## TROUBLESHOOTING

### Issue: No PDFs found
- **Cause**: Uploads folder empty
- **Solution**: Add PDF files to c:\AI Agents\Uploads\
- **Status**: Pipeline continues, reports "0 PDFs processed"

### Issue: JSON file not created
- **Cause**: Agent 1 failed or output folder not writable
- **Solution**: Check folder permissions, check disk space
- **Status**: Pipeline stops, Agent 2 cannot run

### Issue: Excel file not created
- **Cause**: Agent 2 failed, JSON invalid, or Excel not available
- **Solution**: Check JSON validity, check system resources
- **Status**: Fallback to CSV/HTML format if available

### Issue: Execution hangs
- **Cause**: PDF locked, antivirus scanning, network share delay
- **Solution**: Close files, disable antivirus temporarily, use local path
- **Status**: Wait 60 seconds, press Ctrl+C to stop if needed

### Issue: Permission denied
- **Cause**: Folder is read-only or user lacks permissions
- **Solution**: Change folder permissions, run as Administrator
- **Status**: Cannot proceed until permissions fixed

---

## POST-EXECUTION

After successful completion:

1. **Review Excel Report**
   - Open: `c:\AI Agents\Test Results\Consolidated_Tosca_Test_Execution_Report.xlsx`
   - Verify data looks correct
   - Check summary statistics
   - Review any conflicts/flags

2. **Review JSON Data**
   - Optional: Inspect `test_cases_consolidated.json` for raw data
   - Verify all test cases present
   - Verify source PDFs correct

3. **Review Logs**
   - Optional: Check `execution_log.txt` for details
   - Look for any warnings or errors
   - Verify all phases completed

4. **Next Steps**
   - Share Excel report with team
   - Use for test execution analysis
   - Identify failed tests for debugging
   - Track test coverage metrics

---

## DOCUMENT VERSION

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-09-07 | AI Agent | Initial orchestration specification |
