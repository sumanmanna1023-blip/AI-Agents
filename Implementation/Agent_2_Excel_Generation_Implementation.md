# AGENT 2: EXCEL GENERATION & VALIDATION
## Implementation Specification

### INPUT VALIDATION
- Source: test_cases_consolidated.json (from Agent 1)
- Verify file exists
- Verify valid JSON structure
- Verify contains test_cases array
- Verify each record has required fields

### EXCEL GENERATION (SKILL 14)

#### Workbook Name
`Consolidated_Tosca_Test_Execution_Report.xlsx`

#### Primary Worksheet
Name: `Test Execution Results`

#### Required Columns
1. SCTASK ID
2. Test Case ID
3. Test Case Name
4. Status
5. Failure Reason
6. Test Result Details
7. Source Tosca PDF

#### Data Mapping
Map consolidated JSON to Excel:
- sctask_id → SCTASK ID
- test_case_id → Test Case ID
- test_case_name → Test Case Name
- status → Status
- failure_reason → Failure Reason
- test_result_details → Test Result Details
- source_tosca_pdf → Source Tosca PDF

#### Row Creation
- Row 1: Headers
- Row 2+: Data rows (one per test case)
- Preserve all records from JSON
- No filtering or deletion of records
- Maintain exact order or sort by Test Case ID

### EXCEL FORMATTING (SKILL 15)

#### Header Row Formatting
- Bold font
- Light blue background
- Centered alignment
- Readable font size

#### Column Formatting
- Auto-fit column widths
- Wrapped text for long content
- Readable row heights
- Consistent alignment

#### Status Presentation
Color-code status column:
- Passed: Green background
- Failed: Red background
- Blocked: Yellow background
- Other: Gray background
- Conflicts: Orange background with bold text

#### Table Features
- Enable AutoFilter on headers
- Freeze top row (pane freeze)
- Apply table formatting for readability

### SUMMARY WORKSHEET (SKILL 16)

Create second worksheet: `Summary`

Include calculated counts:
- Total Test Cases
- Passed
- Failed
- Blocked
- Skipped
- Not Executed
- Not Available
- Conflict / Review Required

Rules:
- Calculate from actual data, never manual entry
- Use Excel formulas (COUNTIF)
- Include data validation
- Ensure counts match consolidated dataset

### EXCEL VALIDATION (SKILL 17)

After creation, verify:
- [ ] Workbook exists
- [ ] Workbook can be opened
- [ ] Required worksheet exists
- [ ] Required columns exist
- [ ] All consolidated records present
- [ ] No records unintentionally lost
- [ ] Test Case IDs match source JSON
- [ ] Test Case Names match source JSON
- [ ] Statuses match source JSON
- [ ] Failure reasons match source JSON
- [ ] Details match source JSON
- [ ] Source PDFs match source JSON
- [ ] Summary counts match actual records
- [ ] Formatting applied correctly
- [ ] Filters enabled
- [ ] No corruption

If validation fails: regenerate and validate again

### OUTPUT FILE (SKILL 18)

Output location: `Test Results\Consolidated_Tosca_Test_Execution_Report.xlsx`

File must:
- Be in Excel 2007+ format (.xlsx)
- Be readable by standard Excel applications
- Contain all validated data
- Have proper formatting
- Be immediately usable

### ERROR HANDLING

If Excel generation fails:
- Log specific error
- Attempt alternative format (CSV/HTML)
- Continue with fallback output
- Report completion status

Fallback formats:
- CSV: test_cases.csv
- HTML: test_report.html

### DATA INTEGRITY

Rules:
- Never modify Agent 1 data
- Preserve all records exactly
- Maintain data types
- Keep "Not Available" as written
- Preserve source references
- No data cleansing or interpretation

### UI SIMULATION

If UI display required:
- Display formatted table with results
- Show status with color coding
- Show summary statistics
- Verify data matches Excel

### SUCCESS CRITERIA
✓ Excel workbook created
✓ Worksheet structure correct
✓ All columns present
✓ All data rows present
✓ All records match source JSON
✓ Formatting applied
✓ Summary worksheet created
✓ Validation passed
✓ File is readable
✓ Ready for delivery to user

### FINAL RESPONSE

Provide result summary:
```
Excel Generation Completed Successfully

Input file: test_cases_consolidated.json
Output file: Consolidated_Tosca_Test_Execution_Report.xlsx

Records processed: [count]
Passed: [count]
Failed: [count]
Blocked: [count]
Other statuses: [count]

Status: SUCCESS
File location: Test Results\Consolidated_Tosca_Test_Execution_Report.xlsx
```
