= Slide 1

Buongiorno a tutti. 
Sono Davide Lorenzon e oggi vi presento la mia tesi, 
'Valutazione di pgvector come database unificato per architetture RAG',
 realizzata durante il tirocinio curricolare presso Pat SRL.




= Slide 2

Il progetto nasce da un'esigenza dell'azienda: oggi il sistema di ricerca si basa su due tecnologie separate, e questo comporta la gestione di 2 database e il loro allineamento.

Questo approccio multi database, o persistenza poliglotta, non è raro e funziona seppur con la necessità di una maggiore complessità di coordinamento, a renderlo meno adatto è  una particolare esigenza dell'azienda che richiede l'uso di join relaizzati lato backend, 

questo progetto ha una finalità esplorativa.

vuole rivalutare le tecnologie scelte



= slide tre

a questo scopo si valuta pgvector

un'estensione postgres che implementa funzionalità di ricerca semantica direttamente senza motori di ricerca o  database esterni 

da poco arrivato a un grado di avanzamento sufficiente a quanto necessario all'impresa

vanno valutate la fattibilità del suo utilizzo e le sue performance
(sia velocità che qualità)

Questo permetterebbe di gestire la ricerca su un unico database invece di dover utilizzare un secondo db

= slide 4 

altri vincoli tecnologici sono python (già usato dall'azienda),fastAPI(supporto all'asincronia e già usato dall'azienda), grafana(già usato dall'azienda) e la ricerca full-text di postgres (vincoli di licensing e valutazione di una sola nuova tecnologia e definizione esatta dei limiti della full-text nativa)

= Slide 5

Arriviamo al caso d'uso che rende necessari i join lato backend

la ricerca linked, 

consiste nell'eseguire una ricerca su ogni singola entità, recuperare i risultati migliori e poi arricchirli con il loro contesto relazionale

ad esempio ad un attachment possono essere aggiunte le informazioni del conversation item e del ticket di riferimento o direttamente del ticket in base a quali percorsi sono possibili.

con Elasticsearch e nel contesto aziendale i join le opzioni di filtraggio postjoin sono eseguite lato backend


con un db relazionale si può spostare interamente questa operazione lato database dove è semplici  e veloce.

= slide 6

le modalità di ricerca sono 3

sono ricerche per similarità, ovvero 
ordinano i risutlati in base a un criteri di somiglianza e ritornano i più simili

la semantica usa come criterio la una  distanza vettoriale tra vettori di embedding che rappresentano il significato del testo

full-text usa come criterio la corrsipondenza dei lessemi(la radice di una parola) e la posizione

 e ibrida combina i risultati di semantica e full-text per mitigarne le carenze (la semantica fatica con le keyword, la full-text fatica col contesto)

quella realmente utilizzata dall'azienda è la ibrida, perciò nel progetto vengono esplorate anche questa e la full-text

= Slide 7 

i benefici attesi che vanno verificati sono

è la semplificazione dello  stack tecnologico

la conferma del linking lato database

la facilità di integrare funzioni di ricerca su db esistenti

I vincoli invece sono 
ovviamente l'uso di pgvector e la full-text nativa per le ragioni già trattate

la gestione del testo diviso in chunk
molteplicità di campi cercabili e il loro utilizzo per ricerche basate su sottoinsiemi

per fare un esempio :
ipotizziamo che un ticket abbia un testo descrittivo del problema,  uno descrittivo della soluzione.

è nell'interesse dell'azienda poter indicare quali campi vanno coinvolti nella ricerca


= slide 8
Per realizzare il caso d'uso appena descritto e adottando le raccomandazioni di pgvector 

ho realizzato una tabella di supporto ai chunk, per gestirne la molteplicità,

partizionato la tabella dei chunk sul field_name, in modo da gestire la ricerca su sottoinsiemi,

usato un indice HNSW su espressione, viene indicizzato il vettore binario ricavato tramite quantizzazione binaria

denormalizzazione dei campi filterable necessaria a uniformare il problema del filtering a quanto previsto da pgvector

vengono anche indicizzati separatamente per mimare il prefiltering di elastic

Oversampling, dovuto sia all'indice approssimato  sia al filtering e rescoring per la combinazione dei risultati


= Slide 9
Uso degli indici GIN

i punteggi della funzione di scoring sono indipendenti dal corpus documentale, quindi direttamente comparabili

Non è molto  avanzata  perciò sono necessari dei workaround per avere funzionalità simili a Elasticsearch


= Slide 10 
funzione di scoring primitiva, accettato

granularità dello scorin, vengono sommati i punteggi di diverse funzioni di ranking per boostare un risultato che le soddisfa tutte
esempio somma di una phrase query, all word query e any word query

il filtraggio che precede lo scoring è anch'esso poco granulare, non è possibile impostare delle soglie diverse da tutte o almeno una, perciò il problema viene trattato come overlap degli array dei lessemi.


Ma il limite più importante è sulle performance, elastic implementa un meccanismo di tipo block max wand per lo scoring, che permette di non dover mai neanche valutare interi blocchi che non possono contribuire al punteggio finale.

questo limite è accettato solo per vedere quanto realmente penalizzante

= Slide 11

Il sistema di test è stato realizzato con Locust per replicare diversi utenti che effettuano delle ricerche,

Grafana osserva i vari risultati

Vi sono sia metriche di latenza sia metriche di hitrate

Il calcolo avviene su un Db postgres, gestisce facilmente storicizzazione dei log, integrazione con grafana e calcolo continuo delle metriche tramite una view

la ground truth viene passata insieme alle query di test, per i test svolti e stata generata a partire dai dati inseriti ne sistema

= Slide 12

il volume di test dei dati di test è questo, non è un volume dati grande quanto quello di un'azienda vedremo dopo perché i test non sono continuati su volumi più grandi

ma è abbastanza grande da fornire dei risultati validi,ù

la ricerca smenatica di pgvector è stata confermata, è possibile fare la fusione rrf lato  db, la ricerca linked è implementabile lato  DB


= Slide 13

i test non sono continuati perchè questo volume dati ha già fatto emergere delle criticità sul lato full-text che ha dei tempi di ricerca significativamente più altri

perciò per usare unicamente postgres come motore di ricerca è necessario valutare meglio l'applicabilità di estensioni dedicate oppure ripensare come la full- text partecipa alla ricerca



= slide 14 

in conclusione pgvector è valido