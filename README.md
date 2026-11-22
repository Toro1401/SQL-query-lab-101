# SQL Practice Workbook

The workbook contains 101 SQL exercises, with 78 in Part I and 23 in Part II. Each exercise page shows the query, the reasoning behind it, the measured result, and an additional test case.

[Browse the exercises](WORKBOOK.md) · [Requirements](PRD.md) · [Verification and source corrections](VERIFICATION.md)

## Run the checks

The reference run used **Node.js v24.16.0**, its built-in `node:sqlite` module, and **SQLite 3.53.0**. You can run the checks offline without npm, external dependencies, or a database server. The queries were adapted to SQLite and have not been run on SQL Server.

```powershell
node verify.cjs
node verify.cjs I-13
```

The first command checks all 101 exercises. The second runs I-13 on its own. For each exercise, the runner opens a fresh in-memory database, loads `setup/<ID>.sql`, and runs `sql/<ID>.sql`. It uses a separate database when it changes the input for an additional case. A failing check produces a nonzero exit code. All 101 exercises passed the base and additional checks in the reference run.

[verification/results.json](verification/results.json) contains the full results, including the additional cases, the engine version, and the execution timestamp. A single exercise gets a separate report. The report includes all 7,200 vehicle arrangements. The exercise page shows a sample.

You can also load the setup and run most queries in a SQLite editor. The runner registers `forbid_star()` for I-30, `sha256()` and `crc32()` for I-51, and `rnd()` for simulations. The random walk also requires `bitcount()`. The deterministic 32-bit mixer behind `rnd()` is for simulations. The setup files contain the seeds and other parameters.

## Project files

- [WORKBOOK.md](WORKBOOK.md) indexes the individual exercise pages by their original IDs.
- [setup/](setup/) recreates the example data in SQLite, with dates in ISO 8601 format. Tables `t1`, `t2`, and `t3` follow the order given in the source.
- [sql/](sql/) contains the queries that the runner executes and the exercise pages display.
- [fixtures.json](fixtures.json) holds the fixtures and expected results. The runner records exceptions to the source output.
- [verify.cjs](verify.cjs), [checks.cjs](checks.cjs), and [checks-II.cjs](checks-II.cjs) compare results, exercise edge cases, and run independent checks.

`Verified` applies to the documented fixtures and assumptions. The seeded simulations can be reproduced and compared with theoretical probabilities. I-30 and I-51 adapt SQL Server features to SQLite. In particular, CRC32 differs from SQL Server's `CHECKSUM` algorithm.

The solutions were drafted with an assistant at the author's request, without consulting the official SQL solutions. The workbook documents assisted work. Reproduce the queries and make sure you can explain them before using them in an interview.

## Source and attribution

The prompts and example data come from **Scott Peters, Advanced SQL Puzzles**, [revision 4fe0cac6e23f6af967bca0a46e364f9b8534eec3](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md). Exercise pages link to their source prompts and to the SQL Server setup where available. The original material remains the work of its respective authors.

## GitHub About description

SQL practice workbook with 101 SQLite solutions, reproducible checks, edge cases, and methodology.
