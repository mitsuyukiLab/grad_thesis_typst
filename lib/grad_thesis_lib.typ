#let mincho = ("TeX Gyre Termes", "IPAMincho")
#let gothic = ("TeX Gyre Termes", "IPAGothic")
// #let mincho = ("Times New Roman", "IPAMincho")
// #let gothic = ("Times New Roman", "IPAGothic")
// #let mincho = ("Times New Roman", "MS Mincho", "IPAMincho")
// #let gothic = ("Times New Roman", "MS Gothic", "IPAGothic")

#let textL = 24pt
#let textM = 20pt
#let textS = 16pt
#let text_main = 12pt

#let spaceS_size = 1.5em
#let spaceM_size = 3.0em

// Definition of chapter outline
#let toc() = {
  show outline.entry: it => {
    show cite: _ => {} // ← 目次では cite を無視
    it
  }
  show outline.entry.where(level: 1): set block(spacing: spaceS_size)
  v(spaceM_size)
  text(size: textM, font: gothic, weight: "bold")[目次]
  v(spaceS_size)
  outline(indent: spaceS_size, title: none)
  pagebreak(weak: true)
}

// Definition of figure outline
#let toc_img() = {
  show outline.entry: it => {
    show cite: _ => {} // ← 目次では cite を無視
    it
  }
  show outline.entry.where(level: 2): set block(spacing: spaceS_size)
  v(spaceM_size)
  text(size: textM, font: gothic, weight: "bold")[図目次]
  v(spaceS_size)
  outline(indent: spaceS_size, title: none, target: figure.where(kind: image))
  pagebreak(weak: true)
}

// Definition of table outline
#let toc_table() = {
  show outline.entry: it => {
    show cite: _ => {} // ← 目次では cite を無視
    it
  }
  show outline.entry.where(level: 2): set block(spacing: spaceS_size)
  v(spaceM_size)
  text(size: textM, font: gothic, weight: "bold")[表目次]
  v(spaceS_size)
  outline(indent: spaceS_size, title: none, target: figure.where(kind: table))
  pagebreak(weak: true)
}

#let abstract(body) = {
  v(spaceM_size)
  text(size: textM, weight: "bold")[Abstract]
  v(spaceS_size)
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

  set document(author: author_name, title: title)

  // Configure the page.
  set page(
    paper: "a4",
    // margin: (top: 25mm, bottom: 22mm, x: 17mm)
  )

  // Font
  set text(size: text_main, font: mincho, lang: "ja")
  
  // Citation format
  show ref: it => {
    if it.element != none and it.element.func() == heading {
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
  set heading(numbering: (..num) => {
    if num.pos().len() > 1 {
      num.pos().map(str).join(".") + " "
    } else {
      text(cjk-latin-spacing: none)[第 #str(num.pos().first()) 章]
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
    set par(first-line-indent: 0pt)
    if it.level == 1 [
      #pagebreak()
      #v(spaceM_size)
      // First-level headings are centered small caps.
      // We don't want to number of the acknowledgment section.
      #let is-ack = it.body in ([謝辞], [謝　辞], [謝　　辞], [Acknowledgement])
      #set text(size: textM, font: gothic)
      #if it.numbering != none and not is-ack {
        text(cjk-latin-spacing: none)[第 #str(levels.first()) 章]
        h(text_main, weak: true)
      }
      #it.body
      #v(spaceS_size, weak: true)
    ] else if it.level == 2 [
      #v(text_main)
      // The other level headings are run-ins.
      #set text(size: textS, font: gothic)
      #if it.numbering != none {
        numbering("1.1", ..levels)
        h(text_main, weak: true)
      }
      #it.body
    ] else [
      #v(text_main)
      // The other level headings are run-ins.
      #set text(size: text_main, font: gothic)
      #if it.numbering != none {
        numbering("1.1", ..levels)
        h(text_main, weak: true)
      }
      #it.body
    ]
  }

  set math.equation(numbering: (..num) =>
    numbering("(1.1)", counter(heading).get().first(), num.pos().first())
    )

  set figure(numbering: (..num) =>
    numbering("1.1", counter(heading).get().first(), num.pos().first())
  )

  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    it
  }
  show figure.where(kind: table): set figure(supplement: [Table])
  show figure.where(kind: table): set figure.caption(position: top, separator: [ ])
  show figure.where(kind: image): set figure(supplement: [Fig.])
  show figure.where(kind: image): set figure.caption(position: bottom, separator: [ ])
  show math.equation: set math.equation(supplement: [Eq.])

  show figure.caption: it => {
    align(box(align(it, left)), center)
  }

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

  // ------------------------------------------------
    // top page
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
  // ------------------------------------------------

  set par(leading: 1.00em, first-line-indent: 1.00em, justify: true)

  body
}