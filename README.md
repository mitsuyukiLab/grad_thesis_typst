# grad_thesis_typst

これは、卒論・修論・博論などの卒業論文をTypstで書くためのフォーマットです。

## 事前準備

### Typstのインストール

公式のマニュアルは[こちら](https://github.com/typst/typst?tab=readme-ov-file#installation)。

Windowsの場合は、PowerShellか何かで、以下のコマンドを実行してください。

```bash
winget install --id Typst.Typst
```

Mac OSの場合は、Terminalか何かで、[Homebrew](https://formulae.brew.sh/)を使って、以下のコマンドを実行してください。

```bash
brew install typst
```

### フォントのインストール(Mac, Linuxのみ)

現在、フォントについては以下の設定になっています。
各自のPCにインストールされているフォントと照らし合わせて、前の方から優先的に使われるようです。

```ts
#let mincho = ("Times New Roman", "IPAMincho")
#let gothic = ("Times New Roman", "IPAGothic")
```

Typstで認識されているフォントを確認するには、以下のコマンドを実行すると良いです。

```bash
typst fonts
```

#### Windows

IPAフォントのインストールは[ここ](https://www.kisnet.or.jp/~kanou/index.php?windows/windows%E5%85%B1%E9%80%9A/IPAFont%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)あたりを参考にしてください。

フォントの設定を以下のように変えて、Windowsに搭載されているフォントを使うのも良いかもしれません。

```ts
#let mincho = ("Times New Roman", "MS Mincho")
#let gothic = ("Times New Roman", "MS Gothic")
```

個人的にはWSL2を用いてUbuntu環境を作ってしまったほうが好みです。

#### Mac OS

おそらく、MacではTimes New Romanは入っているけども、ゴシックや明朝はフォントをインストールする必要があります。

IPAフォントであれば、[Homebrew](https://formulae.brew.sh/)を利用して簡単にインストールできます。

```bash
brew install --cask font-ipafont
```

MSフォントは、Microsoft OfficeがインストールされているPCであれば[この記事](https://note.com/tomorrow311/n/ne835a8c525a9)の方法で取り込めそうですが、ご自身の責任でお願いします。

#### Linux

以下の方法でインストールできそうです。

```bash
# Debian系(Ubuntu)
sudo apt-get install fonts-ipafont
sudo apt-get install msttcorefonts # Times New Roman
```

## How to use

### 1. レポジトリの用意

- GitHubアカウントを持っている方は、`use this template` で、自分用のレポジトリを生成してください。
  
  - レポジトリの名前は`年度-学位-名字`をおすすめします。例えば、2024年度に卒業論文を書く学部生の場合は`2024-B-mitsuyuki`とかが良いです。
  - Privateレポジトリにし、指導教員を共同編集者に招待してください。

### 2. 執筆環境設定(VSCode)

ローカルPCにTypstとVisual Studio Code(VSCode)がインストールされている前提で説明を続けます。

複数ファイルに分割して記述するスタイルを採用しているため、VSCodeプラグイン固有の自動コンパイル機能は切っておいた方が良いと思います。

[Typst LSP](https://marketplace.visualstudio.com/items?itemName=nvarner.typst-lsp)であれば、このワークスペースにおいては自動コンパイル機能をoffにする設定にしています。他のTypstコンパイル拡張機能をインストールしている場合は、ご自身で自動コンパイル機能をoffにしてください。

PowershellやTerminalか何かで以下のコマンドを実行することで、ファイルの変更時に自動でコンパイルを行ってpdfファイルを生成してくれます。コンパイルが失敗する場合はエラーメッセージが表示されるので、該当の場所を修正しましょう。

```sh
typst watch main.typ main.pdf
```
