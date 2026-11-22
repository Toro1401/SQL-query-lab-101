# Verifica delle 101 soluzioni

Esecuzione di riferimento: 21 novembre 2026, Node.js v24.16.0 e SQLite 3.53.0. **101/101 esercizi PASS**, ciascuno con controllo base e almeno un controllo aggiuntivo. I risultati e il timestamp effettivo si trovano in [verification/results.json](verification/results.json).

```powershell
node verify.cjs
```

Il runner legge direttamente i file SQL e ne controlla la corrispondenza con il quaderno. Nessuna query viene dichiarata Verified sulla sola base della lettura. Ogni caso gira in memoria su dati separati; le cancellazioni e i trigger non toccano database dell'utente.

## Criteri

Quando la traccia contiene un output tabellare, il confronto tratta le righe come un multinsieme: stesso numero di righe, stessi valori e stessi duplicati. L'ordine è confrontato esplicitamente in I-40, dove costituisce il requisito; negli altri esercizi eventuali ordinamenti di presentazione non cambiano l'insieme atteso. Numeri reali normalizzati a sei decimali per il confronto; date trasformate in ISO 8601, celle vuote rappresentate da NULL, codici con zeri iniziali mantenuti come testo.

I-10 usa valori statistici calcolati indipendentemente dalla query, I-31 confronta anche le tre formulazioni e il bonus stipendi, I-46 confronta entrambe le formulazioni. DDL e trigger sono verificati sia su operazioni valide sia su operazioni che devono fallire. Le invarianti aggiuntive verificano risultati concreti delle mutazioni descritte nelle schede: ad esempio I-13 confronta l'intera sequenza di saldi con due movimenti nella stessa data.

Per i problemi senza output fissato si usano valori noti, conteggi combinatori e algoritmi JavaScript indipendenti. Questi ultimi condividono solo il generatore pseudocasuale per riprodurre le stesse estrazioni. Le simulazioni SQL e JS devono coincidere nei risultati misurati; sono controllati anche limiti di arresto e ampie tolleranze rispetto alla teoria. I semi fissati rendono il test stabile, senza fingere che un singolo esperimento dimostri una probabilità.

## Correzioni e interpretazioni della fonte

| Esercizio | Differenza documentata |
|---|---|
| I-26 | La somma 2016 è 159521 + 251696 + 111894 = **523111**. Il valore atteso 411217 omette la terza vendita. |
| II-10 | I 16 posti occupati comprendono **7 pari e 9 dispari**, non 8 e 9. I-18 riporta il conteggio corretto per gli stessi dati. |
| II-22 | L'ordine 1 ammette anche `(1,5),(2,6),(3,4)` e `(1,6),(2,5),(3,4)`: tre gruppi disgiunti, ognuno con costo almeno 10 e al massimo due righe. La tabella della fonte omette queste due soluzioni. Ordine 5: un gruppo per soluzione, non due come dice il commento. |
| I-12, I-68, I-70 | Medie troncate a intero per riprodurre la presentazione della fonte; non arrotondate. I-10 conserva la precisione della media 342/11. |
| I-21 | TX atteso è coerente con la media delle medie mensili per cliente >100 per tutti i clienti dello stato. Non è coerente con il requisito più forte “ogni mese >100”: alcuni mesi di 1001 sono esattamente a 100. Mesi senza ordini esclusi. |
| I-45 | Si restituisce la versione precedente il cui intervallo invade l'inizio di una successiva; non tutti i membri di ogni coppia sovrapposta. |
| I-48 | Anno di riferimento **2021** esplicito per riprodurre i dati della fonte, indipendente dalla data corrente. |
| I-53 | Ordinamento dei gruppi per il massimo lessicografico dei partner, per riprodurre i GroupID mostrati. |
| I-62 | Gli esempi impongono differenza auto-barca **almeno** 200000, non esattamente 200000. |
| II-04 | n=4 per confrontare le due permutazioni attese; n=10 è solo un esempio nel testo. |
| II-12 | La successione non ha un termine nella traccia: si sceglie limite 110, dichiarato nel setup. |
| II-13, II-14 | Parametri dichiarati: C(5,2) e Josephus n=7, passo=3. Non viene affermata una verifica esaustiva di ogni parametro. |
| II-17 | Un 6 attiva un rilancio di penalità. Quel lancio sottrae il proprio valore; un altro 6 mantiene la modalità penalità. Ogni lancio fisico è contato e il punteggio non scende sotto zero. |
| II-23 | La traccia chiede le mosse legali successive del cavallo, non un tour che visiti tutta la scacchiera. |

## Adattamenti di motore

**I-30:** vista SQLite con colonna sentinella `forbid_star()` che fallisce quando selezionata. La lettura delle due colonne esplicite riesce; `SELECT *` fallisce. È un equivalente dimostrativo del comportamento richiesto, non una migrazione letterale dello schema SQL Server o un controllo di sicurezza.

**I-51:** SHA-256 e CRC32 registrati dal runner su serializzazione JSON canonica della chiave naturale. SHA-256 corrisponde all'algoritmo, ma encoding e serializzazione dichiarati ne determinano i byte. CRC32 è un checksum dimostrativo e **non** l'algoritmo proprietario SQL Server `CHECKSUM`. Non sono state testate `HASHBYTES`/`CHECKSUM` su SQL Server. Collisioni restano possibili: mantenere un vincolo UNIQUE sulla chiave naturale; non usare CRC32 come garanzia di unicità.

Le fixture ricreano tabelle e dati delle tracce con nomi semplificati; non eseguono i file T-SQL originali. Le date sono ISO e le chiavi di ordinamento sono esplicite. I-13 usa rowid per distinguere i movimenti della fixture con pari data: su un sistema reale introdurre un MovementID persistente.

## Risultati delle simulazioni

| Esercizio | Osservazione misurata |
|---|---|
| II-16 Monty Hall | 10.000 prove: 3427 vittorie restando, **6573 cambiando**, zero aperture non valide. |
| II-17 Dadi | 10.000 partite a 100 punti: **66,0864 lanci medi**, minimo 28, massimo 165, nessuna partita troncata. |
| II-18 Compleanni | 10.000 gruppi di 23: **5081** con compleanni condivisi, frequenza **0,5081**. |
| II-19 Passeggiata | 10.000 prove concluse, zero vittorie host. Conteggi eleggibili 1..7: 1478, 1410, 1362, 1454, 1454, 1377, 1465. |
| II-20 Markov | 100.000 giorni: **62.680 piovosi**, frequenza **0,6268**; stazionaria teorica 0,625. |
| II-21 Prigionieri | 10.000 permutazioni: **3116 successi**, frequenza **0,3116**; teoria circa 0,3118. |

Questo report descrive verifiche funzionali sulle fixture documentate. Non comprende benchmark di prestazioni su grandi database, test su SQL Server o una prova formale di correttezza generale.
