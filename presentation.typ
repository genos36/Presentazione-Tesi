#import "@preview/polylux:0.4.0": *
#import "unipd.typ": *

#show: unipd-theme.with(palette: (:..unipd-palette, font: "Noto Sans Old"))

#title-slide(
  authors: "Matteo Mazzaretto",
  title: "Ideazione di una pipeline OCR locale per estrarre dati da documenti di trasporto",
  date: "14 Luglio 2026",
)

#slide(title: "L'azienda e il progetto")[
  #grid(
    columns: (45%, 45%),
    column-gutter: 1em,
    img("logo_azienda.svg"),
    img("example-ddt.png"),
  )
]

#slide()[
  #grid(
    columns: (auto, auto),
    column-gutter: 1em,
    [Il progetto *sostituisce* il sistema attuale di estrazione dati dai DDT, basato su Mistral, con una pipeline OCR locale che classifica i layout ed estrae i dati strutturati senza dipendere da LLM o API esterne a pagamento, eliminando i costi operativi ricorrenti.],
    img("mistral-logo.png")
  )
]

#slide(title: "Scelta del progetto")[
  #align(left + horizon)[
    + Affronta un problema rilevante nell'informatica moderna: l'estrazione affidabile di dati da documenti semi-strutturati;
    + Offre l'opportunità di apprendere tecnologie ampiamente utilizzate nell'informatica moderna, come gli OCR;
    + Richiede un approccio algoritmico generalizzabile anziché soluzioni ad-hoc per casi specifici, stimolando capacità di astrazione e design di sistema;
    + Non richiede vincoli specifici per i linguaggi di programmazione.
  ]
]

#slide(title: "Tecnologie utilizzate")[
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

#slide(title: "Casi d'uso")[
  #grid(
    columns: (auto, auto),
    column-gutter: 1em,
    row-gutter: 1em,
    img("UC/UC1.png"),
    img("UC/UC2.png"),
  )
]

#slide()[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    row-gutter: 1em,
    img("UC/UC3.png"),
    img("UC/UC3.3.png")
  )
]

#slide(title: "Requisiti funzionali dal Piano di Lavoro")[
  #table(
    columns: (auto),
    [Il sistema deve poter restituire un indicatore di sicurezza sull'affidabilità del risultato.],
    [Il sistema deve poter estendere il supporto a più template DDT configurabili da interfaccia amministrativa.],
    [Il sistema deve poter avere un controllo sulla rotazione dei PDF caricati.],
    [Il sistema deve poter avere un controllo sul contrasto dei PDF caricati.],
    [Il sistema deve poter avere un controllo sulla riduzione del rumore dei PDF caricati.]
  )
]

#slide(title: "Requisiti di qualità dal Piano di Lavoro")[
  #table(
    columns: (auto),
    [La documentazione deve essere conforme alle scelte implementative, sui risultati ottenuti e sui limiti residui.]
  )
  #align(left)[
    Non esistevano requisiti su tempistiche di estrazione da rispettare oppure requisiti che richiedevano dei paragoni in termini percentuale o assoluti rispetto alla soluzione precedente, in quanto l'obiettivo è *eliminare* i costi derivanti dalle chiamate API, sostituendo completamente la soluzione precedente.
  ]
]

#slide(title: "Requisiti di vincolo dal Piano di Lavoro")[
  #table(
    columns: (auto),
    [Il sistema deve prevedere una pipeline di OCR locale on-premise.],
    [Il sistema deve poter essere distribuito
tramite immagine Docker.],
    [Il sistema deve restituire il risultato in un
formato JSON deciso dall'azienda.],
    [Il sistema deve gestire PDF multipagina.],
    [L'ambiente di esecuzione del sistema deve essere definito tramite un Dockerfile, in modo da rendere agevole l'aggiornamento della versione Python e delle dipendenze di sistema.],
    [Le dipendenze Python del sistema devono essere gestite tramite pip e dichiarate in un file requirements.txt, per consentirne l'aggiornamento in modo riproducibile.]
  )
]

#slide(title: "Approcci iniziali")[
  #grid(
    columns: (auto, auto),
    [
      + Estrarre con OCR il testo;
      + Ricavare i dati con l'utilizzo di regular expression.
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

#slide(title: "Approcci finali")[
  #grid(
    columns: (auto, auto),
    rows: (35%, 35%),
    row-gutter: 1em,
    [Interfaccia per l'*estrazione* di un DDT], img("example/estrazione-ddt.png"),
    [Interfaccia per la *creazione* di un template], img("example/costruzione-template.png"),
  )
]

#slide(title: "Cose da gestire")[
  - Costruzione del template (slide successiva)
  - Gestione dei dati non letti correttamente dagli OCR (a voce, impossibile da gestire automaticamente)
  - Gestione dei rettangoli disegnati male (a voce, impossibile da gestire automaticamente)
  - Gestire l'inclinazione dei DDT e la loro rotazione (a voce oppure codice, parlo di rilevamento rotazione e deskewing)
  - Gestire i fornitori con diversi template (slide apposita)
  - Controllare i risultati dell'estrazione (sezione test di regressione della tesi, secondo me si può omettere oppure parlarne nelle conclusioni)
  - Controllare i risultati degli OCR (si può ometttere totalmente, è l'HTML che mi permette di visualizzare da dove legge i rettangoli)
]

#slide(title: "OCR scelto")[
  DocTR (Document Text Recognition) è una libreria sviluppata da Mindee, basata su architetture transformer e reti convoluzionali, progettata specificamente per il riconoscimento di testo in documenti. Offre una pipeline integrata che include rilevamento delle righe di testo ed estrazione delle parole con le rispettive *coordinate normalizzate*, convertite secondo il sistema di normalizzazione a 250 unità di larghezza e 1000 di altezza adottato nel progetto.
]

#slide(title: "Esempio corpo template")[
  #img("example/corpo-template.png")
]

#slide(title: "Estrazione parole e articoli")[
  #show raw: set text(size: 0.7em)
  ```py
   def words_in_rect(
      xmin: float,
      xmax: float,
      ymin: float,
      ymax: float,
      words: list[Word],
  ) -> list[Word]:
      """Restituisce le parole che si sovrappongono al rettangolo dato. Utilizza una tolleranza e un overlap predefinito"""
      found: list[Word] = []
      for w in words:
          overlap_x: float = (
              min(w["xmax"], xmax + TOLERANCE) - max(w["xmin"], xmin - TOLERANCE)
          )
          overlap_y: float = (
              min(w["ymax"], ymax + TOLERANCE) - max(w["ymin"], ymin - TOLERANCE)
          )
          if overlap_x <= 0 or overlap_y <= 0:
              continue
          word_w: float = w["xmax"] - w["xmin"]
          if word_w > 0 and (overlap_x / word_w) >= MIN_OVERLAP_RATIO:
              found.append(w)
      return found
  ```
]

#slide()[
  #show raw: set text(size: 0.75em)
  ```py
  def _group_lines_by_quantity(
          self,
          righe: list[PhysicalLineDict],
          prima_quantita_rect: Rect,
      ) -> list[PhysicalLineDict]:
          """Raggruppa le righe fisiche in gruppi articolo in base alla quantità"""
          if not righe:
              return []

          b: BodyConfig = self._template["body"]
          qta_in_alto: bool = b["quantita_in_alto"]
          primo_codice_rect: Rect = b["primo_codice"]
          parole_riepilogo: list[str] = self._load_words_summary()

          if qta_in_alto:
              return self._group_qty_on_top(righe, prima_quantita_rect, parole_riepilogo)
          return self._group_qty_on_bottom(righe, prima_quantita_rect, primo_codice_rect, parole_riepilogo)
  ```
]

#slide(title: "Conclusioni")[
  #align(center)[
    #img("conclusioni/consuntivo_finale.png", height: 70%)
  ]
]

#slide()[
  #align(center)[
    #img("conclusioni/req_soddisfatti.png")
  ]
]

#slide()[
  Secondo il report che ho creato durante lo svolgimento del tirocinio, basato sui risultati ottenuti dai test, l'accuratezza esatta ottenuta dall'algoritmo è stata del 99,04%.\
  Per quanto buona sia questa percentuale, mi era impossibile calcolare con precisione la bontà degli articoli estratti, per questo motivo credo che la reale affidabilità si aggiri tra l'80% e il 90%.\
]

#filled-slide[
  Grazie per l'attenzione!
]
