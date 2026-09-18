= Slide 1

Buongiorno a tutti. 
Sono Davide Lorenzon e oggi vi presento la mia tesi, 
'Valutazione di pgvector come database unificato per architetture RAG',
 DESCRITTIVA DEL LAVORO SVOLTO durante il tirocinio curricolare presso Pat SRL.




= Slide 2

Il progetto nasce da un'esigenza dell'azienda: ad oggi il loro sistema di Information retrieval si basa su due tecnologie separate, Postgres ed ElasticSearch, e questo comporta la gestione di 2 database e il loro allineamento continuo.

Questo approccio multi database, o persistenza poliglotta, non è raro e funziona seppur con la necessità di una maggiore complessità di coordinamento, a renderlo meno adatto a questo specifico contesto è una particolare esigenza dell'azienda che aggiunge vincoli relazionali  al problema

questo progetto ha una finalità esplorativa.

vuole rivalutare le tecnologie scelte



= slide tre

a questo scopo si valuta pgvector

un'estensione postgres che implementa funzionalità di ricerca semantica direttamente, senza motori di ricerca o  database esterni 

sta venendo valutato perché da poco arrivato a un grado di avanzamento sufficiente a quanto necessario all'impresa

vanno valutate la fattibilità del suo utilizzo e le sue performance
(sia velocità sia qualità)

Questo permetterebbe di gestire la ricerca su un unico database invece di dover utilizzare anche un secondo db

= slide 4 

altri vincoli tecnologici sono python,fastAPI e grafana già usati dall'azienda e 

la ricerca full-text di postgres 
è necessaria alla completezza del sistema di information retrieval ma non è lo scopo principale del tirocinio.

Per questo motivo in questo progetto non vengono usate estensioni dedicate e si valutano anche i limiti effettivi delle funzioni native senza introdurre precocemente ulteriori dipendenze . 

= Slide 5

Arriviamo al caso d'uso che rende necessari i join

la ricerca linked, 

consiste nell'eseguire una ricerca su ogni singola entità, recuperare i risultati migliori e poi arricchirli con il loro contesto relazionale

ad esempio ad un attachment possono essere aggiunte le informazioni del conversation item e del ticket di riferimento o direttamente del ticket in base a quali percorsi sono possibili.

con Elasticsearch e nel contesto aziendale i join sono eseguiti lato backend


con un db relazionale si può spostare interamente questa operazione lato database dove è semplice e veloce, visto il supporto nativo ai join.

= slide 6

le modalità di ricerca per similarità sono 3


la semantica usa come criterio la una  distanza vettoriale tra vettori di embedding che rappresentano il significato del testo

full-text usa come criterio la corrispondenza dei lessemi(la radice delle parole) e la posizione, a esempio gatto gattino e gatta sono tutte riducibili a gatt

la ibrida combina i risultati di semantica e full-text per mitigarne le carenze (la semantica fatica con le keyword, la full-text fatica col contesto)

quella realmente utilizzata dall'azienda è la ibrida, perciò nel progetto vengono esplorate anche questa e la full-text

il tipo di fusione dei risultatati più comune è la rrf, e si vuole verificare che questa possa essere realizzata lato database
= Slide 7 

i benefici attesi che vanno verificati sono

è la semplificazione dello  stack tecnologico

la conferma del linking lato database

la facilità di integrare funzioni di ricerca su db esistenti

e il riottenimento di proprietà acid


Oltre ai vincoli tecnologici già citati, 

vi è la gestione del testo diviso in chunk.

Molteplicità di campi cercabili e il loro utilizzo per ricerche basate su sottoinsiemi

per fare un esempio :
un ticket ha un testo descrittivo del problema,  uno descrittivo della soluzione.

è nell'interesse dell'azienda poter indicare quali campi vanno coinvolti nella ricerca
solo problema, solo soluzione o entrambi

= slide 8
Per realizzare la ricerca semantica e integrare pg vector

ho realizzato una tabella di supporto ai chunk, per gestirne la molteplicità,

l'indice utilizzato è un indice Hierarchical Navigabale Small Word, abbrevviato con HNSW, su espressione, viene indicizzato il vettore binario ricavato dalla quantizzazione binaria del vettore di embedding originale.

per realizzare la ricerca su determinati campi conviene partizionare la tabella dei chunk sul campo field name.


denormalizzazione dei campi filterable necessaria a semplificare l'applicazione dei filtri e indicizzandoli nella tabella dei chunk si può simulare il prefiltering

Oversampling, è dovuto principalmente all'uso di un indice approssimato sia al filtering,

Il rescoring consiste nel ricalcolare la distanza usando i vettori di embeding reali, una volta recuperato un candidate set sfruttando l'indice.


= Slide 9
// La ricerca full-text non è il focus principale del progetto, ma va comunque affrontata perché serve alla ricerca ibrida


Vengono usati gli indici GIN


i punteggi della funzione di scoring sono indipendenti dal corpus documentale, quindi direttamente comparabili

Non è molto  avanzata  perciò sono necessari dei workaround per avere funzionalità simili a Elasticsearch


= Slide 10
Per poter eseguire anche delle valutazioni sulla qualità della ricerca è stato predisposto un sistema di test


è stato realizzato con Locust per replicare diversi utenti che effettuano delle ricerche,

Grafana osserva i vari risultati

Vi sono sia metriche di latenza sia metriche di hitrate, latency, MRR

Il calcolo avviene su un Db postgres, gestisce facilmente storicizzazione dei log, integrazione con grafana e calcolo continuo delle metriche tramite una view

la ground truth è la "risposta considerata corretta", viene passata insieme alle query di test


= Slide 11

La valutazione del sistema è stata fatta su un volume dati di 10 mila ticket, 50 mila conversation item e 60 mila attachment

Sono stati configurati un numero variabile di utenti tramite locust.

La dashboard grafana comunica direttamente con il database di test usato per il logging e il calcolo delle metriche

Sui dati di test si è ottenuto un answer rate del 100%, ovvero la ground truth appariva sempre nella lista dei risultatati.

Questo è dovuto al fatto che le ricerche di test usano testi pressochè uguali al testo della ground truth.

la definizione della ground truth non è banale, inoltre l'accuratezza dipende anche da fattori trasversali al sistema.

come il modello di embedding


la ricerca semantica ha raggiunto i risultati attesi, con una retrieval latency intorno ai 200 e 300 millisecondi.

è stato  misurata l'attesa lato client, ovvero il tempo tra l'invio di una chiamata api e la ricezione dei risultati.

= Slide 12
è stato confermato anche il linking lato database, compreso nei 200-300 millisecondi 

ciò permette di eseguire il tutto in un'unica query e di effettuare un unica chiamata al DB senza ruond trip inutili


= Slide 13
Dal progetto è anche emerso il limite della ricerca full-text 

le ricerche non ottimizzate per lingua hanno un tempo di esecuzione molto lungo dai 5-10 secondi, quelle ottimizzate per lingua rimangono comunque sui 3 secondi circa

che è un grande limite soprattutto se paragonato ai risultati di pgvector


Ciò è dovuto a un limite strutturale di postgres che non implementa molte delle comuni  funzionalità di un motore di ricerca avanzato.

seppur si siano trovati workaround per alcuni limiti, come il filtro su corrispondenze parziali, il limite principale riguarda l'assenza della block max wand, che è il principale collo di bottiglia


esistono alternative come paradeDB o pg text search  che sono estensioni dedicate alla ricerca full-text, ma che non sono state usate perché fuori dallo scope del progetto



= slide 14
In questo grafico è possibile vedere delle misurazioni sul sistema dopo un'ottimizzazione parziale 

i fattori principali che contribuiscono a questa oscillazione sono la selettività della query e la latenza di rete,

= Slide 15

Grazie dell'attenzione


Ci sono domande?