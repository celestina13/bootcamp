# Assignment 1 feedback - Celestina Hall

**Formative feedback | Rubric 2026.2**

The FASTA explanations clearly distinguish sequence positions, joined motif occurrences and the ratio of canonical-base counts. All five answers matched the independent checks. Your own TSV includes an empty field, the converters have readable checks, and generated results are ignored.

The main code correction is the common ../results assumption. Both converters depend on being launched from code/, rather than working from the repository root as required. Fix that convention, explicitly check output-directory creation and repeat the tests from a fresh checkout.

Use the existing small TSV to check an empty field, a spaced filename and a repeated run. Inspect the output contents and location as well as the exit status. Keep the straightforward, quoted conversion logic; this exercise does not need additional parsing machinery.

The current README is now an Assignment 2 guide. Keep that material, but restore an Assignment 1 section with its own purposes, run commands, expected/observed tests, bc dependency and any help used. A cumulative repository needs to retain a usable route to earlier work. Your named assignment commits help with that history; the next focused commits should bring the earlier documentation and converter interface back into agreement.

---

## Project structure

Relevant tracked layout (simplified; missing required paths are marked):

```text
README.md
.gitignore
code/  unixPrac1.txt, tabtocsv.sh, csvtospace.sh
data/fasta/  3 required files present
data/temperatures/  4 required files present
data/tab-example.tsv
results/  no files tracked; generated on run
sandbox/  no files tracked; optional
```

All required Assignment 1 code and input paths are present, including the own TSV. The root ignore file excludes results and sandbox, with no tracked files there. The structural issue is navigation: README.md now describes Assignment 2 rather than providing an entry point to both assignments.

Keep the existing directories and restore an Assignment 1 section or clearly linked guide in the root README. Retain later coursework rather than replacing it. Align the converter examples with the root-based workflow so someone can find and reproduce the earlier work from this cumulative project.

**Assessed snapshot:** `3840093cad718b923cb9f64df1db29ec1fc80ba2`
