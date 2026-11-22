# SQL Practice Workbook

101 esercizi SQL compilati: 78 nella Parte I e 23 nella Parte II. Ogni scheda contiene query, metodologia, ipotesi, risultato misurato e un caso aggiuntivo eseguito.

[Apri il quaderno](WORKBOOK.md) · [Requisiti](PRD.md) · [Verifiche e correzioni](VERIFICATION.md)

## Riprodurre le verifiche

Ambiente effettivamente utilizzato: **Node.js v24.16.0**, modulo integrato `node:sqlite`, **SQLite 3.53.0**. Non occorrono npm, dipendenze esterne, rete o un server database. Le soluzioni sono adattamenti SQLite; non sono state eseguite su SQL Server.

```powershell
node verify.cjs
node verify.cjs I-13
```

Il runner apre un database in memoria nuovo per ciascun esercizio e per ciascuna mutazione dei dati. Esegue i file `setup/<ID>.sql` e `sql/<ID>.sql`, confronta tutti i risultati e termina con codice diverso da zero se un controllo fallisce. Il primo comando ripete i 101 esercizi; il secondo ne seleziona uno. Sono stati osservati **101/101 PASS** su campione base e controllo aggiuntivo.

I risultati completi, inclusi quelli dei casi aggiuntivi, sono in [verification/results.json](verification/results.json), con versione del motore e timestamp dell'esecuzione. Una verifica singola salva un report separato. I 7.200 abbinamenti dei veicoli sono presenti integralmente nel report; il quaderno ne mostra un campione.

Le query possono essere eseguite in un editor SQLite caricando prima il rispettivo setup. I-30 richiede `forbid_star()`, I-51 richiede `sha256()` e `crc32()`, le simulazioni richiedono `rnd()` e la passeggiata anche `bitcount()`: queste funzioni sono registrate dal runner. `rnd()` usa un mixer deterministico a 32 bit, senza finalità crittografiche. I semi e gli altri parametri sono nei setup degli esercizi.

## Organizzazione e significato di Verified

- [WORKBOOK.md](WORKBOOK.md): schede con gli stessi ID e collegamenti della versione iniziale.
- [setup/](setup/): dati di esempio ricreati in SQLite, date normalizzate ISO 8601; `t1`, `t2`, `t3` seguono l'ordine delle tabelle nella traccia.
- [sql/](sql/): query effettivamente eseguite, identiche a quelle mostrate nel quaderno.
- [fixtures.json](fixtures.json): fixture e risultati attesi ricavati dalle tracce; le eccezioni documentate sono esplicite nel runner.
- [verify.cjs](verify.cjs), [checks.cjs](checks.cjs), [checks-II.cjs](checks-II.cjs): confronti completi, casi limite e oracoli indipendenti.

`Verified` riguarda i dati e i casi documentati, con le ipotesi dichiarate. Le simulazioni sono esperimenti riproducibili, non dimostrazioni matematiche. I-30 e I-51 sono adattamenti di esercizi con particolarità SQL Server; in particolare CRC32 non riproduce l'algoritmo proprietario `CHECKSUM`.

Le soluzioni sono state redatte dall'assistente su richiesta dell'utente, senza consultare le soluzioni SQL ufficiali. Non rappresentano esercizi svolti autonomamente dall'autore del portfolio. Prima di presentarli in un colloquio, riprodurre e comprendere ogni query.

## Fonte e attribuzione

Tracce e dati di esempio: **Scott Peters, Advanced SQL Puzzles**, [revisione 4fe0cac6e23f6af967bca0a46e364f9b8534eec3](https://github.com/smpetersgithub/AdvancedSQLPuzzles/blob/4fe0cac6e23f6af967bca0a46e364f9b8534eec3/Advanced%20SQL%20Puzzles/Advanced%20SQL%20Puzzles%20Markdown.md). I link alle singole tracce e ai setup SQL Server sono conservati nelle schede. La titolarità dei materiali originali resta ai rispettivi autori.

## GitHub About description

SQL practice workbook with 101 SQLite solutions, reproducible checks, edge cases, and methodology.
