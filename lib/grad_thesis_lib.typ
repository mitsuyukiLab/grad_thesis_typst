#let textL = 24pt
#let textM = 20pt
#let textS = 16pt
#let text_main = 12pt

#let gothic = ("Noto Sans JP")
#let mincho = ("Noto Serif CJK JP")
#let english = ("Times New Roman")

// Store theorem environment numbering
#let thmcounters = state("thm",
  (
    "counters": ("heading": ()),
    "latest": ()
  )
)

// Setting theorem environment
#let thmenv(identifier, base, base_level, fmt) = {

  let global_numbering = numbering

  return (
    ..args,
    body,
    number: auto,
    numbering: "1.1",
    refnumbering: auto,
    supplement: identifier,
    base: base,
    base_level: base_level
  ) => {
    let name = none
    if args != none and args.pos().len() > 0 {
      name = args.pos().first()
    }
    if refnumbering == auto {
      refnumbering = numbering
    }
    let result = none
    if number == auto and numbering == none {
      number = none
    }
    if number == auto and numbering != none {
      result = locate(loc => {
        return thmcounters.update(thmpair => {
          let counters = thmpair.at("counters")
          // Manually update heading counter
          counters.at("heading") = counter(heading).at(loc)
          if not identifier in counters.keys() {
            counters.insert(identifier, (0, ))
          }

          let tc = counters.at(identifier)
          if base != none {
            let bc = counters.at(base)

            // Pad or chop the base count
            if base_level != none {
              if bc.len() < base_level {
                bc = bc + (0,) * (base_level - bc.len())
              } else if bc.len() > base_level{
                bc = bc.slice(0, base_level)
              }
            }

            // Reset counter if the base counter has updated
            if tc.slice(0, -1) == bc {
              counters.at(identifier) = (..bc, tc.last() + 1)
            } else {
              counters.at(identifier) = (..bc, 1)
            }
          } else {
            // If we have no base counter, just count one level
            counters.at(identifier) = (tc.last() + 1,)
            let latest = counters.at(identifier)
          }

          let latest = counters.at(identifier)
          return (
            "counters": counters,
            "latest": latest
          )
        })
      })

      number = thmcounters.display(x => {
        return global_numbering(numbering, ..x.at("latest"))
      })
    }

    return figure(
      result +  // hacky!
      fmt(name, number, body, ..args.named()) +
      [#metadata(identifier) <meta:thmenvcounter>],
      kind: "thmenv",
      outlined: false,
      caption: none,
      supplement: supplement,
      numbering: refnumbering,
    )
  }
}

// Definition of theorem box
#let thmbox(
  identifier,
  head,
  ..blockargs,
  supplement: auto,
  padding: (top: 0.5em, bottom: 0.5em),
  namefmt: x => [(#x)],
  titlefmt: strong,
  bodyfmt: x => x,
  separator: [#h(0.1em):#h(0.2em)],
  base: "heading",
  base_level: none,
) = {
  if supplement == auto {
    supplement = head
  }
  let boxfmt(name, number, body, title: auto) = {
    if not name == none {
      name = [ #namefmt(name)]
    } else {
      name = []
    }
    if title == auto {
      title = head
    }
    if not number == none {
      title += " " + number
    }
    title = titlefmt(title)
    body = bodyfmt(body)
    pad(
      ..padding,
      block(
        width: 100%,
        inset: 1.2em,
        radius: 0.3em,
        breakable: false,
        ..blockargs.named(),
        [#title#name#separator#body]
      )
    )
  }
  return thmenv(
    identifier,
    base,
    base_level,
    boxfmt
  ).with(
    supplement: supplement,
  )
}

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
    #text(size: textM, weight: "bold")[
      #v(30pt)
      目次
      #v(30pt)
    ]
  ]

  set text(size: text_main)
  set par(leading: 1.24em, first-line-indent: 0pt)
  locate(loc => {
    let elements = query(heading.where(outlined: true), loc)
    for el in elements {
      let before_toc = query(heading.where(outlined: true).before(loc), loc).find((one) => {one.body == el.body}) != none
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
          set text(weight: "black")
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
  })
}

// Counting figure number
#let img_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("image-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    str(chapt) + "." + str(n + 1)
  })
}

// Definition of figure outline
#let toc_img() = {
  align(left)[
    #text(size: textM, weight: "bold")[
      #v(30pt)
      図目次
      #v(30pt)
    ]
  ]

  set text(size: text_main)
  set par(leading: 1.24em, first-line-indent: 0pt)
  locate(loc => {
    let elements = query(figure.where(outlined: true, kind: "image"), loc)
    for el in elements {
      let chapt = counter(heading).at(el.location()).at(0)
      let num = counter(el.kind + "-chapter" + str(chapt)).at(el.location()).at(0) + 1
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
  })
}

// Counting table number
#let table_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("table-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    str(chapt) + "." + str(n + 1)
  })
}

// Definition of table outline
#let toc_table() = {
  align(left)[
    #text(size: textM, weight: "bold")[
      #v(30pt)
      表目次
      #v(30pt)
    ]
  ]

  set text(size: text_main)
  set par(leading: 1.24em, first-line-indent: 0pt)
   locate(loc => {
    let elements = query(figure.where(outlined: true, kind: "table"), loc)
    for el in elements {
      let chapt = counter(heading).at(el.location()).at(0)
      let num = counter(el.kind + "-chapter" + str(chapt)).at(el.location()).at(0) + 1
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
  })
}

// Counting equation number
#let equation_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter(math.equation)
    let n = c.at(loc).at(0)
    "(" + str(chapt) + "." + str(n) + ")"
  })
}

#let abstract(body) = {
  v(6em)
  text(font: english, size: textM, weight: "bold")[Abstract]
  v(2em)
  body
  pagebreak(weak: true)
}

#let thesis(
  type: "",
  title: "",
  title_en: "",
  submittion_date: none,
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
    // citation number
  show ref: it => {
    if it.element != none and it.element.func() == figure {
      let el = it.element
      let loc = el.location()
      let chapt = counter(heading).at(loc).at(0)

      link(loc)[#if el.kind == "image" or el.kind == "table" {
          // counting 
          let num = counter(el.kind + "-chapter" + str(chapt)).at(loc).at(0) + 1
          it.element.supplement
          " "
          str(chapt)
          "."
          str(num)
        } else if el.kind == "thmenv" {
          let thms = query(selector(<meta:thmenvcounter>).after(loc), loc)
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
      let loc = el.location()
      let chapt = counter(heading).at(loc).at(0)
      let num = counter(math.equation).at(loc).at(0)

      it.element.supplement
      " ("
      str(chapt)
      "."
      str(num)
      ")"
    } else if it.element != none and it.element.func() == heading {
      let el = it.element
      let loc = el.location()
      let num = numbering(el.numbering, ..counter(heading).at(loc))
      if el.level == 1 {
        str(num)
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

  // counting caption number
  show figure: it => {
    set align(center)
    if it.kind == "image" {
      set text(size: 12pt)
      it.body
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.caption.body
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        let c = counter("image-chapter" + str(chapt))
        c.step()
      })
    } else if it.kind == "table" {
      set text(size: 12pt)
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.caption.body
      set text(size: 10.5pt)
      it.body
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        let c = counter("table-chapter" + str(chapt))
        c.step()
      })
    } else {
      it
    }
  }

  set document(author: author_name, title: title)

  // Configure the page.
  set page(
    paper: "a4",
    // margin: (top: 25mm, bottom: 22mm, x: 17mm)
  )

  // Font
  set text(size: text_main, font: english, lang: "ja")
  show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"): set text(font: mincho) // 漢字、ひらがな、カタカナのときだけ明朝体に変更
  show "．": set text(font: mincho) // 全角ピリオドのときだけ明朝体に変更
  show "，": set text(font: mincho) // 全角カンマのときだけ明朝体に変更

  // citation number
  show ref: it => {
    if it.element != none and it.element.func() == figure {
      let el = it.element
      let loc = el.location()
      let chapt = counter(heading).at(loc).at(0)

      link(loc)[#if el.kind == "image" or el.kind == "table" {
          // counting 
          let num = counter(el.kind + "-chapter" + str(chapt)).at(loc).at(0) + 1
          it.element.supplement
          " "
          str(chapt)
          "."
          str(num)
        } else if el.kind == "thmenv" {
          let thms = query(selector(<meta:thmenvcounter>).after(loc), loc)
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
      let loc = el.location()
      let chapt = counter(heading).at(loc).at(0)
      let num = counter(math.equation).at(loc).at(0)

      it.element.supplement
      " ("
      str(chapt)
      "."
      str(num)
      ")"
    } else if it.element != none and it.element.func() == heading {
      let el = it.element
      let loc = el.location()
      let num = numbering(el.numbering, ..counter(heading).at(loc))
      if el.level == 1 {
        let levels = counter(heading).at(loc)
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

  show heading: it => locate(loc => {
    // Find out the final number of the heading counter.
    let levels = counter(heading).at(loc)
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }
    if it.level == 1 [
      #pagebreak()
      // First-level headings are centered smallcaps.
      // We don't want to number of the acknowledgment section.
      #set par(first-line-indent: 0pt)
      #let is-ack = it.body in ([謝辞], [謝　辞], [謝　　辞], [Acknowledgement])
      #set text(size: textM, font: english, weight: "bold")
      #show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"): set text(size: textM, font: gothic) // 日本語のときだけゴシック体に変更
      #show "．": set text(font: gothic)　// 全角ピリオドのときだけゴシック体に変更
      #show "，": set text(font: gothic)　// 全角ピリオドのときだけゴシック体に変更
      #v(9pt, weak: true)
      #if it.numbering != none and not is-ack {
        text(cjk-latin-spacing: none)[第 #str(levels.first()) 章]
        h(8pt, weak: true)
      }
      #it.body
      #v(9pt)
    ] else if it.level == 2 [
      // The other level headings are run-ins.
      #set par(first-line-indent: 0pt)
      #set text(size: textS, weight: "bold", font: english)
      #show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"): set text(size: textS, font: gothic) // 日本語のときだけゴシック体に変更
      #show "．": set text(font: gothic)　// 全角ピリオドのときだけゴシック体に変更
      #show "，": set text(font: gothic)　// 全角ピリオドのときだけゴシック体に変更
      #v(1pt, weak: true)
      #if it.numbering != none {
        numbering("1.1", ..levels)
        h(8pt, weak: true)
      }
      #it.body
    ] else [
      // The other level headings are run-ins.
      #set par(first-line-indent: 0pt)
      #set text(size: text_main, weight: "bold", font: english)
      #show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"): set text(size: text_main, font: gothic) // 日本語のときだけゴシック体に変更
      #show "．": set text(font: gothic)　// 全角ピリオドのときだけゴシック体に変更
      #show "，": set text(font: gothic)　// 全角ピリオドのときだけゴシック体に変更
      #v(1pt, weak: true)
      #if it.numbering != none {
        numbering("1.1", ..levels)
        h(8pt, weak: true)
      }
      #it.body
    ]
  })

  show figure.where(kind: "table"): set figure(placement: top, supplement: [Table ], numbering: table_num)
  show figure.where(kind: "table"): set figure.caption(position: top, separator: [ ])
  show figure.where(kind: "image"): set figure(placement: top, supplement: [Fig.], numbering: img_num)
  show figure.where(kind: "image"): set figure.caption(position: bottom, separator: [ ])
  show math.equation: set math.equation(supplement: [式], numbering: equation_num)

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
  // show outline.entry: set text(font: gothic, lang: "ja")
  show outline.entry.where(
    level: 1
  ): it => {
    v(0.2em)
    set text(weight: "semibold")
    it
  }

  align(center)[
    #v(1cm)
    #block(text(textS)[#type])
    
    // Title row.
    #align(horizon)[
      #block(text(textL, title, weight: "bold"))
      #v(1em)
      #block(text(textM, title_en, weight: "light"))
    ]

    #v(10em)
    #block(text(textS)[#submittion_date 提出])
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
  show par: set block(spacing: 1.00em)

  body
}