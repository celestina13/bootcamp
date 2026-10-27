# Assignment 3 formative feedback

This feedback is organised using the [Computing Bootcamp rubric](https://mulquabio.github.io/MQB/rubrics/Computing_Bootcamp_Rubric.html). It does not award a mark; use it to decide what to revise and check before final submission.

## Criterion 1: Repository organisation & workflow discipline

- The required files are present, supplied inputs are unchanged, and generated results are ignored and not tracked. Several commits describe specific analytical changes and their reasoning.

## Criterion 2: Code completeness & functional correctness

- The fixed and generalised tree-height programs both ran and their respective CSV outputs matched the checked required output format and values. Your code shows degree-to-radian conversion and validation before calculation and writing. Your README records independent row calculations and a `browser()` check; these document your checking approach, although those manual checks were not independently observed.

## Criterion 3: Code quality & style

As you revise, keep names descriptive, use comments to explain decisions rather than restating code, and avoid repeating the same calculation in several places.

## Criterion 4: Documentation

- Before final submission, **Remove ambiguity from the run instructions and comments.** The early README says all scripts run from `code/`, while Assignment 3 correctly specifies the project root. Scope those instructions to their assignments: for Assignment 3, this means the directory containing `code/`, `data/` and the root `README.md`. Also correct the fixed script’s angle-check comment, which currently describes distances, and tidy indentation in the generalised script so the validation blocks are easier to follow.

## Criterion 5: Version-control practice

Commit each functional revision with a short message that says what changed; this makes your development easier to follow than one large final commit.

## Criterion 8: Basic error-handling & input validation

Test an ordinary case and an invalid case for each tree-height route, and confirm both the message shown and whether an output file was created or changed.

## Criterion 9: Problem-solving approach & method implementation

- Your Pound Hill source explains the route from blank counts to species presence, quadrat richness and plot means. Averaging within plots recognises plots as the treatment replicates. When I opened the figure, I found readable axes and distinguishable block shapes. Your interpretation acknowledges variation, overlapping ranges and limited replication rather than making an unqualified causal claim.
- Before final submission, **Keep data identifiers separate from presentation labels.** The Pound Hill script ran and produced the required table, but comparison with the expected output found a capitalisation difference in its treatment keys. The factor relabelling in your code is a likely cause. Such changes can prevent otherwise corresponding records from matching. Compare the unique treatment labels in the input and exported CSV, then trace where they change. Preserve the required identifiers in the table and handle display labels separately if needed. Check the richness values separately after correcting the labels.
- Before final submission, **Make the figure’s summary unambiguous.** I initially read the horizontal summary as a mean, whereas your code uses `fun = median`. Check one treatment’s plotted line against a direct summary of its plot means, then make the caption or accompanying explanation state what the line represents. Reopen the regenerated PDF to check labels, values and the biological interpretation; file presence alone is not enough.

## Criterion 10: Learning progression demonstration

Use this feedback as a revision checklist. Make the changes in small, descriptive commits, then add a short README note explaining what you changed and how you checked it. This will make your development from this formative checkpoint visible in the final portfolio.

## Priorities before final submission

- Rerun the fixed and generalised tree programs separately, using one ordinary and one invalid case for each. The invalid-input tests stopped without producing outputs and reported distance or numeric-value errors; confirm that each message corresponds to the value you deliberately changed. Recheck one ordinary height by direct calculation.
- Then regenerate the Pound Hill table and PDF, inspect the exported treatment keys, and trace one plot mean back to its quadrat richness values. Record these small checks in the README and commit the revisions with descriptive messages.
