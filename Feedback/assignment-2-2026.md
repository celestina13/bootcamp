# Assignment 2 formative feedback

This feedback is organised by the relevant computing bootcamp criteria. Use it to decide what is already working, what you need to investigate, and what to revise before the cumulative submission.

The full criteria are in the [Computing Bootcamp assessment rubric](https://github.com/MulQuaBio/MQB/blob/main/content/rubrics/Computing_Bootcamp_Rubric.md).

## 1. Repository organisation and workflow discipline

- Your root README, `.gitignore`, cleaning script, test script and supplied data files are in the expected locations. The supplied CSV and metadata are unchanged, giving you a reproducible starting point.

## 2. Code completeness and functional correctness

- Your supplied CSV and metadata remain unchanged, and the required files are present.
- Your cleaning script ran and produced all three outputs. Separately, output checks found that the clean records, issues and oak summary tables satisfied the required output format and contents in both test runs.

## 3. Code quality and style

- Your `main()` function gives the program a clear overall structure by connecting loading, processing, summarising and writing. Keep these stages distinct as you revise; use descriptive names and add short comments where the reason for a validation check or data-cleaning step is not obvious.

## 4. Documentation

- Your root README is in place. Make it useful to someone opening the repository for the first time: explain what the cleaner does, how to run the script and tests from the repository root, and which three files it creates. Test the instructions in a newly cloned copy of your repository (a separate folder created with `git clone`): enter that folder and run each README command exactly as written. If something fails, correct the command or add the missing step.

## 5. Version-control practice

- Since the previous formative feedback was added, the saved history contains 7 non-merge commits. Messages such as `Add function validate_record`, `Add tests for validate_record function`, and `Add tests for process_records, summarise_oaks and reruns` show a useful progression from implementation to checking.
- Keep this pattern for the final revisions. Before each commit, use `git diff --staged` to check that it contains one coherent, working change, then write a concise message that names that change and, where it is not obvious, why it was needed.

## 8. Basic error handling and input validation

- Your separate test file covers record validation, accepted/rejected partitioning, oak summaries and end-to-end writing. It also completed successfully in the test run.
- **Check the strength of your tests, not just their exit status.** The tests cover useful stages, but a successful run does not show that every important case is covered. Review whether they assert the returned values and written contents, including a specified invalid or boundary case. Add a focused assertion wherever that review reveals a gap.
- Add the short data-flow explanation to your documentation, then rerun the cleaner and separate test file using the commands you document.
- The output matches support the stated table requirements, not complete test coverage or understanding.

## 9. Problem-solving approach and method implementation

- Your code contains a clear connected workflow: `main()` loads rows through `load_records()`, passes them to `process_records()` and its record-level `validate_record()` checks, then receives `(clean_records, issues)`. The cleaned collection feeds `summarise_oaks()`, and three `write_csv()` calls write the results. The route from input to outputs is clear.
- Before final submission, make this check visible in your repository. In `code/test_silwood_trees.py`, add or refine a small assertion-based test with one valid and one invalid record. Check that `process_records()` places them in the cleaned and issues collections respectively. Then pass the returned cleaned collection to `summarise_oaks()` and check that the invalid record does not contribute. Briefly explain this flow in your root README.
