# README - TOSCA QA AUTOMATION PLATFORM v1.0

## Quick Start

### What is This System?

This is an **AI-Driven Tosca QA Automation Platform** that automatically processes Tosca PDF test execution reports and generates consolidated Excel reports.

**In Simple Terms:**
1. Put Tosca PDF test reports in the `Uploads` folder
2. Run the pipeline script
3. Get a formatted Excel report with all test results, statistics, and formatting

### Key Features

✓ **Automatic PDF Discovery** - Finds all Tosca PDFs in Uploads folder
✓ **Intelligent Data Extraction** - Extracts test cases, statuses, failure reasons
✓ **Duplicate Detection** - Identifies duplicate test records across PDFs
✓ **Conflict Detection** - Flags contradictory information requiring review
✓ **Data Validation** - Validates all extracted information against evidence-based rules
✓ **Professional Excel Report** - Generates formatted, color-coded Excel workbook
✓ **Summary Statistics** - Includes dashboard with test execution counts
✓ **Source Traceability** - Preserves which PDF each test case came from

### System Architecture

```
Tosca PDFs
    ↓
[Agent 1: PDF Analysis & Consolidation]
    ↓
JSON Data
    ↓
[Agent 2: Excel Generation & Validation]
    ↓
Excel Report
```

---

## Installation & Setup

### Prerequisites
- Windows 10/11 or Windows Server
- PowerShell 5.1+
- .NET Framework 4.5+ (for some features)
- Sufficient disk space (1GB recommended)

### Directory Structure

The system uses this folder structure (auto-created if missing):

```
c:\AI Agents\
├── Uploads/                    ← Put your Tosca PDFs here
├── Test Results/              ← Output files go here
├── Implementation/            ← System documentation
│   ├── Agent_1_Tosca_PDF_Analysis_Implementation.md
│   ├── Agent_2_Excel_Generation_Implementation.md
│   ├── SYSTEM_SPECIFICATION.md
│   ├── Data_Formats_Templates.md
│   ├── run-qa-pipeline.md
│   └── README.md (this file)
├── Scripts/
│   ├── agent1_execute.ps1
│   ├── agent2_execute.ps1
│   └── run_simple_pipeline.ps1
└── Prompt/
    └── Prompt.md
```

---

## Quick Start Guide

### Step 1: Add Your Tosca PDFs

1. Open Windows File Explorer
2. Navigate to: `c:\AI Agents\Uploads\`
3. Copy your Tosca test execution PDF reports here
4. Supported format: `.pdf` files only

### Step 2: Run the Pipeline

Open PowerShell and run:

```powershell
powershell -ExecutionPolicy Bypass -File "c:\AI Agents\run_simple_pipeline.ps1"
```

### Step 3: Review Results

After execution completes, find your outputs in `c:\AI Agents\Test Results\`:

- **Consolidated_Tosca_Test_Execution_Report.xlsx** ← Your main report
- **test_cases_consolidated.json** ← Raw data (JSON format)
- **execution_log.txt** ← Detailed execution log

---

## What Each File Does

### Agent 1: PDF Analysis & Consolidation
**File:** `agent1_execute.ps1`

**Purpose:** Reads Tosca PDF files and extracts test data

**Process:**
1. Discovers all PDF files in Uploads folder
2. Reads each PDF completely (all pages)
3. Extracts test case information using text recognition/OCR
4. Identifies test statuses (Passed, Failed, Blocked, etc.)
5. Extracts failure reasons and execution details
6. Normalizes data to consistent format
7. Detects duplicate test cases across PDFs
8. Detects conflicting information
9. Validates entire dataset
10. Creates JSON output file

**Output:** `test_cases_consolidated.json`

### Agent 2: Excel Generation & Validation
**File:** `agent2_execute.ps1`

**Purpose:** Converts JSON data into professional Excel report

**Process:**
1. Reads JSON data from Agent 1
2. Creates Excel workbook with formatting
3. Creates two worksheets:
   - **Test Execution Results** - All test cases with details
   - **Summary** - Statistics and counts
4. Applies professional formatting:
   - Color-coded status column
   - Bold headers
   - Auto-sized columns
   - Filters for easy searching
5. Validates that all data is present and correct
6. Saves final Excel file

**Output:** `Consolidated_Tosca_Test_Execution_Report.xlsx`

### Orchestrator
**File:** `run_simple_pipeline.ps1`

**Purpose:** Coordinates the entire workflow

**Process:**
1. Initializes system (creates folders, starts logging)
2. Runs Agent 1 (PDF analysis)
3. Runs Agent 2 (Excel generation)
4. Displays final summary and statistics

**Run This:** This is the main file you execute to run everything

---

## File Organization

### Documentation Files (Read These)

| File | Purpose |
|------|---------|
| `README.md` | Quick start guide (this file) |
| `SYSTEM_SPECIFICATION.md` | Complete system architecture and rules |
| `Agent_1_Tosca_PDF_Analysis_Implementation.md` | Agent 1 detailed specifications |
| `Agent_2_Excel_Generation_Implementation.md` | Agent 2 detailed specifications |
| `run-qa-pipeline.md` | Orchestration workflow guide |
| `Data_Formats_Templates.md` | Data format reference and examples |
| `INDEX.md` | Master index of all files |

### Implementation Files (These Do the Work)

| File | Purpose |
|------|---------|
| `agent1_execute.ps1` | Agent 1 PowerShell implementation |
| `agent2_execute.ps1` | Agent 2 PowerShell implementation |
| `run_simple_pipeline.ps1` | Pipeline orchestrator |

### Input/Output Folders

| Folder | Purpose | Files |
|--------|---------|-------|
| `Uploads/` | Input PDF files | Your Tosca PDFs |
| `Test Results/` | Output files | JSON, Excel, logs |

---

## How to Use

### Scenario 1: New User - Process Some PDFs

1. **Copy your Tosca PDFs:**
   ```
   c:\AI Agents\Uploads\
   ```

2. **Run the pipeline:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File "c:\AI Agents\run_simple_pipeline.ps1"
   ```

3. **Open the Excel report:**
   ```
   c:\AI Agents\Test Results\Consolidated_Tosca_Test_Execution_Report.xlsx
   ```

### Scenario 2: Troubleshooting - Check What Went Wrong

1. **Review the execution log:**
   ```
   c:\AI Agents\Test Results\execution_log.txt
   ```

2. **Check JSON for raw data:**
   ```
   c:\AI Agents\Test Results\test_cases_consolidated.json
   ```

3. **Common issues and fixes:**
   - **"No PDFs found"** → Put PDFs in Uploads folder
   - **"Permission denied"** → Run PowerShell as Administrator
   - **"File locked"** → Close Excel before running
   - **"Path does not exist"** → Create c:\AI Agents folder manually

### Scenario 3: Batch Processing - Multiple Rounds

The system processes **all PDFs in Uploads folder each time.**

To process different PDFs:
1. Clear Uploads folder (or move PDFs elsewhere)
2. Add new PDFs to Uploads
3. Run pipeline again
4. New Excel report in Test Results folder

---

## Data Handling

### What Data Goes In?

**Input:** Tosca PDF test execution reports containing:
- Test case IDs
- Test case names
- Execution statuses (Passed, Failed, Blocked, etc.)
- Failure reasons (if tests failed)
- Execution details and logs

### What Data Comes Out?

**Output:** Excel report with:
- All test cases from all PDFs consolidated
- Test case ID, name, status, failure reason, details
- Color-coded by status (Green=Passed, Red=Failed, Yellow=Blocked)
- Summary statistics worksheet
- Professional formatting for easy review

### Data Integrity

**Key Guarantee:** 
All data is extracted directly from your PDFs.
- ✓ No guessing or inventing
- ✓ No modification of test results
- ✓ Source PDF preserved for each record
- ✓ Missing data clearly marked "Not Available"
- ✓ Conflicts flagged for manual review

---

## Key Rules & Policies

### Missing Information
When PDF doesn't contain certain information:
- Field is marked: **"Not Available"**
- Never guessed or invented
- Never assumed from other fields

### Test Case IDs and Names
- Preserved **exactly as found** in PDF
- Never created or modified
- Case-sensitive

### Status Values
- **Passed** - Test passed successfully
- **Failed** - Test failed with reason
- **Blocked** - Test cannot run (dependency failed)
- **Skipped** - Test skipped intentionally
- **Not Available** - Status not found in PDF
- **Conflict / Review Required** - Contradictory info in multiple PDFs

### Duplicate Handling
- Same test case in multiple PDFs = consolidated into one record
- Source PDFs preserved in report
- Multiple executions = preserved as separate records

### Conflict Detection
- Same test ID with different status in different PDFs
- Flagged as "Conflict / Review Required"
- Both sources preserved
- Requires manual review to resolve

---

## Troubleshooting

### Issue: PowerShell Execution Policy Error

```
"...cannot be loaded because running scripts is disabled..."
```

**Fix:**
```powershell
powershell -ExecutionPolicy Bypass -File "c:\AI Agents\run_simple_pipeline.ps1"
```

### Issue: Path Not Found

```
"The system cannot find the path specified"
```

**Fix:**
```powershell
# Create the folder manually
mkdir "c:\AI Agents\Uploads"
mkdir "c:\AI Agents\Test Results"
mkdir "c:\AI Agents\Implementation"
```

### Issue: No PDFs Found

```
"No Tosca PDF reports were found in the Uploads folder"
```

**Fix:**
1. Copy your Tosca PDFs to `c:\AI Agents\Uploads\`
2. Make sure files end in `.pdf`
3. Run pipeline again

### Issue: Permission Denied

```
"Access to the path is denied"
```

**Fix:**
1. Run PowerShell as Administrator
2. Check folder permissions are not read-only
3. Make sure no other program has files locked

### Issue: Excel File Not Created

```
"Excel file was not created"
```

**Fix:**
1. Check that PDF analysis completed successfully
2. Check `test_cases_consolidated.json` exists
3. Run pipeline again with more detail:
   ```powershell
   # Run just Agent 2 to debug
   & "c:\AI Agents\agent2_execute.ps1"
   ```

---

## Support & Next Steps

### To Learn More

Read these files in order:
1. **README.md** (this file) - Quick start
2. **SYSTEM_SPECIFICATION.md** - How system works
3. **run-qa-pipeline.md** - Detailed workflow
4. **Agent_1_*.md** - PDF analysis details
5. **Agent_2_*.md** - Excel generation details

### To Customize

Edit these PowerShell scripts (if needed):
- `agent1_execute.ps1` - Customize PDF processing
- `agent2_execute.ps1` - Customize Excel formatting
- `run_simple_pipeline.ps1` - Customize workflow

### To Debug

Check these files:
- `execution_log.txt` - What happened during run
- `test_cases_consolidated.json` - Raw extracted data
- Excel file - Final formatted output

---

## Version & Support

| Item | Value |
|------|-------|
| Platform Version | 1.0 |
| Release Date | 2026-09-07 |
| Status | Production Ready |
| Support | Full Documentation Included |

---

## Key Features Summary

### Automatic Processing
- Discovers PDFs automatically
- No manual file navigation needed
- Processes all PDFs in one run

### Intelligent Extraction
- Text recognition for regular PDFs
- OCR support for scanned documents
- Smart pattern matching for test data

### Quality Assurance
- Duplicate detection
- Conflict detection
- Data validation before Excel generation
- Source traceability for audit trail

### Professional Output
- Color-coded Excel report
- Formatted headers and styling
- Summary statistics worksheet
- AutoFilter for easy navigation
- Print-friendly formatting

### Error Handling
- Graceful handling of partial failures
- Detailed execution logging
- Clear error messages
- Fallback options available

---

## Getting Started Now

1. **Copy test PDFs to Uploads folder:**
   ```
   c:\AI Agents\Uploads\
   ```

2. **Run the pipeline:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File "c:\AI Agents\run_simple_pipeline.ps1"
   ```

3. **Open your Excel report:**
   ```
   c:\AI Agents\Test Results\Consolidated_Tosca_Test_Execution_Report.xlsx
   ```

**That's it! You now have a consolidated report with all your test results.**

---

For detailed technical information, see the other documentation files in the `Implementation` folder.
