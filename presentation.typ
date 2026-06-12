#import "@preview/polylux:0.4.0": *
#import "unipd.typ": *

//#show: unipd-theme
// Altro font
#show: unipd-theme.with(palette: (:..unipd-palette, font: "Noto Sans Old"))

#title-slide(
  authors: "Matteo Mazzaretto",
  title: "Ideazione di una pipeline OCR locale per estrarre dati da documenti di trasporto",
  date: "Luglio 2026",
)

#slide(title: "Static text")[
  Here's some code:

  ```sh
  #!/bin/bash
  sleep 2
  echo "Hello World"
  exit 0
  ```
]

#slide(title: "Dynamic text")[
  #lorem(20)

  #uncover("2-")[This appears after one slide]

  #uncover("4-")[Ciao brooooo]
]

#slide(title: "Qux")[
  _baz_\
  *Fizz*\
  `Fuzz`
]

#slide()[   //Prende il title dalla slide precedente
  #normal-block[Normal block][body]
  #alert-block[Alert block][body]
  #example-block[Example block][
    body

    but a bit longer
  ]
]

#filled-slide[
  Grazie per l'attenzione!
]
