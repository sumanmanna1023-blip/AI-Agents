# AI-Driven Tosca QA Automation Platform

## What This Project Is

This AI-driven QA automation platform takes **Tosca PDF reports** as input, reads and analyzes the information from those reports, consolidates the test case results, and generates an Excel report.

The main objective is to automate the process of reviewing Tosca execution reports and preparing an organized test execution result.

The final Excel report will mention:

- Which test cases passed
- Which test cases failed
- The reason for failure for each failed test case
- Any other relevant details identified from the Tosca PDF reports

The workflow is divided into two main AI agents:

1. **Tosca PDF Analysis & Data Consolidation Agent**
2. **Excel Generation & UI Interaction Agent**

---

# Current Workflow

```text
Requirement Document
        │
        ▼
Tosca PDF Reports
        │
        ▼
┌──────────────────────────────────┐
│              Agent 1              │
│                                  │
│  Tosca PDF Analysis &             │
│  Data Consolidation              │
│                                  │
│  Read → Analyze → Validate →     │
│  Merge the Test Case Details     │
└────────────────┬─────────────────┘
                 │
                 ▼
        Consolidated Test Data
                 │
                 ▼
┌──────────────────────────────────┐
│              Agent 2              │
│                                  │
│  Excel Generation &              │
│  UI Interaction                 │
│                                  │
│  Generate Excel → Validate →     │
│  Display Results in UI           │
└────────────────┬─────────────────┘
                 │
                 ▼
          Final Result
    Test Case Dashboard /
         Excel View
```

---

# Current Agent Responsibilities

Each agent has a defined responsibility.

The agents should complete their assigned tasks without unnecessarily performing work that belongs to the other agent.

---

# 1. Tosca PDF Analysis & Data Consolidation Agent

## Purpose

This agent is responsible for taking all Tosca PDF reports, analyzing them, identifying the test case results, and consolidating the extracted information into one structured dataset.

## Responsibilities

- Takes all the Tosca PDF reports as input.
- Reads and analyzes each PDF report.
- Identifies the test cases available in the reports.
- Identifies the Test Case ID and Test Case Name.
- Determines whether each test case is Passed, Failed, Blocked, or another clearly stated status.
- Identifies the reason for failure when a test case has failed.
- Extracts relevant execution details from the report.
- Maintains the relationship between the test case and its source Tosca PDF.
- Handles multiple Tosca PDF reports.
- Consolidates the information from all analyzed PDFs.
- Detects duplicate test cases or duplicate information.
- Detects conflicting information.
- Validates the extracted data before passing it to Agent 2.
- Sends the final structured and consolidated dataset to Agent 2.

## Does NOT

- Modify or change the original Tosca PDF files.
- Assume a test case is Passed or Failed if the status is not clearly available.
- Create a failure reason based on assumptions or guesses.
- Add information that is not available in the Tosca PDF.
- Ignore a test case just because some information is incomplete.
- Change the original Test Case ID or Test Case Name unnecessarily.
- Mix information from different reports incorrectly.
- Skip pages or relevant sections of a PDF.
- Treat unrelated comments, logs, or information as test results.
- Convert Failed to Passed or Passed to Failed.
- Create new test cases that do not exist in the source reports.
- Remove a test case unless it is confirmed to be a duplicate.
- Hide conflicting or uncertain information.

## Main Rule

> This agent should only extract, analyze, validate, and consolidate information that is actually available in the Tosca PDF reports. It should not guess or create missing information.

## Skills

- PDF document reading
- PDF text extraction
- OCR for scanned PDFs
- Tosca report understanding
- Document understanding
- Test case identification
- Test Case ID extraction
- Test Case Name extraction
- Test execution result detection
- Passed/Failed/Blocked status classification
- Failure reason identification
- Error and execution log analysis
- Requirement and test-step understanding
- Structured data extraction
- Multiple PDF processing
- Different PDF format handling
- Missing-data detection
- Confidence and uncertainty detection
- Duplicate detection
- Data consolidation
- Data normalization
- Conflict detection
- Data validation
- Source traceability
- Structured JSON/data handling

## Output

The agent should provide structured data containing information such as:

```text
SCTASK ID
Test Case ID
Test Case Name
Status
Failure Reason
Test Result Details
Source Tosca PDF
```

---

# 2. Excel Generation & UI Interaction Agent

## Purpose

This agent takes the consolidated test case data from Agent 1, generates the final Excel report, validates the generated file, and interacts with the UI to display the results in an Excel-like format.

## Responsibilities

### Excel Generation

- Takes the consolidated data from Agent 1.
- Creates the final Excel file.
- Organizes the information into proper columns.
- Maintains the original Test Case ID and Test Case Name.
- Maintains the Passed/Failed status received from Agent 1.
- Maintains the original failure reason.
- Includes relevant test execution details.
- Applies proper spreadsheet formatting.
- Validates that all records received from Agent 1 are included in the Excel file.
- Validates the generated Excel file before presenting it to the user.

### Suggested Excel Structure

| Test Case ID | Test Case Name | Status | Failure Reason | Details |
|---|---|---|---|---|
| TC001 | Login Validation | Passed | N/A | Test completed |
| TC002 | Order Creation | Failed | API returned 500 | Order could not be created |

### UI Interaction

- Takes the generated Excel file.
- Interacts with the application UI.
- Opens or displays the generated results.
- Presents the data in an Excel-like format.
- Allows the user to easily review Passed and Failed test cases.
- Allows the user to review failure reasons and execution details.
- Can use Playwright for UI interaction and automation.
- Validates that the data displayed in the UI matches the generated Excel data.

## Does NOT

### Excel

- Change the test case status while generating the Excel.
- Change the meaning of the failure reason.
- Remove important test case information.
- Create fake or placeholder test results.
- Add test cases that were not received from Agent 1.
- Generate an incomplete Excel file.
- Duplicate records unnecessarily.
- Change the original Test Case ID.
- Change the source data simply for formatting purposes.

### UI

- Modify the actual test case results.
- Change Passed to Failed or Failed to Passed.
- Change failure reasons.
- Delete test cases or rows.
- Add information that is not present in the generated Excel.
- Hide failed test cases.
- Make assumptions about missing information.
- Change the original Excel file unless explicitly instructed.
- Change the displayed information in a way that alters its meaning.

## Main Rule

> This agent should convert the consolidated data into the required Excel format and present the same information through the UI. It should not change, reinterpret, or invent the test results.

## Skills

### Excel Skills

- Excel file generation
- Spreadsheet formatting
- Column creation
- Data mapping
- Table creation
- Sorting and filtering
- Header formatting
- Status formatting
- Failure-reason formatting
- Auto column sizing
- Data validation
- Duplicate validation
- Excel formula handling when required
- File naming
- File creation and saving
- Excel integrity validation

### UI and Automation Skills

- Browser/UI interaction
- Playwright automation
- File upload/download handling
- Excel file interaction
- UI navigation
- Table interaction
- Searching and filtering
- Sorting
- Data verification
- UI element identification
- Dynamic element handling
- Screenshot capture
- Error handling
- Test execution
- Result validation
- Self-healing automation

---

# Common Rules for Both Agents

Both agents should follow these rules:

1. Do not guess or hallucinate information.
2. Do not modify the original source documents.
3. Do not change Passed/Failed results.
4. Do not create test cases that are not present in the source.
5. Do not remove information without a valid reason.
6. Preserve Test Case IDs.
7. Preserve Test Case Names.
8. Preserve source Tosca PDF references when available.
9. Preserve the original failure reason as much as possible.
10. If information is missing, mark it as **Not Available** instead of guessing.
11. If information is conflicting, flag it for review.
12. Maintain traceability from the final Excel row back to the original Tosca PDF.
13. Validate input and output at each stage.
14. Maintain clear logs for processing errors and exceptions.
15. One agent should not unnecessarily duplicate the work of the other agent.

---

# run-qa-pipeline

Responsible for orchestrating the complete QA workflow.

## Execution Sequence

### Step 1 — Tosca PDF Analysis & Data Consolidation

Agent 1:

```text
Tosca PDF Reports
       ↓
Read PDFs
       ↓
Analyze Test Cases
       ↓
Identify Status
       ↓
Identify Failure Reasons
       ↓
Extract Test Details
       ↓
Validate Data
       ↓
Merge & Consolidate
```

Output:

```text
Consolidated Test Case Data
```

### Step 2 — Excel Generation & UI Interaction

Agent 2:

```text
Consolidated Test Case Data
       ↓
Generate Excel
       ↓
Validate Excel
       ↓
Interact with UI
       ↓
Display Test Results
```

Output:

```text
Final Excel Report
       +
Test Case Dashboard / Excel View
```

---

# Final End-to-End Flow

```text
Requirement Document
        │
        ▼
Tosca PDF Reports
        │
        ▼
┌────────────────────────────────────┐
│              AGENT 1               │
│                                    │
│ Tosca PDF Analysis &               │
│ Data Consolidation                 │
│                                    │
│ Read → Analyze → Validate → Merge  │
└──────────────────┬─────────────────┘
                   │
                   ▼
        Consolidated Test Data
                   │
                   ▼
┌────────────────────────────────────┐
│              AGENT 2               │
│                                    │
│ Excel Generation &                 │
│ UI Interaction                    │
│                                    │
│ Generate → Validate → Display      │
└──────────────────┬─────────────────┘
                   │
                   ▼
             Final Result
                   │
          ┌────────┴────────┐
          ▼                 ▼
     Excel Report      Test Dashboard
```

# Final Objective

The objective of this project is to automate the process of reviewing **Tosca PDF reports** and converting the execution results into a structured and easy-to-review Excel report.

The two-agent workflow reduces unnecessary agent-to-agent communication while keeping the responsibilities clearly separated:

**Agent 1:** Read → Analyze → Validate → Consolidate

**Agent 2:** Generate Excel → Validate → Display through UI

The final result should provide a clear view of the test execution status, including Passed and Failed test cases, failure reasons, and other relevant execution details.
