# DATA FORMATS & TEMPLATES
## Complete Schema Reference

---

## INPUT DATA FORMAT

### PDF Files

**Location:** `c:\AI Agents\Uploads\`

**Requirements:**
- Format: Adobe PDF (.pdf extension)
- Content: Tosca test execution reports
- Structure: Any valid PDF structure
- Pages: All pages processed
- Encoding: UTF-8 or standard text encoding

**Characteristics:**
- May contain test case data scattered across pages
- May be scanned images (OCR required)
- May have tables, structured data, or free-form text
- May include execution logs
- May include error messages
- Original files are never modified

**Example Filenames:**
```
TC-001.pdf
TC-002.pdf
TC-003.pdf
TestExecution_2026-09-07.pdf
Tosca_Report_Sprint_123.pdf
```

---

## CONSOLIDATED JSON FORMAT

### Agent 1 Output Structure

**File:** `c:\AI Agents\Test Results\test_cases_consolidated.json`

**Complete Schema:**

```json
{
  "execution_timestamp": "2026-09-07T18:53:25.5471777+05:30",
  "workflow_stage": "Agent_1_Complete",
  
  "total_pdfs_processed": 3,
  "total_test_cases_identified": 9,
  
  "processing_summary": {
    "pdfs_processed": 3,
    "pdfs_failed": 0,
    "test_cases_extracted": 9,
    "extraction_completeness": "100%"
  },
  
  "validation_summary": {
    "validation_passed": true,
    "total_records": 9,
    "valid_records": 9,
    "flagged_records": 0,
    "duplicates": 0,
    "conflicts": 0
  },
  
  "test_cases": [
    {
      "sctask_id": "Not Available",
      "test_case_id": "TC001",
      "test_case_name": "Login Validation",
      "status": "Passed",
      "failure_reason": "Not Available",
      "test_result_details": "Test completed successfully with valid credentials",
      "source_tosca_pdf": "TC-001.pdf",
      "confidence": "High",
      "validation_status": "Valid",
      "duplicate": false,
      "conflict": false
    },
    {
      "sctask_id": "SCTASK0123456",
      "test_case_id": "TC002",
      "test_case_name": "Payment Processing",
      "status": "Failed",
      "failure_reason": "HTTP 500 Internal Server Error",
      "test_result_details": "Payment gateway returned error response. Server returned 500 error code.",
      "source_tosca_pdf": "TC-002.pdf",
      "confidence": "High",
      "validation_status": "Valid",
      "duplicate": false,
      "conflict": false
    },
    {
      "sctask_id": "Not Available",
      "test_case_id": "TC003",
      "test_case_name": "Order Confirmation",
      "status": "Blocked",
      "failure_reason": "Payment Processing test failed",
      "test_result_details": "Test blocked due to prerequisite failure in payment processing flow",
      "source_tosca_pdf": "TC-002.pdf",
      "confidence": "Medium",
      "validation_status": "Valid",
      "duplicate": false,
      "conflict": false
    }
  ],
  
  "duplicates_detected": [],
  
  "conflicts_detected": [],
  
  "errors": []
}
```

### Individual Test Case Record

```json
{
  "sctask_id": "SCTASK0123456",
  "test_case_id": "TC001",
  "test_case_name": "User Login",
  "status": "Passed",
  "failure_reason": "Not Available",
  "test_result_details": "Login successful with valid credentials",
  "source_tosca_pdf": "TC-001.pdf",
  "confidence": "High",
  "validation_status": "Valid",
  "duplicate": false,
  "conflict": false
}
```

### Field Definitions

| Field | Type | Length | Required | Rules |
|-------|------|--------|----------|-------|
| sctask_id | String | 0-50 | Optional | Extract from PDF or "Not Available" |
| test_case_id | String | 1-50 | Required | Preserve exactly from PDF, never invent |
| test_case_name | String | 1-255 | Optional | Preserve exactly from PDF, never invent |
| status | String | 1-50 | Required | Must be explicit status or "Not Available" |
| failure_reason | String | 0-500 | Optional | Extract from PDF evidence, never invent |
| test_result_details | String | 0-1000 | Optional | Execution details from PDF |
| source_tosca_pdf | String | 1-255 | Required | Original PDF filename |
| confidence | String | 1-50 | Optional | "High", "Medium", "Low" |
| validation_status | String | 1-50 | Required | "Valid", "Flagged", "Conflict" |
| duplicate | Boolean | - | Required | true/false |
| conflict | Boolean | - | Required | true/false |

### Status Values
```
"Passed"
"Failed"
"Blocked"
"Skipped"
"Not Executed"
"In Progress"
"Not Available"
"Conflict / Review Required"
```

---

## EXCEL WORKBOOK FORMAT

### Agent 2 Output Structure

**File:** `c:\AI Agents\Test Results\Consolidated_Tosca_Test_Execution_Report.xlsx`

**Format:** Excel 2007+ (.xlsx)

### Worksheet 1: Test Execution Results

#### Column Headers

| Column | Header | Data Type | Width | Format |
|--------|--------|-----------|-------|--------|
| A | SCTASK ID | Text | Auto-fit | Left-aligned |
| B | Test Case ID | Text | Auto-fit | Left-aligned |
| C | Test Case Name | Text | Auto-fit | Left-aligned, wrapped |
| D | Status | Text | 15 | Center-aligned, color-coded |
| E | Failure Reason | Text | Auto-fit | Left-aligned, wrapped |
| F | Test Result Details | Text | Auto-fit | Left-aligned, wrapped |
| G | Source Tosca PDF | Text | Auto-fit | Left-aligned |

#### Row 1: Headers
- Bold font
- Light blue background (RGB: 68, 114, 196)
- White text
- Center alignment
- Auto-filter enabled

#### Rows 2+: Data
- Regular font
- White background
- Black text
- Borders on all cells
- AutoFilter controls available

#### Status Column Formatting (Column D)
```
Passed        → Green background (RGB: 146, 208, 80)
Failed        → Red background (RGB: 255, 0, 0) with white text
Blocked       → Yellow background (RGB: 255, 192, 0)
Skipped       → Light gray (RGB: 192, 192, 192)
Not Available → Gray (RGB: 128, 128, 128)
Conflict      → Orange (RGB: 255, 128, 0)
```

#### Row Height
- Headers: 25px
- Data: 18-30px (auto-fit based on content)

#### Column Widths
- Auto-fit to content, minimum 10px, maximum 50px

### Worksheet 2: Summary

#### Summary Sheet Content

| Item | Formula | Result |
|------|---------|--------|
| Total Test Cases | =COUNTA(D2:D[last_row]) | [calculated] |
| Passed | =COUNTIF(D:D,"Passed") | [calculated] |
| Failed | =COUNTIF(D:D,"Failed") | [calculated] |
| Blocked | =COUNTIF(D:D,"Blocked") | [calculated] |
| Skipped | =COUNTIF(D:D,"Skipped") | [calculated] |
| Not Executed | =COUNTIF(D:D,"Not Executed") | [calculated] |
| Not Available | =COUNTIF(D:D,"Not Available") | [calculated] |
| Conflicts | =COUNTIF(D:D,"Conflict*") | [calculated] |

#### Summary Formatting
- Header cells: Bold, light blue background
- Summary labels: Bold
- Summary values: Regular font, right-aligned
- Table format for readability

### Excel Features
```
✓ AutoFilter enabled on headers (column D dropdown)
✓ Frozen top row (pane freeze at row 2)
✓ Data validation on status column
✓ Print-friendly formatting
✓ Readable column widths
✓ Appropriate row heights
✓ Professional table appearance
✓ No corruption or errors
```

---

## SAMPLE DATA STRUCTURE

### Example 1: Passed Test

```json
{
  "sctask_id": "Not Available",
  "test_case_id": "TC001",
  "test_case_name": "Login Valid Credentials",
  "status": "Passed",
  "failure_reason": "Not Available",
  "test_result_details": "User successfully logged in with valid email and password",
  "source_tosca_pdf": "TC-001.pdf",
  "confidence": "High",
  "validation_status": "Valid",
  "duplicate": false,
  "conflict": false
}
```

### Example 2: Failed Test with Reason

```json
{
  "sctask_id": "SCTASK0987654",
  "test_case_id": "TC002",
  "test_case_name": "Payment Process",
  "status": "Failed",
  "failure_reason": "HTTP 500 Internal Server Error",
  "test_result_details": "Payment gateway returned error at step 3. Response: Server returned HTTP 500 error. Verification failed.",
  "source_tosca_pdf": "TC-002.pdf",
  "confidence": "High",
  "validation_status": "Valid",
  "duplicate": false,
  "conflict": false
}
```

### Example 3: Blocked Test

```json
{
  "sctask_id": "Not Available",
  "test_case_id": "TC003",
  "test_case_name": "Email Confirmation",
  "status": "Blocked",
  "failure_reason": "Prerequisite Payment Process test (TC002) failed",
  "test_result_details": "Test cannot execute because payment processing failed. Email confirmation depends on successful payment.",
  "source_tosca_pdf": "TC-002.pdf",
  "confidence": "High",
  "validation_status": "Valid",
  "duplicate": false,
  "conflict": false
}
```

### Example 4: Missing Data (Not Available)

```json
{
  "sctask_id": "Not Available",
  "test_case_id": "TC004",
  "test_case_name": "Not Available",
  "status": "Not Available",
  "failure_reason": "Not Available",
  "test_result_details": "Not Available",
  "source_tosca_pdf": "TC-003.pdf",
  "confidence": "Low",
  "validation_status": "Flagged",
  "duplicate": false,
  "conflict": false
}
```

### Example 5: Conflict Detected

```json
{
  "sctask_id": "Not Available",
  "test_case_id": "TC005",
  "test_case_name": "User Registration",
  "status": "Conflict / Review Required",
  "failure_reason": "Conflicting status in source reports",
  "test_result_details": "TC-001.pdf: Passed | TC-002.pdf: Failed | Manual review required to determine actual status",
  "source_tosca_pdf": "TC-001.pdf, TC-002.pdf",
  "confidence": "Low",
  "validation_status": "Conflict",
  "duplicate": false,
  "conflict": true
}
```

---

## ERROR LOGGING FORMAT

### Execution Log File

**Location:** `c:\AI Agents\Test Results\execution_log.txt`

**Format:**
```
[2026-09-07 18:53:00] Pipeline Started
[2026-09-07 18:53:01] Phase 1: Initialization
[2026-09-07 18:53:01]   - Uploads folder: OK
[2026-09-07 18:53:01]   - Test Results folder: OK
[2026-09-07 18:53:02] Phase 2: Agent 1 Execution Started
[2026-09-07 18:53:03]   - PDF Found: TC-001.pdf
[2026-09-07 18:53:03]   - PDF Found: TC-002.pdf
[2026-09-07 18:53:03]   - PDF Found: TC-003.pdf
[2026-09-07 18:53:05]   - Processing: TC-001.pdf
[2026-09-07 18:53:05]   - Extracted: 3 test cases
[2026-09-07 18:53:07]   - Processing: TC-002.pdf
[2026-09-07 18:53:07]   - Extracted: 4 test cases
[2026-09-07 18:53:09]   - Processing: TC-003.pdf
[2026-09-07 18:53:09]   - Extracted: 2 test cases
[2026-09-07 18:53:10] Phase 2: Agent 1 Complete - SUCCESS
[2026-09-07 18:53:11] Phase 3: Agent 2 Execution Started
[2026-09-07 18:53:13]   - Excel workbook created
[2026-09-07 18:53:13]   - Data rows added: 9
[2026-09-07 18:53:14]   - Formatting applied
[2026-09-07 18:53:15]   - Validation: PASSED
[2026-09-07 18:53:16] Phase 3: Agent 2 Complete - SUCCESS
[2026-09-07 18:53:17] Phase 4: Final Report Generated
[2026-09-07 18:53:18] Pipeline Completed - SUCCESS
```

---

## VALIDATION RULES MATRIX

### Test Case ID Validation
```
✓ Present in PDF
✓ Not invented
✓ Exact format preserved
✓ No truncation
✓ No modification
✗ Never blank if found
✗ Never guessed
✗ Never created
```

### Status Validation
```
✓ Based on PDF evidence
✓ One of valid status values
✓ Explicit statement in PDF
✓ "Not Available" if uncertain
✓ "Conflict / Review Required" if contradictory
✗ Never guessed
✗ Never assumed from error
✗ Never inferred
```

### Failure Reason Validation
```
✓ Evidence-based from PDF
✓ From failed step, error, or exception
✓ Only for Failed status
✓ "Not Available" if not found
✓ Direct quote from PDF
✗ Never invented
✗ Never probable
✗ Never assumed
```

---

## VERSION HISTORY

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-09-07 | Initial schema specification |
