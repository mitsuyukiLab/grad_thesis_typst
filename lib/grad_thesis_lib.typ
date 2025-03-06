#let mincho = ("Times New Roman", "IPAMincho")
#let gothic = ("Times New Roman", "IPAGothic")
// #let mincho = ("Times New Roman", "MS Mincho", "IPAMincho")
// #let gothic = ("Times New Roman", "MS Gothic", "IPAGothic")

#let textL = 24pt
#let textM = 20pt
#let textS = 16pt
#let text_main = 12pt

// Definition of content to string
#let to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(to-string).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

// Definition of chapter outline
#let toc() = {
  align(left)[
    #text(size: textM)[
      #v(30pt)
      目次
      #v(30pt)
    ]
  ]

  set text(size: text_main)
  set par(leading: 1.24em, first-line-indent: 0pt)
  context{
    let elements = query(heading.where(outlined: true))
    for el in elements {
      let before_toc = query(heading.where(outlined: true).before(here())).find((one) => {one.body == el.body}) != none
      let page_num = if before_toc {
        numbering("i", counter(page).at(el.location()).first())
      } else {
        counter(page).at(el.location()).first()
      }

      link(el.location())[#{
        // acknoledgement has no numbering
        let chapt_num = if el.numbering != none {
          numbering(el.numbering, ..counter(heading).at(el.location()))
        } else {none}

        if el.level == 1 {
          set text(font: gothic)
          if chapt_num == none {} else {
            chapt_num
            "  "
          }
          let rebody = to-string(el.body)
          rebody
        } else if el.level == 2 {
          h(2em)
          chapt_num
          " "
          let rebody = to-string(el.body)
          rebody
        } else {
          h(5em)
          chapt_num
          " "
          let rebody = to-string(el.body)
          rebody
        }
      }]
      box(width: 1fr, h(0.5em) + box(width: 1fr, repeat[.]) + h(0.5em))
      [#page_num]
      linebreak()
    }
  }
}

// Counting figure number
#let img_num(_) = {
  context{
    let chapt = counter(heading).at(here()).at(0)
    let c = counter("image-chapter" + str(chapt))
    let n = c.at(here()).at(0)
    str(chapt) + "." + str(n + 1)
  }
}

// Definition of figure outline
#let toc_img() = {
  align(left)[
    #text(size: textM)[
      #v(30pt)
      図目次
      #v(30pt)
    ]
  ]

  set text(size: text_main)
  set par(leading: 1.24em, first-line-indent: 0pt)
  context{
    let elements = query(figure.where(outlined: true, kind: image))
    for el in elements {
      let chapt = counter(heading).at(el.location()).at(0)
      let num = counter("image-chapter" + str(chapt)).at(el.location()).at(0) + 1
      let page_num = counter(page).at(el.location()).first()
      let caption_body = to-string(el.caption.body)
      "Fig. "
      str(chapt)
      "."
      str(num)
      h(1em)
      caption_body
      box(width: 1fr, h(0.5em) + box(width: 1fr, repeat[.]) + h(0.5em))
      [#page_num]
      linebreak()
    }
  }
}

// Counting table number
#let table_num(_) = {
  context{
    let chapt = counter(heading).at(here()).at(0)
    let c = counter("table-chapter" + str(chapt))
    let n = c.at(here()).at(0)
    str(chapt) + "." + str(n + 1)
  }
}

// Definition of table outline
#let toc_table() = {
  align(left)[
    #text(size: textM)[
      #v(30pt)
      表目次
      #v(30pt)
    ]
  ]

  set text(size: text_main)
  set par(leading: 1.24em, first-line-indent: 0pt)
   context{
    let elements = query(figure.where(outlined: true, kind: table))
    for el in elements {
      let chapt = counter(heading).at(el.location()).at(0)
      let num = counter("table-chapter" + str(chapt)).at(el.location()).at(0) + 1
      let page_num = counter(page).at(el.location()).first()
      let caption_body = to-string(el.caption.body)
      "Table "
      str(chapt)
      "."
      str(num)
      h(1em)
      caption_body
      box(width: 1fr, h(0.5em) + box(width: 1fr, repeat[.]) + h(0.5em))
      [#page_num]
      linebreak()
    }
  }
}

// Counting equation number
#let equation_num(_) = {
  context{
    let chapt = counter(heading).at(here()).at(0)
    let c = counter("equation-chapter" + str(chapt))
    let n = c.at(here()).at(0)
    "(" + str(chapt) + "." + str(n + 1) + ")"
  }
}

#let abstract(body) = {
  v(6em)
  text(size: textM, weight: "bold")[Abstract]
  v(2em)
  body
  pagebreak(weak: true)
}

#let thesis(
  type: "",
  title: "",
  title_en: "",
  submission_date: none,
  supervisor_name: none,
  supervisor_title: none,
  author_name: "",
  author_student_id:"",
  author_affiliation_1: "",
  author_affiliation_2: "",
  author_affiliation_3: "",
  author_affiliation_4: "",
  body
) = {
  
  show figure.caption: it => {
    context{
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.body
    }
  }

  // counting caption number
  show figure: it => {
    set align(center)
    v(text_main, weak: true)
    it
    v(text_main)
    if it.kind == "image" {
      context{
        let chapt = counter(heading).at(here()).at(0)
        let c = counter("image-chapter" + str(chapt))
        c.step()
      }
    } else if it.kind == "table" {
      context{
        let chapt = counter(heading).at(here()).at(0)
        let c = counter("table-chapter" + str(chapt))
        c.step()
      }
    }
  }

  show math.equation.where(block: true): it => {
    it
    context{
        let chapt = counter(heading).at(here()).at(0)
        let c = counter("equation-chapter" + str(chapt))
        c.step()
      }
  }

  set document(author: author_name, title: title)

  // Configure the page.
  set page(
    paper: "a4",
    // margin: (top: 25mm, bottom: 22mm, x: 17mm)
  )

  // Font
  set text(size: text_main, font: mincho, lang: "ja")
  
  // citation number
  show ref: it => {
    if it.element != none and it.element.func() == figure {
      let el = it.element
      let location = el.location()
      let chapt = counter(heading).at(location).at(0)

      link(location)[#if el.kind == "image" or el.kind == "table" {
          // counting 
          let num = counter(el.kind + "-chapter" + str(chapt)).at(location).at(0) + 1
          it.element.supplement
          " "
          str(chapt)
          "."
          str(num)
        } else if el.kind == "thmenv" {
          let thms = query(selector(<meta:thmenvcounter>).after(location))
          let number = thmcounters.at(thms.first().location()).at("latest")
          it.element.supplement
          " "
          numbering(it.element.numbering, ..number)
        } else {
          it
        }
      ]
    } else if it.element != none and it.element.func() == math.equation {
      let el = it.element
      let location = el.location()
      let chapt = counter(heading).at(location).at(0)
      link(location)[
        #{
        let num = counter("equation" + "-chapter" + str(chapt)).at(location).at(0) + 1
        it.element.supplement
        " ("
        str(chapt)
        "."
        str(num)
        ")"
        }
      ]
    } else if it.element != none and it.element.func() == heading {
      let el = it.element
      let location = el.location()
      let num = numbering(el.numbering, ..counter(heading).at(location))
      if el.level == 1 {
        let levels = counter(heading).at(location)
        "第"
        str(levels.first())
        "章"
      } else if el.level == 2 {
        str(num)
        "節"
      } else if el.level == 3 {
        str(num)
        "項"
      }
    } else {
      it
    }
  }

  // Configure lists.
  set enum(indent: text_main, body-indent: text_main)
  set list(indent: text_main, body-indent: text_main)

  // Heading
  set heading(numbering: (..nums) => {
    if nums.pos().len() > 1 {
      nums.pos().map(str).join(".") + " "
    } else {
      text(cjk-latin-spacing: none)[第 #str(nums.pos().first()) 章]
      h(0.5em)
    }
  })

  show heading: it => context{
    // Find out the final number of the heading counter.
    let levels = counter(heading).at(here())
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }
    if it.level == 1 [
      #pagebreak()
      // First-level headings are centered smallcaps.
      // We don't want to number of the acknowledgment section.
      #v(30pt)
      #set par(first-line-indent: 0pt)
      #let is-ack = it.body in ([謝辞], [謝　辞], [謝　　辞], [Acknowledgement])
      #set text(size: textM, font: gothic)
      #if it.numbering != none and not is-ack {
        text(cjk-latin-spacing: none)[第 #str(levels.first()) 章]
        h(8pt, weak: true)
      }
      #it.body
      #v(30pt, weak: true)
    ] else if it.level == 2 [
      #v(text_main)
      // The other level headings are run-ins.
      #set par(first-line-indent: 0pt)
      #set text(size: textS, font: gothic)
      #if it.numbering != none {
        numbering("1.1", ..levels)
        h(8pt, weak: true)
      }
      #it.body
    ] else [
      #v(text_main)
      // The other level headings are run-ins.
      #set par(first-line-indent: 0pt)
      #set text(size: text_main, font: gothic)
      #v(1pt)
      #if it.numbering != none {
        numbering("1.1", ..levels)
        h(8pt, weak: true)
      }
      #it.body
    ]
  }
  
  show figure.where(kind: table): set figure(supplement: [Table], numbering: table_num)
  show figure.where(kind: table): set figure.caption(position: top, separator: [ ])
  show figure.where(kind: image): set figure(supplement: [Fig.], numbering: img_num)
  show figure.where(kind: image): set figure.caption(position: bottom, separator: [ ])
  show math.equation: set math.equation(supplement: [Eq.], numbering: equation_num)

  // Display block code in a larger block with more padding.
  show raw.where(block: true): block.with(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
  )

  show raw.where(block: true): code => {
    show raw.line: line => {
      text(fill: gray)[#line.number]
      h(1em)
      line.body
    }
    code
    linebreak(justify: false)
  }

  // Outline
  show outline.entry.where(
    level: 1
  ): it => {
    v(0.2em)
    it
  }

  align(center)[
    #v(1cm)
    #block(text(textS)[#type])
    
    // Title row.
    #align(horizon)[
      #block(text(textL, title))
      #v(1em)
      #block(text(textM, title_en))
    ]

    #v(10em)
    #block(text(textS)[#submission_date 提出])
    #v(2em)
    #block(text(textS)[指導教員 #supervisor_name #supervisor_title])
    #v(4em)

    // Author information.
    #block(text(textS)[#author_affiliation_1])
    #block(text(textS)[#author_affiliation_2 #author_affiliation_3])
    #block(text(textS)[#author_affiliation_4])
    #v(2em)
    #block(text(textM)[#author_student_id  #author_name])
  ]

  pagebreak(weak: true)

  set par(leading: 1.00em, first-line-indent: 1.00em, justify: true)

  body
}