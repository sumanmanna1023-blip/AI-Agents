## AI-Driven SCTASK QA Automation Platform

## What This Project Is

This AI agent takes all the SCTASK reports as input and reads and analyzes the information from those reports. Based on the analysis, the agent will generate an Excel file containing the test case results.

The Excel file will mention:

- Which test cases passed
- Which test cases failed
- The reason for failure for each failed test case
- Any other relevant details identified from the SCTASK reports
- The main idea is to automate the process of reviewing SCTASK reports and preparing the test execution results in an organized Excel format.

## Current Workflow

Requirement Document

Tosca PDF Reports
        │
        ▼
SCTASK PDF Reports
        │
        ▼
┌─────────────────────┐
│      Agent 1        │
│    PDF Analysis     │
│                     │
│  Read & Analyze     │
│       PDFs          │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      Agent 2        │
│ Data Consolidation  │
│                     │
│  Merge All Details  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      Agent 3        │
│  Excel Generation   │
│                     │
│ Create Final Excel  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      Agent 4        │
│   UI Interaction    │
│                     │
│ Display Excel Data  │
└──────────┬──────────┘
           │
           ▼
      Final Result

  Test Case Dashboard
        / Excel View

## Current Agent Responsibilities

Each agent has a single responsibility.

Never perform work that belongs to another agent.

1. PDF Analysis Agent

Responsibilities

- Takes all the SCTASK PDF reports.
- Reads and analyzes each report.
- Identifies the test cases and their execution results.
- Finds whether each test case is Passed or Failed.
- If a test case is failed, identifies the reason for failure.
- Sends the analyzed details to Agent 2.

Does NOT

- Modify or change the original PDF files.
- Assume a test case is Passed or Failed if the status is not clearly mentioned.
- Create a failure reason based on assumptions or guesses.
- Add information that is not available in the PDF.
- Ignore test cases just because the information is incomplete.
- Change the original test case name or test case ID unnecessarily.
- Mix information from different SCTASK reports while analyzing them.
- Skip pages or sections of a PDF without checking them.
- Treat comments, logs, or unrelated information as a test case result unless it is clearly relevant.

Main Rule - 

-- This Agent should only extract and analyze what is actually available in the PDF. It should not guess missing information.

Skills - 

- PDF document reading
- PDF text extraction
- OCR for scanned PDFs
- Document understanding
- Test case identification
- Test case status detection
- Passed/Failed/Blocked status classification
- Failure reason identification
- Error/log analysis
- Requirement and test-step understanding
- Structured data extraction
- Handling multiple PDF files
- Handling different PDF formats
- Missing-data detection
- Confidence/uncertainty detection
- Source traceability

Output -

- SCTASK ID
- Test Case ID
- Test Case Name
- Status
- Failure Reason
- Test Result Details
- Source PDF

2. Data Consolidation Agent

Responsibilities

Takes all the analysis received from Agent 1.
Merges the details from all PDF reports.
Removes duplicate information if required.
Consolidates the test case name, status, failure reason, and other relevant details into a single structured dataset.
Sends the consolidated data to Agent 3.

Does NOT

Change the results provided by Agent 1 without a valid reason.
Convert Failed to Passed or vice versa.
Create new test cases that were not present in the Agent 1 results.
Remove test cases unless they are confirmed duplicates.
Change failure reasons or create new reasons based on assumptions.
Mix data between different SCTASKs incorrectly.
Lose the reference to the original SCTASK/report.
Ignore conflicting information without flagging it.
Main Rule
This Agent should merge and organize the information, not reinterpret the results.


Skills

Data merging
Data consolidation
Duplicate detection
Test case matching
Test case ID matching
SCTASK mapping
Data validation
Data normalization
Conflict detection
Missing-data identification
Status consistency validation
Failure-reason consolidation
Structured JSON/data handling
Maintaining source traceability
Sorting and grouping test cases

Example

If Agent 1 provides:

SCTASK-101 → TC001 → Passed
SCTASK-102 → TC002 → Failed → Login error
SCTASK-103 → TC003 → Passed

Agent 2 should convert it into one consolidated dataset instead of keeping separate outputs.

Important Skill

Agent 2 should be able to detect when the same test case appears in multiple reports and determine whether it is actually a duplicate or a separate execution.

3. Excel Generation Agent

Responsibilities

Takes the consolidated data from Agent 2.
Creates an Excel file with the test execution results.
Organizes the information into proper columns such as:
Test Case
Status
Failure Reason
SCTASK Reference
Additional Details
Generates the final Excel file.

Does NOT

Change the test case status while generating the Excel.
Change or rewrite the failure reason in a way that changes its meaning.
Remove important test case information.
Create fake or placeholder test results.
Add unnecessary columns or information that wasn't requested.
Generate an incomplete Excel file.
Duplicate test cases unless the source data contains legitimate duplicates.
Change the original SCTASK/Test Case IDs.

Main Rule

This Agent should only convert the consolidated data into the required Excel format.
Skills
Excel file generatio
Spreadsheet formatting
Column creation
Data mapping
Table creation
Sorting and filtering
Header formattin
Status formatting
Failure-reason formatting
Auto column sizing
Data validation
Duplicate validation
Excel formula handling if required
File naming
File creation and saving
Excel integrity validation


Suggested Excel Structure


| SCTASK ID  | Test Case ID | Test Case Name   | Status | Failure Reason   | Details                                                               |
| ---------- | ------------ | ---------------- | ------ | ---------------- | --------------------------------------------------------------------- |
| SCTASK-101 | TC001        | Login Validation | Passed | N/A              | Test completed successfully                                           |
| SCTASK-102 | TC002        | Order Creation   | Failed | API returned 500 | Order could not be created because the API returned an HTTP 500 error |


Important Skill

Before generating the final file, Agent 3 should validate that every record received from Agent 2 is present in the Excel file.

4. UI Interaction Agent

Responsibilities

Takes the Excel file generated by Agent 3.
Interacts with the UI.
Opens/displays the generated Excel file.
Shows the test case results in an Excel-like format so the user can easily review the Passed and Failed test cases and their failure reasons.

Does NOT

Modify the actual test case results.
Change Passed/Failed status.
Change failure reasons.
Delete rows or test cases from the generated file.
Add data that is not present in the Excel file.
Change the original Excel file unless explicitly instructed.
Make assumptions about missing information.
Hide failed test cases.
Change the formatting in a way that makes important information difficult to understand.

Main Rule

This Agent is mainly responsible for displaying/presenting the final information, not changing the data.

Skills

Browser/UI interaction
Playwright automation
File upload/download handling
Excel file interaction
UI navigation
Table interaction
Searching and filtering
Sorting
Data verification
UI element identification
Dynamic element handling
Screenshot capture
Error handling
Test execution
Result validation
Self-healing automation


## Common Rules for All Agents

All agents should follow these rules:

Do not guess or hallucinate information.
Do not modify source information unless explicitly required.
Do not change Passed/Failed results.
Do not create test cases that are not present in the source.
Do not remove information without a valid reason.
Preserve Test Case IDs and SCTASK references.
Preserve the original failure reason as much as possible.
If information is missing, mark it as Not Available instead of guessing.
If information is conflicting, flag it for review instead of choosing one randomly.
Maintain traceability from the final Excel row back to the original SCTASK/PDF.
Each agent should only perform the task assigned to it.
One agent should not perform another agent's responsibility.
Validate both input and output at every stage.
Maintain clear logs for processing errors and exceptions.

## run-qa-pipeline

Responsible for orchestrating the complete QA workflow.

Execution Sequence

PDF Analysis Agent
Data Consolidation Agent
Excel Generation Agent
UI Interaction Agent

- Pipeline Flow

Input
  │
  ▼
SCTASK PDF Reports
  │
  ▼
Agent 1
PDF Analysis
  │
  ▼
Structured Test Results
  │
  ▼
Agent 2
Data Consolidation
  │
  ▼
Consolidated Test Data
  │
  ▼
Agent 3
Excel Generation
  │
  ▼
Final Excel Report
  │
  ▼
Agent 4
UI Interaction
  │
  ▼
Final Test Case Dashboard / Excel View

## Final Objective

The complete pipeline should automate the process from SCTASK PDF reports to a structured and reviewable test execution report, while preserving the original test results and failure information throughout the workflow.

The agents should work independently within their defined responsibilities and pass validated outputs from one stage to the next.