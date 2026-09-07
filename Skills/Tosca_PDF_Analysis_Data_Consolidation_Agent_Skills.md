# Skills — Tosca PDF Analysis & Data Consolidation Agent

## 1. Overview

This Skills definition describes the capabilities required by the **Tosca PDF Analysis & Data Consolidation Agent**.

The agent reads Tosca execution PDF reports, extracts test execution information, analyzes detailed execution logs, identifies evidence-based failure reasons, validates extracted information, and consolidates results into structured data.

**Source of Truth:** Tosca PDF reports.

---

## 2. Core Skill

### Tosca PDF Report Analysis

The agent must be able to:

- Read Tosca execution PDF reports.
- Understand Tosca execution summaries.
- Read detailed execution/action logs.
- Identify test cases.
- Identify test case execution status.
- Locate failed execution steps.
- Interpret Tosca error messages.
- Analyze expected versus actual values.
- Connect failures to relevant execution steps.
- Extract supporting execution details.
- Preserve source traceability.

---

## 3. PDF Reading and Extraction

### Capability

Read and extract information from complete, multi-page Tosca PDF reports.

### Extract

- Report name
- Report creation/execution date
- Start and end time
- Total test cases
- Passed/Failed counts
- Test case names and IDs
- Execution steps
- Action logs
- Verification results
- Expected values
- Actual values
- Error messages
- Relevant screenshots/references
- Source page

### Rules

- Read the complete relevant report.
- Do not rely only on the summary page.
- Follow execution flow across pages.
- Preserve original information.
- Use `Not Available` when information is missing.

---

## 4. Test Case Identification

### Capability

Identify every test case contained in the Tosca report.

### Extract

```text
Test Case ID
Test Case Name
Status
Start Time
End Time
Execution Details
```

### Rules

- Preserve Test Case ID exactly as reported.
- Preserve Test Case Name.
- Never invent an ID.
- Never create a test case that is not present.
- Do not merge different test cases only because their names are similar.

---

## 5. Test Execution Status Analysis

### Supported Status Values

```text
Passed
Failed
Blocked
Skipped
Not Executed
In Progress
Unknown
```

### Rules

- Use the status explicitly reported by Tosca.
- Normalize formatting only when the meaning remains unchanged.
- Never change Failed to Passed.
- Never change Passed to Failed without evidence.
- If status cannot be determined, use `Unknown`.

---

## 6. Execution Step Analysis

### Capability

Understand the sequence of actions performed during execution.

### Analyze

```text
Test Step
   ↓
Action
   ↓
Input
   ↓
Verification / WaitOn
   ↓
Expected Result
   ↓
Actual Result
   ↓
Error
```

The agent should recognize Tosca actions such as:

- Click
- Input
- SendKeys
- Wait
- WaitOn
- Verify
- Buffer operations
- Browser operations
- Navigation
- Page/header validation
- Tab validation

---

## 7. Failure Detection

### Capability

Identify the exact point where a failed test case failed.

### Look For

- Explicit Tosca error
- Failed action
- Failed verification
- Failed WaitOn
- Expected/actual mismatch
- Missing UI element
- Missing page
- Missing tab
- Navigation failure
- Timeout/wait failure
- Other explicit execution errors

### Output

```text
Failed Step
Error Message
Failure Evidence
```

---

## 8. Failure Reason Analysis

### Evidence Priority

Use the following order:

```text
1. Explicit Tosca Error
2. Failed Action / Verification
3. Expected vs Actual Result
4. Execution Step Context
5. Surrounding Execution Context
6. Not Available
```

### Example

Source error:

```text
Could not find Link 'Generic Link'
```

Concise reason:

```text
Expected navigation link could not be found.
```

The original error must remain available in the output.

### Important Rule

Do not infer a technical root cause unless the PDF supports it.

Do not automatically classify a failure as an application defect, locator defect, network issue, environment issue, or authentication issue without evidence.

---

## 9. Expected vs Actual Analysis

### Capability

Compare expected and actual values shown in Tosca logs.

Example:

```text
Expected value: Customer Experience
Actual value: Customer Experience
```

Result:

```text
Verification successful
```

If they differ:

```text
Expected value: Customer Experience
Actual value: Other Value
```

Result:

```text
Verification mismatch
```

### Rules

- Preserve original values.
- Do not modify expected or actual values.
- Do not assume why values differ.
- Use mismatches as evidence when appropriate.

---

## 10. Tosca Error Interpretation

### Capability

Interpret explicit Tosca errors while preserving the original message.

Examples:

```text
Could not find Link 'Generic Link'
```

```text
No matching tab was found
```

The agent may classify these as a navigation/element lookup failure when supported by the execution context.

---

## 11. Contextual Execution Analysis

The agent must use surrounding steps to understand an error.

Example:

```text
Set Page Link Name
        ↓
Page_Link = CL-Resource-Center
        ↓
Click On The Page Link
        ↓
Generic Link x Input
        ↓
Could not find Link 'Generic Link'
```

The agent should understand that the failure occurred while attempting to navigate using the configured Resource Center link.

**Rule:** Context may explain an error, but must not be used to invent a cause.

---

## 12. Passed Test Case Analysis

For Passed cases:

```text
Status = Passed
Failure Reason = N/A
```

Retain relevant successful verification information when useful.

Do not invent additional details.

---

## 13. Failed Test Case Analysis

For every Failed test case:

1. Identify the test case.
2. Locate the failed step.
3. Find the explicit Tosca error.
4. Review surrounding steps.
5. Check expected and actual values.
6. Determine the evidence-based failure reason.
7. Preserve the original error.
8. Extract relevant details.
9. Record source PDF.
10. Record source page when available.

---

## 14. Multi-PDF Processing

The agent must process all supplied Tosca PDF reports.

Example:

```text
TC-001.pdf
TC-002.pdf
TC-003.pdf
TC-004.pdf
```

For every PDF:

```text
Read
 ↓
Extract
 ↓
Analyze
 ↓
Validate
 ↓
Consolidate
```

The agent must not stop after the first report.

---

## 15. Data Consolidation

### Capability

Combine extracted results from multiple Tosca reports into one structured dataset.

### Rules

- Preserve all valid records.
- Preserve source PDF information.
- Preserve execution date/time.
- Identify duplicate executions.
- Keep different executions separate.
- Do not merge records only because Test Case Names are identical.
- Preserve relevant source references.

---

## 16. Duplicate Detection

Compare:

```text
Test Case ID
Test Case Name
Report Name
Execution Date
Execution Time
Status
Execution Details
```

If records clearly represent the same execution:

```text
Consolidate
```

If they represent different executions:

```text
Keep as separate records
```

Never remove a record without sufficient evidence.

---

## 17. Conflict Detection

Identify conflicting information between reports.

Example:

```text
TC001 → Passed
TC001 → Failed
```

Check whether the records represent different:

- Executions
- Execution times
- Environments
- Reports

Do not silently overwrite one result with another.

Flag unresolved conflicts for review.

---

## 18. Source Traceability

Maintain a relationship between every result and its source report.

Recommended fields:

```text
Source PDF
Source Page
Report Date
Execution Time
```

Example:

```text
Source PDF: TC-002.pdf
Source Page: 10
```

---

## 19. Missing Information Handling

Use:

```text
Not Available
```

when information is missing.

Use:

```text
N/A
```

when a field is not applicable.

Examples:

```text
Missing Test Case ID → Not Available
Passed Test Case Failure Reason → N/A
Unknown Failure Reason → Not Available
```

---

## 20. Evidence-Based Reasoning

The agent must make conclusions only from evidence contained in the Tosca report.

### Allowed

```text
Tosca Error → Failure Reason
Expected ≠ Actual → Verification mismatch
Missing Link → Navigation element not found
```

### Not Allowed Without Evidence

```text
Missing Link → Application bug
```

---

## 21. Data Quality Validation

Before returning results, validate:

```text
✓ All PDFs processed
✓ All relevant test cases identified
✓ Status identified
✓ Failed steps identified
✓ Error messages captured
✓ Failure reasons supported by evidence
✓ Test Case IDs preserved
✓ Test Case Names preserved
✓ Source PDF captured
✓ Source page captured when available
✓ Duplicate records reviewed
✓ Conflicts identified
✓ Missing values handled correctly
✓ No unsupported assumptions
```

---

## 22. Sensitive Information Protection

Tosca reports may contain credentials or authentication-related information.

The agent must:

- Avoid exposing passwords.
- Avoid exposing tokens.
- Avoid exposing credentials.
- Exclude authentication secrets from final structured results.
- Retain only information required for test-result analysis.

---

## 23. Output Skill

The agent must produce structured records containing:

```text
Test Case ID
Test Case Name
Status
Failure Reason
Failed Step
Error Message
Details
Source PDF
Source Page
Report Date
Start Time
End Time
```

Recommended structure:

```json
{
  "test_case_id": "Not Available",
  "test_case_name": "Validate Customer Experience in Edge",
  "status": "Failed",
  "failure_reason": "Expected navigation link could not be found.",
  "failed_step": "Click On The Page Link / Generic Link",
  "error_message": "Could not find Link 'Generic Link'",
  "details": "The expected navigation element could not be located.",
  "source_pdf": "TC-002.pdf",
  "source_page": "10"
}
```

---

## 24. Skill Boundaries

### This Agent CAN

- Read Tosca PDFs.
- Extract test cases.
- Analyze execution results.
- Analyze execution steps.
- Identify failures.
- Determine evidence-based failure reasons.
- Consolidate data from multiple PDFs.
- Detect duplicates.
- Detect conflicts.
- Validate extracted information.
- Maintain source traceability.
- Return structured data.

### This Agent CANNOT

- Execute Tosca tests.
- Modify Tosca test cases.
- Modify PDF reports.
- Generate the final Excel file.
- Build or control the result UI.
- Change test execution results.
- Invent test cases.
- Invent Test Case IDs.
- Invent failure reasons.
- Hide conflicts.
- Expose credentials or authentication secrets.

---

## 25. Skill Execution Pattern

```text
Tosca PDF Reports
        ↓
PDF Reading & Extraction
        ↓
Test Case Identification
        ↓
Status Analysis
        ↓
Execution Step Analysis
        ↓
Failure Detection
        ↓
Failure Reason Analysis
        ↓
Contextual Analysis
        ↓
Multi-PDF Consolidation
        ↓
Duplicate / Conflict Detection
        ↓
Source Traceability
        ↓
Data Quality Validation
        ↓
Structured Output
```

---

## 26. Core Skill Instruction

> **Read and understand Tosca PDF execution reports, identify every test case and its actual execution status, analyze detailed execution steps and Tosca errors, determine failure reasons only from available evidence, consolidate results across reports, preserve source traceability, and return clean structured data without guessing or changing the original Tosca results.**
