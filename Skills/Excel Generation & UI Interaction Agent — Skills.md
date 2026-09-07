# Excel Generation & UI Interaction Agent — Skills

## 1. Skill Name

**Excel Generation & UI Interaction Skills**

---

## 2. Purpose

This skill enables the **Excel Generation & UI Interaction Agent** to transform validated consolidated test case data received from Agent 1 into a structured Excel report, validate the generated report, and display the same information through the application UI.

The skill ensures that the information received from Agent 1 is preserved without modification, reinterpretation, or invention.

---

# 3. Skill Scope

This skill covers:

* Consolidated data intake
* Data mapping
* Excel generation
* Excel formatting
* Excel validation
* Data integrity validation
* Duplicate validation
* File integrity validation
* UI navigation
* Excel upload
* UI table interaction
* UI data validation
* Search and filtering
* Sorting
* Screenshot capture
* Error handling
* Playwright automation
* Self-healing UI interaction

This skill does **not** cover Tosca PDF analysis or PDF data extraction.

---

# 4. Input

The skill accepts structured consolidated test data from Agent 1.

Expected fields may include:

```text
Test Case ID
Test Case Name
Status
Failure Reason
Details
Source Tosca PDF
```

Example:

```text
{
  "Test Case ID": "TC001",
  "Test Case Name": "Login Validation",
  "Status": "Passed",
  "Failure Reason": "N/A",
  "Details": "Test completed",
  "Source Tosca PDF": "TC-001.pdf"
}
```

---

# 5. Source of Truth

The data received from Agent 1 is the **single source of truth**.

The skill must preserve:

* Test Case ID
* Test Case Name
* Status
* Failure Reason
* Details
* Source Tosca PDF

The skill may format the data for presentation but must never change its meaning.

---

# 6. Skill: Input Data Validation

## Objective

Validate the structure and availability of the consolidated data before creating the Excel report.

### Actions

1. Receive Agent 1 output.
2. Verify that the data is readable.
3. Verify that records are available.
4. Identify available fields.
5. Validate that the input structure and records are usable.
6. Detect missing field values without treating them as structural errors.
7. Preserve unavailable values as provided, or use the agreed `Not Available` convention when no value is supplied.
8. Do not invent missing information.

Missing optional values must not prevent report generation. The skill must stop
only when the input cannot be read, has no usable records, or lacks the
structure needed to map records to the required Excel columns.

### Example

```text
Input:
TC001 | Login Validation | Passed

Validation:
Test Case ID      → Available
Test Case Name    → Available
Status            → Available
Failure Reason    → Not Available
Details           → Not Available
```

The skill must not create a failure reason or test detail when it is not provided.

---

# 7. Skill: Data-to-Excel Mapping

## Objective

Map consolidated Agent 1 data to the corresponding Excel columns.

### Mapping

```text
Agent 1 Field              Excel Column
------------------------------------------------
Test Case ID          →    Test Case ID
Test Case Name        →    Test Case Name
Status                →    Status
Failure Reason        →    Failure Reason
Details               →    Details
Source Tosca PDF      →    Source Tosca PDF
```

The mapping must be deterministic and consistent.

---

# 8. Skill: Excel File Generation

## Objective

Generate a valid Excel report containing the consolidated test execution data.

### Default File Name

```text
Tosca_Test_Execution_Consolidated.xlsx
```

### Generation Requirements

* Create the Excel workbook.
* Create the required worksheet.
* Add column headers.
* Insert all consolidated records.
* Preserve original values.
* Maintain record order where appropriate.
* Save the generated file.
* Confirm that the file exists.

---

# 9. Skill: Excel Formatting

The skill should create a professional and readable Excel report.

### Formatting Capabilities

* Header formatting
* Column width adjustment
* Text wrapping
* Table formatting
* Auto-sizing
* Filtering
* Freeze header row
* Alignment
* Status formatting
* Failure reason visibility

Formatting must not alter the underlying data.

---

# 10. Skill: Status Formatting

The skill may visually distinguish different execution statuses.

Supported examples:

```text
Passed
Failed
Blocked
Skipped
Not Executed
```

Visual formatting is permitted.

Changing the actual status value is prohibited.

### Example

```text
Input Status:
Failed

Excel Status:
Failed
```

The skill must never transform:

```text
Failed → Passed
Passed → Failed
```

---

# 11. Skill: Record Count Validation

## Objective

Verify that the number of Excel records matches the number of records received from Agent 1.

### Example

```text
Agent 1 Records: 25
Excel Records:   25

Result: PASS
```

If:

```text
Agent 1 Records: 25
Excel Records:   24

Result: FAIL
```

The skill must identify the discrepancy.

---

# 12. Skill: Test Case ID Validation

The skill must compare every Test Case ID in the Excel file against the Agent 1 input.

### Validation

```text
Agent 1:
TC001
TC002
TC003

Excel:
TC001
TC002
TC003

Result:
PASS
```

The skill must not:

* Change IDs
* Generate new IDs
* Remove IDs
* Replace IDs

---

# 13. Skill: Test Case Name Validation

The skill must verify that Test Case Names remain unchanged.

Example:

```text
Agent 1:
TC001 → Login Validation

Excel:
TC001 → Login Validation

Result:
PASS
```

The skill must not rename or rewrite test case names.

---

# 14. Skill: Status Validation

The skill must compare the Excel status against the Agent 1 status.

Example:

```text
Agent 1:
TC002 → Failed

Excel:
TC002 → Failed

Result:
PASS
```

Any mismatch must be reported.

---

# 15. Skill: Failure Reason Validation

For test cases containing failure information, the skill must verify that the failure reason is preserved.

Example:

```text
Agent 1:
TC002
Status: Failed
Failure Reason: API returned 500

Excel:
TC002
Status: Failed
Failure Reason: API returned 500

Result:
PASS
```

The skill must not generate or modify failure reasons.

---

# 16. Skill: Details Validation

The skill must verify that execution details received from Agent 1 are preserved in the Excel report.

Example:

```text
Agent 1:
Details = Order could not be created

Excel:
Details = Order could not be created

Result = PASS
```

---

# 17. Skill: Source Traceability Validation

Where Agent 1 provides the source PDF reference, the skill should preserve it in the Excel report.

Example:

```text
Source Tosca PDF:
TC-002.pdf
```

Excel:

```text
Source Tosca PDF:
TC-002.pdf
```

This provides traceability between the consolidated result and the original Tosca execution report.

---

# 18. Skill: Duplicate Validation

The skill must identify unintended duplicate records.

### Important Rule

A duplicate Test Case ID does not automatically mean that a record should be deleted.

The skill must consider the complete input record before determining whether duplication is unintended.

The skill must not remove valid execution records automatically.

---

# 19. Skill: Excel Integrity Validation

After generation, validate:

```text
Workbook exists
       ↓
Workbook opens successfully
       ↓
Worksheet exists
       ↓
Headers exist
       ↓
Records exist
       ↓
Record count matches
       ↓
IDs match
       ↓
Names match
       ↓
Statuses match
       ↓
Failure reasons match
       ↓
Details match
       ↓
Source references match
```

Only after successful validation should the report be treated as the final Excel output.

---

# 20. Skill: Excel Read/Write

The skill should be capable of:

* Creating workbooks
* Creating worksheets
* Writing headers
* Writing rows
* Reading worksheets
* Reading cell values
* Validating rows
* Validating columns
* Saving workbooks
* Reopening saved workbooks
* Comparing source and output data

---

# 21. Skill: UI Navigation

The skill should be capable of navigating the application UI.

### Typical Flow

```text
Open Application
       ↓
Login if required
       ↓
Navigate to Result Section
       ↓
Locate Excel Upload / Result Area
       ↓
Load Excel
       ↓
Display Results
```

The skill must only perform actions required by the workflow.

---

# 22. Skill: Excel Upload

Where the application requires an Excel upload, the skill should:

1. Locate the upload control.
2. Select the generated Excel file.
3. Upload the file.
4. Wait for processing.
5. Verify successful upload.
6. Verify that the results are displayed.

The skill must not upload an unrelated file.

---

# 23. Skill: UI Table Validation

The skill must verify that the UI table represents the Excel data correctly.

### Example

```text
Excel:
TC001 | Login Validation | Passed

UI:
TC001 | Login Validation | Passed

Result:
MATCH
```

For failed cases:

```text
Excel:
TC002 | Order Creation | Failed | API returned 500

UI:
TC002 | Order Creation | Failed | API returned 500

Result:
MATCH
```

---

# 24. Skill: UI Search

The skill may search for:

* Test Case ID
* Test Case Name
* Status
* Failure Reason

Example:

```text
Search:
TC002
```

The skill should verify that the expected test case is displayed.

---

# 25. Skill: UI Filtering

Where supported, the skill can apply filters.

Example:

```text
Status = Failed
```

Expected behavior:

```text
Only failed test cases are displayed.
```

Filtering must not modify the underlying data.

---

# 26. Skill: UI Sorting

The skill may sort the displayed table by:

* Test Case ID
* Test Case Name
* Status
* Failure Reason

Sorting must only change presentation order.

It must not modify test case data.

---

# 27. Skill: Playwright Automation

Playwright can be used for browser automation.

### Capabilities

```text
Browser Launch
Page Navigation
Element Detection
Click
Fill
Select
Upload
Download
Table Reading
Search
Filter
Sort
Assertions
Screenshot
Error Handling
```

---

# 28. Skill: Reliable UI Selectors

The skill should prefer stable selectors.

Priority:

```text
1. Accessible Role
2. Label
3. Stable ID
4. Stable Attribute
5. Reliable Text
```

Avoid unstable selectors whenever possible.

---

# 29. Skill: Dynamic UI Handling

The skill should handle:

* Dynamic loading
* Delayed elements
* Loading indicators
* AJAX requests
* Dynamic tables
* Pagination
* Modal windows
* Notifications
* Temporary UI states

The skill should wait for the required UI state rather than relying only on fixed delays.

---

# 30. Skill: Self-Healing UI

When a UI element cannot be located:

```text
Element Not Found
       ↓
Check Page State
       ↓
Check Available Elements
       ↓
Try Reliable Alternative Selector
       ↓
Verify Target
       ↓
Continue
```

The skill must never select an unrelated element simply because it appears visually similar.

---

# 31. Skill: UI Result Verification

The skill must verify that the displayed UI information matches the generated Excel report.

Validation should include:

* Test Case ID
* Test Case Name
* Status
* Failure Reason
* Details where displayed

Example:

```text
Excel Record
     ↓
Locate Same Record in UI
     ↓
Compare Fields
     ↓
All Fields Match?
     ↓
YES → Validation Passed
NO  → Validation Failed
```

---

# 32. Skill: Screenshot Capture

Screenshots may be captured for:

* Successful UI result display
* Failed result display
* Upload confirmation
* Validation failure
* Unexpected UI behavior
* Processing errors

Screenshots are supporting evidence and do not replace structured validation.

---

# 33. Skill: Error Handling

The skill must provide clear errors for:

### Input Error

```text
Unable to process consolidated Agent 1 data.
```

### Excel Generation Error

```text
Unable to generate the Excel report.
```

### Excel Validation Error

```text
Generated Excel does not match the consolidated input.
```

### Upload Error

```text
Unable to upload the generated Excel file.
```

### UI Validation Error

```text
UI results do not match the generated Excel report.
```

The skill must never report success when validation has failed.

---

# 34. Skill: Missing Information Handling

If a field is unavailable:

```text
Do not guess.
Do not invent.
Do not infer unsupported information.
```

Use the value supplied by Agent 1.

If Agent 1 explicitly provides:

```text
N/A
```

preserve:

```text
N/A
```

If information is unavailable and no value is supplied, represent it according to the platform's agreed convention, such as:

```text
Not Available
```

---

# 35. Skill: Data Integrity Rules

The following transformations are prohibited:

```text
Passed → Failed
Failed → Passed

TC001 → TC002

Login Validation → User Login Test

API returned 500 → Unknown Error
```

The skill must preserve source information exactly unless formatting is required for presentation.

---

# 36. Skill: Agent Boundary Enforcement

This skill must maintain a strict boundary between Agent 1 and Agent 2.

### Agent 1 Responsibilities

```text
Read Tosca PDFs
Analyze Tosca reports
Extract execution information
Determine results
Identify failure information
Consolidate test case data
```

### Agent 2 Responsibilities

```text
Receive consolidated data
Generate Excel
Format Excel
Validate Excel
Interact with UI
Display results
Validate UI
```

Agent 2 must not perform Agent 1's responsibilities.

---

# 37. Skill: Audit and Traceability

The skill should maintain traceability between:

```text
Agent 1 Data
     ↓
Excel Record
     ↓
UI Record
```

Each record should remain traceable using the available Test Case ID and Source Tosca PDF information.

---

# 38. Skill: Execution Logging

The skill should maintain execution logs for important operations.

Example:

```text
[INFO] Consolidated data received.
[INFO] Input records: 25.
[INFO] Excel generation started.
[INFO] Excel generation completed.
[INFO] Excel validation started.
[INFO] Record count validation passed.
[INFO] Status validation passed.
[INFO] Excel validation completed.
[INFO] UI interaction started.
[INFO] Excel uploaded successfully.
[INFO] UI validation completed.
[INFO] Pipeline completed successfully.
```

Errors should be logged clearly.

Example:

```text
[ERROR] Excel validation failed.
[ERROR] TC002 status mismatch detected.
```

---

# 39. Skill: Final Validation

Before reporting success, perform the following checklist:

```text
[ ] Agent 1 data received
[ ] Input structure validated
[ ] Required fields mapped
[ ] Excel generated
[ ] Excel formatting applied
[ ] Record count validated
[ ] Test Case IDs validated
[ ] Test Case Names validated
[ ] Status validated
[ ] Failure Reasons validated
[ ] Details validated
[ ] Source PDF references validated
[ ] Duplicate validation completed
[ ] Excel integrity validated
[ ] UI accessed
[ ] Excel uploaded/loaded
[ ] UI table displayed
[ ] UI data validated
[ ] No data was changed
```

Only when applicable checks pass should the agent report successful completion.

---

# 40. Final Output

The skill produces:

### Output 1

```text
Tosca_Test_Execution_Consolidated.xlsx
```

### Output 2

A UI representation of the same consolidated test execution results.

### Output 3

Validation information indicating whether:

```text
Excel Validation = PASS / FAIL
UI Validation     = PASS / FAIL
```

---

# 41. Skill Execution Flow

```text
START
  |
  v
Receive Agent 1 Data
  |
  v
Validate Input
  |
  v
Map Data
  |
  v
Generate Excel
  |
  v
Format Excel
  |
  v
Validate Excel
  |
  +---- FAIL ----> Report Error
  |
  +---- PASS
          |
          v
      Access UI
          |
          v
      Upload / Load Excel
          |
          v
      Display Results
          |
          v
      Validate UI Data
          |
          +---- FAIL ----> Report UI Mismatch
          |
          +---- PASS
                  |
                  v
             Final Output
                  |
                  v
                 END
```

---

# 42. Core Skill Rules

The skill must always follow these rules:

1. **Agent 1 is the source of truth.**
2. **Never analyze Tosca PDFs.**
3. **Never change test results.**
4. **Never change Test Case IDs.**
5. **Never change Test Case Names.**
6. **Never change Failure Reasons.**
7. **Never invent missing information.**
8. **Never remove valid records.**
9. **Never create fake test cases.**
10. **Validate the Excel before presenting it.**
11. **Validate UI data against Excel.**
12. **Maintain traceability.**
13. **Report mismatches clearly.**
14. **Do not claim success when validation fails.**

---

# 43. Skill Definition

```text
Skill:
Excel Generation & UI Interaction

Input:
Validated Consolidated Test Case Data from Agent 1

Process:
Validate Input
→ Map Data
→ Generate Excel
→ Format Excel
→ Validate Excel
→ Access UI
→ Upload / Load Excel
→ Display Results
→ Validate UI

Output:
Validated Excel Report
+
UI Test Case Result View
+
Validation Status

Primary Principle:
Preserve the exact meaning of Agent 1's consolidated test data.
```

---

# 44. Success Criteria

The skill execution is successful when:

```text
Agent 1 Data
      ↓
Correctly mapped
      ↓
Excel generated
      ↓
Excel validated
      ↓
UI populated
      ↓
UI validated
      ↓
All information preserved
```

The final Excel report and UI must represent the **same consolidated test execution information received from Agent 1**.

---

# 45. Final Skill Objective

The objective of this skill is to provide the **Excel Generation & UI Interaction Agent** with all capabilities required to reliably transform validated Tosca test execution data into a professional Excel report and present the same information through the UI.

The skill follows the principle:

```text
Agent 1
PDF Analysis & Data Consolidation
          ↓
Consolidated Test Data
          ↓
Agent 2 Skills
          ↓
Excel Generation
          ↓
Excel Validation
          ↓
UI Interaction
          ↓
UI Validation
          ↓
Final Test Execution Report
```

**No analysis.
No reinterpretation.
No invented data.
No modification of test results.**

The skill exists to ensure that the consolidated results are **accurately generated, validated, and presented**.
