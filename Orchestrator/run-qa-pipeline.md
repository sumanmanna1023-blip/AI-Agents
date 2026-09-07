# Orchestrator - run-qa-pipeline

## Pipeline Orchestrator

This file describes the orchestration and execution of the AI-Driven Tosca QA Automation Platform.

### System Overview

The complete workflow consists of two sequential agents coordinated by this orchestrator:

```
START
  ↓
Validate Input Files
  ↓
AGENT 1: Tosca PDF Analysis & Data Consolidation
  Read → Analyze → Validate → Consolidate
  ↓
Consolidated Test Data (JSON)
  ↓
AGENT 2: Excel Generation & UI Interaction
  Generate → Validate → Display
  ↓
Final Output: Excel Report + UI Display
  ↓
END
```

## Orchestration Process

### Phase 1: Initialization

```
1. Start Pipeline
   - Initialize logging
   - Set working directory to: c:\AI Agents
   - Confirm Test Results folder exists
   - Confirm Uploads folder exists
   - Initialize error tracking

2. Validate Input
   - Verify Tosca PDF files are provided
   - Confirm all files are readable
   - List all input files
   - Record file count

3. Log Start
   - Timestamp workflow start
   - Record input file names
   - Initialize progress tracking
```

### Phase 2: Agent 1 Execution

```
4. Invoke Agent 1 - Tosca PDF Analysis & Data Consolidation
   
   Instructions:
   - Use Agent_1_Tosca_PDF_Analysis_Implementation.md
   - Process all Tosca PDF files in Uploads folder
   - Extract test case information
   - Validate extracted data
   - Detect duplicates and conflicts
   - Consolidate results
   
   Expected Input:
   - One or more .pdf files
   
   Expected Output:
   - Consolidated test case data (JSON format)
   - File: test_cases_consolidated.json
   - Location: /Test Results/
   
   Validation:
   - Confirm JSON is valid
   - Verify all required fields present
   - Confirm record count > 0
   - Check for conflicts/duplicates flags

5. Monitor Agent 1 Progress
   - Track processing status
   - Log any errors or warnings
   - Capture extraction summary
   - Validate output structure

6. Validate Agent 1 Output
   - Confirm test_cases_consolidated.json exists
   - Parse JSON file
   - Verify schema:
     - test_cases: array
     - Each record has: test_case_id, test_case_name, status, 
       failure_reason, test_result_details, source_tosca_pdf
     - Validation metadata included
   
   If validation FAILS:
   - Log error
   - Stop pipeline
   - Report to user
   - Do not proceed to Agent 2
   
   If validation PASSES:
   - Log success
   - Proceed to Agent 2

7. Prepare Agent 1 Output for Agent 2
   - Copy test_cases_consolidated.json to input for Agent 2
   - Timestamp data handoff
   - Log transition to Agent 2
```

### Phase 3: Agent 2 Execution

```
8. Invoke Agent 2 - Excel Generation & UI Interaction
   
   Instructions:
   - Use Agent_2_Excel_Generation_Implementation.md
   - Receive consolidated test data from Agent 1
   - Generate Excel report
   - Validate Excel integrity
   - Interact with UI
   - Display results
   
   Expected Input:
   - test_cases_consolidated.json from Agent 1
   
   Expected Output:
   - Excel file: Tosca_Test_Execution_Consolidated.xlsx
   - Location: /Test Results/
   - UI display with results

9. Monitor Agent 2 Progress
   - Track Excel generation
   - Monitor file creation
   - Track UI interaction
   - Capture validation results

10. Validate Agent 2 Output
    - Confirm Excel file exists
    - Verify file size > 0
    - Attempt to open Excel
    - Verify worksheet structure
    - Verify record count = Agent 1 count
    - Sample-check data values
    - Confirm UI display
    
    If validation FAILS:
    - Log error details
    - Provide remediation guidance
    - Report to user
    - Continue to completion reporting
    
    If validation PASSES:
    - Log success
    - Proceed to completion

11. Verify Data Integrity Through All Layers
    
    Required validation:
    
    Agent 1 Data → Excel Data:
    - Record count must match
    - Test Case IDs must be identical
    - Test Case Names must be identical
    - Statuses must be identical
    - Failure Reasons must be identical
    
    Excel Data → UI Data:
    - All displayed values must match Excel
    - No truncation allowed
    - No reformatting of values
    - Source references must be preserved
```

### Phase 4: Completion & Reporting

```
12. Generate Final Report
    
    Report must include:
    
    Input Summary:
    - Total PDFs processed: [count]
    - Total test cases identified: [count]
    - Processing timestamp
    
    Agent 1 Summary:
    - Records consolidated: [count]
    - Duplicates detected: [count]
    - Conflicts detected: [count]
    - Errors encountered: [count]
    - Data validation status: PASSED/FAILED
    
    Agent 2 Summary:
    - Excel file generated: YES/NO
    - Excel validation: PASSED/FAILED
    - UI display: SUCCESSFUL/FAILED
    - UI data validation: PASSED/FAILED
    - Any data mismatches: [list]
    
    Overall Status:
    - Workflow Status: SUCCESS/FAILURE
    - Final output location: [path]
    - Ready for user review: YES/NO
    
    Errors/Warnings:
    - [List all errors]
    - [List all warnings]
    - [Recommended actions]

13. Archive Results
    - Move test results to Test Results folder
    - Maintain folder structure
    - Create log files
    - Archive input PDFs reference
    - Document execution metadata

14. Complete Pipeline
    - Timestamp workflow completion
    - Provide completion summary
    - Indicate next steps
    - End orchestration
```

## Success Criteria

The workflow is successful only when ALL of these conditions are met:

```
✓ All provided readable Tosca PDFs were processed
✓ All identifiable test cases were considered
✓ Test Case IDs were preserved exactly
✓ Test Case Names were preserved exactly
✓ Statuses were source-supported
✓ Failure reasons were source-supported
✓ Missing information was not fabricated
✓ Conflicts were identified and flagged
✓ Duplicates were appropriately handled
✓ Source traceability was maintained
✓ Agent 1 data was validated
✓ Excel was generated successfully
✓ Excel contains the validated Agent 1 data
✓ Excel integrity was validated
✓ UI displays the Excel information
✓ UI data matches Excel data
```

## Error Handling

### Errors During Agent 1

If Agent 1 encounters an error:
- Log the error with full details
- Stop pipeline execution
- Report to user
- Provide troubleshooting guidance
- Do NOT proceed to Agent 2

### Errors During Agent 2

If Agent 2 encounters an error:
- Log the error with full details
- Attempt to remediate if possible
- Report the error to user
- Provide completion status
- Indicate whether to retry

### Critical Failures

Critical failures that stop execution:
- Cannot read input PDFs
- Invalid PDF format
- No test cases found
- JSON validation fails
- Excel generation fails
- File system errors

### Warning Conditions

Warnings that don't stop execution:
- PDF contains uncertain data
- Conflicts detected in data
- Duplicates detected
- Missing optional fields
- OCR applied to scanned content

## File Structure

```
c:\AI Agents\
├── Prompt/
│   └── Prompt.md                          [System prompt]
├── Agents/
│   ├── Tosca PDF Analysis...Agent.md      [Agent 1 description]
│   ├── Excel Generation...Agent.md        [Agent 2 description]
│   ├── Agent_1_Tosca_PDF_Analysis...md    [Agent 1 implementation]
│   └── Agent_2_Excel_Generation...md      [Agent 2 implementation]
├── Skills/
│   ├── Tosca_PDF...Skills.md              [Agent 1 skills]
│   └── Excel Generation...Skills.md       [Agent 2 skills]
├── Uploads/
│   └── [Tosca PDF files go here]
└── Test Results/
    ├── test_cases_consolidated.json       [Agent 1 output]
    ├── Tosca_Test_Execution...xlsx        [Agent 2 output]
    └── execution_log.txt                  [Workflow log]
```

## How to Execute

### Step 1: Prepare Input Files

1. Place Tosca PDF reports in: `c:\AI Agents\Uploads\`
2. Confirm files are readable PDFs
3. Note the filenames

### Step 2: Trigger Pipeline

Run the orchestrator:

```
Execute: run-qa-pipeline
Input: Tosca PDF reports in Uploads folder
```

### Step 3: Monitor Execution

- Agent 1 begins processing PDFs
- Consolidated data is generated
- Agent 1 output is validated
- Agent 2 begins Excel generation
- Excel is validated
- UI display is established
- Final report is generated

### Step 4: Review Results

Check:
- `c:\AI Agents\Test Results\Tosca_Test_Execution_Consolidated.xlsx`
- UI display for test results
- `execution_log.txt` for detailed processing information

## Expected Outputs

### Primary Outputs

1. **Consolidated Test Data** (JSON)
   - File: `test_cases_consolidated.json`
   - Location: `c:\AI Agents\Test Results\`
   - Contains: All test cases from all PDFs
   - Format: Valid JSON structure

2. **Excel Report**
   - File: `Tosca_Test_Execution_Consolidated.xlsx`
   - Location: `c:\AI Agents\Test Results\`
   - Contains: Test results in Excel format
   - Structure: Headers + data rows

3. **UI Display**
   - Results displayed in application UI
   - Data matches Excel file
   - Ready for user review

### Secondary Outputs

1. **Execution Log**
   - File: `execution_log.txt`
   - Location: `c:\AI Agents\Test Results\`
   - Contains: Detailed processing information

2. **Error Report** (if applicable)
   - Lists any errors or mismatches
   - Provides remediation guidance

3. **Processing Summary**
   - Overview of workflow execution
   - Statistics on data processing
   - Validation results

## Key Principles

1. **Sequential Execution**: Agent 1 → Agent 2 (never parallel)
2. **Data Preservation**: Never modify or invent data
3. **Complete Transparency**: Log all operations
4. **Strict Validation**: Verify at each stage
5. **Source Fidelity**: Maintain accuracy from source
6. **Error Reporting**: Do not hide issues
7. **User Focus**: Provide clear, actionable results

## Troubleshooting

### If Workflow Fails

1. Check `execution_log.txt` for error details
2. Identify which phase failed (Agent 1 or Agent 2)
3. Review error message and recommendations
4. Correct input files if needed
5. Retry workflow

### Common Issues

- **PDFs not found**: Ensure files in Uploads folder
- **Invalid PDF format**: Confirm PDFs are readable
- **No test cases extracted**: Check PDF structure
- **Excel generation failed**: Check file permissions
- **UI display failed**: Confirm application is running

### Support

For issues:
1. Review the workflow log
2. Check individual agent output
3. Verify input file format
4. Consult the skills documentation
5. Review system rules and constraints
