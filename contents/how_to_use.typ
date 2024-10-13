= 卒論修論フォーマットの使い方 <how_to_use_this_format>

== 図について <about_figure>

=== 一般的な図の記述方法 <how_to_describe_figure_in_general>

図のcaptionは @fig:fig_example のように図の下部につけてください。
図の表題（caption）は英語で書きます。
また、表題の最後にはピリオドを付けて下さい。
図は原則として英語表記としてください。
文字・記号等は十分に判読できる大きさとしてください。
Typstでは、PNG・JPEG・GIF・SVG フォーマットの画像をサポートしています。
画像の中に文字が入っている場合はベクトル形式であるSVGフォーマットを採用することを強く進めます。

#figure(
  image("img/example.svg", width: 90%),
  placement: none, // top, bottom, auto, none
  caption: "Example of a figure.",
  supplement: "Fig.",
  kind: "image",
) <fig:fig_example>

=== このテンプレートにおける図の記述方法 <how_to_describe_figure_in_this_format>

Typstの文法とこのテンプレートに沿って、図を記述する方法を以下に示します。

`placement` 属性は、位置固定 (`none`) や自動 (`auto`) だけでなく、紙面の上 (`top`) に寄せるか下 (`bottom`) に寄せるかを決められます。いい感じに調整してください。

```typst
#figure(
  placement: none, // top, bottom, auto, none
  image("img/example.svg", width: 90%),
  caption: [Example of a figure.],
  supplement: "Fig.", // 図番号の前につける文字列(固定)
  kind: "fig", // 図目次作成のためのキーワード(固定)
) <fig:fig_example> // 図の参照用のラベル
```

```typst
図のcaptionは @fig:fig_example のように図の下部につけてください。
```

`supplement`属性と`kind`属性と`numbering`属性は、このテンプレートにおいてすべて共通です。
書くのを忘れそうなので、注意してください。


== 表について <about_table>

=== 一般的な表の記述方法 <how_to_describe_table_in_general>

表は，@tab:table_example のように表形式で記述します．
表題（caption）は表の上に書きます．
表の表題（caption）は英語で書きます．
また，表題の最後にはピリオドを付けて下さい．
また，表も原則として英語表記としてください．

#figure(
  caption: [Example of a table.],
  placement: none, // top, bottom, auto, none
  table(
    columns: 4,
    stroke: (x: none),
    table.header(
      [*Margins*],
      [...],
      [*Left Column*],
      [*Right Column*],
    ),
    row-gutter: (2.2pt, auto),
    [Top], [...], [27 mm], [27 mm],
    [Left], [...], [16 mm], [107.5 mm],
    [Right], [...], [100 mm], [191.5 mm],
    [Bottom], [...], [275 mm], [275 mm],
  ),
  supplement: "Table",
  kind: "table",
) <tab:table_example>


=== このテンプレートにおける表の記述方法 <how_to_describe_table_in_this_format>

Typstの文法とこのテンプレートに沿って、表を記述する方法を以下に示します。

`placement` 属性は、位置固定 (`none`) や自動 (`auto`) だけでなく、紙面の上 (`top`) に寄せるか下 (`bottom`) に寄せるかを決められます。いい感じに調整してください。

```typst
#figure(
  caption: [Example of a table.],
  placement: none, // top, bottom, auto, none
  table(
    columns: 4,
    stroke: (x: none),
    table.header(
      [*Margins*],
      [...],
      [*Left Column*],
      [*Right Column*],
    ),
    row-gutter: (2.2pt, auto),
    [Top], [...], [27 mm], [27 mm],
    [Left], [...], [16 mm], [107.5 mm],
    [Right], [...], [100 mm], [191.5 mm],
    [Bottom], [...], [275 mm], [275 mm],
  ),
  supplement: "Table", // 表番号の前につける文字列(固定)
  kind: "table", // 表目次作成のためのキーワード(固定)
) <tab:table_example> // 表の参照用のラベル
```

```typst
表は，@tab:table_example のように表形式で記述します．
```

`supplement`属性と`kind`属性と`numbering`属性は、このテンプレートにおいてすべて共通です。
書くのを忘れそうなので、注意してください。

== 数式について <about_equation>

数式の書き方はTypstのドキュメントを参照してください。数式については、このテンプレート特有のものはありません。
数式番号をつけるような中央揃えの数式は、以下のように記載してください。
例えば，@eq:mmg_example のように記述してください．
$
m(dot(u)-v r) &=-m_x dot(u)+m_y v r+X_H+X_P+X_R \
m(dot(v)+u r) &=-m_y dot(v)+m_x u r+Y_H+Y_R \
I_(z G) dot(r) &=-J_Z dot(r)+N_H+N_R
$ <eq:mmg_example>

```typst
$
m(dot(u)-v r) &=-m_x dot(u)+m_y v r+X_H+X_P+X_R \
m(dot(v)+u r) &=-m_y dot(v)+m_x u r+Y_H+Y_R \
I_(z G) dot(r) &=-J_Z dot(r)+N_H+N_R
$ <eq:mmg_example>
```

```typst
例えば，@eq:mmg_example のように記述してください．
```

また、文中に書く数式は、
例えば，$n_i = sum_(i=1)^(N)(f(r_(i j)))$のように記述してください。

```typst
また、文中に書く数式は、
例えば，$n_i = sum_(i=1)^(N)(f(r_(i j)))$のように記述してください。
```


== 参考文献について <about_reference>

参考文献は、例えば、references.bibにある以下の文献を引用することを考えます。
引用する場合は @visAssessmentApproachesLogistics2016 のように記述してください。

```bib
@article{visAssessmentApproachesLogistics2016,
  title    = {Assessment Approaches to Logistics for Offshore Wind Energy Installation},
  author   = {Vis, Iris F. A. and Ursavas, Evrim},
  year     = {2016},
  journal  = {Sustainable Energy Technologies and Assessments},
  volume   = {14},
  pages    = {80--91},
  issn     = {2213-1388},
  langid   = {english},
  keywords = {Logistics,Offshore installations,Renewable energy sources,Wind energy,Wind farms}
}
```

```typst
引用する場合は @visAssessmentApproachesLogistics2016 のように記述してください。
```

複数の参考文献を扱う場合は、
@visAssessmentApproachesLogistics2016
@anchuanhongjiBoLangZhongniokeruChuannoCaoZongYunDongsimiyuresiyon2006
@aitallaStudyNewInstallation2017
のようになります。
適宜、参考文献を追加してください。

```typst
複数の参考文献を扱う場合は、
@visAssessmentApproachesLogistics2016
@anchuanhongjiBoLangZhongniokeruChuannoCaoZongYunDongsimiyuresiyon2006
@aitallaStudyNewInstallation2017
のようになります。
適宜、参考文献を追加してください。
```

使用してない参考文献は自動的に記載されないようになっているので、とりあえずreference.bibに入れておいて構いません.
通し番号は本文で言及された順になりますがこれも自動的に処理されるので気にしなくて良いです。
