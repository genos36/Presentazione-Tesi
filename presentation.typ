#import "@preview/polylux:0.4.0": *
#import "unipd.typ": *

#show: unipd-theme.with(palette: (:..unipd-palette, font: "Noto Sans Old"))

#title-slide(
  authors: "Matteo Mazzaretto",
  title: "Ideazione di una pipeline OCR locale per estrarre dati da documenti di trasporto",
  date: "14 Luglio 2026",
)

#slide(title: "L'azienda e il progetto (1)")[
  #grid(
    columns: (18%, 82%),
    rows: (25%, 12.5%, 12.5%, 12.5%, 12.5%),
    stroke: 1pt + black,
    img("logo_azienda.svg"),
    img("example-ddt.png"),
    [*Problema*], [Estrarre dati da fonti semi-strutturate],
    [*Attualità*], [Sistema basato su LLM/API esterne a pagamento],
    [*Soluzione*], [Pipeline di OCR locale basata su soluzioni algoritmiche],
    [*Benefici*], [Soluzione deterministica, abbattimento dei costi operativi]
  )
]

#slide(title: "L'azienda e il progetto (2)")[
  #grid(
    columns: (18%, 82%),
    rows: (25%, 12.5%, 12.5%, 12.5%, 12.5%),
    stroke: 1pt + black,
    grid.cell(colspan: 2, align: center)[#img("logo_azienda.svg")],
    [*Problema*], [Estrarre dati da fonti semi-strutturate],
    [*Attualità*], [Sistema basato su LLM/API esterne a pagamento],
    [*Soluzione*], [Pipeline di OCR locale basata su soluzioni algoritmiche],
    [*Benefici*], [Soluzione deterministica, abbattimento dei costi operativi]
  )
]

#slide(title: "L'azienda e il progetto (3)")[
  #grid(
    columns: (auto, auto, auto),
    stroke: 1pt + black,
    inset: 8pt,
    img("logo_azienda.svg"),
    [*Problema*], [Estrarre dati da fonti semi-strutturate],
    grid.cell(rowspan: 3)[
      #align(center + horizon)[
        #stack(
          spacing: 1em,
          img("example-ddt.png")
        )
      ]
    ],
    [*Attualità*], [Sistema basato su LLM/API esterne a pagamento],
    [*Soluzione*], [Pipeline di OCR locale basata su soluzioni algoritmiche],
    [*Benefici*], [Soluzione deterministica, abbattimento dei costi operativi]
  )
]

#slide(title: "L'azienda e il progetto (4)")[
  #grid(
    columns: (auto, auto, auto),
    inset: 8pt,
    img("logo_azienda.svg"),
    [*Problema*], [Estrarre dati da fonti semi-strutturate],
    grid.cell(rowspan: 3)[
      #align(center + horizon)[
        #stack(
          spacing: 1em,
          img("example-ddt.png")
        )
      ]
    ],
    [*Attualità*], [Sistema basato su LLM/API esterne a pagamento],
    [*Soluzione*], [Pipeline di OCR locale basata su soluzioni algoritmiche],
    [*Benefici*], [Soluzione deterministica, abbattimento dei costi operativi]
  )
]

#slide(title: "Tecnologie utilizzate (1)")[
  #grid(
    columns: (1fr, 1fr),
    row-gutter: 1em,
    column-gutter: 1em,
    align: center + horizon,
    img("technologies/html_css_js.png", width: 8cm, height: 4cm),
    img("technologies/python.png", width: 8cm, height: 4cm),
    img("technologies/flask.svg", width: 8cm, height: 4cm),
    img("technologies/docker.png", width: 8cm, height: 4cm)
  )
]

#slide(title: "OCR scelto (1)")[
  *DocTR - Document Text Recognition*
  align: left + horizon
  - basata su transformer e reti neurali convoluzionali
  - progettata per il riconoscimento di testo nei documenti
  - rilevamento righe, parole e coordinate
]

#slide(title: "Tecnologie utilizzate (2)")[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    align: center + horizon,
    img("technologies/html_css_js.png", width: 8cm, height: 4cm),
    img("technologies/python.png", width: 8cm, height: 4cm),
    img("technologies/flask.svg", width: 8cm, height: 4cm),
    img("technologies/docker.png", width: 8cm, height: 4cm),
    [*DocTR - Document Text Recognition*],[
  - basata su transformer e reti neurali convoluzionali
  - progettata per il riconoscimento di testo nei documenti
  - rilevamento righe, parole e coordinate]
  )
]

#slide(title: "User Journey")[
  #set align(center + horizon)
  #grid(
    columns: (1fr, auto, 1fr, auto, 1fr),
    column-gutter: 0.5em,
    align: center + horizon,
    box(
      stroke: 1pt + black,
      radius: 4pt,
      inset: 10pt,
      width: 100%,
    )[
      *1. Creazione template* \
      #text(size: 0.8em)[L'utente configura il template per il fornitore]
    ],
    text(size: 1.5em)[→],
    box(
      stroke: 1pt + black,
      radius: 4pt,
      inset: 10pt,
      width: 100%,
    )[
      *2. Caricamento DDT* \
      #text(size: 0.8em)[Il PDF viene caricato e processato]
    ],
    text(size: 1.5em)[→],
    box(
      stroke: 1pt + black,
      radius: 4pt,
      inset: 10pt,
      width: 100%,
    )[
      *3. Visualizza estrazione* \
      #text(size: 0.8em)[L'utente controlla i dati estratti]
    ],
  )
]

#slide(title: "Requisiti principali (1)")[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    row-gutter: 0.6em,
    [#align(center)[*Funzionali*]], [#align(center)[*Di vincolo*]],
    [- Indicatori di affidabilità dei risultati], [- Pipeline OCR completamente locale],
    [- Supporto a template DDT multipli], [- Distribuzione tramite Docker],
    [- Gestione di rotazione, contrasto e rumore dei PDF], [- Gestione di PDF multipagina],
  )
]

#slide(title: "Requisiti principali (2)")[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    row-gutter: 0.6em,
    align: left + horizon,
    [*Funzionali*], [*Di vincolo*],
    [- Indicatori di affidabilità dei risultati], [- Pipeline OCR completamente locale],
    [- Supporto a template DDT multipli], [- Distribuzione tramite Docker],
    [- Gestione di rotazione, contrasto e rumore dei PDF], [- Gestione di PDF multipagina],
  )
]

#slide(title: "Approcci iniziali")[
  #grid(
    columns: (auto, auto),
    [
      + Estrarre con OCR il testo;
      + Ricavare i dati con regular expression.
      Il problema emergeva subito: i template DDT con tabelle come nel secondo esempio non sarebbero mai stati gestibili con questo approccio, poiché le regex non hanno conoscenza spaziale del testo.
    ],
    [
      #table(
        columns: (50%, 40%),
        [*Numero colli*], [1],
        [*Peso lordo*], [1.0KG]
      )
      #v(0.5em)
      #table(
          columns: (auto, auto),
          [*Numero colli*], [*Peso lordo*],
          [1], [1.0KG]
      )
    ]
  )
]

#slide(title: "Interfaccia grafica")[
  #grid(
    columns: (auto, auto),
    rows: (35%, 35%),
    column-gutter: 1em,
    [*Estrazione* di un DDT], img("example/estrazione-ddt.png"),
    [*Creazione* di un template], img("example/costruzione-template.png"),
  )
]

#slide(title: "Problematiche da risolvere")[
  - Costruzione del template
  - Gestione dei rettangoli disegnati male
  - Gestire l'inclinazione dei DDT e la loro rotazione (a voce oppure codice, parlo di rilevamento rotazione e deskewing)
  - Gestire i fornitori con diversi template
]

#slide(title: "Costruzione del template")[
  #img("example/corpo-template.png")
]

#slide(title: "Deskewing")[
  #grid(
    rows: (40%, 40%),
    img("deskew/pre-deskew.png", height: 90%),
    img("deskew/post-deskew.png", height: 90%),
  )
]

#slide(title: "Estrazione: concetti chiave (1)")[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5em,
    [
      *Estrazione delle parole nel rettangolo*
      #show raw: set text(size: 0.75em)
      ```
      function words_in_rect(bounding_box, words):
      found = []
      for word in words:
          if not word.overlaps(bounding_box):
              continue
          if word.overlap_size(bounding_box).x >= MIN_OVERLAP_RATIO:
              found.append(word)
      return found
      ```
    ],
    [
      *Raggruppamento articoli per quantità*
      #show raw: set text(size: 0.75em)
      ```
      function group_lines_by_quantity(lines, quantity_box):
      groups = []
      current = none
      for line in lines:
          if line.has_summary_keyword():
              break
          if line.has_quantity(quantity_box):
              if current != none:
                  groups.append(current)
              current = new_group(line)
          else:
              current.extend(line)
      groups.append(current)
      return groups

      ```
    ]
  )
]

#slide(title: "Estrazione: concetti chiave (2)")[
  #align(left)[
    *Estrazione delle parole nel rettangolo*\
    ```
    function words_in_rect(bounding_box, words):
    found = []
    for word in words:
        if not word.overlaps(bounding_box):
            continue
        if word.overlap_size(bounding_box).x >= MIN_OVERLAP_RATIO:
            found.append(word)
    return found
    ```
  ] 
]

#slide()[
  #align(left)[
    *Raggruppamento articoli per quantità*\
    #show raw: set text(size: 0.9em)
    ```
    function group_lines_by_quantity(lines, quantity_box):
    groups = []
    current = none
    for line in lines:
        if line.has_summary_keyword():
            break
        if line.has_quantity(quantity_box):
            if current != none:
                groups.append(current)
            current = new_group(line)
        else:
            current.extend(line)
    groups.append(current)
    return groups
    ```
  ]
]


#slide(title: "Conclusioni")[
  #grid(
    columns: (35%, 60%),
    column-gutter: 1em,
    row-gutter: 1em,
    [
      #set text(size: 0.75em)
      #stack(
        spacing: 0.3em,
        box(stroke: 1pt + black, radius: 4pt, inset: 8pt, width: 100%)[*Onboarding*],
        align(center)[#text(size: 1.3em)[↓]],
        box(stroke: 1pt + black, radius: 4pt, inset: 8pt, width: 100%)[*Approccio regex*],
        align(center)[#text(size: 1.3em)[↓]],
        box(stroke: 1pt + black, radius: 4pt, inset: 8pt, width: 100%)[*Sviluppo GUI estrazione*],
        align(center)[#text(size: 1.3em)[↓]],
        box(stroke: 1pt + black, radius: 4pt, inset: 8pt, width: 100%)[*Sviluppo GUI template*],
        align(center)[#text(size: 1.3em)[↓]],
        box(stroke: 1pt + black, radius: 4pt, inset: 8pt, width: 100%)[*Testing template*],
      )
    ],
    [
      #grid(
        columns: (1.2fr, 1fr, 1fr, 1fr),
        stroke: 1pt + black,
        inset: 6pt,
        align: center + horizon,
        [*Tipo*], [*Obb*], [*Des*], [*Opz*],
        [Funzionale], [146/146], [1/1], [4/4],
        [Qualità], [1/1], [0/0], [0/0],
        [Vincolo], [4/4], [0/0], [2/2]
      )
    ],
    grid.cell(colspan: 2)[
      Testando l'algoritmo su tutti i DDT di esempio disponibili, il numero di
      articoli estratti risulta corretto nel *99,04%* dei casi.\
      Questo dato non garantisce però che ogni singolo campo sia esatto: da un
      controllo manuale a campione, stimo l'affidabilità reale più vicina
      all'*80-90%*.
    ]
  )
]

#filled-slide[
  Grazie per l'attenzione!
]
