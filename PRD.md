# SQL Practice Workbook · PRD

Il progetto raccoglie 101 esercizi per studiare SQL e rendere riproducibili le soluzioni. Un lettore deve poter identificare la traccia, ricreare i dati, eseguire la query e controllarne metodo e risultati.

## Versione compilata

- 78 esercizi nella Parte I e 23 nella Parte II, mantenendo ID e riferimenti della versione iniziale.
- Una soluzione SQLite, metodologia e ipotesi esplicite per ogni scheda.
- Fixture locali e query eseguibili, senza dipendenze di rete.
- Stato Verified solo dopo esecuzione del campione e di un caso aggiuntivo o controllo negativo.
- Report con risultati integrali, versione database e timestamp, riproducibile con `node verify.cjs`.
- Correzioni motivate quando l'output della fonte contraddice dati o regole.

## Criteri di accettazione

1. Ogni esercizio identifica ID, traccia, SQLite 3.53.0 e dati necessari.
2. I file setup ricreano i dati in un database isolato; i file SQL coincidono con le query nel quaderno.
3. Tutte le righe sono confrontate con i risultati attesi, incluse le molteplicità. DDL e problemi aperti hanno controlli espliciti.
4. Ogni scheda spiega significato della riga, ordine dei dati, ipotesi e almeno un caso aggiuntivo eseguito.
5. Le simulazioni hanno parametri e semi riproducibili, confronto con probabilità teoriche quando pertinente e verifica mediante algoritmo indipendente.
6. Stato corrente misurato: 101/101 PASS nell'ambiente indicato; adattamenti I-30/I-51 e differenze dalla fonte dichiarati.

## Limiti e provenienza

Soluzioni redatte dall'assistente, senza consultare le soluzioni ufficiali. Verified non equivale a una prova su ogni input né a una certificazione SQL Server. I riferimenti alle tracce restano fissati alla revisione originaria. Il quaderno e i file del progetto contengono quanto serve per ripetere le verifiche.

## Sviluppi futuri

Portare le query su SQL Server con verifiche native delle funzioni specifiche; ampliare i casi limite; selezionare esercizi rappresentativi dopo revisione e comprensione personale.
