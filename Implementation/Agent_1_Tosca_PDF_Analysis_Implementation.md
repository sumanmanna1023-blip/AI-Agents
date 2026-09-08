# AGENT 1: TOSCA PDF ANALYSIS & DATA CONSOLIDATION
## Implementation Specification

### EXECUTION PHASES

#### PHASE 1: INITIALIZATION
- Verify Uploads folder exists
- Verify output folder exists (Test Results)
- Initialize logging
- Prepare data structures

#### PHASE 2: PDF FILE DISCOVERY (SKILL 01)
- Scan Uploads folder for .pdf files
- Create list of valid PDFs
- If no PDFs found, report and exit
- Preserve original filenames

#### PHASE 3: PDF DOCUMENT READING (SKILL 02)
For each PDF:
- Open PDF file
- Extract all text from all pages
- Preserve page context
- Search for test case data
- Note: Process all pages, not just first

#### PHASE 4: OCR PROCESSING (SKILL 03)
If normal text extraction insufficient:
- Apply OCR to extract test case information
- Focus on: Test Case IDs, Names, Status, Errors
- Validate OCR results against PDF content

#### PHASE 5: TOSCA REPORT ANALYSIS (SKILL 04)
- Understand Tosca report structure
- Identify test execution results
- Distinguish from requirements/documentation
- Look for: Status, Pass/Fail, Blocked, Skipped

#### PHASE 6: TEST CASE IDENTIFICATION (SKILL 05)
For each test case extract:
- SCTASK ID
- Test Case ID (preserve original)
- Test Case Name (preserve original)
- Status
- Failure Reason
- Test Result Details
- Source Tosca PDF

Rules:
- Never create Test Case ID or Name
- Missing fields = "Not Available"
- Don't omit records due to missing fields

#### PHASE 7: STATUS DETECTION (SKILL 06)
Recognize explicit statuses:
- Passed
- Failed
- Blocked
- Skipped
- Not Executed
- In Progress
- Other Tosca statuses

Rules:
- Base on explicit evidence only
- Error ≠ automatically Failed (unless stated)
- Conflicting statuses = "Conflict / Review Required"
- Undeterminable = "Not Available"

#### PHASE 8: FAILURE REASON EXTRACTION (SKILL 07)
Extract evidence for failures:
- Failed step
- Assertion failure
- Validation failure
- API error
- HTTP error
- Database error
- Timeout
- Element identification failure
- Application error
- Exception
- Tosca execution error
- Relevant log entries

Rules:
- Only use PDF evidence
- Never create probable reasons
- Missing = "Not Available"

#### PHASE 9: EXECUTION DETAIL EXTRACTION (SKILL 08)
Capture additional context:
- Failed step details
- Error messages
- Exceptions
- Validation messages
- Execution logs
- Application responses
- Relevant execution information

Rules:
- Only relevant details
- Provide useful context
- Don't copy irrelevant content

#### PHASE 10: DATA NORMALIZATION (SKILL 09)
Convert to consistent structure:
- Standardize column names
- Handle empty values
- Normalize status representation
- Normalize filenames
- Clean whitespace
- Fix formatting inconsistencies

Rule:
- Change formatting, never meaning
- "TC001" may become "TC001" (formatting)
- "Failed" never becomes "Passed" (meaning)

#### PHASE 11: DUPLICATE DETECTION (SKILL 10)
Check across PDFs:
- Compare Test Case IDs
- Compare Test Case Names
- Consider execution context
- Consider source PDF
- Consider execution information

Rules:
- Only consolidate confirmed duplicates
- If same test in multiple reports but different executions, preserve
- Don't delete just because similar names

#### PHASE 12: CONFLICT DETECTION (SKILL 11)
Find contradictory information:
- Example: TC001 = Passed in PDF A, Failed in PDF B
- Don't silently select one
- Flag as: "Conflict / Review Required"
- Preserve source information

#### PHASE 13: SOURCE TRACEABILITY (SKILL 12)
Every record must maintain:
- Source PDF filename
- If multiple PDFs contribute, preserve all references
- Allow users to identify originating report

#### PHASE 14: DATA VALIDATION (SKILL 13)
Validate consolidated dataset:
- [ ] All identified test cases present
- [ ] Test Case IDs preserved
- [ ] Test Case Names preserved
- [ ] Statuses evidence-based
- [ ] Failure reasons evidence-based
- [ ] Missing values marked "Not Available"
- [ ] Duplicate handling valid
- [ ] Conflicts identified
- [ ] Source PDFs preserved
- [ ] No unsupported information introduced

If validation fails: correct before continuing

#### PHASE 15: CONSOLIDATED OUTPUT CREATION
Generate JSON with structure:
```json
{
  "sctask_id": "Not Available",
  "test_case_id": "TC001",
  "test_case_name": "Login Validation",
  "status": "Passed",
  "failure_reason": "Not Available",
  "test_result_details": "Test completed successfully",
  "source_tosca_pdf": "TC-001.pdf"
}
```

Output file: `test_cases_consolidated.json`

### ERROR HANDLING
- If one PDF fails: continue processing others
- Record: PDF Filename, Status, Error
- Don't allow one bad PDF to stop pipeline
- If all PDFs fail: don't generate fake result

### MISSING INFORMATION POLICY
When information unavailable:
- Use exactly: "Not Available"
- Never guess
- Never use info from another test case
- Never infer from Test Case Name
- Never infer failure reasons

### HALLUCINATION PREVENTION
STRICTLY PROHIBITED:
- Inventing test cases
- Inventing Test Case IDs
- Inventing Test Case Names
- Inventing statuses
- Inventing failure reasons
- Inventing execution details
- Guessing missing information
- Using external information
- Changing execution results

PDF is the source of truth.

### OUTPUT STRUCTURE
Generate consolidated data with:
- Total PDFs processed: [count]
- Test cases extracted: [count]
- Duplicates detected: [count]
- Conflicts detected: [count]
- Valid records: [count]
- Flagged records: [count]
- Validation status: PASSED/FAILED
- Processing timestamp
- Output file path
- Workflow stage: "Agent_1_Complete"

### SUCCESS CRITERIA
✓ All PDFs discovered
✓ All readable PDFs processed
✓ Test cases extracted
✓ Statuses validated
✓ Failure reasons validated
✓ Duplicates checked
✓ Conflicts checked
✓ Source traceability preserved
✓ Consolidated dataset validated
✓ Consolidated JSON created
✓ Ready for handoff to Agent 2
