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

// [*Tecnologie*], [*pgvector* + *full-text nativa*], 
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
    // [*Modello dati*], [Ticket, conversation item, attachment ],
   [È il caso d'uso che rende *Elasticsearch* inadatto],
  )]
]


#slide(title: "Tre modalità di ricerca")[
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 1em,
    align: center + horizon,
    inset: 8pt,
    [*Semantica*], [*Full-text*], [*Ibrida*],
    [Similarità sui vettori di *embedding*],
    [Corrispondenza *lessicale*],
    [Fusione delle due tramite *RRF*],

  )
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
    [*Partizionamento* su field_name],
    [Indice *HNSW* su bit vector],
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






#slide(title: "Limiti della ricerca full-text")[
  #set align(center + horizon)
  #grid(
    columns: (1fr, 1fr, ),
    column-gutter: 1em,
    inset: 8pt,
    [Nessuno scoring BM25: accettato],
    [Granularità dello scoring: Combinazioni di funzioni semplici],
    [Filtering granulare: Overlap tra array di lessemi],
    [Performance: Accettato],



    // box(stroke: 1pt + black, radius: 4pt, inset: 10pt, width: 100%)[
    //   Nessun *BM25* nativo \ → ranking sommato manualmente
    // ],
    // box(stroke: 1pt + black, radius: 4pt, inset: 10pt, width: 100%)[
    //   Nessuna *soglia minima* \ → filtro su array ordinati
    // ],
    // box(stroke: 1pt + black, radius: 4pt, inset: 10pt, width: 100%)[
    //   Nessuna *fusione ibrida* \ → RRF costruito a mano
    // ],
  )
]

#slide(title: "Sistema di test")[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    row-gutter: 0.6em,
    align: center + horizon,
    inset: 8pt,
    [*Locust* \ simula utenti paralleli],
    [*Grafana* \ dashboard collegata a Postgres],
    [*Metriche* \ hit rate, MRR, latenza],
    [*Ground truth* \ da dati sintetici],// TODO
    grid.cell(colspan:2,image("images/example/image.png", height: 30%))
  )
  
]

#slide(title: "Risultati: cosa ha funzionato")[
  #box(height: 80%)[#grid(
    columns: (1fr, 1fr),
    rows:(2.5fr,1fr,1fr,1fr),
    column-gutter: 1.5em,
    align: center + horizon,
    inset: 2em,
    grid.cell(colspan:2,align:bottom)[*Volume dati*:10.000 ticket, 50.000 conversation item, 60.000 attachment],
    grid.cell()[*Ricerca semantica* \ 200-300ms, *confermata*],
    grid.cell()[*Fusione ibrida* \ semplice ed efficace lato DB],
    [],[],
    grid.cell(colspan:2,align:bottom)[
      
      *Linking* \ join performanti su chiave primaria],
    [ // TODO: quarto punto, o passa a 2x1 se ne hai solo 3
    ],
  )]
]
#slide(title: "Risultati: cosa non ha funzionato")[
  #box(height: 80%)[#grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5em,
    align: center + horizon,
    inset: 2em,
        grid.cell(colspan:2,align:bottom)[*Volume dati*:10.000 ticket, 50.000 conversation item, 60.000 attachment],

    [*Full-text* \ 5-10s],
    [*Answer rate 100%* \ ma su dataset di test],
    grid.cell(colspan: 2)[*No Block-Max WAND* \ non replicabile in Postgres],
  )]
]




// #slide(title: "Conclusioni")[
//   #columns(2,
//     [
//       *Vantaggi*
//       - *pgvector* valido per ricerca semantica/ibrida
//       - Stack *unificato*, meno overhead

//       #colbreak()

//       *Limiti e sviluppi futuri*
//       - Full-text *più lento* di Elasticsearch
//       - Estendere i test a tutte le tipologie
//     ],
//   )

//   Possibili soluzioni:

//   Utilizzare estensioni specializzate (*ParedeDB*)

//   Rivedere il ruolo della ricerca full-text
// ]

#filled-slide[
  #align(center)[#box(fill:color.white,stroke:color.black+2pt,inset: 0em)[#image("images/meme-pg.png",height: 60%)]]
  Grazie per l'attenzione! \
  Domande?
]
