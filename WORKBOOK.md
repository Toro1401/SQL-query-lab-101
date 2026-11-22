# SQL Practice Workbook

**Completamento:** 101/101 schede compilate e verificate il 21 novembre 2026 con SQLite 3.53.0 e Node.js v24.16.0. Soluzioni redatte dall’assistente; non sono state consultate le soluzioni SQL ufficiali. `Verified` indica le fixture e i casi documentati, non una prova per ogni possibile input. Gli adattamenti SQLite I-30 e I-51 sono dichiarati nelle schede.

Eseguire `node verify.cjs` dalla cartella del progetto, oppure `node verify.cjs I-13`. Ogni esercizio usa un database in memoria separato. I file [setup](setup/) ricreano i dati della traccia, i file [sql](sql/) contengono le query. Il runner registra le funzioni di supporto per hash, checksum e numeri pseudocasuali; vedere [README](README.md). Risultati integrali in [verification/results.json](verification/results.json), criteri e correzioni in [VERIFICATION.md](VERIFICATION.md).

Gli ID seguono la numerazione delle due parti della fonte. Puoi raggiungere una scheda dall’indice di GitHub o dai link qui sotto.

- [Part I · SQL patterns and data analysis](#part-i--sql-patterns-and-data-analysis) · 78 exercises
- [Part II · Sequences, combinations and simulations](#part-ii--sequences-combinations-and-simulations) · 23 exercises

Per iniziare con gli esercizi di analisi, segui quest’ordine: [I-13](#i-13--calculate-a-running-stock-balance), [I-21](#i-21--aggregate-orders-by-customer-and-month), [I-26](#i-26--compare-annual-revenue), [I-27](#i-27--deduplicate-a-table), [I-48](#i-48--find-uninterrupted-sales-activity), and [I-68](#i-68--measure-the-effect-of-extreme-values).

Apri la traccia e carica il setup SQLite in un database nuovo prima della query. I link al setup SQL Server permettono di risalire alla fonte dove disponibile. Il verificatore confronta tutte le righe, duplicati inclusi, e controlla anche l’ordine in I-40. Per gli esercizi senza un output unico usa valori noti, invarianti o un confronto con un algoritmo JavaScript indipendente. Nelle schede trovi l’output del campione base e il comportamento del caso aggiuntivo.

## Part I · SQL patterns and data analysis

### I-01 · Compare two baskets
I-01
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L149) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L12-L39)

[Setup SQLite](setup/I-01.sql) · [Query](sql/I-01.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(item)` (5 righe); `t2(item)` (5 righe).

```sql
SELECT a.item AS cart1,b.item AS cart2
FROM t1 a
FULL
JOIN t2 b ON a.item=b.item;
```

**Result and verification:** Risultato 1: 8 righe. [["Sugar","Sugar"],["Bread","Bread"],["Juice",null],["Soda",null],["Flour",null],[null,"Butter"]] … (output completo nel report)

**Method and assumptions:** Il FULL JOIN restituisce gli articoli comuni e quelli presenti in un solo carrello. Se un articolo compare più volte, la join restituisce tutte le corrispondenze.

**Edge cases and trade-offs:** Aggiungendo Only A al primo carrello compare una sola riga per quell’articolo, con cart2 a NULL.

```sql
INSERT INTO t1 VALUES ('Only A');
```

### I-02 · Map a reporting hierarchy
I-02
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L190) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L40-L60)

[Setup SQLite](setup/I-02.sql) · [Query](sql/I-02.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(employee_id, manager_id, job_title)` (6 righe).

```sql
WITH RECURSIVE h AS (
SELECT *,0 depth,','||employee_id||',' path
FROM t1
WHERE manager_id IS NULL
UNION ALL
SELECT e.*,h.depth+1,h.path||e.employee_id||','
FROM t1 e
JOIN h ON e.manager_id=h.employee_id
WHERE instr(h.path,','||e.employee_id||',')=0)
SELECT employee_id,manager_id,job_title,depth
FROM h;
```

**Result and verification:** Risultato 1: 6 righe. [[1001,null,"CEO",0],[2002,1001,"Director",1],[3003,1001,"Office Manager",1],[4004,2002,"Engineer",2],[5005,2002,"Engineer",2],[6006,2002,"Engineer",2]]

**Method and assumptions:** La ricorsione parte dal CEO a profondità zero e include i dipendenti che si possono raggiungere da lui. Il controllo sul percorso evita i cicli ed esclude i dipendenti scollegati dalla gerarchia.

**Edge cases and trade-offs:** Il dipendente 7007 fa riferimento a un responsabile assente, quindi il risultato rimane identico.

```sql
INSERT INTO t1 VALUES (7007,9999,'Orphan');
```

### I-03 · Validate fiscal periods
I-03
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L218) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L61-L77)

[Setup SQLite](setup/I-03.sql) · [Query](sql/I-03.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** Nessuna tabella iniziale: DDL o generazione interna.

```sql
CREATE TABLE pay (employee_id INTEGER NOT NULL CHECK(employee_id>0), fiscal_year INTEGER NOT NULL CHECK(fiscal_year BETWEEN 1900 AND 9998), start_date TEXT NOT NULL, end_date TEXT NOT NULL, pay_cents INTEGER NOT NULL CHECK(pay_cents>0), PRIMARY KEY(employee_id,fiscal_year), CHECK(start_date=printf('%04d-01-01',fiscal_year)), CHECK(end_date=printf('%04d-12-31',fiscal_year)));
INSERT INTO pay VALUES (1,2024,'2024-01-01','2024-12-31',10000);
SELECT *
FROM pay;
```

**Result and verification:** Risultato 1: 1 riga. [[1,2024,"2024-01-01","2024-12-31",10000]]

**Method and assumptions:** La chiave primaria ammette una riga per dipendente e anno solare, usato come anno fiscale. I vincoli verificano le date e la paga, espressa in centesimi interi. Per rilevare anni mancanti servirebbe un controllo a parte.

**Edge cases and trade-offs:** I vincoli rifiutano un secondo record per lo stesso anno e dipendente, un inizio ad anno avviato, una paga negativa e un ID NULL.

### I-04 · Combine two filters
I-04
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L239) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L78-L99)

[Setup SQLite](setup/I-04.sql) · [Query](sql/I-04.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(customer_id, order_id, delivery_state, amount)` (8 righe).

```sql
SELECT *
FROM t1 o
WHERE delivery_state='TX' AND EXISTS(
SELECT 1
FROM t1 c
WHERE c.customer_id=o.customer_id AND c.delivery_state='CA');
```

**Result and verification:** Risultato 1: 3 righe. [[1001,2,"TX",950],[1001,3,"TX",670],[1001,4,"TX",860]]

**Method and assumptions:** Ogni riga rappresenta un ordine in TX di un cliente che ha fatto almeno un ordine in CA. EXISTS controlla se l’ordine in CA esiste senza duplicare quelli in TX.

**Edge cases and trade-offs:** Un secondo ordine in CA per il cliente 1001 non aggiunge righe al risultato.

```sql
INSERT INTO t1 VALUES (1001,9,'CA',10);
```

### I-05 · Normalize contact numbers
I-05
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L272) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L100-L123)

[Setup SQLite](setup/I-05.sql) · [Query](sql/I-05.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(customer_id, type, phone_number)` (6 righe).

```sql
SELECT customer_id,max(CASE WHEN type='Cellular' THEN phone_number END) cellular,max(CASE WHEN type='Work' THEN phone_number END) work,max(CASE WHEN type='Home' THEN phone_number END) home
FROM t1
GROUP BY customer_id;
```

**Result and verification:** Risultato 1: 3 righe. [[1001,"555-897-5421","555-897-6542","555-698-9874"],[2002,"555-963-6544","555-812-9856",null],[3003,"555-987-6541",null,null]]

**Method and assumptions:** L’aggregazione condizionale raccoglie i tipi di numero in una riga per cliente. Se un tipo compare più volte, la query prende il massimo lessicografico. In un’applicazione reale va concordato quale tenere.

**Edge cases and trade-offs:** Per il nuovo cliente, che ha solo un numero Home, Cellular e Work rimangono NULL.

```sql
INSERT INTO t1 VALUES (4004,'Home','555-000-0000');
```

### I-06 · Order the steps of a workflow
I-06
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L299) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L124-L145)

[Setup SQLite](setup/I-06.sql) · [Query](sql/I-06.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(workflow, step_number, completion_date)` (11 righe).

```sql
SELECT workflow
FROM t1
GROUP BY workflow
HAVING count(completion_date)>0 AND count(completion_date)<count(*);
```

**Result and verification:** Risultato 1: 2 righe. [["Bravo"],["Charlie"]]

**Method and assumptions:** Un workflow è parziale quando il numero di date di completamento non NULL è maggiore di zero e minore del totale dei passaggi. Due conteggi bastano e soddisfano anche il vincolo del bonus su COUNT.

**Edge cases and trade-offs:** Echo ha un solo passaggio senza data di completamento. Rimane fuori dai workflow parziali.

```sql
INSERT INTO t1 VALUES ('Echo',1,NULL);
```

### I-07 · Analyze mission data
I-07
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L331) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L146-L176)

[Setup SQLite](setup/I-07.sql) · [Query](sql/I-07.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(candidate_id, description)` (10 righe); `t2(description)` (3 righe).

```sql
SELECT DISTINCT c.candidate_id
FROM t1 c
WHERE NOT EXISTS(
SELECT 1
FROM t2 r
WHERE NOT EXISTS(
SELECT 1
FROM t1 s
WHERE s.candidate_id=c.candidate_id AND s.description=r.description));
```

**Result and verification:** Risultato 1: 1 riga. [[1001]]

**Method and assumptions:** La query restituisce chi possiede tutte le competenze richieste. Il confronto riguarda l’insieme delle competenze, quindi ripetere un requisito non rende più restrittiva la selezione.

**Edge cases and trade-offs:** Aggiungere di nuovo Geologist ai requisiti lascia invariato l’elenco dei candidati.

```sql
INSERT INTO t2 VALUES ('Geologist');
```

### I-08 · Classify workflow cases
I-08
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L373) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L177-L196)

[Setup SQLite](setup/I-08.sql) · [Query](sql/I-08.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(workflow, case_1, case_2, case_3)` (4 righe).

```sql
SELECT workflow,case_1+case_2+case_3 passed
FROM t1;
```

**Result and verification:** Risultato 1: 4 righe. [["Alpha",0],["Bravo",2],["Charlie",1],["Delta",0]]

**Method and assumptions:** Per ogni workflow si sommano tre flag binari. Se manca un flag, il totale rimane NULL perché il dato è sconosciuto.

**Edge cases and trade-offs:** Con tutti e tre i flag positivi, Passed vale 3.

```sql
INSERT INTO t1 VALUES ('Echo',1,1,1);
```

### I-09 · Find equivalent groups
I-09
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L401) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L197-L218)

[Setup SQLite](setup/I-09.sql) · [Query](sql/I-09.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(employee_id, license)` (14 righe).

```sql
WITH people AS (
SELECT DISTINCT employee_id id
FROM t1)
SELECT a.id,b.id,(
SELECT count(DISTINCT license)
FROM t1
WHERE employee_id=a.id)
FROM people a
CROSS
JOIN people b
WHERE a.id<>b.id AND NOT EXISTS(
SELECT license
FROM t1
WHERE employee_id=a.id EXCEPT
SELECT license
FROM t1
WHERE employee_id=b.id) AND NOT EXISTS(
SELECT license
FROM t1
WHERE employee_id=b.id EXCEPT
SELECT license
FROM t1
WHERE employee_id=a.id);
```

**Result and verification:** Risultato 1: 4 righe. [[1001,2002,3],[2002,1001,3],[4004,5005,3],[5005,4004,3]]

**Method and assumptions:** La query confronta le licenze in entrambe le direzioni. Restituisce una riga per coppia orientata quando nessuno dei due ha licenze che mancano all’altro.

**Edge cases and trade-offs:** Ripetere Class A per il dipendente 1001 non cambia le coppie restituite.

```sql
INSERT INTO t1 VALUES (1001,'Class A');
```

### I-10 · Compute summary statistics
I-10
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L439) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L219-L235)

[Setup SQLite](setup/I-10.sql) · [Query](sql/I-10.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(integer_value)` (11 righe).

```sql
WITH r AS(
SELECT integer_value v,row_number() OVER(
ORDER BY integer_value) rn,count(*) OVER() n
FROM t1)
SELECT (
SELECT avg(1.0*integer_value)
FROM t1) mean,(
SELECT avg(1.0*v)
FROM r
WHERE rn IN ((n+1)/2,(n+2)/2)) median,(
SELECT integer_value
FROM t1
GROUP BY integer_value
ORDER BY count(*) DESC,integer_value
LIMIT 1) mode,(
SELECT max(integer_value)-min(integer_value)
FROM t1) range;
```

**Result and verification:** Risultato 1: 1 riga. [[31.09090909090909,14,10,85]]

**Method and assumptions:** La riga riporta la media con precisione reale, la mediana e l’ampiezza tra massimo e minimo. In caso di parità per la moda si prende il valore più piccolo.

**Edge cases and trade-offs:** Con il campione 1, 2, 3 e 4, media e mediana valgono 2.5, la moda scelta è 1 e l’ampiezza è 3.

```sql
DELETE FROM t1; INSERT INTO t1 VALUES (1),(2),(3),(4);
```

### I-11 · Arrange values in different orders
I-11
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L462) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L236-L252)

[Setup SQLite](setup/I-11.sql) · [Query](sql/I-11.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(test_case)` (3 righe).

```sql
WITH RECURSIVE p(path,used,n) AS(
SELECT '',',',0
UNION ALL
SELECT path||CASE WHEN n=0 THEN '' ELSE ',' END||test_case,used||test_case||',',n+1
FROM p
CROSS
JOIN t1
WHERE instr(used,','||test_case||',')=0)
SELECT path
FROM p
WHERE n=(
SELECT count(*)
FROM t1);
```

**Result and verification:** Risultato 1: 6 righe. [["A,B,C"],["A,C,B"],["B,A,C"],["B,C,A"],["C,A,B"],["C,B,A"]]

**Method and assumptions:** Ogni riga è una permutazione di tutti gli elementi. Il numero di posizioni deriva dai dati e gli elementi devono essere distinti e privi di virgole.

**Edge cases and trade-offs:** Con l’aggiunta di D si ottengono 24 permutazioni distinte, ciascuna di 4 elementi.

```sql
INSERT INTO t1 VALUES ('D');
```

### I-12 · Measure average time between dates
I-12
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L489) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L253-L272)

[Setup SQLite](setup/I-12.sql) · [Query](sql/I-12.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(workflow, execution_date)` (9 righe).

```sql
WITH d AS(
SELECT workflow,julianday(execution_date)-julianday(lag(execution_date) OVER(PARTITION BY workflow
ORDER BY execution_date)) gap
FROM t1)
SELECT workflow,cast(avg(gap) AS INTEGER)
FROM d
GROUP BY workflow;
```

**Result and verification:** Risultato 1: 3 righe. [["Alpha",7],["Bravo",9],["Charlie",14]]

**Method and assumptions:** Per ciascun workflow si calcola la media dei tempi tra eventi consecutivi. Il risultato è troncato all’intero come nella fonte.

**Edge cases and trade-offs:** Con un solo evento non ci sono intervalli da mediare, quindi il risultato è NULL.

```sql
INSERT INTO t1 VALUES ('Single','2018-06-01');
```

### I-13 · Calculate a running stock balance
I-13
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L517) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L273-L291)

[Setup SQLite](setup/I-13.sql) · [Query](sql/I-13.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(date, quantity_adjustment)` (5 righe).

```sql
SELECT date,quantity_adjustment,sum(quantity_adjustment) OVER(
ORDER BY date,rowid ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) inventory
FROM t1
ORDER BY date,rowid;
```

**Result and verification:** Risultato 1: 5 righe. [["2018-07-01",100,100],["2018-07-02",75,175],["2018-07-03",-150,25],["2018-07-04",50,75],["2018-07-05",-100,-25]]

**Method and assumptions:** Il saldo parte da zero e somma un movimento alla volta. La finestra ROWS segue la data e usa rowid quando due date coincidono. Sui dati reali userei un MovementID esplicito per fissare questo ordine.

**Edge cases and trade-offs:** Inserendo un movimento da -10 subito dopo quello da +75 del 2 luglio, i saldi diventano 100, 175, 165, 15, 65 e -35.

```sql
INSERT INTO t1 VALUES ('2018-07-02',-10);
```

### I-14 · Interpret incomplete process logs
I-14
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L547) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L292-L314)

[Setup SQLite](setup/I-14.sql) · [Query](sql/I-14.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(workflow, step_number, status)` (11 righe).

```sql
SELECT workflow,CASE WHEN count(DISTINCT status)=1 THEN min(status) WHEN sum(status='Error')>0 THEN 'Indeterminate' ELSE 'Running' END
FROM t1
GROUP BY workflow;
```

**Result and verification:** Risultato 1: 5 righe. [["Alpha","Indeterminate"],["Bravo","Complete"],["Charlie","Running"],["Delta","Error"],["Echo","Running"]]

**Method and assumptions:** La query assegna uno stato per workflow. Uno stato uniforme si conserva. Se gli stati non coincidono, prevale Indeterminate in presenza di un errore, altrimenti il workflow risulta in esecuzione. Gli stati sono non NULL.

**Edge cases and trade-offs:** Un workflow con Error e Running restituisce Indeterminate.

```sql
INSERT INTO t1 VALUES ('Foxtrot',1,'Error'); INSERT INTO t1 VALUES ('Foxtrot',2,'Running');
```

### I-15 · Combine labels by group
I-15
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L585) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L315-L340)

[Setup SQLite](setup/I-15.sql) · [Query](sql/I-15.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(sequence, syntax)` (9 righe).

```sql
SELECT group_concat(syntax,' '
ORDER BY sequence)
FROM t1;
```

**Result and verification:** Risultato 1: 1 riga. [["SELECT Product, UnitPrice, EffectiveDate FROM Products WHERE UnitPrice > 100"]]

**Method and assumptions:** La query concatena i frammenti nell’ordine dato da Sequence, che deve essere univoco.

**Edge cases and trade-offs:** Il frammento aggiunto finisce in coda, separato da uno spazio.

```sql
INSERT INTO t1 VALUES (10,';');
```

### I-16 · Match reversed pairs
I-16
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L611) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L341-L359)

[Setup SQLite](setup/I-16.sql) · [Query](sql/I-16.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(player_a, player_b, score)` (3 righe).

```sql
SELECT min(player_a,player_b),max(player_a,player_b),sum(score)
FROM t1
GROUP BY min(player_a,player_b),max(player_a,player_b);
```

**Result and verification:** Risultato 1: 2 righe. [[1001,2002,150],[3003,4004,140]]

**Method and assumptions:** Prima di sommare i punteggi, la query mette i due estremi in un ordine comune. In questo modo ciascuna coppia compare una volta.

**Edge cases and trade-offs:** Aggiungere la coppia inversa aumenta il totale di 10 e lascia invariato il numero di coppie.

```sql
INSERT INTO t1 VALUES (2002,1001,10);
```

### I-17 · Expand grouped records
I-17
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L636) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L360-L377)

[Setup SQLite](setup/I-17.sql) · [Query](sql/I-17.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(product, quantity)` (3 righe).

```sql
WITH RECURSIVE n AS(
SELECT product,quantity,1 k
FROM t1
WHERE quantity>0
UNION ALL
SELECT product,quantity,k+1
FROM n
WHERE k<quantity)
SELECT product,1 quantity
FROM n;
```

**Result and verification:** Risultato 1: 9 righe. [["Pencil",1],["Eraser",1],["Notebook",1],["Pencil",1],["Eraser",1],["Notebook",1]] … (output completo nel report)

**Method and assumptions:** La query produce una riga per unità di prodotto. Espande le quantità intere positive e salta lo zero.

**Edge cases and trade-offs:** Il prodotto Zero ha quantità 0, quindi non aggiunge righe.

```sql
INSERT INTO t1 VALUES ('Zero',0);
```

### I-18 · Assign seats
I-18
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L664) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L378-L394)

[Setup SQLite](setup/I-18.sql) · [Query](sql/I-18.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(seat_number)` (16 righe).

```sql
WITH RECURSIVE n(x) AS(
SELECT 1
WHERE (
SELECT max(seat_number)
FROM t1)>=1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT max(seat_number)
FROM t1)), missing AS(
SELECT x
FROM n
WHERE NOT EXISTS(
SELECT 1
FROM t1
WHERE seat_number=x)), g AS(
SELECT x,x-row_number() OVER(
ORDER BY x) grp
FROM missing)
SELECT min(x),max(x)
FROM g
GROUP BY grp
ORDER BY min(x);
WITH RECURSIVE n(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT max(seat_number)
FROM t1))
SELECT count(*)
FROM n
WHERE x NOT IN(
SELECT seat_number
FROM t1);
SELECT CASE seat_number%2 WHEN 0 THEN 'Even Numbers' ELSE 'Odd Numbers' END,count(*)
FROM t1
GROUP BY seat_number%2;
```

**Result and verification:** Risultato 1: 4 righe. [[1,6],[8,12],[16,26],[36,51]] Risultato 2: 1 riga. [[38]] Risultato 3: 2 righe. [["Even Numbers",7],["Odd Numbers",9]]

**Method and assumptions:** La query restituisce gli intervalli dei posti mancanti, il numero di posti liberi da 1 al posto massimo e i conteggi dei posti occupati pari e dispari.

**Edge cases and trade-offs:** Occupando il posto 1, il primo intervallo libero va da 2 a 6. Rimangono 37 posti liberi e quelli dispari occupati salgono a 10.

```sql
INSERT INTO t1 VALUES (1);
```

### I-19 · Compare historical and future dates
I-19
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L701) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L395-L416)

[Setup SQLite](setup/I-19.sql) · [Query](sql/I-19.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(start_date, end_date)` (5 righe).

```sql
WITH a AS(
SELECT *,max(end_date) OVER(
ORDER BY start_date,end_date ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) prev
FROM t1), b AS(
SELECT *,sum(prev IS NULL OR start_date>prev) OVER(
ORDER BY start_date,end_date) grp
FROM a)
SELECT min(start_date),max(end_date)
FROM b
GROUP BY grp;
```

**Result and verification:** Risultato 1: 3 righe. [["2018-01-01","2018-01-09"],["2018-01-10","2018-01-11"],["2018-01-12","2018-01-19"]]

**Method and assumptions:** Il massimo cumulativo delle date di fine permette di unire gli intervalli sovrapposti, anche quando uno contiene interamente l’altro. Due intervalli solo adiacenti restano distinti.

**Edge cases and trade-offs:** L’intervallo aggiunto dal 2 al 3 gennaio 2018 è già coperto. L’unione resta invariata.

```sql
INSERT INTO t1 VALUES ('2018-01-02','2018-01-03');
```

### I-20 · Compare prices at different points
I-20
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L727) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L417-L439)

[Setup SQLite](setup/I-20.sql) · [Query](sql/I-20.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(product_id, effective_date, unit_price)` (5 righe).

```sql
SELECT product_id,effective_date,unit_price
FROM(
SELECT *,row_number() OVER(PARTITION BY product_id
ORDER BY effective_date DESC,rowid DESC) rn
FROM t1
WHERE effective_date<='2018-12-31')
WHERE rn=1;
```

**Result and verification:** Risultato 1: 2 righe. [[1001,"2018-06-08",3.99],[2002,"2018-05-19",2.99]]

**Method and assumptions:** Per ogni prodotto si prende il prezzo più recente disponibile al 2018-12-31, la data di riferimento della fonte. A parità di data conta rowid.

**Edge cases and trade-offs:** Il prezzo del 2099-01-01 arriva dopo la data di riferimento e non modifica il risultato.

```sql
INSERT INTO t1 VALUES (1001,'2099-01-01',99);
```

### I-21 · Aggregate orders by customer and month
I-21
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L750) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L440-L472)

[Setup SQLite](setup/I-21.sql) · [Query](sql/I-21.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(order_id, customer_id, order_date, amount, state)` (13 righe).

```sql
WITH monthly AS(
SELECT state,customer_id,substr(order_date,1,7) month,avg(1.0*amount) m
FROM t1
GROUP BY state,customer_id,substr(order_date,1,7)), customers AS(
SELECT state,customer_id,avg(m) m
FROM monthly
GROUP BY state,customer_id)
SELECT state
FROM customers
GROUP BY state
HAVING min(m)>100;
```

**Result and verification:** Risultato 1: 1 riga. [["TX"]]

**Method and assumptions:** In ogni stato selezionato, la media delle medie mensili supera 100 per ciascun cliente. Il calcolo salta i mesi senza ordini. TX rispetta questo criterio anche se il cliente 1001 ha singoli mesi con media esattamente pari a 100.

**Edge cases and trade-offs:** Un nuovo cliente TX con media zero fa uscire l’intero stato dal risultato.

```sql
INSERT INTO t1 VALUES (14,9999,'2018-01-01',0,'TX');
```

### I-22 · Count matching occurrences
I-22
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L783) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L473-L498)

[Setup SQLite](setup/I-22.sql) · [Query](sql/I-22.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(workflow, message, occurrences)` (8 righe).

```sql
WITH a AS(
SELECT workflow,message,sum(occurrences) n
FROM t1
GROUP BY workflow,message),b AS(
SELECT *,dense_rank() OVER(PARTITION BY message
ORDER BY n DESC) r
FROM a)
SELECT workflow,message,n
FROM b
WHERE r=1;
```

**Result and verification:** Risultato 1: 4 righe. [["Bravo","Error: Cannot Divide by 0",3],["Charlie","Error: Conversion Failed",7],["Charlie","Error: Unidentified error occurred",10],["Alpha","Status Complete",8]]

**Method and assumptions:** La query conta quante volte compare ciascun messaggio in ogni workflow. Per ogni messaggio restituisce tutti i workflow al primo posto.

**Edge cases and trade-offs:** Con una parità per Status Complete compaiono sia Alpha sia Tie.

```sql
INSERT INTO t1 VALUES ('Tie','Status Complete',8);
```

### I-23 · Split a result into halves
I-23
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L811) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L499-L518)

[Setup SQLite](setup/I-23.sql) · [Query](sql/I-23.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(player_id, score)` (5 righe).

```sql
SELECT ntile(2) OVER(
ORDER BY score DESC,player_id),player_id,score
FROM t1;
```

**Result and verification:** Risultato 1: 5 righe. [[1,2002,9432],[1,5005,6832],[1,3003,6548],[2,1001,2343],[2,4004,1054]]

**Method and assumptions:** La query assegna ciascun giocatore a una di due metà bilanciate. Se il numero di giocatori è dispari, la prima metà ne contiene uno in più. A pari punteggio decide l’ID.

**Edge cases and trade-offs:** Con sei giocatori ogni metà ne contiene tre. Chi ha lo stesso punteggio viene ordinato per ID.

```sql
INSERT INTO t1 VALUES (6006,9432);
```

### I-24 · Select a page of sorted rows
I-24
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L841) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L519-L551)

[Setup SQLite](setup/I-24.sql) · [Query](sql/I-24.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(order_id, customer_id, order_date, amount, state)` (13 righe).

```sql
SELECT *
FROM t1
ORDER BY order_id
LIMIT 6 OFFSET 4;
```

**Result and verification:** Risultato 1: 6 righe. [[5,1001,"2018-02-01",100,"TX"],[6,4004,"2018-05-01",50,"IA"],[7,1001,"2018-01-01",150,"TX"],[8,3003,"2018-03-01",100,"IA"],[9,4004,"2018-04-01",100,"IA"],[10,1001,"2018-01-01",75,"TX"]]

**Method and assumptions:** La pagina contiene gli ordini dal quinto al decimo nell’ordinamento per OrderID univoco. Le posizioni sono quelle nella lista ordinata e possono differire dagli ID.

**Edge cases and trade-offs:** Dopo aver rimosso il primo ordine, le stesse posizioni contengono gli ID da 6 a 11.

```sql
DELETE FROM t1 WHERE order_id=1;
```

### I-25 · Rank suppliers
I-25
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L876) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L552-L580)

[Setup SQLite](setup/I-25.sql) · [Query](sql/I-25.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(order_id, customer_id, count, vendor)` (6 righe).

```sql
WITH a AS(
SELECT customer_id,vendor,count(*) n
FROM t1
GROUP BY customer_id,vendor),b AS(
SELECT *,dense_rank() OVER(PARTITION BY customer_id
ORDER BY n DESC) r
FROM a)
SELECT customer_id,vendor
FROM b
WHERE r=1;
```

**Result and verification:** Risultato 1: 2 righe. [[1001,"Direct Parts"],[2002,"ACME"]]

**Method and assumptions:** Per ciascun cliente si contano gli ordini per fornitore, uno per riga, a prescindere dalla quantità nel campo Count. Si conservano tutti i fornitori a pari merito.

**Edge cases and trade-offs:** Con due ordini a testa per il cliente 1001, la query restituisce entrambi i fornitori.

```sql
INSERT INTO t1 VALUES (7,1001,1,'ACME');
```

### I-26 · Compare annual revenue
I-26
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L900) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L581-L603)

[Setup SQLite](setup/I-26.sql) · [Query](sql/I-26.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(year, amount)` (6 righe).

```sql
SELECT sum(CASE WHEN year=2018 THEN amount ELSE 0 END) AS "2018",sum(CASE WHEN year=2017 THEN amount ELSE 0 END) AS "2017",sum(CASE WHEN year=2016 THEN amount ELSE 0 END) AS "2016"
FROM t1;
```

**Result and verification:** Correzione fonte: 2016 = 159521 + 251696 + 111894 = 523111, non 411217 (che omette 111894). Risultato 1: 1 riga. [[352645,420219,523111]]

**Method and assumptions:** La riga riassume il 2018 e i due anni precedenti. Ogni colonna somma tutte le vendite dell’anno e vale zero se mancano righe.

**Edge cases and trade-offs:** La vendita aggiunta al 2015 è fuori dal periodo e non cambia nessuna delle tre somme.

```sql
INSERT INTO t1 VALUES (2015,999);
```

### I-27 · Deduplicate a table
I-27
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L923) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L604-L620)

[Setup SQLite](setup/I-27.sql) · [Query](sql/I-27.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(integer_value)` (6 righe).

```sql
DELETE
FROM t1
WHERE rowid NOT IN(
SELECT min(rowid)
FROM t1
GROUP BY integer_value);
SELECT integer_value
FROM t1;
```

**Result and verification:** Risultato 1: 4 righe. [[1],[2],[3],[4]]

**Method and assumptions:** La cancellazione conserva, per ciascun valore, la riga con rowid più basso. Eseguirla una seconda volta lascia i dati invariati.

**Edge cases and trade-offs:** Aggiungendo un altro 4 prima della cancellazione, resta comunque una sola copia dello stesso valore.

```sql
INSERT INTO t1 VALUES (4);
```

### I-28 · Carry values forward
I-28
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L950) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L621-L639)

[Setup SQLite](setup/I-28.sql) · [Query](sql/I-28.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(row_number, test_case)` (9 righe).

```sql
SELECT row_number,(
SELECT b.test_case
FROM t1 b
WHERE b.row_number<=a.row_number AND b.test_case IS NOT NULL
ORDER BY b.row_number DESC
LIMIT 1)
FROM t1 a;
```

**Result and verification:** Risultato 1: 9 righe. [[1,"Alpha"],[2,"Alpha"],[3,"Alpha"],[4,"Alpha"],[5,"Bravo"],[6,"Bravo"]] … (output completo nel report)

**Method and assumptions:** Per ogni posizione la query usa il valore corrente se è noto, altrimenti cerca l’ultimo valore noto precedente.

**Edge cases and trade-offs:** Un NULL all’inizio rimane NULL perché non c’è un valore precedente da usare.

```sql
INSERT INTO t1 VALUES (0,NULL);
```

### I-29 · Count contiguous groups
I-29
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L986) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L640-L668)

[Setup SQLite](setup/I-29.sql) · [Query](sql/I-29.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(step_number, status)` (12 righe).

```sql
WITH a AS(
SELECT *,lag(status) OVER(
ORDER BY step_number) prev
FROM t1),b AS(
SELECT *,sum(prev IS NOT status) OVER(
ORDER BY step_number) grp
FROM a)
SELECT min(step_number),max(step_number),status,count(*)
FROM b
GROUP BY grp,status;
```

**Result and verification:** Risultato 1: 3 righe. [[1,4,"Passed",4],[5,9,"Failed",5],[10,12,"Passed",3]]

**Method and assumptions:** Un gruppo inizia quando lo stato cambia nel percorso ordinato per StepNumber. Un salto nella numerazione, da solo, non spezza il gruppo.

**Edge cases and trade-offs:** Aggiungere Failed dopo Passed apre un quarto gruppo, di lunghezza 1.

```sql
INSERT INTO t1 VALUES (13,'Failed');
```

### I-30 · Select a changing set of columns
I-30
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1017) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L669-L682)

[Setup SQLite](setup/I-30.sql) · [Query](sql/I-30.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** Nessuna tabella iniziale: DDL o generazione interna.

```sql
CREATE TABLE products_data(product_id INTEGER PRIMARY KEY,product_name TEXT);
INSERT INTO products_data VALUES (1,'Widget');
CREATE VIEW products AS
SELECT product_id,product_name,forbid_star() AS forbidden
FROM products_data;
SELECT product_id,product_name
FROM products;
```

**Result and verification:** Risultato 1: 1 riga. [[1,"Widget"]]

**Method and assumptions:** La vista SQLite espone una colonna sentinella che fa fallire SELECT *. Le colonne nominate esplicitamente restano leggibili. Il runner registra forbid_star() per mostrare il comportamento della vista. Una vista così costruita non fornisce un controllo di accesso.

**Edge cases and trade-offs:** La selezione delle due colonne esplicite riesce. SELECT * restituisce Explicit columns required.

### I-31 · Find the runner-up value
I-31
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1035) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L683-L699)

[Setup SQLite](setup/I-31.sql) · [Query](sql/I-31.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(integer_value)` (5 righe); `t2(name, salary)` (5 righe).

```sql
SELECT max(integer_value)
FROM t1
WHERE integer_value<(
SELECT max(integer_value)
FROM t1);
SELECT DISTINCT integer_value
FROM t1
ORDER BY integer_value DESC
LIMIT 1 OFFSET 1;
WITH r AS(
SELECT integer_value,dense_rank() OVER(
ORDER BY integer_value DESC) r
FROM t1)
SELECT DISTINCT integer_value
FROM r
WHERE r=2;
SELECT max(salary)
FROM t2
WHERE salary<(
SELECT max(salary)
FROM t2);
```

**Result and verification:** Risultato 1: 1 riga. [[3762]] Risultato 2: 1 riga. [[3762]] Risultato 3: 1 riga. [[3762]] Risultato 4: 1 riga. [[150000]]

**Method and assumptions:** Le tre query cercano il secondo valore distinto. DENSE_RANK assegna lo stesso rango ai duplicati. Con meno di due valori, l’aggregazione restituisce NULL e le altre query non producono righe. Nel bonus stipendi il secondo valore distinto è 150000, anche con due primi e due secondi posti.

**Edge cases and trade-offs:** Una copia in più del valore massimo 3763 lascia invariato il secondo valore distinto.

```sql
INSERT INTO t1 VALUES (3763);
```

### I-32 · Extract boundary rows
I-32
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1070) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L700-L720)

[Setup SQLite](setup/I-32.sql) · [Query](sql/I-32.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(spaceman_id, job_description, mission_count)` (9 righe).

```sql
SELECT job_description,(
SELECT spaceman_id
FROM t1 b
WHERE b.job_description=a.job_description
ORDER BY mission_count DESC,spaceman_id
LIMIT 1),(
SELECT spaceman_id
FROM t1 b
WHERE b.job_description=a.job_description
ORDER BY mission_count,spaceman_id
LIMIT 1)
FROM t1 a
GROUP BY job_description;
```

**Result and verification:** Risultato 1: 3 righe. [["Astrogator",3003,1001],["Geologist",4004,6006],["Technician",7007,8008]]

**Method and assumptions:** Per ogni professione si restituiscono gli ID con più e meno missioni. Un pareggio si risolve scegliendo l’ID più basso.

**Edge cases and trade-offs:** Un Astrogator che pareggia a 17 missioni con ID 9999 non cambia il risultato.

```sql
INSERT INTO t1 VALUES (9999,'Astrogator',17);
```

### I-33 · Check dates against cutoffs
I-33
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1098) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L721-L761)

[Setup SQLite](setup/I-33.sql) · [Query](sql/I-33.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(order_id, component, days_to_deliver)` (3 righe); `t2(product, component, days_to_manufacture)` (8 righe).

```sql
WITH m AS(
SELECT product,max(days_to_manufacture) days
FROM t2
GROUP BY product)
SELECT order_id,component,days,days_to_deliver,CASE WHEN days=days_to_deliver THEN 'On Schedule' WHEN days>days_to_deliver THEN 'Behind Schedule' ELSE 'Ahead of Schedule' END
FROM t1
JOIN m ON product=component;
```

**Result and verification:** Risultato 1: 3 righe. [[1,"Aurora",7,7,"On Schedule"],[2,"Twilight",7,3,"Behind Schedule"],[3,"SunRay",3,9,"Ahead of Schedule"]]

**Method and assumptions:** Poiché la produzione è parallela, il tempo necessario è quello della lavorazione più lenta. La query valuta ogni ordine e assume che l’assemblaggio non richieda altro tempo.

**Edge cases and trade-offs:** Se il tempo richiesto coincide con il massimo ammesso, l’ordine è On Schedule.

```sql
INSERT INTO t1 VALUES (4,'SunRay',3);
```

### I-34 · Filter with exclusion rules
I-34
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1135) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L762-L780)

[Setup SQLite](setup/I-34.sql) · [Query](sql/I-34.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(order_id, customer_id, amount)` (4 righe).

```sql
SELECT *
FROM t1
WHERE customer_id IS NOT 1001 OR amount IS NOT 50;
```

**Result and verification:** Risultato 1: 3 righe. [[1,1001,25],[3,2002,65],[4,3003,50]]

**Method and assumptions:** La query esclude solo la combinazione cliente 1001 e importo 50. IS NOT permette di conservare le righe con valori NULL che non corrispondono alla combinazione.

**Edge cases and trade-offs:** Un ordine da 50 con cliente NULL rimane nel risultato.

```sql
INSERT INTO t1 VALUES (5,NULL,50);
```

### I-35 · Segment sales by market
I-35
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1158) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L781-L807)

[Setup SQLite](setup/I-35.sql) · [Query](sql/I-35.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(invoice_id, sales_rep_id, amount, sales_type)` (8 righe).

```sql
SELECT sales_rep_id
FROM t1
WHERE sales_type IN('Domestic','International')
GROUP BY sales_rep_id
HAVING count(DISTINCT sales_type)=1;
```

**Result and verification:** Risultato 1: 4 righe. [[3003],[4004],[5005],[6006]]

**Method and assumptions:** La query include un rappresentante se ha venduto in una sola categoria distinta. Più vendite nella stessa categoria contano come un’unica categoria.

**Edge cases and trade-offs:** Un’altra vendita Domestic del rappresentante 3003 lascia invariato l’elenco.

```sql
INSERT INTO t1 VALUES (9,3003,1,'Domestic');
```

### I-36 · Compare routes between cities
I-36
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1190) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L808-L831)

[Setup SQLite](setup/I-36.sql) · [Query](sql/I-36.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(route_id, departure_city, arrival_city, cost)` (4 righe).

```sql
WITH RECURSIVE r(city,path,cost,visited) AS(
SELECT 'Austin','Austin',0,',Austin,'
UNION ALL
SELECT arrival_city,path||' --> '||arrival_city,r.cost+t1.cost,visited||arrival_city||','
FROM r
JOIN t1 ON departure_city=city
WHERE city<>'Des Moines' AND instr(visited,','||arrival_city||',')=0)
SELECT path,cost
FROM r
WHERE city='Des Moines';
```

**Result and verification:** Risultato 1: 2 righe. [["Austin --> Dallas --> Des Moines",500],["Austin --> Dallas --> Memphis --> Des Moines",600]]

**Method and assumptions:** Si enumerano i percorsi semplici da Austin a Des Moines. La lista visited impedisce di tornare in una città già visitata. Sui dati di prova il percorso minimo costa 500 e quello massimo 600.

**Edge cases and trade-offs:** Aggiungere il collegamento da Dallas ad Austin non crea percorsi ammessi, perché farebbe tornare al punto di partenza.

```sql
INSERT INTO t1 VALUES (5,'Dallas','Austin',1);
```

### I-37 · Build group keys from conditions
I-37
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1216) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L832-L855)

[Setup SQLite](setup/I-37.sql) · [Query](sql/I-37.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(order_id, distributor, facility, zone, amount)` (4 righe).

```sql
SELECT dense_rank() OVER(
ORDER BY distributor,facility,zone),*
FROM t1;
```

**Result and verification:** Risultato 1: 4 righe. [[1,1,"ACME",123,"ABC",100],[1,2,"ACME",123,"ABC",75],[2,3,"Direct Parts",789,"XYZ",150],[2,4,"Direct Parts",789,"XYZ",125]]

**Method and assumptions:** A ogni ordine si assegna il rango della combinazione dei suoi tre attributi. Le chiavi numeriche dipendono dalle combinazioni presenti al momento del calcolo.

**Edge cases and trade-offs:** Una riga con una combinazione già nota riceve la stessa chiave, 1.

```sql
INSERT INTO t1 VALUES (5,'ACME',123,'ABC',1);
```

### I-38 · Assemble reporting rows
I-38
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1240) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L856-L883)

[Setup SQLite](setup/I-38.sql) · [Query](sql/I-38.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(region, distributor, sales)` (10 righe).

```sql
WITH r AS(
SELECT DISTINCT region
FROM t1),d AS(
SELECT DISTINCT distributor
FROM t1),s AS(
SELECT region,distributor,sum(sales) sales
FROM t1
GROUP BY region,distributor)
SELECT r.region,d.distributor,coalesce(s.sales,0)
FROM r
CROSS
JOIN d
LEFT
JOIN s USING(region,distributor);
```

**Result and verification:** Risultato 1: 12 righe. [["North","ACE",10],["North","ACME",65],["North","Direct Parts",8],["South","ACE",67],["South","ACME",9],["South","Direct Parts",7]] … (output completo nel report)

**Method and assumptions:** Il report contiene una riga per regione e distributore. Per ogni coppia somma le vendite o mostra zero. I dati non specificano date, quindi si usa un unico periodo implicito.

**Edge cases and trade-offs:** Una vendita aggiuntiva porta ACE/North a 15. Le coppie possibili restano 12.

```sql
INSERT INTO t1 VALUES ('North','ACE',5);
```

### I-39 · Generate prime values
I-39
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1280) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L884-L900)

[Setup SQLite](setup/I-39.sql) · [Query](sql/I-39.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(integer_value)` (10 righe).

```sql
WITH RECURSIVE n(x) AS(
SELECT 2
UNION ALL
SELECT x+1
FROM n
WHERE x*x<=(
SELECT max(integer_value)
FROM t1))
SELECT integer_value
FROM t1
WHERE integer_value>1 AND NOT EXISTS(
SELECT 1
FROM n
WHERE x*x<=integer_value AND integer_value%x=0);
```

**Result and verification:** Risultato 1: 4 righe. [[2],[3],[5],[7]]

**Method and assumptions:** La query esclude 1 e i numeri negativi. Per gli altri candidati cerca divisori fino alla radice quadrata e restituisce i primi.

**Edge cases and trade-offs:** Aggiungere 49 non cambia il risultato perché è divisibile per 7.

```sql
INSERT INTO t1 VALUES (49);
```

### I-40 · Define a custom row order
I-40
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1309) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L901-L917)

[Setup SQLite](setup/I-40.sql) · [Query](sql/I-40.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(city)` (4 righe).

```sql
SELECT city
FROM t1
ORDER BY CASE city WHEN 'Baltimore' THEN 1 WHEN 'Denver' THEN 2 WHEN 'Atlanta' THEN 3 WHEN 'Chicago' THEN 4 ELSE 5 END,city;
```

**Result and verification:** Risultato 1: 4 righe. [["Baltimore"],["Denver"],["Atlanta"],["Chicago"]]

**Method and assumptions:** Le città note seguono l’ordine esplicito della traccia. Le nuove città vengono dopo, in ordine alfabetico.

**Edge cases and trade-offs:** Boston non è nell’ordine predefinito, quindi finisce in coda.

```sql
INSERT INTO t1 VALUES ('Boston');
```

### I-41 · Link associated identifiers
I-41
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1333) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L918-L938)

[Setup SQLite](setup/I-41.sql) · [Query](sql/I-41.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(associate_1, associate_2)` (6 righe).

```sql
WITH RECURSIVE edges(a,b) AS(
SELECT *
FROM t1
UNION
SELECT associate_2,associate_1
FROM t1),reach(root,node) AS(
SELECT a,a
FROM edges
UNION
SELECT root,b
FROM reach
JOIN edges ON a=node),components AS(
SELECT node,min(root) root
FROM reach
GROUP BY node)
SELECT dense_rank() OVER(
ORDER BY root),node
FROM components;
```

**Result and verification:** Risultato 1: 8 righe. [[1,"Anne"],[1,"Betty"],[1,"Charles"],[1,"Dan"],[1,"Emma"],[2,"Francis"]] … (output completo nel report)

**Method and assumptions:** La query trova la componente di ciascun nodo nel grafo non orientato e la identifica con il nome più piccolo. UNION elimina le visite duplicate, così la ricerca termina anche se trova un ciclo.

**Edge cases and trade-offs:** Il collegamento da Emma ad Anne chiude un percorso già raggiungibile. Le componenti restano le stesse.

```sql
INSERT INTO t1 VALUES ('Emma','Anne');
```

### I-42 · Find shared connections
I-42
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1368) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L939-L957)

[Setup SQLite](setup/I-42.sql) · [Query](sql/I-42.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(friend_1, friend_2)` (6 righe).

```sql
WITH e(a,b) AS(
SELECT friend_1,friend_2
FROM t1
UNION
SELECT friend_2,friend_1
FROM t1)
SELECT a,b,(
SELECT count(*)
FROM e x
JOIN e y ON x.b=y.b
WHERE x.a=e.a AND y.a=e.b)
FROM e
WHERE a<b;
```

**Result and verification:** Risultato 1: 6 righe. [["Jason","Mary",2],["Jason","Mike",1],["Jason","Susan",1],["John","Mary",0],["Mary","Mike",1],["Mary","Susan",1]]

**Method and assumptions:** Per ogni coppia di amici si salvano i nomi in un ordine comune. La query conta i vicini condivisi nel grafo non orientato e ignora le amicizie duplicate.

**Edge cases and trade-offs:** Aggiungere Mary e Jason nell’altro ordine non cambia i conteggi.

```sql
INSERT INTO t1 VALUES ('Mary','Jason');
```

### I-43 · Use a running window frame
I-43
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1403) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L958-L977)

[Setup SQLite](setup/I-43.sql) · [Query](sql/I-43.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(order_id, customer_id, quantity)` (6 righe).

```sql
SELECT *,min(quantity) OVER(PARTITION BY customer_id
ORDER BY order_id ROWS UNBOUNDED PRECEDING)
FROM t1;
```

**Result and verification:** Risultato 1: 6 righe. [[1,1001,5,5],[2,1001,8,5],[3,1001,3,3],[4,1001,7,3],[1,2002,4,4],[2,2002,9,4]]

**Method and assumptions:** Per ogni ordine si prende il minimo visto fin lì per lo stesso cliente. La finestra assume che OrderID sia univoco all’interno del cliente.

**Edge cases and trade-offs:** Un nuovo minimo di 1 per il cliente 1001 aggiorna solo la finestra di quel cliente.

```sql
INSERT INTO t1 VALUES (5,1001,1);
```

### I-44 · Track dimension history
I-44
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1431) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L978-L1005)

[Setup SQLite](setup/I-44.sql) · [Query](sql/I-44.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(customer_id, balance_date, amount)` (10 righe).

```sql
SELECT customer_id,balance_date,coalesce(date(lead(balance_date) OVER(PARTITION BY customer_id
ORDER BY balance_date),'-1 day'),'9999-12-31'),amount
FROM t1;
```

**Result and verification:** Risultato 1: 10 righe. [[1001,"2021-09-01","2021-09-11",42.12],[1001,"2021-09-12","2021-09-17",56.23],[1001,"2021-09-18","2021-10-09",65.56],[1001,"2021-10-10","2021-10-10",17.65],[1001,"2021-10-11","9999-12-31",54.32],[2002,"2021-09-02","2021-09-09",11.11]] … (output completo nel report)

**Method and assumptions:** Ogni versione del cliente copre un intervallo di giorni inclusivo. Le date iniziali devono essere univoche per cliente. Una versione termina il giorno prima della successiva e l’ultima rimane aperta.

**Edge cases and trade-offs:** L’unica versione del nuovo cliente termina al 9999-12-31, usato per rappresentare l’intervallo aperto.

```sql
INSERT INTO t1 VALUES (3003,'2021-01-01',0);
```

### I-45 · Compare versions of dimension records
I-45
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1467) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1006-L1030)

[Setup SQLite](setup/I-45.sql) · [Query](sql/I-45.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(customer_id, start_date, end_date, amount)` (6 righe).

```sql
SELECT *
FROM t1 a
WHERE EXISTS(
SELECT 1
FROM t1 b
WHERE b.customer_id=a.customer_id AND b.start_date>a.start_date AND b.start_date<=a.end_date);
```

**Result and verification:** Risultato 1: 2 righe. [[1001,"2021-09-18","2021-10-12",65.56],[2002,"2021-09-01","2021-09-17",42.12]]

**Method and assumptions:** La query segnala la versione precedente quando il suo intervallo include l’inizio di una versione successiva. Gli estremi sono inclusivi. Per seguire la convenzione della fonte si segnala solo la versione precedente.

**Edge cases and trade-offs:** La versione aggiunta per il cliente 3003 non si sovrappone ad altre. L’elenco rimane invariato.

```sql
INSERT INTO t1 VALUES (3003,'2021-01-01','2021-01-02',0);
```

### I-46 · Identify overdrawn accounts
I-46
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1491) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1031-L1049)

[Setup SQLite](setup/I-46.sql) · [Query](sql/I-46.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(account_id, balance)` (7 righe).

```sql
SELECT account_id
FROM t1
GROUP BY account_id
HAVING max(balance)<=0 AND count(balance)=count(*);
SELECT DISTINCT a.account_id
FROM t1 a
WHERE NOT EXISTS(
SELECT 1
FROM t1 b
WHERE b.account_id=a.account_id AND (b.balance>0 OR b.balance IS NULL));
```

**Result and verification:** Risultato 1: 1 riga. [[2002]] Risultato 2: 1 riga. [[2002]]

**Method and assumptions:** Entrambe le formulazioni restituiscono i conti che non hanno mai avuto un saldo positivo. Zero è ammesso. Un saldo NULL esclude il conto, perché la storia è incompleta.

**Edge cases and trade-offs:** Entrambe le formulazioni includono un conto con saldo sempre pari a zero.

```sql
INSERT INTO t1 VALUES (4004,0);
```

### I-47 · Analyze a staffing calendar
I-47
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1518) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1050-L1088)

[Setup SQLite](setup/I-47.sql) · [Query](sql/I-47.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(schedule_id, start_time, end_time)` (2 righe); `t2(schedule_id, activity, start_time, end_time)` (4 righe).

```sql
WITH bounds(id,t) AS(
SELECT schedule_id,start_time
FROM t1
UNION
SELECT schedule_id,end_time
FROM t1
UNION
SELECT a.schedule_id,max(a.start_time,s.start_time)
FROM t2 a
JOIN t1 s USING(schedule_id)
WHERE a.end_time>s.start_time AND a.start_time<s.end_time
UNION
SELECT a.schedule_id,min(a.end_time,s.end_time)
FROM t2 a
JOIN t1 s USING(schedule_id)
WHERE a.end_time>s.start_time AND a.start_time<s.end_time),segments AS(
SELECT id,t,lead(t) OVER(PARTITION BY id
ORDER BY t) fin
FROM bounds)
SELECT id,coalesce((
SELECT activity
FROM t2 a
WHERE a.schedule_id=id AND a.start_time<=t AND a.end_time>=fin
ORDER BY a.rowid
LIMIT 1),'Work'),t,fin
FROM segments
WHERE fin>t;
```

**Result and verification:** Risultato 1: 9 righe. [["A","Meeting","2021-10-01 10:00","2021-10-01 10:30"],["A","Work","2021-10-01 10:30","2021-10-01 12:00"],["A","Break","2021-10-01 12:00","2021-10-01 12:30"],["A","Work","2021-10-01 12:30","2021-10-01 13:00"],["A","Meeting","2021-10-01 13:00","2021-10-01 13:30"],["A","Work","2021-10-01 13:30","2021-10-01 15:00"]] … (output completo nel report)

**Method and assumptions:** I confini di turni e attività dividono la giornata in segmenti semiaperti. Le attività si ritagliano sui limiti del turno. Se due attività si sovrappongono, prevale il rowid più basso e la durata si conta una volta sola.

**Edge cases and trade-offs:** Il turno B, senza attività, produce un solo segmento Work di 120 minuti.

```sql
DELETE FROM t2 WHERE schedule_id='B';
```

### I-48 · Find uninterrupted sales activity
I-48
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1554) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1089-L1107)

[Setup SQLite](setup/I-48.sql) · [Query](sql/I-48.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(sales_id, year)` (11 righe).

```sql
WITH params(y) AS(VALUES(2021))
SELECT sales_id
FROM t1,params
WHERE year BETWEEN y-2 AND y
GROUP BY sales_id
HAVING count(DISTINCT year)=3;
```

**Result and verification:** Risultato 1: 1 riga. [[4004]]

**Method and assumptions:** Si include un venditore solo se ha effettuato vendite in ciascuno dei tre anni. Il periodo termina nel 2021 per riprodurre i dati della fonte indipendentemente dalla data di esecuzione.

**Edge cases and trade-offs:** Dopo aver aggiunto una vendita del 2019 per il venditore 2002, si qualificano 2002 e 4004.

```sql
INSERT INTO t1 VALUES (2002,2019);
```

### I-49 · Compare competitors by weight
I-49
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1586) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1108-L1128)

[Setup SQLite](setup/I-49.sql) · [Query](sql/I-49.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(line_order, name, weight)` (6 righe).

```sql
WITH a AS(
SELECT *,sum(weight) OVER(
ORDER BY line_order ROWS UNBOUNDED PRECEDING) total
FROM t1)
SELECT name
FROM a
WHERE total<=2000
ORDER BY line_order DESC
LIMIT 1;
```

**Result and verification:** Risultato 1: 1 riga. [["Haruki"]]

**Method and assumptions:** Si sommano i pesi positivi nell’ordine di ingresso e si restituisce l’ultimo atleta per cui il totale è al massimo 2000. La coda non consente di saltare persone.

**Edge cases and trade-offs:** Se il primo atleta supera il limite, non entra nessuno.

```sql
UPDATE t1 SET weight=2001 WHERE line_order=1;
```

### I-50 · Track counts during play
I-50
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1609) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1129-L1151)

[Setup SQLite](setup/I-50.sql) · [Query](sql/I-50.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(batter_id, pitch_number, result)` (21 righe).

```sql
WITH RECURSIVE p AS(
SELECT *,row_number() OVER(PARTITION BY batter_id
ORDER BY pitch_number) rn
FROM t1),r(batter_id,pitch_number,result,rn,b,s,nb,ns) AS(
SELECT batter_id,pitch_number,result,rn,0,0,result='Ball',result IN('Foul','Strike')
FROM p
WHERE rn=1
UNION ALL
SELECT p.batter_id,p.pitch_number,p.result,p.rn,r.nb,r.ns,r.nb+(p.result='Ball'),r.ns+(p.result='Strike' OR(p.result='Foul' AND r.ns<2))
FROM r
JOIN p ON p.batter_id=r.batter_id AND p.rn=r.rn+1
WHERE r.nb<4 AND r.ns<3 AND r.result<>'In Play')
SELECT batter_id,pitch_number,result,b||' - '||s,CASE WHEN result='In Play' THEN 'In-Play' ELSE nb||' - '||ns END
FROM r;
```

**Result and verification:** Risultato 1: 21 righe. [[1001,1,"Foul","0 - 0","0 - 1"],[2002,1,"Ball","0 - 0","1 - 0"],[3003,1,"Ball","0 - 0","1 - 0"],[4004,1,"Foul","0 - 0","0 - 1"],[1001,2,"Foul","0 - 1","0 - 2"],[2002,2,"Strike","1 - 0","1 - 1"]] … (output completo nel report)

**Method and assumptions:** La ricorsione aggiorna il conteggio di ball e strike dopo ogni lancio valido. Un foul non aumenta gli strike oltre due. Il turno termina a quattro ball, tre strike o quando la palla è in gioco.

**Edge cases and trade-offs:** Il sesto lancio di 1001 arriva dopo la fine del turno e non cambia il risultato.

```sql
INSERT INTO t1 VALUES (1001,6,'Ball');
```

### I-51 · Design a primary key
I-51
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1645) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1152-L1171)

[Setup SQLite](setup/I-51.sql) · [Query](sql/I-51.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(assembly_id, part)` (6 righe).

```sql
SELECT assembly_id,part,sha256(json_array(cast(assembly_id AS INTEGER),part)) hash_key,crc32(json_array(cast(assembly_id AS INTEGER),part)) checksum_key
FROM t1;
```

**Result and verification:** Risultato 1: 6 righe. [[1001,"Bolt","f8add5f60dfeba507c3012f6bdfb43a368b9277b32f32d42912df6cad5df74c7",671178375],[1001,"Screw","e8596075244a203235fb05496d5bcc5a4252d4b57ce0fa2b010f8235a4423a83",4158788195],[2002,"Nut","44b49c60716b0be7aa87d483e8a70c876b6841fbaca79ca89a8accb365c7f60e",3755685612],[2002,"Washer","13554319230e3f5b09c6ccfe2be606691168cec18b66e9a4112d23529587cbf2",3892678580],[3003,"Toggle","df4f345f2b2d9fb32904bc4448a77033ff3b13a0c9546b9d759b7631cfa6044d",339927199],[3003,"Bolt","9bbf70ce0abcefccb24998058463e3613d7e4a05518d339c1f742236e0f3cbd5",3939297438]]

**Method and assumptions:** Questo adattamento SQLite di HASHBYTES e CHECKSUM usa SHA-256 e CRC32, registrati dal runner. L’array JSON canonico distingue NULL dalle stringhe. CRC32 è un algoritmo diverso da CHECKSUM di SQL Server e può produrre collisioni. Il vincolo UNIQUE sulla chiave naturale resta necessario anche se si usa un hash.

**Edge cases and trade-offs:** La serializzazione distingue NULL dalle stringhe e SHA-256 restituisce 64 cifre esadecimali.

```sql
INSERT INTO t1 VALUES (4004,NULL);
```

### I-52 · Reshape contact records
I-52
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1664) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1172-L1184)

[Setup SQLite](setup/I-52.sql) · [Query](sql/I-52.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(customer_id, phone_number)` (3 righe).

```sql
CREATE TABLE phones(customer_id INTEGER PRIMARY KEY,phone_number TEXT NOT NULL CHECK(length(phone_number)=14 AND phone_number GLOB '([0-9][0-9][0-9])-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'));
INSERT INTO phones
SELECT *
FROM t1;
SELECT *
FROM phones;
```

**Result and verification:** Risultato 1: 3 righe. [[1001,"(555)-555-5555"],[2002,"(555)-555-5555"],[3003,"(555)-555-5555"]]

**Method and assumptions:** Si conserva un numero per cliente. CHECK impone la lunghezza e la posizione esatta delle cifre ASCII. NOT NULL rende obbligatorio il numero.

**Edge cases and trade-offs:** I vincoli rifiutano un numero corto, lettere al posto delle cifre, una cifra di troppo e NULL.

### I-53 · Match partner identifiers
I-53
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1684) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1185-L1204)

[Setup SQLite](setup/I-53.sql) · [Query](sql/I-53.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(primary_id, spouse_id)` (6 righe).

```sql
SELECT dense_rank() OVER(
ORDER BY max(primary_id,spouse_id)),primary_id,spouse_id
FROM t1;
```

**Result and verification:** Risultato 1: 6 righe. [[1,"Ashley","Dee"],[1,"Dee","Ashley"],[2,"Jordan","Casey"],[2,"Casey","Jordan"],[3,"Pat","Charlie"],[3,"Charlie","Pat"]]

**Method and assumptions:** Si restituisce una riga per persona. Le coppie reciproche sono ordinate per il maggiore dei due identificativi in ordine lessicografico, come richiesto per riprodurre i GroupID della fonte.

**Edge cases and trade-offs:** Alla nuova coppia viene assegnato il gruppo 4.

```sql
INSERT INTO t1 VALUES ('Zoe','Zed');
```

### I-54 · Model a lottery draw
I-54
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1712) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1205-L1235)

[Setup SQLite](setup/I-54.sql) · [Query](sql/I-54.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(number)` (3 righe); `t2(ticket_id, number)` (9 righe).

```sql
WITH m AS(
SELECT ticket_id,count(DISTINCT CASE WHEN number IN(
SELECT number
FROM t1) THEN number END) n
FROM t2
GROUP BY ticket_id)
SELECT coalesce(sum(CASE WHEN n=(
SELECT count(DISTINCT number)
FROM t1) AND n>0 THEN 100 WHEN n>0 THEN 10 ELSE 0 END),0)
FROM m;
```

**Result and verification:** Risultato 1: 1 riga. [[110]]

**Method and assumptions:** La query riassume l’incasso in una riga. Ogni biglietto paga 100 se contiene tutti i numeri vincenti e 10 se ne contiene soltanto una parte.

**Edge cases and trade-offs:** Il numero 25 aggiunto ad AAA lascia invariato l’incasso.

```sql
INSERT INTO t2 VALUES ('AAA',25);
```

### I-55 · Audit table changes
I-55
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1746) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1236-L1269)

[Setup SQLite](setup/I-55.sql) · [Query](sql/I-55.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(product_name, quantity)` (3 righe); `t2(product_name, quantity)` (3 righe).

```sql
SELECT CASE WHEN a.product_name IS NULL THEN 'Product does not exist in table A' WHEN b.product_name IS NULL THEN 'Product does not exist in table B' WHEN a.quantity IS b.quantity THEN 'Matches in both table A and table B' ELSE 'Quantity in table A and table B do not match' END,coalesce(a.product_name,b.product_name)
FROM t1 a
FULL
JOIN t2 b USING(product_name);
```

**Result and verification:** Risultato 1: 4 righe. [["Matches in both table A and table B","Widget"],["Quantity in table A and table B do not match","Doodad"],["Product does not exist in table B","Gizmo"],["Product does not exist in table A","Dingbat"]]

**Method and assumptions:** Il nome del prodotto è univoco in ciascuna tabella. FULL JOIN permette di distinguere i prodotti assenti dalle quantità diverse. Se entrambe le quantità sono NULL, la query le considera corrispondenti.

**Edge cases and trade-offs:** Il prodotto con quantità NULL in entrambe le tabelle risulta corrispondente.

```sql
INSERT INTO t1 VALUES ('Null',NULL); INSERT INTO t2 VALUES ('Null',NULL);
```

### I-56 · Generate a sequence recursively
I-56
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1777) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1270-L1279)

[Setup SQLite](setup/I-56.sql) · [Query](sql/I-56.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** Nessuna tabella iniziale: DDL o generazione interna.

```sql
WITH RECURSIVE n(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM n
WHERE x<10)
SELECT x
FROM n;
```

**Result and verification:** Risultato 1: 10 righe. [[1],[2],[3],[4],[5],[6]] … (output completo nel report)

**Method and assumptions:** La ricorsione emette un intero alla volta, da 1 a 10 compresi. La condizione di arresto è nel passo ricorsivo.

**Edge cases and trade-offs:** Anche dopo aver creato una tabella estranea, la query produce dieci righe consecutive.

```sql
CREATE TABLE unused(x);
```

### I-57 · Identify empty positions
I-57
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1800) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1280-L1297)

[Setup SQLite](setup/I-57.sql) · [Query](sql/I-57.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(statement)` (2 righe).

```sql
WITH RECURSIVE w(id,string,start,rest,rn) AS(
SELECT rowid,statement,1,statement,1
FROM t1
UNION ALL
SELECT id,string,start+instr(rest,' '),substr(rest,instr(rest,' ')+1),rn+1
FROM w
WHERE instr(rest,' ')>0)
SELECT rn,id,string,start,start+length(CASE WHEN instr(rest,' ')=0 THEN rest ELSE substr(rest,1,instr(rest,' ')-1) END)-1,CASE WHEN instr(rest,' ')=0 THEN rest ELSE substr(rest,1,instr(rest,' ')-1) END
FROM w;
```

**Result and verification:** Risultato 1: 8 righe. [[1,1,"SELECT EmpID FROM Employees;",1,6,"SELECT"],[1,2,"SELECT * FROM Transactions;",1,6,"SELECT"],[2,1,"SELECT EmpID FROM Employees;",8,12,"EmpID"],[2,2,"SELECT * FROM Transactions;",8,8,"*"],[3,1,"SELECT EmpID FROM Employees;",14,17,"FROM"],[3,2,"SELECT * FROM Transactions;",10,13,"FROM"]] … (output completo nel report)

**Method and assumptions:** Ogni token ha una posizione a partire da 1. Il punto e virgola resta nel token e ogni coppia di spazi consecutivi delimita un token vuoto.

**Edge cases and trade-offs:** Due spazi consecutivi tra A e B producono un token vuoto.

```sql
INSERT INTO t1 VALUES ('A  B');
```

### I-58 · Find values that sum to a target
I-58
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1826) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1298-L1315)

[Setup SQLite](setup/I-58.sql) · [Query](sql/I-58.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(equation)` (9 righe).

```sql
WITH RECURSIVE r(e,p,total,term,sgn) AS(
SELECT equation,1,0,0,1
FROM t1
UNION ALL
SELECT e,p+1,CASE WHEN substr(e,p,1) IN('+','-') THEN total+sgn*term ELSE total END,CASE WHEN substr(e,p,1) IN('+','-') THEN 0 ELSE term*10+cast(substr(e,p,1) AS INTEGER) END,CASE substr(e,p,1) WHEN '+' THEN 1 WHEN '-' THEN -1 ELSE sgn END
FROM r
WHERE p<=length(e))
SELECT e,total+sgn*term
FROM r
WHERE p=length(e)+1;
```

**Result and verification:** Risultato 1: 9 righe. [["123",123],["1+23",24],["1-23",-22],["12+3",15],["12-3",9],["1+2+3",6]] … (output completo nel report)

**Method and assumptions:** La ricorsione legge le cifre e applica i segni + e - man mano. Ogni espressione produce una riga. La query non esegue il testo come codice e non prevede spazi o parentesi.

**Edge cases and trade-offs:** L’espressione 10-20+3 restituisce -7.

```sql
INSERT INTO t1 VALUES ('10-20+3');
```

### I-59 · Check whether symbols balance
I-59
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1860) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1316-L1343)

[Setup SQLite](setup/I-59.sql) · [Query](sql/I-59.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(id, string)` (9 righe).

```sql
WITH RECURSIVE r(id,original,s) AS(
SELECT id,string,string
FROM t1
UNION ALL
SELECT id,original,replace(replace(replace(s,'()',''),'[]',''),'{}','')
FROM r
WHERE s<>replace(replace(replace(s,'()',''),'[]',''),'{}',''))
SELECT id,original,CASE WHEN s='' THEN 'Balanced' ELSE 'Unbalanced' END
FROM r
WHERE s=replace(replace(replace(s,'()',''),'[]',''),'{}','');
```

**Result and verification:** Risultato 1: 9 righe. [[7,"({)","Unbalanced"],[1,"()","Balanced"],[2,"[]","Balanced"],[3,"{}","Balanced"],[5,"()[]","Balanced"],[9,"}()[][","Unbalanced"]] … (output completo nel report)

**Method and assumptions:** Si eliminano le coppie di parentesi adiacenti finché non se ne trovano più. La stringa è bilanciata se il residuo è vuoto. Il controllo riguarda anche l’ordine e nel caso peggiore ha costo quadratico.

**Edge cases and trade-offs:** La stringa ([)] contiene lo stesso numero di aperture e chiusure, ma l’incrocio delle parentesi la rende non bilanciata.

```sql
INSERT INTO t1 VALUES (10,'([)]');
```

### I-60 · Return unique product matches
I-60
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1900) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1344-L1364)

[Setup SQLite](setup/I-60.sql) · [Query](sql/I-60.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(product, product_code)` (4 righe).

```sql
SELECT product_code
FROM t1
GROUP BY product_code
HAVING count(DISTINCT product)=1;
```

**Result and verification:** Risultato 1: 2 righe. [["01"],["03"]]

**Method and assumptions:** La query conserva un codice se è associato a un solo prodotto distinto. I codici sono testo, così gli zeri iniziali si conservano.

**Edge cases and trade-offs:** Ripetere il codice 01 per Alpha non introduce un secondo prodotto e lascia invariato il risultato.

```sql
INSERT INTO t1 VALUES ('Alpha','01');
```

### I-61 · Summarize game scores
I-61
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1922) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1365-L1383)

[Setup SQLite](setup/I-61.sql) · [Query](sql/I-61.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(attempt_id, player_id, score)` (6 righe).

```sql
WITH a AS(
SELECT *,score-first_value(score) OVER w df,score-last_value(score) OVER(PARTITION BY player_id
ORDER BY attempt_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) dl,CASE WHEN lag(score) OVER w IS NULL OR score>lag(score) OVER w THEN 1 ELSE 0 END improved
FROM t1
WINDOW w AS(PARTITION BY player_id
ORDER BY attempt_id))
SELECT attempt_id,player_id,score,df,dl,improved,min(improved) OVER(PARTITION BY player_id)
FROM a;
```

**Result and verification:** Risultato 1: 6 righe. [[1,1001,2,0,-6,1,1],[2,1001,7,5,-1,1,1],[3,1001,8,6,0,1,1],[1,2002,6,0,-1,1,0],[2,2002,9,3,2,1,0],[3,2002,7,1,0,0,0]]

**Method and assumptions:** Ogni riga confronta un tentativo con il primo e con l’ultimo punteggio. Per convenzione il primo tentativo ha flag 1. Il miglioramento complessivo richiede che ogni passaggio aumenti il punteggio.

**Edge cases and trade-offs:** Se l’ultimo punteggio di 1001 è uguale al precedente, il flag complessivo passa a 0.

```sql
INSERT INTO t1 VALUES (4,1001,8);
```

### I-62 · Compare purchases across categories
I-62
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1954) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1384-L1409)

[Setup SQLite](setup/I-62.sql) · [Query](sql/I-62.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(vehicle_id, type, model, price)` (8 righe).

```sql
SELECT a.model,b.model
FROM t1 a
CROSS
JOIN t1 b
WHERE a.type='Car' AND b.type='Boat' AND a.price>=b.price+200000;
```

**Result and verification:** Risultato 1: 5 righe. [["Rolls-Royce Phantom","ATX 22-S"],["Rolls-Royce Phantom","Malibu"],["Rolls-Royce Phantom","Mastercraft"],["Lamborghini Spyder","ATX 22-S"],["Lamborghini Spyder","Mastercraft"]]

**Method and assumptions:** La query abbina auto e barca quando la differenza è almeno 200000. Questa soglia inclusiva riproduce l’output, anche se la traccia usa l’espressione “200000 more”.

**Edge cases and trade-offs:** La Lamborghini da 290000 e la barca da 90000 si abbinano perché la differenza è esattamente 200000.

```sql
INSERT INTO t1 VALUES (9,'Boat','Exact',90000);
```

### I-63 · Analyze redemption codes
I-63
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L1983) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1410-L1438)

[Setup SQLite](setup/I-63.sql) · [Query](sql/I-63.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(order_id, product, discount)` (12 righe).

```sql
SELECT order_id
FROM t1
GROUP BY order_id
HAVING count(DISTINCT product)=1 AND count(product)=count(*) AND sum(discount IS NOT 'PROMO')=0;
```

**Result and verification:** Risultato 1: 1 riga. [[3]]

**Method and assumptions:** L’ordine compare se contiene un solo prodotto e ogni riga ha lo sconto PROMO. Si ammettono righe duplicate. Uno sconto NULL non soddisfa la condizione.

**Edge cases and trade-offs:** Aggiungere uno sconto NULL all’ordine 3 lo esclude dal risultato.

```sql
INSERT INTO t1 VALUES (3,'Item 1',NULL);
```

### I-64 · Extract quoted text
I-64
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2014) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1439-L1461)

[Setup SQLite](setup/I-64.sql) · [Query](sql/I-64.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(id, string)` (6 righe).

```sql
WITH a AS(
SELECT *,length(string)-length(replace(string,'"','')) n,instr(string,'"') p
FROM t1)
SELECT id,string,CASE WHEN n<>2 THEN 'Error' WHEN instr(substr(string,p+1),'"')-1>10 THEN 'True' ELSE 'False' END
FROM a;
```

**Result and verification:** Risultato 1: 6 righe. [[1,"\"12345678901234\"","True"],[2,"1\"12345678901234\"","True"],[3,"123\"45678\"901234\"","Error"],[4,"123\"45678901234\"","True"],[5,"12345678901\"234\"","False"],[6,"12345678901234","Error"]]

**Method and assumptions:** Per ciascuna stringa si richiedono due virgolette esatte e più di 10 caratteri al loro interno. La query segnala Error quando trova una sola virgoletta, un caso che la traccia non specifica.

**Edge cases and trade-offs:** Con esattamente dieci caratteri tra le virgolette, il risultato è False.

```sql
INSERT INTO t1 VALUES (7,'"1234567890"');
```

### I-65 · Analyze property listings
I-65
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2046) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1462-L1488)

[Setup SQLite](setup/I-65.sql) · [Query](sql/I-65.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(listing_id, home_id, status)` (9 righe).

```sql
WITH a AS(
SELECT *,sum(status IN('New Listing','Relisted')) OVER(
ORDER BY listing_id ROWS UNBOUNDED PRECEDING) global_id
FROM t1)
SELECT listing_id,home_id,status,max(CASE WHEN status IN('New Listing','Relisted') THEN global_id END) OVER(PARTITION BY home_id
ORDER BY listing_id ROWS UNBOUNDED PRECEDING)
FROM a;
```

**Result and verification:** Risultato 1: 9 righe. [[1,"Home A","New Listing",1],[2,"Home A","Pending",1],[3,"Home A","Relisted",2],[4,"Home B","New Listing",3],[5,"Home B","Under Contract",3],[6,"Home B","Relisted",4]] … (output completo nel report)

**Method and assumptions:** Ogni evento New Listing o Relisted assegna una nuova chiave globale. Gli eventi successivi della stessa casa la ereditano, anche se ci sono eventi di altre case in mezzo. Un evento senza una precedente apertura ha gruppo NULL.

**Edge cases and trade-offs:** Con gli eventi interlacciati, Home A resta nel gruppo 2 mentre Relisted apre il gruppo 6 per Home C.

```sql
INSERT INTO t1 VALUES (10,'Home A','Pending'); INSERT INTO t1 VALUES (11,'Home C','Relisted');
```

### I-66 · Find compatible components
I-66
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2080) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1489-L1515)

[Setup SQLite](setup/I-66.sql) · [Query](sql/I-66.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(serial, manufacture_day, product)` (9 righe).

```sql
WITH a AS(
SELECT *,row_number() OVER(PARTITION BY product
ORDER BY manufacture_day,serial) rn
FROM t1)
SELECT max(CASE WHEN product='Bolt' THEN serial END),max(CASE WHEN product='Washer' THEN serial END),max(CASE WHEN product='Nut' THEN serial END)
FROM a
GROUP BY rn;
```

**Result and verification:** Risultato 1: 3 righe. [["A111","D222","G333"],["B111","E222","H333"],["C111","F222","I333"]]

**Method and assumptions:** Si ordinano i componenti di ciascun tipo per data e seriale, poi si abbinano quelli nella stessa posizione FIFO. Un kit incompleto compare comunque, con NULL per il pezzo assente.

**Edge cases and trade-offs:** L’ultimo kit resta nel risultato anche con Nut a NULL.

```sql
DELETE FROM t1 WHERE serial='I333';
```

### I-67 · Find shared birth dates
I-67
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2108) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1516-L1541)

[Setup SQLite](setup/I-67.sql) · [Query](sql/I-67.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(student, birthday)` (9 righe).

```sql
SELECT birthday,group_concat(student,', '
ORDER BY student)
FROM t1
GROUP BY birthday
HAVING count(*)>1;
```

**Result and verification:** Risultato 1: 2 righe. [["2015-04-15","Jacob, Susan, Tim"],["2015-05-23","Angie, Mike"]]

**Method and assumptions:** Si raggruppano i record per data di nascita completa, anno compreso. Si restituiscono le date condivise, con i nomi in ordine alfabetico.

**Edge cases and trade-offs:** La data 2016-04-15 aggiunta per Another non introduce una nuova data condivisa.

```sql
INSERT INTO t1 VALUES ('Another','2016-04-15');
```

### I-68 · Measure the effect of extreme values
I-68
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2135) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1542-L1566)

[Setup SQLite](setup/I-68.sql) · [Query](sql/I-68.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(team, year, score)` (8 righe).

```sql
WITH a AS(
SELECT *,avg(1.0*score) OVER(PARTITION BY team) mean
FROM t1),b AS(
SELECT *,row_number() OVER(PARTITION BY team
ORDER BY abs(score-mean) DESC,year) rn
FROM a)
SELECT team,cast(avg(1.0*score) AS INTEGER)
FROM b
WHERE rn>1
GROUP BY team;
```

**Result and verification:** Risultato 1: 2 righe. [["Bulldogs",61],["Cougars",53]]

**Method and assumptions:** Per ogni squadra si calcola la media iniziale e si rimuove il punteggio più distante. A pari distanza si rimuove quello dell’anno più vecchio. La media residua è troncata come nella fonte.

**Edge cases and trade-offs:** Una squadra con un solo punteggio resta senza osservazioni dopo la rimozione. Il risultato per le altre squadre resta identico.

```sql
INSERT INTO t1 VALUES ('Single',2020,10);
```

### I-69 · Break down a hierarchy
I-69
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2161) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1567-L1590)

[Setup SQLite](setup/I-69.sql) · [Query](sql/I-69.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(parent, child)` (6 righe).

```sql
WITH RECURSIVE roots AS(
SELECT DISTINCT parent root
FROM t1
WHERE parent NOT IN(
SELECT child
FROM t1)),seeds AS(
SELECT root,child,dense_rank() OVER(
ORDER BY root,child) grp
FROM roots
JOIN t1 ON parent=root),r(grp,node) AS(
SELECT grp,root
FROM seeds
UNION
SELECT grp,child
FROM seeds
UNION
SELECT r.grp,t1.child
FROM r
JOIN t1 ON parent=node
WHERE node NOT IN(
SELECT root
FROM roots))
SELECT grp,node
FROM r;
```

**Result and verification:** Risultato 1: 8 righe. [[1,"A"],[1,"B"],[2,"A"],[2,"C"],[1,"D"],[1,"E"]] … (output completo nel report)

**Method and assumptions:** Ogni riga associa un nodo al suo ramo principale. La radice compare in ogni gruppo e l’ordine dei gruppi segue i suoi figli. UNION elimina le duplicazioni.

**Edge cases and trade-offs:** H, figlio di E, finisce nel ramo 1.

```sql
INSERT INTO t1 VALUES ('E','H');
```

### I-70 · Summarize student records
I-70
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2201) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1591-L1617)

[Setup SQLite](setup/I-70.sql) · [Query](sql/I-70.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(parent_id, child_id, age, gender)` (8 righe).

```sql
WITH a AS(
SELECT *,age-lag(age) OVER(PARTITION BY parent_id
ORDER BY age,child_id) gap
FROM t1)
SELECT parent_id,count(*),cast(avg(1.0*age) AS INTEGER),max(age)-min(age),coalesce(max(gap),0),min(age),max(age),group_concat(gender,', '
ORDER BY age,child_id)
FROM a
GROUP BY parent_id;
```

**Result and verification:** Risultato 1: 4 righe. [[1001,2,10,4,4,8,12,"M, F"],[2002,3,10,7,5,7,14,"F, F, M"],[3003,2,13,2,2,12,14,"F, M"],[4004,1,7,0,0,7,7,"M"]]

**Method and assumptions:** Per famiglia si calcolano la differenza tra età estreme e il salto massimo tra età consecutive. Il riepilogo dei generi segue l’ordine per età e ID. La media è troncata come nella fonte e per un figlio unico i divari sono zero.

**Edge cases and trade-offs:** Per la famiglia con un figlio di 10 anni, la media vale 10 e tutti i divari valgono zero.

```sql
INSERT INTO t1 VALUES (5005,'I',10,'F');
```

### I-71 · Validate staff records
I-71
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2229) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1618-L1674)

[Setup SQLite](setup/I-71.sql) · [Query](sql/I-71.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(employee_id, department)` (3 righe); `t2(employee_id, department)` (3 righe); `t3(employee_id, name)` (6 righe).

```sql
CREATE TABLE employees(employee_id INTEGER PRIMARY KEY,name TEXT);
INSERT INTO employees SELECT * FROM t3;
CREATE TABLE temporary(employee_id INTEGER PRIMARY KEY REFERENCES employees,department TEXT);
CREATE TABLE permanent(employee_id INTEGER PRIMARY KEY REFERENCES employees,department TEXT);
CREATE TRIGGER temp_insert BEFORE INSERT ON temporary WHEN EXISTS(SELECT 1 FROM permanent WHERE employee_id=NEW.employee_id) BEGIN SELECT raise(ABORT,'Employee already permanent'); END;
CREATE TRIGGER perm_insert BEFORE INSERT ON permanent WHEN EXISTS(SELECT 1 FROM temporary WHERE employee_id=NEW.employee_id) BEGIN SELECT raise(ABORT,'Employee already temporary'); END;
CREATE TRIGGER temp_update BEFORE UPDATE OF employee_id ON temporary WHEN EXISTS(SELECT 1 FROM permanent WHERE employee_id=NEW.employee_id) BEGIN SELECT raise(ABORT,'Employee already permanent'); END;
CREATE TRIGGER perm_update BEFORE UPDATE OF employee_id ON permanent WHEN EXISTS(SELECT 1 FROM temporary WHERE employee_id=NEW.employee_id) BEGIN SELECT raise(ABORT,'Employee already temporary'); END;
INSERT INTO temporary SELECT * FROM t1;
INSERT INTO permanent SELECT * FROM t2;
SELECT employee_id,department,'Temporary' FROM temporary UNION ALL SELECT employee_id,department,'Permanent' FROM permanent;
```

**Result and verification:** Risultato 1: 6 righe. [[1001,"Engineering","Temporary"],[2002,"Sales","Temporary"],[3003,"Marketing","Temporary"],[4004,"Marketing","Permanent"],[5005,"Accounting","Permanent"],[6006,"Accounting","Permanent"]]

**Method and assumptions:** La query produce una riga per assunzione. Il runner attiva le chiavi esterne e i trigger simmetrici impediscono la doppia presenza anche durante un UPDATE. SQLite serializza le scritture.

**Edge cases and trade-offs:** Il test respinge sei operazioni: inserimenti doppi, inserimenti senza anagrafica e aggiornamenti incrociati nei due sensi.

### I-72 · Check warranty eligibility
I-72
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2267) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1675-L1699)

[Setup SQLite](setup/I-72.sql) · [Query](sql/I-72.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(repair_id, customer_id, repair_date)` (8 righe).

```sql
WITH a AS(
SELECT *,lag(repair_id) OVER w prev_id,lag(repair_date) OVER w prev_date
FROM t1
WINDOW w AS(PARTITION BY customer_id
ORDER BY repair_date,repair_id)),b AS(
SELECT *,julianday(repair_date)-julianday(prev_date) gap
FROM a),c AS(
SELECT *,sum(gap IS NULL OR gap>30) OVER(PARTITION BY customer_id
ORDER BY repair_date,repair_id) grp
FROM b),d AS(
SELECT *,row_number() OVER(PARTITION BY customer_id,grp
ORDER BY repair_date,repair_id)-1 seq
FROM c)
SELECT customer_id,repair_id,prev_id,repair_date,prev_date,seq,gap
FROM d
WHERE gap<=30;
```

**Result and verification:** Risultato 1: 4 righe. [["A",2002,1001,"2023-01-15","2023-01-01",1,14],["A",3003,2002,"2023-01-17","2023-01-15",2,2],["A",5005,4004,"2023-04-01","2023-03-24",1,8],["B",7007,6006,"2023-06-23","2023-06-22",1,1]]

**Method and assumptions:** Ogni intervento rinnova la garanzia. Per ciascun cliente si ordinano gli interventi per data e ID. Si includono le riparazioni a non più di 30 giorni dalla precedente e si avvia una nuova sequenza dopo un divario più lungo.

**Edge cases and trade-offs:** La riparazione a esattamente 30 giorni è inclusa e risulta il primo intervento coperto della nuova sequenza.

```sql
INSERT INTO t1 VALUES (9009,'B','2023-10-01');
```

### I-73 · Summarize unique states
I-73
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2295) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1700-L1724)

[Setup SQLite](setup/I-73.sql) · [Query](sql/I-73.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(step_id, workflow, status)` (8 righe).

```sql
SELECT a.*,(
SELECT count(DISTINCT b.status)
FROM t1 b
WHERE b.workflow=a.workflow AND b.step_id<=a.step_id)
FROM t1 a;
```

**Result and verification:** Risultato 1: 8 righe. [[1,"Alpha","Open",1],[2,"Alpha","Open",1],[3,"Alpha","Inactive",2],[4,"Alpha","Open",2],[5,"Bravo","Closed",1],[6,"Bravo","Closed",1]] … (output completo nel report)

**Method and assumptions:** Per ogni passaggio, la query conta gli stati distinti osservati nello stesso workflow fino a quel punto incluso. COUNT DISTINCT ignora NULL.

**Edge cases and trade-offs:** Con uno stato già visto, il conteggio distinto non aumenta.

```sql
INSERT INTO t1 VALUES (9,'Bravo','Closed');
```

### I-74 · Compare league results
I-74
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2327) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1725-L1749)

[Setup SQLite](setup/I-74.sql) · [Query](sql/I-74.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(game_id, bowler, score)` (8 righe).

```sql
WITH a AS(
SELECT game_id,bowler,lead(bowler) OVER(PARTITION BY game_id
ORDER BY score DESC,bowler) next
FROM t1),b AS(
SELECT min(bowler,next) lo,max(bowler,next) hi
FROM a
WHERE next IS NOT NULL)
SELECT lo,hi,count(*)
FROM b
GROUP BY lo,hi;
```

**Result and verification:** Risultato 1: 5 righe. [["Anthony","Dennis",1],["Dennis","John",1],["John","Susan",2],["Mary","Ralph",1],["Ralph","Susan",1]]

**Method and assumptions:** Si ordinano i punteggi in senso decrescente, usando il nome per sciogliere le parità. La query abbina i giocatori vicini in classifica e dispone i nomi in ordine alfabetico in ogni coppia.

**Edge cases and trade-offs:** Aggiungere Solo come unico giocatore della sua lega non crea una coppia.

```sql
INSERT INTO t1 VALUES (3,'Solo',100);
```

### I-75 · Find mirrored matches
I-75
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2356) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1750-L1770)

[Setup SQLite](setup/I-75.sql) · [Query](sql/I-75.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(box_id, length, width, height)` (3 righe).

```sql
WITH a AS(
SELECT box_id,min(length,width,height) lo,max(length,width,height) hi,length+width+height-min(length,width,height)-max(length,width,height) mid
FROM t1)
SELECT box_id,dense_rank() OVER(
ORDER BY lo,mid,hi)
FROM a;
```

**Result and verification:** Risultato 1: 3 righe. [["A",1],["B",1],["C",2]]

**Method and assumptions:** La query ordina le tre dimensioni positive e non NULL di ciascuna scatola. Le scatole che differiscono solo per la rotazione finiscono nello stesso gruppo.

**Edge cases and trade-offs:** La scatola con le dimensioni di A e B ruotate resta nel gruppo 1.

```sql
INSERT INTO t1 VALUES ('D',25,15,10);
```

### I-76 · Assign records to batches
I-76
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2380) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1771-L1806)

[Setup SQLite](setup/I-76.sql) · [Query](sql/I-76.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(batch, batch_start)` (2 righe); `t2(batch, line, syntax)` (6 righe).

```sql
SELECT batch,batch_start,(
SELECT min(line)
FROM t2
WHERE t2.batch=t1.batch AND line>=batch_start AND trim(syntax)='GO')
FROM t1;
```

**Result and verification:** Risultato 1: 2 righe. [["A",1,3],["A",5,6]]

**Method and assumptions:** Si restituisce una riga per inizio batch. Il primo GO alla riga corrente o successiva ne indica la fine. In sua assenza il termine è NULL. La query esamina il testo senza eseguirlo.

**Edge cases and trade-offs:** Il batch privo di GO ha termine NULL.

```sql
INSERT INTO t1 VALUES ('A',7);
```

### I-77 · Analyze sensor measurements
I-77
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2411) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1807-L1824)

[Setup SQLite](setup/I-77.sql) · [Query](sql/I-77.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(temperature_id, temperature_value)` (12 righe).

```sql
WITH a AS(
SELECT *, (
SELECT temperature_value
FROM t1 b
WHERE b.temperature_id<a.temperature_id AND temperature_value IS NOT NULL
ORDER BY temperature_id DESC
LIMIT 1) prev,(
SELECT temperature_value
FROM t1 b
WHERE b.temperature_id>a.temperature_id AND temperature_value IS NOT NULL
ORDER BY temperature_id
LIMIT 1) next
FROM t1 a)
SELECT temperature_id,coalesce(temperature_value,CASE WHEN prev IS NULL THEN next WHEN next IS NULL THEN prev ELSE max(prev,next) END)
FROM a;
```

**Result and verification:** Risultato 1: 12 righe. [[1,52],[2,65],[3,65],[4,65],[5,72],[6,72]] … (output completo nel report)

**Method and assumptions:** Per ogni lettura NULL si cerca il valore noto più vicino da ciascun lato e si prende il maggiore. Se trova un solo vicino usa quello. Se non ne trova, lascia NULL.

**Edge cases and trade-offs:** Una lettura NULL all’inizio prende il primo valore noto successivo, 52.

```sql
INSERT INTO t1 VALUES (0,NULL);
```

### I-78 · Test for matching records
I-78
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2451) · [SQL Server setup](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20DDL.sql#L1825-L1856)

[Setup SQLite](setup/I-78.sql) · [Query](sql/I-78.sql) · [Controlli](checks.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(statusid, status)` (4 righe); `t2(statuscode)` (1 riga).

```sql
SELECT *
FROM t1
WHERE EXISTS(
SELECT 1
FROM t2);
```

**Result and verification:** Risultato 1: 4 righe. [[1,"Completed"],[2,"Fail"],[3,"Unknown"],[4,"Completed"]]

**Method and assumptions:** La query restituisce una riga per stato se la tabella dei codici contiene almeno un record. EXISTS verifica la presenza senza moltiplicare le righe.

**Edge cases and trade-offs:** Quando la tabella dei codici è vuota, la query non restituisce stati.

```sql
DELETE FROM t2;
```

## Part II · Sequences, combinations and simulations

Per i problemi aperti, i parametri scelti sono riportati nel setup e il controllo è spiegato nella scheda o nel report di verifica.

### II-01 · Compute factorial values
II-01
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2499)

[Setup SQLite](setup/II-01.sql) · [Query](sql/II-01.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(n)` (1 riga).

```sql
WITH RECURSIVE f(n,v) AS(
SELECT 1,1
WHERE (
SELECT n
FROM t1)>0
UNION ALL
SELECT n+1,v*(n+1)
FROM f
WHERE n<(
SELECT n
FROM t1))
SELECT n,v
FROM f;
```

**Result and verification:** Risultato 1: 10 righe. [[1,1],[2,2],[3,6],[4,24],[5,120],[6,720]] … (output completo nel report)

**Method and assumptions:** La query restituisce ogni intero da 1 a n e il suo fattoriale. Fino a 20! il risultato entra in un intero SQLite a 64 bit con segno. Per valori maggiori serve aritmetica a precisione arbitraria.

**Edge cases and trade-offs:** Con n=1 si ottiene solo la riga (1,1).

```sql
UPDATE t1 SET n=1;
```

### II-02 · Enumerate all orderings
II-02
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2522)

[Setup SQLite](setup/II-02.sql) · [Query](sql/II-02.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(n)` (1 riga).

```sql
WITH RECURSIVE nums(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM nums
WHERE x<(
SELECT n
FROM t1)),p(path,mask,k,last) AS(
SELECT '',0,0,0
UNION ALL
SELECT path||CASE WHEN k=0 THEN '' ELSE ',' END||x,mask|(1<<x),k+1,x
FROM p
CROSS
JOIN nums
WHERE (mask&(1<<x))=0)
SELECT (
SELECT n
FROM t1),path
FROM p
WHERE k=(
SELECT n
FROM t1);
```

**Result and verification:** Risultato 1: 6 righe. [[3,"1,2,3"],[3,"1,3,2"],[3,"2,1,3"],[3,"2,3,1"],[3,"3,1,2"],[3,"3,2,1"]]

**Method and assumptions:** La maschera di bit tiene traccia degli interi da 1 a n già usati. Ogni riga è una permutazione senza ripetizioni. Il numero di righe cresce come n!, quindi funziona per n piccoli.

**Edge cases and trade-offs:** Con n=1 esiste solo la permutazione 1.

```sql
UPDATE t1 SET n=1;
```

### II-03 · Build increasing sequences
II-03
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2541)

[Setup SQLite](setup/II-03.sql) · [Query](sql/II-03.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(n)` (1 riga).

```sql
WITH RECURSIVE r(n,s) AS(
SELECT 1,'1'
UNION ALL
SELECT n+1,s||(n+1)
FROM r
WHERE n<(
SELECT n
FROM t1))
SELECT s
FROM r;
```

**Result and verification:** Risultato 1: 5 righe. [["1"],["12"],["123"],["1234"],["12345"]]

**Method and assumptions:** La query emette un prefisso crescente per ogni lunghezza, partendo da 1 e aggiungendo l’intero successivo fino a n. Conserva il risultato come testo per mantenere la concatenazione.

**Edge cases and trade-offs:** Con n=1 si ottiene un solo prefisso, il testo 1.

```sql
UPDATE t1 SET n=1;
```

### II-04 · Select nonconsecutive values
II-04
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2559)

[Setup SQLite](setup/II-04.sql) · [Query](sql/II-04.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(n)` (1 riga).

```sql
WITH RECURSIVE nums(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM nums
WHERE x<(
SELECT n
FROM t1)),p(path,mask,k,last) AS(
SELECT '',0,0,0
UNION ALL
SELECT path||CASE WHEN k=0 THEN '' ELSE ',' END||x,mask|(1<<x),k+1,x
FROM p
CROSS
JOIN nums
WHERE (mask&(1<<x))=0 AND (k=0 OR abs(x-last)>1))
SELECT path
FROM p
WHERE k=(
SELECT n
FROM t1);
```

**Result and verification:** Risultato 1: 2 righe. [["2,4,1,3"],["3,1,4,2"]]

**Method and assumptions:** Ogni riga è una permutazione in cui due valori adiacenti non differiscono di 1. Con n=4 si riproducono le due righe attese. La traccia usa n=10 solo come esempio.

**Edge cases and trade-offs:** Con n=3 non esiste una permutazione valida.

```sql
UPDATE t1 SET n=3;
```

### II-05 · Build a target sum
II-05
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2577)

[Setup SQLite](setup/II-05.sql) · [Query](sql/II-05.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(n)` (1 riga).

```sql
WITH RECURSIVE ops(o) AS(VALUES(''),('+'),('-')),r(k,s,total,term,sign) AS(
SELECT 1,'1',0,1,1
UNION ALL
SELECT k+1,s||o||(k+1),CASE WHEN o='' THEN total ELSE total+sign*term END,CASE WHEN o='' THEN term*10+(k+1) ELSE k+1 END,CASE WHEN o='-' THEN -1 WHEN o='+' THEN 1 ELSE sign END
FROM r
CROSS
JOIN ops
WHERE k<(
SELECT n
FROM t1))
SELECT s,total+sign*term
FROM r
WHERE k=(
SELECT n
FROM t1);
```

**Result and verification:** Risultato 1: 9 righe. [["123",123],["12+3",15],["12-3",9],["1+23",24],["1+2+3",6],["1+2-3",0]] … (output completo nel report)

**Method and assumptions:** Tra le cifre consecutive da 1 a n si può concatenare, sommare o sottrarre. Il dominio è da 1 a 9 e ci sono 3^(n-1) combinazioni. La query costruisce il totale durante la ricerca senza eseguire il testo risultante.

**Edge cases and trade-offs:** Con n=1 non si inseriscono operatori e l’espressione vale 1.

```sql
UPDATE t1 SET n=1;
```

### II-06 · Enumerate binary strings
II-06
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2599)

[Setup SQLite](setup/II-06.sql) · [Query](sql/II-06.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(n)` (1 riga).

```sql
WITH RECURSIVE bit(b) AS(VALUES('0'),('1')),r(s,k) AS(VALUES('',0)
UNION ALL
SELECT s||b,k+1
FROM r
CROSS
JOIN bit
WHERE k<(
SELECT n
FROM t1))
SELECT s
FROM r
WHERE k=(
SELECT n
FROM t1);
```

**Result and verification:** Risultato 1: 8 righe. [["000"],["001"],["010"],["011"],["100"],["101"]] … (output completo nel report)

**Method and assumptions:** La query genera una stringa per ogni combinazione di n cifre binarie. Il tipo testo conserva gli zeri iniziali.

**Edge cases and trade-offs:** Con n=0 si ottiene una sola stringa, quella vuota.

```sql
UPDATE t1 SET n=0;
```

### II-07 · Arrange a sequence of integers
II-07
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2620)

[Setup SQLite](setup/II-07.sql) · [Query](sql/II-07.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(n, k)` (1 riga).

```sql
WITH RECURSIVE nums(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM nums
WHERE x<(
SELECT n
FROM t1)),p(path,mask,k,last) AS(
SELECT '',0,0,0
UNION ALL
SELECT path||CASE WHEN k=0 THEN '' ELSE ',' END||x,mask|(1<<x),k+1,x
FROM p
CROSS
JOIN nums
WHERE (mask&(1<<x))=0)
SELECT path
FROM p
WHERE k=(
SELECT k
FROM t1);
```

**Result and verification:** Risultato 1: 24 righe. [["1,2,3"],["1,2,4"],["1,3,2"],["1,3,4"],["1,4,2"],["1,4,3"]] … (output completo nel report)

**Method and assumptions:** Ogni riga dispone k elementi distinti scelti da 1 a n. La ricorsione si ferma dopo k scelte e sui dati base produce 24 terne.

**Edge cases and trade-offs:** Con n=3 e k=2 si ottengono tutte le sei coppie ordinate senza ripetizioni.

```sql
UPDATE t1 SET n=3,k=2;
```

### II-08 · Assign vehicles under constraints
II-08
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2657)

[Setup SQLite](setup/II-08.sql) · [Query](sql/II-08.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(adults)` (1 riga).

```sql
WITH RECURSIVE people(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM people
WHERE x<10),r(k,mask,seats,prev) AS(
SELECT 0,0,'',0
UNION ALL
SELECT k+1,mask|(1<<x),seats||CASE WHEN k=0 THEN '' ELSE ',' END||x,x
FROM r
CROSS
JOIN people
WHERE (mask&(1<<x))=0 AND (k>=4 OR x<=(
SELECT adults
FROM t1)) AND (k NOT IN(6,8,9) OR x>prev))
SELECT seats
FROM r
WHERE k=10;
```

**Result and verification:** Risultato 1: 7200 righe. [["1,2,3,4,5,6,7,8,9,10"],["1,2,3,4,5,6,8,7,9,10"],["1,2,3,4,5,6,9,7,8,10"],["1,2,3,4,5,6,10,7,8,9"],["1,2,3,4,5,7,8,6,9,10"],["1,2,3,4,5,7,9,6,8,10"]] … (output completo nel report)

**Method and assumptions:** Le posizioni da 1 a 4 sono i guidatori di moto, sidecar, golf e auto. La posizione 5 è il passeggero del sidecar, da 6 a 7 quelli del golf e da 8 a 10 quelli dell’auto. Le persone da 1 a 5 sono adulte, le altre sono bambini. Ordinando i passeggeri di ogni veicolo si evitano duplicati: 120 scelte dei guidatori per 60 assegnazioni danno 7200 disposizioni.

**Edge cases and trade-offs:** Con tre adulti e quattro mezzi da guidare non c’è alcuna disposizione valida.

```sql
UPDATE t1 SET adults=3;
```

### II-09 · Locate available positions
II-09
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2677)

[Setup SQLite](setup/II-09.sql) · [Query](sql/II-09.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(statement)` (2 righe).

```sql
WITH RECURSIVE w(id,string,start,rest,rn) AS(
SELECT rowid,statement,1,statement,1
FROM t1
UNION ALL
SELECT id,string,start+instr(rest,' '),substr(rest,instr(rest,' ')+1),rn+1
FROM w
WHERE instr(rest,' ')>0)
SELECT rn,id,string,start,CASE WHEN instr(rest,' ')>0 THEN start+instr(rest,' ')-1 END,rtrim(CASE WHEN instr(rest,' ')=0 THEN rest ELSE substr(rest,1,instr(rest,' ')-1) END,';'),length(string)-length(replace(string,' ',''))
FROM w;
```

**Result and verification:** Risultato 1: 8 righe. [[1,1,"SELECT EmpID FROM Emps;",1,7,"SELECT",3],[1,2,"SELECT * FROM Trans;",1,7,"SELECT",3],[2,1,"SELECT EmpID FROM Emps;",8,13,"EmpID",3],[2,2,"SELECT * FROM Trans;",8,9,"*",3],[3,1,"SELECT EmpID FROM Emps;",14,18,"FROM",3],[3,2,"SELECT * FROM Trans;",10,14,"FROM",3]] … (output completo nel report)

**Method and assumptions:** Ogni riga riporta un token, la posizione iniziale, lo spazio successivo e il totale degli spazi. L’ultimo token non ha spazio successivo e la fonte rimuove da quel token il punto e virgola.

**Edge cases and trade-offs:** ONE produce un token, nessuno spazio successivo e un totale di zero spazi.

```sql
INSERT INTO t1 VALUES ('ONE');
```

### II-10 · Arrange seats under constraints
II-10
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2703)

[Setup SQLite](setup/II-10.sql) · [Query](sql/II-10.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(seat_number)` (16 righe).

```sql
WITH RECURSIVE n(x) AS(
SELECT 1
WHERE (
SELECT max(seat_number)
FROM t1)>=1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT max(seat_number)
FROM t1)), missing AS(
SELECT x
FROM n
WHERE NOT EXISTS(
SELECT 1
FROM t1
WHERE seat_number=x)), g AS(
SELECT x,x-row_number() OVER(
ORDER BY x) grp
FROM missing)
SELECT min(x),max(x)
FROM g
GROUP BY grp
ORDER BY min(x);
WITH RECURSIVE n(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT max(seat_number)
FROM t1))
SELECT count(*)
FROM n
WHERE x NOT IN(
SELECT seat_number
FROM t1);
SELECT CASE seat_number%2 WHEN 0 THEN 'Even Numbers' ELSE 'Odd Numbers' END,count(*)
FROM t1
GROUP BY seat_number%2;
```

**Result and verification:** Correzione fonte: 7 posti occupati pari, non 8; 9 dispari, totale 16. Coerente con I-18. Risultato 1: 4 righe. [[1,6],[8,12],[16,26],[36,51]] Risultato 2: 1 riga. [[38]] Risultato 3: 2 righe. [["Even Numbers",7],["Odd Numbers",9]]

**Method and assumptions:** La query elenca gli intervalli liberi, conta tutti i posti mancanti da 1 al posto massimo e divide gli occupati in pari e dispari.

**Edge cases and trade-offs:** Con il posto 1 occupato il primo intervallo libero va da 2 a 6. Mancano 37 posti e gli occupati dispari sono 10.

```sql
INSERT INTO t1 VALUES (1);
```

### II-11 · Count groups with sequence logic
II-11
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2743)

[Setup SQLite](setup/II-11.sql) · [Query](sql/II-11.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(step_number, status)` (12 righe).

```sql
WITH a AS(
SELECT *,lag(status) OVER(
ORDER BY step_number) prev
FROM t1),b AS(
SELECT *,sum(prev IS NOT status) OVER(
ORDER BY step_number) grp
FROM a)
SELECT min(step_number),max(step_number),status,count(*)
FROM b
GROUP BY grp,status;
```

**Result and verification:** Risultato 1: 3 righe. [[1,4,"Passed",4],[5,9,"Failed",5],[10,12,"Passed",3]]

**Method and assumptions:** Si leggono i passaggi per StepNumber. Un cambio di stato avvia un gruppo, mentre un salto nel numero del passaggio lascia intatto il gruppo corrente.

**Edge cases and trade-offs:** Un Failed aggiunto dopo Passed forma un quarto gruppo di un solo passaggio.

```sql
INSERT INTO t1 VALUES (13,'Failed');
```

### II-12 · Reach a target by doubling or incrementing
II-12
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2774)

[Setup SQLite](setup/II-12.sql) · [Query](sql/II-12.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(stop)` (1 riga).

```sql
WITH RECURSIVE r(x) AS(VALUES(1)
UNION ALL
SELECT CASE WHEN 2*x<100 THEN 2*x ELSE x+1 END
FROM r
WHERE CASE WHEN 2*x<100 THEN 2*x ELSE x+1 END<=(
SELECT stop
FROM t1))
SELECT x
FROM r;
```

**Result and verification:** Risultato 1: 53 righe. [[1],[2],[4],[8],[16],[32]] … (output completo nel report)

**Method and assumptions:** Ogni riga contiene il numero raggiunto. Si raddoppia finché il risultato è inferiore a 100, poi si aggiunge 1. Poiché la traccia lascia aperta la fine, il setup fissa il limite a 110.

**Edge cases and trade-offs:** Con limite 1 si ottiene solo il valore iniziale.

```sql
UPDATE t1 SET stop=1;
```

### II-13 · Generate binomial coefficients
II-13
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2781)

[Setup SQLite](setup/II-13.sql) · [Query](sql/II-13.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(row, col)` (1 riga).

```sql
WITH RECURSIVE c(k,v) AS(VALUES(0,1)
UNION ALL
SELECT k+1,v*((
SELECT row
FROM t1)-k)/(k+1)
FROM c
WHERE k<(
SELECT col
FROM t1))
SELECT v
FROM c
WHERE k=(
SELECT col
FROM t1);
```

**Result and verification:** Risultato 1: 1 riga. [[10]]

**Method and assumptions:** La query calcola un coefficiente binomiale per la riga e la colonna indicate, con indici da zero. La formula moltiplicativa intera restituisce 10 per C(5,2). Gli intermedi devono entrare in un intero a 64 bit con segno.

**Edge cases and trade-offs:** Alla colonna iniziale C(5,0) vale 1.

```sql
UPDATE t1 SET col=0;
```

### II-14 · Model circular elimination
II-14
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2788)

[Setup SQLite](setup/II-14.sql) · [Query](sql/II-14.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(n, k)` (1 riga).

```sql
WITH RECURSIVE j(n,s) AS(VALUES(1,0)
UNION ALL
SELECT n+1,(s+(
SELECT k
FROM t1))%(n+1)
FROM j
WHERE n<(
SELECT n
FROM t1))
SELECT s+1
FROM j
WHERE n=(
SELECT n
FROM t1);
```

**Result and verification:** Risultato 1: 1 riga. [[4]]

**Method and assumptions:** Per n=7 si parte dalla persona 1, la si include nel conteggio e si elimina ogni terza persona. La ricorrenza di Josephus usa indici da zero, che si convertono alla numerazione da 1 nel risultato.

**Edge cases and trade-offs:** Con una sola persona il superstite è 1.

```sql
UPDATE t1 SET n=1;
```

### II-15 · Simulate a higher-or-lower game
II-15
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2795)

[Setup SQLite](setup/II-15.sql) · [Query](sql/II-15.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(seed)` (1 riga).

```sql
WITH RECURSIVE numbers(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM numbers
WHERE x<52),deck AS MATERIALIZED(
SELECT x card,2+(x-1)%13 rank,row_number() OVER(
ORDER BY rnd(x+(
SELECT seed
FROM t1)),x) pos
FROM numbers),turns AS(
SELECT a.pos,a.card,a.rank,b.card next_card,b.rank next_rank,(
SELECT count(*)
FROM deck c
WHERE c.pos>a.pos AND c.rank>a.rank) hi,(
SELECT count(*)
FROM deck c
WHERE c.pos>a.pos AND c.rank<a.rank) lo
FROM deck a
JOIN deck b ON b.pos=a.pos+1)
SELECT pos,card,rank,next_card,next_rank,hi,lo,CASE WHEN hi>lo THEN 'Higher' WHEN lo>hi THEN 'Lower' WHEN rnd(pos+(
SELECT seed
FROM t1)+1000)%2=0 THEN 'Higher' ELSE 'Lower' END guess
FROM turns
ORDER BY pos;
```

**Result and verification:** Risultato 1: 51 righe. [[1,23,11,37,12,12,36,"Lower"],[2,37,12,34,9,8,39,"Lower"],[3,34,9,13,14,18,28,"Lower"],[4,13,14,50,12,0,45,"Lower"],[5,50,12,39,14,7,38,"Lower"],[6,39,14,5,6,0,44,"Lower"]] … (output completo nel report)

**Method and assumptions:** Il mazzo ha 52 carte, quattro semi e ranghi da 2 a 14. Per ciascuna delle 51 previsioni si contano le carte di rango maggiore e minore rimaste. Un’estrazione riproducibile decide quando i conteggi sono pari. Una carta dello stesso rango fa perdere la previsione.

**Edge cases and trade-offs:** Con seme 42 si controllano le 52 carte uniche. I conteggi residui e tutte le 51 previsioni coincidono con l’implementazione indipendente in JavaScript.

```sql
UPDATE t1 SET seed=42;
```

### II-16 · Compare strategies in a door-choice simulation
II-16
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2805)

[Setup SQLite](setup/II-16.sql) · [Query](sql/II-16.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(trials, seed)` (1 riga).

```sql
WITH RECURSIVE n(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT trials
FROM t1)),doors(d) AS(VALUES(1),(2),(3)),draws AS MATERIALIZED(
SELECT x,1+rnd(x*2+(
SELECT seed
FROM t1))%3 prize,1+rnd(x*2+1+(
SELECT seed
FROM t1))%3 choice
FROM n),host AS(
SELECT *,(
SELECT min(d)
FROM doors
WHERE d<>prize AND d<>choice) opened
FROM draws)
SELECT count(*),sum(prize=choice),sum(prize=6-choice-opened),sum(opened=prize OR opened=choice)
FROM host;
```

**Result and verification:** Risultato 1: 1 riga. [[10000,3427,6573,0]]

**Method and assumptions:** Un riepilogo conta 10000 prove, le vittorie di entrambe le strategie e le aperture non valide. Il presentatore conosce il premio e apre una porta con una capra. Cambiare porta ha probabilità teorica di circa 2/3: la simulazione permette di confrontare il risultato osservato con quel valore.

**Edge cases and trade-offs:** Con una sola prova, una strategia vince e l’altra perde. Il presentatore apre una porta valida.

```sql
UPDATE t1 SET trials=1;
```

### II-17 · Simulate rolling dice
II-17
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2812)

[Setup SQLite](setup/II-17.sql) · [Query](sql/II-17.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(trials, target, seed)` (1 riga).

```sql
WITH RECURSIVE n(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT trials
FROM t1)),r(trial,step,score,penalty) AS(
SELECT x,0,0,0
FROM n
UNION ALL
SELECT trial,step+1,CASE WHEN penalty=1 THEN max(0,score-(1+rnd((
SELECT seed
FROM t1)+trial*100000+step)%6)) WHEN 1+rnd((
SELECT seed
FROM t1)+trial*100000+step)%6=6 THEN score ELSE score+1+rnd((
SELECT seed
FROM t1)+trial*100000+step)%6 END,1+rnd((
SELECT seed
FROM t1)+trial*100000+step)%6=6
FROM r
WHERE score<(
SELECT target
FROM t1) AND step<10000)
SELECT count(*),avg(1.0*step),min(step),max(step)
FROM r
WHERE score>=(
SELECT target
FROM t1);
```

**Result and verification:** Risultato 1: 1 riga. [[10000,66.0864,28,165]]

**Method and assumptions:** Il riepilogo conta le partite concluse e riporta media, minimo e massimo dei lanci fisici. Un 6 fa partire i rilanci di penalità, ciascuno dei quali sottrae il numero uscito. Un altro 6 prolunga la penalità. Il punteggio non scende sotto zero e tutte le partite devono terminare prima del limite di 10000 lanci. Questa è l’interpretazione adottata per la regola ambigua.

**Edge cases and trade-offs:** Con obiettivo 1 e 100 partite, media, minimo e massimo coincidono con il simulatore JavaScript sulle stesse estrazioni. Tutte le partite terminano.

```sql
UPDATE t1 SET target=1,trials=100;
```

### II-18 · Estimate the chance of a shared birthday
II-18
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2823)

[Setup SQLite](setup/II-18.sql) · [Query](sql/II-18.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(trials, people, seed)` (1 riga).

```sql
WITH RECURSIVE n(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT trials
FROM t1)),p(k) AS(
SELECT 1
UNION ALL
SELECT k+1
FROM p
WHERE k<(
SELECT people
FROM t1)),g AS(
SELECT x,count(DISTINCT rnd((
SELECT seed
FROM t1)+x*1000+k)%365) distinct_days
FROM n
CROSS
JOIN p
GROUP BY x)
SELECT count(*),sum(distinct_days<(
SELECT people
FROM t1)),avg(distinct_days<(
SELECT people
FROM t1))
FROM g;
```

**Result and verification:** Risultato 1: 1 riga. [[10000,5081,0.5081]]

**Method and assumptions:** La riga riepiloga 10000 gruppi di 23 persone, indicando quanti hanno un compleanno condiviso e con quale frequenza. Le date sono indipendenti e uniformi su 365 giorni, senza anni bisestili o stagionalità. La probabilità teorica è circa 0.5073.

**Edge cases and trade-offs:** Con una persona per gruppo, nessuna delle 100 prove ha un compleanno condiviso.

```sql
UPDATE t1 SET people=1,trials=100;
```

### II-19 · Simulate a path of random steps
II-19
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2830)

[Setup SQLite](setup/II-19.sql) · [Query](sql/II-19.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(trials, people, seed)` (1 riga).

```sql
WITH RECURSIVE n(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT trials
FROM t1)),positions(p) AS(
SELECT 0
UNION ALL
SELECT p+1
FROM positions
WHERE p+1<(
SELECT people
FROM t1)),r(trial,step,pos,mask) AS(
SELECT x,0,0,1
FROM n
UNION ALL
SELECT trial,step+1,(pos+CASE rnd((
SELECT seed
FROM t1)+trial*100000+step)%2 WHEN 0 THEN 1 ELSE -1 END+(
SELECT people
FROM t1))%(
SELECT people
FROM t1),mask|(1<<((pos+CASE rnd((
SELECT seed
FROM t1)+trial*100000+step)%2 WHEN 0 THEN 1 ELSE -1 END+(
SELECT people
FROM t1))%(
SELECT people
FROM t1)))
FROM r
WHERE bitcount(mask)<(
SELECT people-1
FROM t1) AND step<10000)
SELECT p,count(*)
FROM r
JOIN positions ON (mask&(1<<p))=0
WHERE bitcount(mask)=(
SELECT people-1
FROM t1)
GROUP BY p;
```

**Result and verification:** Risultato 1: 7 righe. [[1,1478],[2,1410],[3,1362],[4,1454],[5,1454],[6,1377]] … (output completo nel report)

**Method and assumptions:** La query conta le vittorie di ciascun possibile vincitore in 10000 passeggiate circolari. La posizione 0 del presentatore parte come visitata. Ogni prova si ferma quando resta una sola posizione non visitata. Il test verifica il limite dei passi e i sette partecipanti eleggibili hanno frequenze di vittoria simili.

**Edge cases and trade-offs:** Con due persone, l’unico partecipante diverso dal presentatore vince tutte le 100 prove.

```sql
UPDATE t1 SET people=2,trials=100;
```

### II-20 · Simulate state transitions
II-20
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2843)

[Setup SQLite](setup/II-20.sql) · [Query](sql/II-20.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(days, seed)` (1 riga).

```sql
WITH RECURSIVE r(day,rain) AS(VALUES(1,0)
UNION ALL
SELECT day+1,CASE WHEN rnd((
SELECT seed
FROM t1)+day)%100<CASE rain WHEN 1 THEN 70 ELSE 50 END THEN 1 ELSE 0 END
FROM r
WHERE day<(
SELECT days
FROM t1))
SELECT count(*),sum(rain),avg(rain)
FROM r;
```

**Result and verification:** Risultato 1: 1 riga. [[100000,62680,0.6268]]

**Method and assumptions:** La riga mostra il numero di giorni simulati, quanti sono piovosi e la loro quota. La catena da 100000 giorni parte dal sole. La probabilità di pioggia al passo successivo è 0.5 dopo il sole e 0.7 dopo la pioggia. A regime la quota teorica è 5/8, cioè 0.625.

**Edge cases and trade-offs:** Se la simulazione include solo il primo giorno, fissato al sole, i giorni piovosi sono zero.

```sql
UPDATE t1 SET days=1;
```

### II-21 · Analyze a prisoner search strategy
II-21
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2856)

[Setup SQLite](setup/II-21.sql) · [Query](sql/II-21.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(trials, prisoners, seed)` (1 riga).

```sql
WITH RECURSIVE trials(t) AS(
SELECT 1
UNION ALL
SELECT t+1
FROM trials
WHERE t<(
SELECT trials
FROM t1)),nums(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM nums
WHERE x<(
SELECT prisoners
FROM t1)),ranked AS MATERIALIZED(
SELECT t,x,row_number() OVER(PARTITION BY t
ORDER BY rnd((
SELECT seed
FROM t1)+t*1000+x),x) pos
FROM trials
CROSS
JOIN nums),perms AS MATERIALIZED(
SELECT t,json_group_array(x
ORDER BY pos) p
FROM ranked
GROUP BY t),r(t,p,cur,start,seen,len,longest,steps) AS(
SELECT t,p,1,1,',',0,0,0
FROM perms
UNION ALL
SELECT t,p,CASE WHEN json_extract(p,'$['||(cur-1)||']')=start THEN (
SELECT min(x)
FROM nums
WHERE x<>cur AND instr(seen,','||x||',')=0) ELSE json_extract(p,'$['||(cur-1)||']') END,CASE WHEN json_extract(p,'$['||(cur-1)||']')=start THEN (
SELECT min(x)
FROM nums
WHERE x<>cur AND instr(seen,','||x||',')=0) ELSE start END,seen||cur||',',CASE WHEN json_extract(p,'$['||(cur-1)||']')=start THEN 0 ELSE len+1 END,CASE WHEN json_extract(p,'$['||(cur-1)||']')=start THEN max(longest,len+1) ELSE longest END,steps+1
FROM r
WHERE cur IS NOT NULL AND steps<(
SELECT prisoners
FROM t1))
SELECT count(*),sum(longest<=(
SELECT prisoners/2
FROM t1)),avg(longest<=(
SELECT prisoners/2
FROM t1)),max(steps)
FROM r
WHERE steps=(
SELECT prisoners
FROM t1);
```

**Result and verification:** Risultato 1: 1 riga. [[10000,3116,0.3116,100]]

**Method and assumptions:** Il riepilogo di 10000 permutazioni di 100 scatole conta prove, vittorie della strategia dei cicli, frequenza e numero massimo di passi della decomposizione. Ciascun prigioniero segue il ciclo della propria etichetta. Il gruppo vince se tutti i cicli hanno lunghezza al massimo 50. La probabilità teorica è circa 0.3118: le probabilità dei singoli non si possono moltiplicare come 0.5^100.

**Edge cases and trade-offs:** Con quattro prigionieri e 100 prove si confronta il risultato esatto con la decomposizione JavaScript dei cicli, usando un limite di due scatole.

```sql
UPDATE t1 SET trials=100,prisoners=4;
```

### II-22 · Find groups without shared elements
II-22
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2863)

[Setup SQLite](setup/II-22.sql) · [Query](sql/II-22.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(order_id, line_item, cost)` (16 righe).

```sql
WITH RECURSIVE options AS(
SELECT order_id,line_item a,line_item b,'('||line_item||')' label,1<<line_item mask
FROM t1
WHERE cost>=10
UNION ALL
SELECT a.order_id,a.line_item,b.line_item,'('||a.line_item||','||b.line_item||')',(1<<a.line_item)|(1<<b.line_item)
FROM t1 a
JOIN t1 b ON a.order_id=b.order_id AND a.line_item<b.line_item
WHERE a.cost+b.cost>=10),o AS(
SELECT *,row_number() OVER(PARTITION BY order_id
ORDER BY a,b) rn
FROM options),r(order_id,last,mask,k,labels) AS(
SELECT DISTINCT order_id,0,0,0,''
FROM t1
UNION ALL
SELECT r.order_id,o.rn,r.mask|o.mask,k+1,labels||CASE WHEN k=0 THEN '' ELSE ',' END||label
FROM r
JOIN o ON r.order_id=o.order_id AND o.rn>last AND (r.mask&o.mask)=0),ranked AS(
SELECT *,max(k) OVER(PARTITION BY order_id) best
FROM r)
SELECT order_id,k,nullif(labels,'')
FROM ranked
WHERE k=best;
```

**Result and verification:** La tabella attesa omette due soluzioni ottime valide per ordine 1: (1,5),(2,6),(3,4) e (1,6),(2,5),(3,4). Ogni gruppo ha al massimo due elementi, costo >=10, senza sovrapposizioni e sempre tre gruppi. Sono incluse nel confronto corretto. Il commento su ordine 5 dice due gruppi, ma ciascuna soluzione ne ha uno. Risultato 1: 10 righe. [[1,3,"(1,5),(2),(3,4)"],[1,3,"(1,5),(2,6),(3,4)"],[1,3,"(1,6),(2),(3,4)"],[1,3,"(1,6),(2,5),(3,4)"],[2,3,"(1),(2),(3)"],[3,0,null]] … (output completo nel report)

**Method and assumptions:** Per ogni ordine si cercano le partizioni con il maggior numero di gruppi. Ogni gruppo ha uno o due elementi e costo almeno 10. Le maschere assicurano che i gruppi siano disgiunti e si possono lasciare elementi inutilizzati. La ricerca è esponenziale e usa ID interi da 1 a 62. Per l’ordine 5 la tabella attesa ha un gruppo per soluzione, anche se il commento della fonte ne indica due.

**Edge cases and trade-offs:** Un ordine con un solo elemento di costo 9 ammette zero gruppi e ha combinazione NULL.

```sql
INSERT INTO t1 VALUES (6,1,9);
```

### II-23 · Construct a knight's route
II-23
[Open exercise](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md?plain=1#L2910)

[Setup SQLite](setup/II-23.sql) · [Query](sql/II-23.sql) · [Controlli](checks-II.cjs)

**Status:** Verified · **SQL engine/version:** SQLite 3.53.0 (Node.js v24.16.0)

**Input:** `t1(x, y)` (1 riga).

```sql
WITH offsets(dx,dy) AS(VALUES(1,2),(1,-2),(-1,2),(-1,-2),(2,1),(2,-1),(-2,1),(-2,-1))
SELECT (x+dx)||char(64+y+dy)
FROM t1
CROSS
JOIN offsets
WHERE x+dx BETWEEN 1 AND 8 AND y+dy BETWEEN 1 AND 8;
```

**Result and verification:** Risultato 1: 8 righe. [["5F"],["5B"],["3F"],["3B"],["6E"],["6C"]] … (output completo nel report)

**Method and assumptions:** La query prova gli otto spostamenti a L da 4D. Restituisce una riga per mossa che rimane tra 1 e 8 su entrambi gli assi. La traccia richiede le prossime mosse e termina dopo un solo salto.

**Edge cases and trade-offs:** Dall’angolo 1A rimangono solo 2C e 3B.

```sql
UPDATE t1 SET x=1,y=1;
```
