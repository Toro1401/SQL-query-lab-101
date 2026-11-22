# Verification of the 101 solutions

The reference run on November 21, 2026 used Node.js v24.16.0 and SQLite 3.53.0. **All 101 exercises passed** the base case and at least one additional check. [verification/results.json](verification/results.json) records the results and the execution timestamp.

```powershell
node verify.cjs
```

The runner reads the SQL files and checks that each query matches the one on its exercise page. Each case runs on separate in-memory data, so deletes and triggers are isolated from the user's databases.

## What the runner checks

When the prompt gives a table of expected results, the runner compares the values and the number of occurrences of each row. It also checks row order in I-40, where sorting is the requirement. For the other exercises, presentation order does not affect the comparison. The checks normalize real numbers to six decimal places. The fixtures use ISO 8601 dates, represent empty cells as NULL, and store codes with leading zeros as text.

I-10 uses statistics calculated independently. I-31 checks three formulations and the salary bonus. I-46 checks both formulations. The DDL and trigger tests cover operations that should succeed and operations that should fail. The additional cases check concrete results after changing the input. For example, I-13 checks the full sequence of balances when two movements share a date.

For problems without a fixed output, the runner uses known values, combinatorial counts, or independent JavaScript algorithms. SQL and JavaScript share the pseudorandom generator so both implementations receive the same draws. The checks compare their measured results, enforce stopping limits, and allow for a margin around theoretical values. Fixed seeds make the runs reproducible.

## Source corrections and interpretations

| Exercise | Documented difference |
|---|---|
| I-26 | The 2016 total is 159521 + 251696 + 111894 = **523111**. The expected value of 411217 omits the third sale. |
| II-10 | The 16 occupied seats include **7 even and 9 odd**. The source quotes 8 even seats. I-18 gives the correct counts for the same data. |
| II-22 | Order 1 also allows `(1,5),(2,6),(3,4)` and `(1,6),(2,5),(3,4)`. Each solution has three disjoint groups, with a cost of at least 10 and at most two rows per group. The source table omits both solutions. For order 5, each solution gives one group, while the source comment says two. |
| I-12, I-68, I-70 | The queries truncate averages to integers to match the source. I-10 retains the precision of the mean 342/11. |
| I-21 | The expected TX result agrees with requiring every customer's average of monthly averages to exceed 100. Some months for customer 1001 average exactly 100, so requiring each month to exceed 100 would give a different result. Months without orders are excluded. |
| I-45 | The output identifies the earlier version whose interval overlaps the start of a later one. |
| I-48 | The reference year is fixed at **2021** to reproduce the source data. |
| I-53 | The query orders groups by the lexicographically larger partner to match the displayed GroupID values. |
| I-62 | The examples require a difference of **at least** 200000 between the price of the car and the boat. |
| II-04 | The fixture uses n=4 to match the two expected permutations. The prompt mentions n=10 as an example. |
| II-12 | The prompt gives no endpoint. The setup specifies a limit of 110. |
| II-13, II-14 | The tests cover C(5,2) and the Josephus problem with n=7 and a step of 3. They cover the stated parameters. |
| II-17 | A 6 triggers a penalty roll. Each penalty roll subtracts its face value, and another 6 extends the penalty. Every physical roll counts, and the score stays at or above zero. |
| II-23 | The prompt asks for the knight's next legal moves. A full tour of the board is outside its scope. |

## SQLite adaptations

**I-30** uses a SQLite view with a `forbid_star()` sentinel column. Reading the two explicit columns succeeds. `SELECT *` fails because it reads the sentinel. This demonstrates the requested behavior in SQLite. The SQL Server schema and access controls are outside the scope of the exercise.

**I-51** registers SHA-256 and CRC32 in the runner and applies them to the canonical JSON serialization of the natural key. The encoding and serialization determine the bytes supplied to SHA-256. CRC32 differs from SQL Server's proprietary `CHECKSUM`. The tests do not exercise `HASHBYTES` or `CHECKSUM` on SQL Server. Collisions are possible, so enforce uniqueness with a UNIQUE constraint on the natural key.

The fixtures recreate the source tables and data with simpler names and ISO dates. The runner executes the SQLite setup and uses explicit ordering keys. I-13 uses rowid to distinguish same-day movements in the fixture. A production table should have a persistent MovementID.

## Simulation results

| Exercise | Measured result |
|---|---|
| II-16 Monty Hall | 10,000 trials. 3,427 wins by staying, **6,573 by switching**, and no invalid openings. |
| II-17 Dice | 10,000 games with a target of 100 points. **66.0864 rolls on average**, with a minimum of 28 and a maximum of 165. Every game finished. |
| II-18 Birthdays | 10,000 groups of 23. **5,081** shared a birthday, for a frequency of **0.5081**. |
| II-19 Random walk | 10,000 completed trials and zero wins by the host. Win counts for eligible participants 1 through 7 were 1478, 1410, 1362, 1454, 1454, 1377, and 1465. |
| II-20 Markov chain | 100,000 days, of which **62,680** were rainy. The observed fraction was **0.6268**, compared with a theoretical stationary fraction of 0.625. |
| II-21 Prisoners | 10,000 permutations, with **3,116** successes. The observed frequency was **0.3116**, compared with a theoretical probability of about 0.3118. |

The results cover functional checks on the documented fixtures. Large-database performance, SQL Server behavior, and general proofs of correctness are outside their scope.
