#import "lib/grad_thesis_lib.typ": thesis, toc, toc_img, toc_table

#show: thesis.with(
  type: "卒業論文", // "卒業論文", "修士論文", "博士論文"
  title: "論文タイトルを入れる入れる \n 君の名は",
  title_en: "Please input your thesis title \n Your Name",
  submission_date: "2050年3月4日",
  supervisor_name: "海洋 太郎",
  supervisor_title: "准教授",
  author_name: "航空 太郎",
  author_student_id: "11QA111",
  author_affiliation_1: "横浜国立大学",
  author_affiliation_2: "理工学部", // "大学院理工学府", "大学院先進実践学環"
  author_affiliation_3: "機械・材料・海洋系学科", // "機械・材料・海洋系工学専攻", "リスク共生学"
  author_affiliation_4: "海洋空間のシステムデザインEP", // "海洋空間教育分野", none
)

// ------------------------------------------------
// 表紙の次にBlank Pageを挿入する
#pagebreak()
#pagebreak()
// ------------------------------------------------

// ------------------------------------------------
// Abstractと目次用の設定
#set page(numbering: "i", number-align: center)
#counter(page).update(1)
// ------------------------------------------------

#include "contents/abstract.typ" 

#toc()
#toc_img()
#toc_table()

// ------------------------------------------------
// 本文用の設定
#set page(numbering: "1", number-align: center)
#counter(page).update(1)
// -- ----------------------------------------------

// ここで各章のファイルを読み込む
#include "contents/how_to_use.typ" // 最終的にはコメントアウトしてください
#include "contents/introduction.typ"
#include "contents/related_study.typ"
#include "contents/proposed_method.typ"
#include "contents/case_study.typ"
#include "contents/discussion.typ"
#include "contents/conclusion.typ"
#include "contents/acknowledgement.typ"

// 参考文献
#[
  #set text(lang: "en")
  #bibliography(title: "参考文献", style:"lib/jasnaoe-reference.csl", "references.bib")
]
