# SQL Practice Workbook · PRD

The workbook gives readers 101 exercises to study and reproduce in SQL. For each one, readers can find the prompt, recreate the data, run the query, and check the reasoning and results.

## Current scope

- Part I has 78 exercises and Part II has 23. The pages retain their original IDs and source links.
- Each page includes a SQLite solution and states its method and assumptions.
- The setups and queries run offline.
- An exercise earns the status Verified after the base example and an additional case or negative check pass.
- Run `node verify.cjs` to reproduce the report with full results, engine version, and execution timestamp.
- When an expected result conflicts with the source data or rules, explain the correction.

## Acceptance criteria

1. Every page identifies its exercise, source prompt, SQLite 3.53.0, and required input.
2. The setup recreates the data in an isolated database. The SQL file matches the query on the exercise page.
3. The checks compare every expected row, including duplicate occurrences. DDL and open-ended exercises have explicit checks.
4. Each page explains what a row represents, which ordering and assumptions matter, and what happened in at least one additional test.
5. Simulations state their parameters and seeds, compare with theory where applicable, and use an independent algorithm to verify the result.
6. The documented environment reproduces 101 passing exercises. The pages identify the I-30 and I-51 adaptations and any differences from the source.

## Limits and provenance

The solutions were drafted with an assistant without consulting the official solutions. The checks cover the documented fixtures in SQLite. The source references point to a fixed revision, and the repository contains the files needed to repeat the checks.

## Future work

Port the queries to SQL Server and test its native features. Add more edge cases. Select representative exercises after reviewing and reproducing the solutions independently.
