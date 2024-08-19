# grad_thesis_typst

## How to use

ローカルPCにTypstとVisual Studio Code(VSCode)がインストールされている前提で説明を続けます。

複数ファイルに分割して記述するスタイルを採用しているため、VSCodeプラグイン固有の自動コンパイル機能は切っておいた方が良いと思います。

[Typst LSP](https://marketplace.visualstudio.com/items?itemName=nvarner.typst-lsp)であれば、このワークスペースにおいては自動コンパイル機能をoffにする設定にしています。他のTypstコンパイル拡張機能をインストールしている場合は、ご自身で自動コンパイル機能をoffにしてください。

PowershellやTerminalか何かで以下のコマンドを実行することで、ファイルの変更時に自動でコンパイルを行ってpdfファイルを生成してくれます。コンパイルが失敗する場合はエラーメッセージが表示されるので、該当の場所を修正しましょう。

```sh
typst watch main.typ main.pdf
```
