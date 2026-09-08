# MASTER INDEX - TOSCA QA AUTOMATION PLATFORM v1.0
## Complete File and Document Reference

---

## SYSTEM OVERVIEW

This index provides a complete map of all files, documents, and components in the Tosca QA Automation Platform.

**System Purpose:** Automatically process Tosca PDF test execution reports and generate consolidated Excel reports with data validation, duplicate detection, and conflict resolution.

**Deployment Path:** `c:\AI Agents\`

**Version:** 1.0

**Status:** Production Ready

---

## FILE ORGANIZATION

### 📋 DOCUMENTATION FILES

#### Quick Start & Overview
| File | Location | Purpose | Read When |
|------|----------|---------|-----------|
| README.md | `Implementation/` | Quick start guide, common tasks | First - introduces the system |
| Master Index | `Implementation/INDEX.md` | This file - complete reference | Need to find something |

#### System Architecture & Design
| File | Location | Purpose | Read When |
|------|----------|---------|-----------|
| SYSTEM_SPECIFICATION.md | `Implementation/` | Complete system architecture, rules, data validation | Need detailed understanding |
| Agent_1_Tosca_PDF_Analysis_Implementation.md | `Implementation/` | Agent 1 specification and responsibilities | Customizing PDF analysis |
| Agent_2_Excel_Generation_Implementation.md | `Implementation/` | Agent 2 specification and responsibilities | Customizing Excel generation |
| run-qa-pipeline.md | `Implementation/` | Orchestration workflow, phases, quality gates | Understanding full pipeline |

#### Reference & Specifications
| File | Location | Purpose | Read When |
|------|----------|---------|-----------|
| Data_Formats_Templates.md | `Implementation/` | Data format schemas, JSON structure, Excel format | Working with data directly |
| Prompt.md | `Prompt/` | Original system requirements | Understanding source requirements |

---

### 💻 IMPLEMENTATION FILES (PowerShell Scripts)

#### Main Orchestrator
| File | Location | Purpose | How to Run |
|------|----------|---------|-----------|
| run_simple_pipeline.ps1 | `c:\AI Agents\` | Pipeline orchestrator - runs both agents | `powershell -ExecutionPolicy Bypass -File "c:\AI Agents\run_simple_pipeline.ps1"` |

#### Individual Agents
| File | Location | Purpose | Run Via |
|------|----------|---------|---------|
| agent1_execute.ps1 | `c:\AI Agents\` | PDF analysis & data consolidation | `run_simple_pipeline.ps1` or `. "c:\AI Agents\agent1_execute.ps1"` |
| agent2_execute.ps1 | `c:\AI Agents\` | Excel generation & validation | `run_simple_pipeline.ps1` or `. "c:\AI Agents\agent2_execute.ps1"` |

---

### 📁 DATA FOLDERS

#### Input Folder
```
c:\AI Agents\Uploads\
├── Place your Tosca PDF files here
├── Format: .pdf files only
├── Supported: All standard PDF formats
└── Note: Original files are never modified
```

**Contents:** Your Tosca test execution PDF reports
**Maximum Files:** No limit (system scales)
**Maximum Size:** No limit (depends on system RAM)
**Management:** Add/remove as needed between runs

#### Output Folder
```
c:\AI Agents\Test Results\
├── test_cases_consolidated.json    [Agent 1 output]
├── Consolidated_Tosca_Test_Execution_Report.xlsx  [Agent 2 output]
├── Tosca_Test_Execution_Consolidated.csv  [Fallback format]
├── Tosca_Test_Execution_Consolidated.html [Fallback format]
└── execution_log.txt               [Workflow log]
```

**Purpose:** Receives all output from pipeline
**Cleanup:** Safe to delete between runs (auto-recreated)
**Backup:** Consider backing up Excel reports

---

## DOCUMENT READING GUIDE

### For Different User Types

#### 👤 New User (Getting Started)
**Read in this order:**
1. `README.md` - Get oriented (5 min)
2. `run-qa-pipeline.md` - Understand workflow (10 min)
3. `SYSTEM_SPECIFICATION.md` - Understand capabilities (15 min)

**Then:** Copy PDFs to Uploads, run pipeline

#### 👨‍💼 Business User (Just Using)
**Read:**
- `README.md` - Quick start guide only

**Then:** Follow Quick Start Guide steps

#### 👨‍💻 Developer (Modifying/Debugging)
**Read in this order:**
1. `README.md` - Overview (5 min)
2. `SYSTEM_SPECIFICATION.md` - Architecture (20 min)
3. `run-qa-pipeline.md` - Phases & workflow (15 min)
4. `Agent_1_*.md` - PDF analysis logic (20 min)
5. `Agent_2_*.md` - Excel generation logic (15 min)
6. `Data_Formats_Templates.md` - Data schemas (15 min)

**Then:** Review/modify `.ps1` scripts

#### 🔍 Data Analyst (Working with Results)
**Read:**
- `Data_Formats_Templates.md` - Data structure reference
- Summary section of `run-qa-pipeline.md`

**Then:** Open Excel reports and analyze

---

## QUICK REFERENCE GUIDE

### What Goes Where?

| Item | Location | Format |
|------|----------|--------|
| Your test PDFs | `c:\AI Agents\Uploads\` | .pdf files |
| Consolidated data | `c:\AI Agents\Test Results\test_cases_consolidated.json` | JSON |
| Final report | `c:\AI Agents\Test Results\Consolidated_Tosca_Test_Execution_Report.xlsx` | Excel |
| Execution log | `c:\AI Agents\Test Results\execution_log.txt` | Text log |

### Key Commands

| Task | Command |
|------|---------|
| Run full pipeline | `powershell -ExecutionPolicy Bypass -File "c:\AI Agents\run_simple_pipeline.ps1"` |
| Run Agent 1 only | `. "c:\AI Agents\agent1_execute.ps1"` |
| Run Agent 2 only | `. "c:\AI Agents\agent2_execute.ps1"` |
| View logs | `notepad "c:\AI Agents\Test Results\execution_log.txt"` |
| View raw data | Open JSON file with text editor |

### File Size Expectations

| File | Size | Notes |
|------|------|-------|
| PDF file (typical) | 1-10 MB | Your input files |
| JSON output (100 tests) | 50-100 KB | Structured data |
| Excel report (100 tests) | 100-200 KB | With formatting |
| Execution log | 1-10 KB | Text log |

---

## SYSTEM CAPABILITIES

### What the System Does

✓ **PDF Discovery** - Finds all PDFs in Uploads folder
✓ **PDF Reading** - Extracts text from all pages
✓ **OCR Support** - Handles scanned documents
✓ **Test Extraction** - Finds test case IDs, names, statuses
✓ **Status Detection** - Identifies Pass/Fail/Blocked/other
✓ **Failure Analysis** - Extracts failure reasons and details
✓ **Data Validation** - Checks data integrity and consistency
✓ **Duplicate Detection** - Finds duplicate test records
✓ **Conflict Detection** - Identifies contradictory information
✓ **Data Consolidation** - Merges data from multiple PDFs
✓ **Excel Generation** - Creates professional Excel workbook
✓ **Excel Formatting** - Color-codes, headers, filters
✓ **Summary Statistics** - Calculates test counts and percentages
✓ **Source Traceability** - Preserves which PDF each record came from
✓ **Error Logging** - Records all processing details

### What the System Does NOT Do

✗ Modify your original PDF files
✗ Guess or invent test data
✗ Change test results
✗ Delete records silently
✗ Make assumptions about missing data
✗ Upload to external systems
✗ Share data beyond local files

---

## DATA FLOW DIAGRAM

```
PHASE 1: PDF ANALYSIS
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  Uploads Folder                                            │
│  ├─ TC-001.pdf ──┐                                        │
│  ├─ TC-002.pdf ──┼─→ [Agent 1: PDF Analysis]             │
│  └─ TC-003.pdf ──┘   - Read & extract data               │
│                      - Detect duplicates                  │
│                      - Detect conflicts                   │
│                      - Validate data                      │
│                                ↓                          │
│                    test_cases_consolidated.json           │
│                                                             │
└─────────────────────────────────────────────────────────────┘

PHASE 2: EXCEL GENERATION
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  test_cases_consolidated.json ──→ [Agent 2: Excel Gen]    │
│                                    - Read JSON             │
│                                    - Create workbook       │
│                                    - Format cells          │
│                                    - Add summary           │
│                                    - Validate output       │
│                                ↓                          │
│        Consolidated_Tosca_Test_Execution_Report.xlsx      │
│                                                             │
│                      User Review & Analysis                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## VALIDATION CHECKLIST

Before running pipeline:
- [ ] PDFs in `c:\AI Agents\Uploads\` folder
- [ ] PowerShell 5.1+ installed
- [ ] Execution policy allows scripts
- [ ] Sufficient disk space (1GB recommended)
- [ ] No antivirus blocking script execution

After running pipeline:
- [ ] `test_cases_consolidated.json` created
- [ ] `Consolidated_Tosca_Test_Execution_Report.xlsx` created
- [ ] `execution_log.txt` updated
- [ ] Excel file opens without errors
- [ ] All test cases visible in report
- [ ] Status column color-coded correctly
- [ ] Summary worksheet populated

---

## TROUBLESHOOTING INDEX

### Common Issues

| Problem | Cause | Solution | Documentation |
|---------|-------|----------|-----------------|
| "File not found" | Incorrect path | Check folder path | README.md |
| "Permission denied" | Access restrictions | Run as Administrator | README.md |
| "No PDFs found" | Empty Uploads folder | Add PDF files | README.md |
| "Excel not created" | Agent 2 failed | Check JSON file | run-qa-pipeline.md |
| "PowerShell error" | Execution policy | Use -ExecutionPolicy Bypass | README.md |
| "File locked" | Excel open during run | Close Excel first | README.md |

### Debug Approach

1. **Check execution log:**
   ```
   c:\AI Agents\Test Results\execution_log.txt
   ```

2. **Verify input files:**
   ```
   dir c:\AI Agents\Uploads\
   ```

3. **Check JSON output:**
   ```
   notepad c:\AI Agents\Test Results\test_cases_consolidated.json
   ```

4. **Review Agent 1 specifically:**
   ```powershell
   . "c:\AI Agents\agent1_execute.ps1"
   ```

5. **Review Agent 2 specifically:**
   ```powershell
   . "c:\AI Agents\agent2_execute.ps1"
   ```

---

## KEY CONCEPTS

### Status Values
- **Passed** = Test passed successfully
- **Failed** = Test failed (reason provided)
- **Blocked** = Test cannot run (dependency failed)
- **Skipped** = Test skipped intentionally
- **Not Available** = Status unknown/not found
- **Conflict / Review Required** = Different PDFs report different status

### Duplicate Test Case
- Same test ID AND same test name AND same context
- System consolidates into single record
- Source PDFs preserved

### Conflict Detection
- Same test case appears with different status in different PDFs
- Flagged for manual review
- Both sources documented

### Source Traceability
- Every record shows which PDF it came from
- Allows tracing results back to original reports
- Required for audit trails

---

## SUCCESS METRICS

### Successful Execution
- All phases complete without stopping errors
- JSON file created with all test cases
- Excel file created and opens successfully
- Execution log shows "SUCCESS" status
- Summary statistics calculated and displayed

### Data Quality
- All test cases from PDFs present in output
- No data loss or corruption
- Statuses match PDF content
- Source PDFs preserved
- Missing fields marked "Not Available"

### Output Quality
- Excel file formatted professionally
- Headers bold and color-coded
- Status column color-coded by status
- Summary worksheet present and accurate
- AutoFilter enabled for easy navigation

---

## VERSION MANAGEMENT

| Component | Version | Status | Last Updated |
|-----------|---------|--------|--------------|
| System Spec | 1.0 | Production | 2026-09-07 |
| Agent 1 | 1.0 | Production | 2026-09-07 |
| Agent 2 | 1.0 | Production | 2026-09-07 |
| Orchestrator | 1.0 | Production | 2026-09-07 |
| Documentation | 1.0 | Complete | 2026-09-07 |

---

## SUPPORT & RESOURCES

### Where to Find Things

| Question | Answer | Location |
|----------|--------|----------|
| How do I start? | Quick start guide | README.md |
| How does it work? | System architecture | SYSTEM_SPECIFICATION.md |
| What are the steps? | Workflow phases | run-qa-pipeline.md |
| How is data structured? | Data formats | Data_Formats_Templates.md |
| What went wrong? | Troubleshooting guide | README.md Troubleshooting section |
| I want to modify X | Agent specifications | Agent_1/Agent_2 _*.md files |

### Document Relationships

```
Prompt.md (Requirements)
        ↓
SYSTEM_SPECIFICATION.md (Architecture)
        ↓
        ├─→ Agent_1_*.md (PDF Analysis)
        ├─→ Agent_2_*.md (Excel Generation)
        ├─→ run-qa-pipeline.md (Orchestration)
        └─→ Data_Formats_Templates.md (Schemas)
                ↓
        Implementation Files (.ps1)
                ↓
        README.md (User Guide)
```

---

## QUICK START COMMAND

Copy and paste this command to get started:

```powershell
powershell -ExecutionPolicy Bypass -File "c:\AI Agents\run_simple_pipeline.ps1"
```

Then open the Excel report in `c:\AI Agents\Test Results\`

---

## DOCUMENT VERSION

| Version | Date | Status |
|---------|------|--------|
| 1.0 | 2026-09-07 | Initial - Production Ready |

**Master Index provides complete reference for all system files and components.**
