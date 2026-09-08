# TOSCA QA AUTOMATION PLATFORM - COMPLETE SPECIFICATION
## Version 1.0

---

## EXECUTIVE SUMMARY

This is an **AI-Driven Tosca QA Automation Platform** that automatically:

1. **Discovers** Tosca PDF test execution reports
2. **Analyzes** PDF content to extract test cases
3. **Validates** extracted data against evidence-based rules
4. **Consolidates** results with duplicate/conflict detection
5. **Generates** professional Excel reports
6. **Validates** final output for accuracy

---

## SYSTEM ARCHITECTURE

### Two-Agent Sequential Pipeline

```
PHASE 1: PDF Discovery & Analysis
         (Agent 1: PDF Analysis & Data Consolidation)
         
         Input:  Tosca PDF files from Uploads/ folder
         Process: Extract test cases, validate, consolidate
         Output: test_cases_consolidated.json
         
         ↓
         
PHASE 2: Excel Generation & Validation
         (Agent 2: Excel Generation & UI Interaction)
         
         Input:  test_cases_consolidated.json from Agent 1
         Process: Generate Excel, format, validate
         Output: Consolidated_Tosca_Test_Execution_Report.xlsx
         
         ↓
         
PHASE 3: Quality Assurance
         Verify all outputs, validate data integrity
         Return final Excel report to user
```

---

## AGENT 1: TOSCA PDF ANALYSIS & DATA CONSOLIDATION

### Responsibility
Process Tosca PDF execution reports and extract consolidated test data.

### Input
- Source: `c:\AI Agents\Uploads\` folder
- Valid files: `.pdf` files only
- No modification to originals
- Process all PDFs found

### Processing Workflow
1. Discover all PDF files
2. Read each PDF (all pages)
3. Extract test case information using OCR if needed
4. Identify: Test Case ID, Name, Status, Failure Reason, Details
5. Normalize extracted data
6. Detect duplicates across PDFs
7. Detect conflicts (same test case, different status)
8. Validate consolidated data
9. Create JSON output

### Core Rules
- **Never guess** — use only PDF evidence
- **Never hallucinate** — don't invent test cases or IDs
- **Preserve originals** — Test Case IDs and Names must match exactly
- **Mark missing data** — "Not Available" for unavailable fields
- **Maintain traceability** — preserve source PDF for each record
- **Handle errors gracefully** — continue if one PDF fails

### Output
```
c:\AI Agents\Test Results\test_cases_consolidated.json
```

Structure:
```json
{
  "execution_timestamp": "2026-09-07T18:00:00Z",
  "total_pdfs_processed": 3,
  "processing_summary": {
    "pdfs_processed": 3,
    "pdfs_failed": 0,
    "test_cases_extracted": 9,
    "extraction_completeness": "100%"
  },
  "test_cases": [
    {
      "sctask_id": "Not Available",
      "test_case_id": "TC001",
      "test_case_name": "Login Validation",
      "status": "Passed",
      "failure_reason": "Not Available",
      "test_result_details": "Test completed successfully",
      "source_tosca_pdf": "TC-001.pdf",
      "confidence": "High",
      "validation_status": "Valid",
      "duplicate": false,
      "conflict": false
    }
  ],
  "duplicates_detected": [],
  "conflicts_detected": [],
  "errors": [],
  "validation_summary": {
    "validation_passed": true,
    "total_records": 9,
    "valid_records": 9,
    "flagged_records": 0,
    "duplicates": 0,
    "conflicts": 0
  },
  "total_test_cases_identified": 9,
  "workflow_stage": "Agent_1_Complete"
}
```

---

## AGENT 2: EXCEL GENERATION & VALIDATION

### Responsibility
Transform consolidated JSON into professional Excel report with validation.

### Input
- Source: `c:\AI Agents\Test Results\test_cases_consolidated.json` (from Agent 1)
- Verify valid JSON structure
- Verify contains test_cases array
- Verify required fields present

### Excel Workbook Structure

#### Worksheet 1: Test Execution Results
**Columns:**
1. SCTASK ID
2. Test Case ID
3. Test Case Name
4. Status
5. Failure Reason
6. Test Result Details
7. Source Tosca PDF

**Formatting:**
- Header: Bold, light blue background, centered
- Data: Auto-fit columns, wrapped text, appropriate heights
- Status column: Color-coded (Green=Passed, Red=Failed, Yellow=Blocked)
- AutoFilter enabled on headers
- Table formatting for professional appearance

#### Worksheet 2: Summary
**Contains:**
- Total Test Cases (calculated)
- Passed (counted)
- Failed (counted)
- Blocked (counted)
- Skipped (counted)
- Not Executed (counted)
- Not Available (counted)
- Conflicts/Review Required (counted)

All counts use Excel formulas, not manual values.

### Output
```
c:\AI Agents\Test Results\Consolidated_Tosca_Test_Execution_Report.xlsx
```

### Output Validation
Before delivery, verify:
- ✓ Workbook created successfully
- ✓ All worksheets present
- ✓ All required columns present
- ✓ All data rows present (no loss)
- ✓ All values match source JSON
- ✓ Formatting applied correctly
- ✓ Summary counts accurate
- ✓ File is readable and usable

---

## DATA VALIDATION RULES

### Test Case ID Rules
- Must be extracted from PDF (never invented)
- Preserve original format exactly
- Examples: "TC001", "TC-001", "TC_001" — preserve as found

### Test Case Name Rules
- Must be extracted from PDF (never invented)
- Preserve original text exactly
- If missing: "Not Available"

### Status Rules
- Must be based on explicit evidence in PDF
- Valid statuses: Passed, Failed, Blocked, Skipped, Not Executed, In Progress
- If conflicting statuses: "Conflict / Review Required"
- If undeterminable: "Not Available"
- Error ≠ automatically Failed (unless explicitly stated)

### Failure Reason Rules
- Only extract from PDF evidence
- Valid evidence: Failed steps, assertions, errors, exceptions, logs
- Never create probable reasons
- If missing: "Not Available"

### Missing Information Policy
```
When field is unavailable: "Not Available"
- Never guess
- Never use info from another test case
- Never infer from Test Case Name
- Never infer failure reasons
- Never use external information
```

---

## DUPLICATE HANDLING

### When is it a duplicate?
- Same Test Case ID AND
- Same Test Case Name AND
- Same execution context AND
- From same or different PDFs

### Action
- Consolidate confirmed duplicates
- If represents different executions: preserve both records
- Document which PDFs contributed to each record

### When NOT to consolidate
- Same name, different IDs
- Same ID, different names
- Different execution contexts
- Uncertain matches

---

## CONFLICT DETECTION

### Conflict Definition
Same test case (ID + Name) with contradictory information.

### Example
```
PDF A: TC001 - Status: Passed
PDF B: TC001 - Status: Failed
```

### Action
- Flag as: "Conflict / Review Required"
- DO NOT silently select one
- Preserve both records
- Preserve source PDFs
- Mark for manual review

---

## ERROR HANDLING STRATEGY

### Single PDF Failure
- Log error with filename and reason
- Continue processing other PDFs
- Include failed PDF in error report

### Multiple PDF Failures
- Process remaining valid PDFs
- Generate report from valid data
- Don't generate fake data
- Report which PDFs failed and why

### Excel Generation Failure
- Attempt fallback formats (CSV, HTML)
- Log specific error
- Notify user of alternative format

---

## FILE STRUCTURE

```
c:\AI Agents\
├── Uploads/                          # Input folder for PDF files
│   ├── TC-001.pdf
│   ├── TC-002.pdf
│   └── TC-003.pdf
│
├── Test Results/                     # Output folder
│   ├── test_cases_consolidated.json  # Agent 1 output
│   ├── Consolidated_Tosca_Test_Execution_Report.xlsx  # Agent 2 output
│   ├── execution_log.txt             # Execution log
│   └── errors.log                    # Error log (if any)
│
├── Prompt/
│   └── Prompt.md                     # Original prompt specification
│
├── Implementation/
│   ├── Agent_1_Tosca_PDF_Analysis_Implementation.md
│   ├── Agent_2_Excel_Generation_Implementation.md
│   ├── SYSTEM_SPECIFICATION.md       # This file
│   └── run-qa-pipeline.md            # Orchestration guide
│
└── Scripts/
    ├── agent1_execute.ps1
    ├── agent2_execute.ps1
    └── run_simple_pipeline.ps1
```

---

## EXECUTION CHECKLIST

Before starting:
- [ ] Tosca PDF files in Uploads folder
- [ ] Output folder (Test Results) exists
- [ ] PowerShell execution policy allows scripts
- [ ] Sufficient disk space for outputs
- [ ] No antivirus blocking PDF reading

During execution:
- [ ] Agent 1 processes all PDFs
- [ ] Agent 1 outputs JSON file
- [ ] Agent 2 reads JSON file
- [ ] Agent 2 generates Excel workbook
- [ ] All validations pass

After execution:
- [ ] JSON file contains expected test cases
- [ ] Excel file created successfully
- [ ] Excel file readable and formatted
- [ ] Summary statistics accurate
- [ ] All source PDFs preserved
- [ ] No data loss or corruption

---

## SUCCESS CRITERIA

**Agent 1 Success:**
- All PDFs discovered ✓
- All readable PDFs processed ✓
- Test cases extracted ✓
- Duplicates detected ✓
- Conflicts detected ✓
- Data validated ✓
- JSON created ✓

**Agent 2 Success:**
- JSON input validated ✓
- Excel workbook created ✓
- All data rows present ✓
- Formatting applied ✓
- Summary worksheet created ✓
- Validation passed ✓
- File readable ✓

**Overall Success:**
```
PDF files processed: [count]
Test cases consolidated: [count]
Passed: [count]
Failed: [count]
Blocked: [count]
Conflicts: [count]
Status: SUCCESS ✓
Excel report: Ready for review
```

---

## FINAL PRINCIPLE

> **Extract facts from Tosca PDFs. Validate those facts. Consolidate them without changing their meaning. Generate an Excel report containing exactly the validated information. Never guess, invent, or hallucinate.**

---

## VERSION HISTORY

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-09-07 | Initial specification |
