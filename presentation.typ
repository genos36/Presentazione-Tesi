#import "@preview/polylux:0.4.0": *
#import "unipd.typ": *

#show: unipd-theme.with(palette: (:..unipd-palette, font: "Noto Sans Old"))

#title-slide(
  authors: "Davide Lorenzon",
  title: "Valutazione di pgvector come database unificato per architetture RAG",
  date: "22 Settembre 2026",
)

#slide(title: "Il problema di partenza")[
  #v(1em)
  #grid(
    align: horizon+center,
    columns: (1fr, 3fr),
    rows: (2fr, 1fr, 1fr, 1fr,1.5fr,),
    inset: 1em,
    img("logo-azienda.svg"),[#image("images/example/poliglot.drawio.png", height: 100%)],
    [*Problema*], [*Information retrieval* in un contesto relazionale],
    [*Soluzione attuale*], [*Postgres* + *Elasticsearch* per la ricerca],
    grid.cell()[*Criticità*],
    [
    #sym.bullet *Overhead* di sincronizzazione e comunicazione
    
    #sym.bullet *Join* lato backend
    ],
  )
]

#slide(title: "Alternativa da valutare")[
  #v(1em)
  #grid(
    columns: (1.75fr, 1fr,1fr),
    rows: (1fr, 1fr, 1fr, 1fr),
    inset: 0.5em,
    align: center,
    grid.cell(rowspan:4, align: top)[
      #text("Pgvector", size: 1.8em, weight:"bold")
      #image("/images/example/unified.drawio.png", height: 50%)
      
    ],[*Perché adesso*], [Avanzamento di *pgvector*],

[*Da valutare*], [*Fattibilità* tecnica e *performance*],
grid.cell(colspan:2)[#text(size:1.2em)[Estensione diretta e senza altri DB esterni]],




  )
]


#slide(title: "Altri vincoli tecnologici")[
  #box(height:80%)[
  #grid(
    columns: (1fr,1fr),
    rows: (1fr, 1fr),
    inset: 0.5em,
    align: center,
    [Python #image(height:4em,"images/example/python.png")],
    [FastAPI#image(height:4em,"images/example/fastapi.svg")],
    [Grafana#image(height:4em, "images/example/Grafana_logo.svg.webp")],
    [full-text search nativa#image(height:4em,"images/example/postgres.png")],
  )

]



]

#slide(title: "Contesto")[
  
  #box(height: 80%)[#grid(
    align: horizon+center,
    columns: (1fr, 1fr),
    rows: (2fr, 1fr,1fr),
    inset: 0em,
    grid.cell(colspan:2)[#image("images/example/er.drawio.png", width: 80%)],
    grid.cell(rowspan: 2)[*Ricerca linked*], [Interroga *tutte le entità* e ricostruisce il contesto],
   [È il caso d'uso che rende *Elasticsearch* inadatto],
  )]
]


#slide(title: "Tre modalità di ricerca")[
#box(height: 80%)[  
  #grid(
    columns: (1fr, 1fr, 1fr),
    rows:(1fr,1fr,5fr),
    column-gutter: 1em,
    align: center + horizon,
    inset: 8pt,
    [*Semantica*], [*Full-text*], [*Ibrida*],
    [Similarità sui vettori di *embedding*],
    [Corrispondenza *lessicale*],
    [Fusione delle due tramite *RRF*],
    [#image("images/searches/sem.png")],
    [#image("images/searches/full.png")],
    [#image("images/searches/rrf.png")],
  )
]
]


#slide(title: "Benefici attesi e vincoli previsti")[
  #set list(spacing: 2em)
  #grid(
    inset:1em,
    align:left+top,
    columns:(1fr,1fr),
    rows:(1fr,4fr),
      grid.cell(align:center+horizon)[*Benefici attesi*],
      grid.cell(align:center+horizon)[*Vincoli*],
      [
      - Stack *semplificato*
      - *Linking* lato DB
      - Integrazione più semplice su DB esistenti
      - Proprietà *ACID*
      ],
      [
      - Solo *full-text nativo* (no dipendenze premature)
      - *Pgvector*
      - Testo ricercabile diviso in *chunk*
      - Più campi ricercabili per entità
      ]
  
  )
]


#slide(title: "Ricerca semantica")[
#box(height: 80%)[  #grid(
    columns: (1fr, 1fr),
    rows:(1fr,1fr,1fr,1fr,1fr),
    column-gutter: 1em,
    align: left + horizon,
    inset: 8pt,
    [*Tabella chunk* di supporto],
    grid.cell(align:center,rowspan:5)[
      #image("images/example/semantica.drawio.png")
    ],
    [Indice *HNSW* su bit vector],
    [*Partizionamento* su field_name],
    [*Denormalizzazione* dei campi filterable],
    [*Oversampling* e *rescoring*],
  )]
]
#slide(title: "Ricerca full-text")[
#box(height: 80%)[  #grid(
    columns: (1fr, 1fr),
    rows:(1fr,1fr,1fr,1fr),
    column-gutter: 1em,
    align: left + horizon,
    inset: 8pt,
    [Non il focus principale ma comunque necessaria alla valutazione],
    grid.cell(align:center,rowspan:4)[
      #image("images/example/semantica.drawio.png")
    ],
    [Indice *GIN*],
    [Punteggi sempre *comparabili*],
    [Esplorati workaround],
  )]
]




#slide(title: "Sistema di test")[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    row-gutter: 0.6em,
    align: center + horizon,
    inset: 8pt,
    [*Locust* \ simula utenti paralleli],
    [*Grafana* \ dashboard collegata a *Postgres*],
    [*Metriche* \ hit rate, MRR, latenza],
    [Basato sulla \ *Ground truth*],// TODO
    grid.cell(colspan:2,image("images/example/image.png", height: 30%))
  )
  
]
#slide(title: "Valutazione del sistema")[
  #box(height: 70%)[
    #grid(
    columns: (1fr,1.2fr,1fr,1.5fr,1.5fr) ,
    rows:(1fr,2fr,2.5fr),
    column-gutter: 1.5em,
    align: center + horizon,
    inset: 0em,
    grid.cell(colspan: 5, align: horizon)[#box(inset:0.4em, radius: 16pt,fill:luma(99%),stroke: color.black)[Query] #sym.arrow #box(inset:0.4em, radius: 16pt,fill:luma(99%),stroke: color.black)[API] #sym.arrow #box(inset:0.4em, radius: 16pt,fill:luma(99%),stroke: color.black)[Database + pgvector] #sym.arrow #box(inset:0.4em, radius: 16pt,fill:luma(99%),stroke: color.black)[Risultati]],
    [Dataset \ 10.000 *Ticket*],
    [*Conv. item* \ 50.000],
    [*Attachment* \ 60.000],
    [*Utenti paralleli* \ test tramite *Locust*],
    [*Data visualization* \ tramite *dashboard Grafana*],
    grid.cell(colspan: 3)[
    #box(width: 100%,height:65%,stroke: luma(90%),inset:0.4em, radius: 16pt)[*Anser Rate* \ ground truth nei risultati 100% ]
],
    grid.cell(colspan: 2)[
    #box(width: 100%,height:65%,stroke: luma(90%),inset:0.4em, radius: 16pt)[*Latency* \ tempo tra richiesta-risposta < 300ms ]
],
)]

#place(dy:0%-5pt)[#block(width: 100%)[La ground truth è stata costruita automaticamente a partire dal dataset]]

]


#slide(title: "Risultati: Semantica e linking")[
  #box(height: 70%)[
    #set box(height: 80%)
    #grid(
    columns: (1fr,4fr),
    rows:(1fr,1fr,1fr,1fr),
    column-gutter: 1.5em,
    align: center + horizon,
    inset: 0em,
    grid.cell(colspan: 2)[
      #grid(
        columns:(1fr,1em,1fr), 
      box(inset:0.4em, radius: 16pt,fill:luma(99%),stroke: color.black)[
      ElasticSearch \ + join esterne] , 
      align(horizon+center)[#text(size:2em,sym.arrow.long)],
      box(inset:0.4em, radius: 16pt,fill:luma(99%),stroke: color.black)[Postgres/pgvector \ + join integrate]
      )      
      ] ,
    grid.cell(rowspan: 3)[#box(inset:0.4em, radius: 16pt,fill:luma(99%),stroke: color.black,height: 40%, width: 100%)[*Latency* \ *200-300ms*]],
    grid.cell(align: left)[- Linking all'interno della stessa query SQL: *nessun round-trip aggiuntivo*],
    grid.cell(align: left)[- Ricerche tramite singola query: *database interrogato una sola volta*],
    grid.cell(align: left)[- Il *linking relazionale è integrato* nella pipeline di retrieval]
  )]
  #place()[No overhead di sincronizzazione e join lato backend di ElasticSearch]
]


#slide(title: "Limiti della ricerca full-text")[
  #let card(contenuto)=box(
    height: 80%, width: 100%,
    inset:0.4em, radius: 16pt,
    stroke:color.black,
    fill:luma(99%),
    contenuto,
    )
  
  #box(height: 80%, width: 100%)[#grid(
    columns: (1fr,1fr,1fr),
    rows:(1fr,1fr,1fr,),
    column-gutter: 1.5em,
    align: center + horizon,
    inset: 0em,
    card()[*Postgres* \ non ottimizzata per lingua \ *5-10s*],
    card()[*Postgres* \ ottimizzato per lingua \ #sym.tilde *3s*],
    card()[*Pgvector* \ ricerca semantica \ *< 300ms*],
    grid.cell(colspan: 3)[
      #columns(2)[
    - *Limite strutturale* Postgres non offre le funzionalità dei motori full-text (BM25, ranking, filtering, Block MAX WAND)
    - *Workaround*: Implementate funzioni di ranking e operazioni sugli array (overlap)]
    - *Conseguenza*: Ricerca full-text collo di bottiglia nella ricerca ibrida      
    ],
    grid.cell(colspan: 3)[
      Il *limite è la full-text di PostgreSQL*: valutare alternative come *pg_text_search* e *ParadeDB* (out of scope)
      ]
  )]
]

#slide(title: "Risultati: cosa non ha funzionato")[
  #box(height: 80%, width: 100%)[#grid(
    columns: (1fr, 2fr),
    column-gutter: 1.5em,
    align: center + horizon,
    inset: 1em,

    grid.cell(rowspan:2, colspan: 2)[#image("images/ingestion tme.jpeg",width: 90%)],


  )]
]


#filled-slide[
  #align(center)[#box(fill:color.white,stroke:color.black+2pt,inset: 0em)[#image("images/meme-pg.png",height: 60%)]]
  Grazie per l'attenzione! \
  Domande?
]
