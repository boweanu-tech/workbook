## 目的

`workbook/999_GPTbox/lotusmath.sty` とその分割ファイルを整理するときに、既存 `.tex` から利用している公開APIを固定する。

今後 `lotusmath.sty` の内部実装を整理しても、このページに載せた公開コマンドについては、原則として名前・引数・出力結果を変更しない。

## 対象

- 対象ファイル：`workbook/999_GPTbox/lotusmath.sty` および `workbook/999_GPTbox/lotusmath-*.sty`
- 確認版：`2026/09/30 workbook package with English API`
- 用途：数学・理科・副教科などを含む workbook 系教材全体の組版

## 基本方針

- 既存 `.tex` がコンパイル不能になる変更は禁止。
- 公開APIのコマンド名・引数数・省略可能引数の有無は維持する。
- 表示余白・改ページ・解答欄の出方は、意図しない変更をしない。
- `\LM...` で始まるコマンド・長さ・状態変数は、原則として内部実装扱いにする。
- ただし、既存 `.tex` で直接使っている可能性があるものは、削除せず互換性を残す。
- 新しい公開APIを追加する場合は、このファイルにも追記する。

## 記法

- `[]` は省略可能引数。
- `{}` は必須引数。
- 「公開」は `.tex` 側で直接使ってよいコマンド。
- 「互換」は古い `.tex` のために残すコマンド。
- 「内部」は通常 `.tex` 側で直接使わないコマンド。

---

# 1. パッケージ全体・ファイル読み込み

## 公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\Use{variant}{theme}` | 2 | 問題ファイルを読み込み、解答出力対象に登録する | 例：`\Use{lesson}{01A}` のような使い方を想定 |
| `\UseREF{variant}{theme}{suffix}` | 3 | REF系など、サフィックス付きファイルを読み込む | `variant_themeSuffix.tex` を読み込む |
| `\BeginQuestions` | 0 | 問題モードを開始する | カウンタ・状態を初期化 |
| `\PrintAnswers` | 0 | 登録済み問題の解答を最後にまとめて出力する | 内部で `\BeginAnswers` を呼ぶ |

## 準公開・内部寄り

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\BeginAnswers` | 0 | 解答モードを開始する | 通常は `\PrintAnswers` 経由で使う |

## 内部API

| コマンド | 引数 | 用途 |
|---|---:|---|
| `\LMSetProblemDir{file}` | 1 | 入力ファイルの場所から `\graphicspath` を設定 |
| `\LMAnswerInput{variant}{theme}` | 2 | 解答出力時に問題ファイルを再読み込み |
| `\LMAnswerInputRef{variant}{theme}{suffix}` | 3 | REF系ファイルを解答出力時に再読み込み |
| `\LMProblemList` | 0 | 解答出力対象の蓄積用マクロ |

---

# 2. 表紙・ページ制御

## 公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\CoverPage{title}{subtitle}` | 2 | テスト系表紙を作る | 見出しは「総まとめテスト」固定 |
| `\CoverPageLesson{title}{subtitle}{note}` | 3 | lesson系表紙を作る | 表紙後に空白ページを挿入 |
| `\LessonPageBreak` | 0 | lesson用の改ページ | 解答モードでは段切りにする |
| `\LessonQuestionBreak` | 0 | lessonの問題ページだけ改ページする | 解答モードでは何もしない |
| `\MakeEvenPage` | 0 | 偶数ページ終わりに調整する | 必要なら空白ページを追加 |

---

# 3. 大問・テーマ見出し

## 公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\MajorQuestion{title}` | 1 | 大問・テーマ見出しを出す | 通常版。問題モードでは改ページする |
| `\MajorQuestionLesson{title}` | 1 | lesson用の大問・テーマ見出しを出す | lessonでは枠が大きめ |

## 内部API

| コマンド | 引数 | 用途 |
|---|---:|---|
| `\LMBoxedMajor` | 0 | 解答側などで使う大問番号枠 |
| `\LMBoxedMajorLesson` | 0 | lesson用の大問番号枠 |
| `\LMPrintedMajor` | 0 | 表示中のテーマ番号 |

---

# 4. 大問内の問題タイプ見出し

## 公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\TypeQuestion{text}{tag}` | 2 | 問題タイプ見出しを出す | 行数にかかわらず、番号枠と説明文を中央揃えする |
| `\TypeQuestionSingle{text}{tag}` | 2 | 旧1行見出しとの互換用 | 内部では `\TypeQuestion` を呼ぶ |
| `\TypeQuestionDouble{text}{tag}` | 2 | 旧2行見出しとの互換用 | 内部では `\TypeQuestion` を呼ぶ |

## 注意

`\TypeQuestion` の第2引数は「大問タグ」として渡す。現在の `lotusmath.sty` ではこの値を参照していないが、将来のおかわり問題・REF生成などで使う可能性があるため、引数自体は維持する。旧 `\TypeQuestionSingle` / `\TypeQuestionDouble` も同じ形式で利用できる。

大問タグは原則として `テーマタグ_問題の形式タグ` とする。半角英小文字とアンダースコアを基本とし、同じテーマ・問題形式には同じタグを使う。例：`beverb_copy`、`beverb_choose`、`beverb_error_correct`。

## 内部API

| コマンド | 引数 | 用途 |
|---|---:|---|
| `\LMBoxedTypeQuestion` | 0 | 問題側のタイプ番号枠 |
| `\LMBoxedTypeQuestionAns` | 0 | 解答側のタイプ番号枠 |
| `\LMTypeQuestionText` | 1 | 見出し内の `\vec` の表示を保ち、矢印の高さだけを中央揃えの計算から除外する |

---

# 5. 指示文・本文

## 公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\Instruction{text}` | 1 | 指示文を出す | 問題モードのみ本文表示 |
| `\InstructionTall{text}` | 1 | 行間を広めにした指示文 | 長い指示文用 |
| `\Text{text}` | 1 | 地の文を出す | 問題モードのみ表示 |
| `\TextTall{text}` | 1 | 行間を広めにした地の文 | 長い本文用 |

---

# 6. 小問表示

## 公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\Q{question}{answer}{space}` | 3 | 小問1つを出す | 余白を第3引数で直接指定する旧形式 |
| `\QQ{question}{answer}` | 2 | 標準小問 | 現在の基本形 |
| `\QQTall{question}{answer}` | 2 | 行間広めの標準小問 | 長い問題文用 |
| `\QQRow{q1}{a1}{q2}{a2}` | 4 | 小問2つを左右に並べる | 計算問題などで使用 |
| `\QQRowThree{q1}{a1}{q2}{a2}{q3}{a3}` | 6 | 小問3つを横に並べる | 短い式や数値の問題向け |
| `\QQSingle{question}{answer}` | 2 | 左半分幅の小問1つを出す | 2列調整用 |
| `\QQFigRow[width]{fig1}{q1}{a1}{fig2}{q2}{a2}` | 7 | 図つき小問2つを左右に並べる | 第1引数は省略可 |
| `\QQSideFig{figWidth}{figPath}{question}{answer}` | 4 | 小問1つと図を横並びにする | 小問番号つき図版問題の標準 |

## 内部API

| コマンド | 引数 | 用途 |
|---|---:|---|
| `\LMQQRowThreeCell{question}{answer}` | 2 | `\QQRowThree` の1列分を出力する内部補助 |

---

# 7. 図・画像配置

## 公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\LMFig[width]{path}` | 2 | 図を中央配置で表示 | 第1引数省略時は `0.7\linewidth` |
| `\LMFigInline[width]{path}` | 2 | 図をインライン的に表示 | 第1引数省略時は `0.7\linewidth` |
| `\LMFigBlock[width]{path}` | 2 | 図を中央配置ブロックで表示 | 第1引数省略時は `0.7\linewidth` |
| `\FigProblemBlock{figWidth}{figPath}{sideText}{body}` | 4 | 右に図、左に本文、その下に小問群を置く | 図つき大問ブロック |
| `\FigProblemBlockTall{figWidth}{figPath}{sideText}{body}` | 4 | 図横本文の行送りを広くした図つき大問ブロック | 長い本文用 |

---

# 8. 回り込み図・表

## 公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\WrapTextFig{pos}{width}{figPath}{text}` | 4 | 説明文だけを図に回り込ませる | 小問番号つき `\QQ` は中に入れない |
| `\WrapTextFig[rows]{pos}{width}{figPath}{text}` | 5 | 行数指定ありの回り込み図 | `wrapfigure` の行数指定を使う |
| `\WrapTextTable{pos}{width}{table}{text}` | 4 | 本文や小問を表に回り込ませる | `table` には `tabular` などを記述する |
| `\WrapTextTable[rows]{pos}{width}{table}{text}` | 5 | 行数指定ありの回り込み表 | `wraptable` の行数指定を使う |

## 互換API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\WrapFig{pos}{width}{figPath}{text}` | 4 | 旧回り込み図 | 互換用。今後は `\WrapTextFig` 優先 |
| `\WrapFig[rows]{pos}{width}{figPath}{text}` | 5 | 行数指定ありの旧回り込み図 | 互換用 |

## 内部API

| コマンド | 引数 | 用途 |
|---|---:|---|
| `\LMWrapTextFigAuto` | 4 | 行数指定なし `\WrapTextFig` の実体 |
| `\LMWrapTextFigRows` | 5 | 行数指定あり `\WrapTextFig` の実体 |
| `\LMWrapTextTableAuto` | 4 | 行数指定なし `\WrapTextTable` の実体 |
| `\LMWrapTextTableRows` | 5 | 行数指定あり `\WrapTextTable` の実体 |
| `\LMWrapFigAuto` | 4 | 行数指定なし `\WrapFig` の実体 |
| `\LMWrapFigRows` | 5 | 行数指定あり `\WrapFig` の実体 |

---

# 9. 行間・余白調整

## 公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\SetRowSpace{length}` | 1 | 小問間の余白を直接指定する | 例：`\SetRowSpace{8mm}` |
| `\SetRowSpaceCalc` | 0 | 計算問題用の広め余白にする | 現在は `16mm` |
| `\SetRowSpaceQanda` | 0 | 一問一答用の狭め余白にする | 小問間隔は `1mm`、解答間隔は `1.8mm` |
| `\ResetRowSpace` | 0 | 標準余白に戻す | 小問間隔 `4mm`、解答間隔 `3mm` に戻す |
| `\BeginTwoCols` | 0 | 2列系レイアウト開始用の互換コマンド | 現実装では `\par\vspace{2mm}` |
| `\EndTwoCols` | 0 | 2列系レイアウト終了用の互換コマンド | 現実装では `\par` |

## 内部の長さ

| 長さ | 用途 | 現在値 |
|---|---|---:|
| `\LMRuleWidth` | 枠線・罫線の太さ | `0.8pt` |
| `\LMDefaultRowSpace` | 標準小問間隔 | `4mm` |
| `\LMDefaultAnswerRowSpace` | 標準解答間隔 | `3mm` |
| `\LMCalcRowSpace` | 計算問題用小問間隔 | `16mm` |
| `\LMQandaRowSpace` | 一問一答用小問間隔 | `1mm` |
| `\LMQandaAnswerRowSpace` | 一問一答用解答間隔 | `1.8mm` |
| `\LMAnswerRowSpace` | 現在の解答間隔 | 初期値 `\LMDefaultAnswerRowSpace` |
| `\LMRowSpace` | 現在の小問間隔 | 初期値 `\LMDefaultRowSpace` |
| `\LMFigureRowSpace` | 図つき問題の下余白 | `3mm` |
| `\LMFigSideGap` | 図と本文の横間隔 | `4mm` |
| `\LMTypeQuestionTopSpace` | 大問2以降の見出し上余白 | `2mm` |

---

# 10. 穴埋め・参照穴埋め

## 公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\Blank{label}` | 1 | `【 label 】` 形式の空欄を出す | 単純な空欄 |
| `\NamedBlank{name}` | 1 | 現在の小問番号を名前つきで記録し、空欄を出す | 後で `\RefBlank` 参照可能 |
| `\RefBlank{name}` | 1 | `\NamedBlank` で記録した小問番号を参照して空欄を出す | 未定義なら `??` |

---

# 11. 解答表示・解答幅調整

## 公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\AnswerTwoLines{line1}{line2}` | 2 | 解答を左揃えで2行表示する | 小問番号と1行目を上揃えにする |
| `\AnswerThreeLines{line1}{line2}{line3}` | 3 | 解答を左揃えで3行表示する | 小問番号と1行目を上揃えにする |
| `\AnswerColumnBreak` | 0 | 解答ページだけ次の段へ送る | 問題モードでは何もしない |
| `\QueueAnswerPageBreak` | 0 | 解答出力対象に改ページを予約する | `\PrintAnswers` 実行時に、現在の解答ブロックを閉じて次ページへ送る |

## 内部API

原則として `.tex` 側から直接使わない。ただし、既存ファイルで使っている可能性があれば互換維持する。

| コマンド | 引数 | 用途 |
|---|---:|---|
| `\LMFitAnswer{width}{answer}` | 2 | 解答が幅に収まらない場合、小さくして収める |
| `\LMFitInlineAnswer{width}{answer}` | 2 | インライン解答を幅に収める |
| `\LMAnswerParbox{width}{answer}` | 2 | 幅指定の解答用 `parbox` |
| `\LMMeasureAnswer{width}{answer}` | 2 | 解答の高さを測定し、長い解答か判定 |
| `\LMPrintAnswerBox{width}{answer}` | 2 | 指定幅で解答本体だけを出力する。縦余白は入れない |
| `\LMPrintAnswer{width}{labelWidth}{answer}` | 3 | 解答本体と後続の縦余白を出力する共通処理 |
| `\LMPrintLabeledAnswer{labelWidth}{answer}` | 2 | 小問番号つき解答を出力する内部補助 |
| `\LMQueuedAnswerPageBreak` | 0 | `\QueueAnswerPageBreak` で予約された改ページを解答出力時に実行する |

---

# 12. 数学記号・表記補助

## 公開API

| コマンド          |  引数 | 用途                   | 備考            |
| ------------- | --: | -------------------- | ------------- |
| `\percent`    |   0 | パーセント記号を出す    | 全角 `％` と空白に統一する |
| `\Tri{name}`  |   1 | 三角形記号つきでローマン体の頂点名を出す | 例：`\Tri{ABC}` |
| `\Ang{name}`  |   1 | 角記号つきでローマン体の点名を出す    | 例：`\Ang{ABC}` |
| `\Lseg{name}` |   1 | 線分名をローマン体で出す         | 例：`\Lseg{AB}` |
| `\EqNo{label}` | 1 | 式番号を丸囲みで表示する | 例：`\EqNo{1}` |
| `\EqItem{label}{formula}` | 2 | 式番号と数式を一定幅で横並びにする | 数式部分は内部で数式モードになる |
| `\SetEqItemWidth{length}` | 1 | `\EqItem` 1項目分の幅を変更する | 初期値は `25mm` |
| `\SetEqListArrayStretch{value}` | 1 | 式一覧の行間倍率を変更する | 初期値は `1.6` |

## 公開環境

| 環境 | 用途 | 備考 |
|---|---|---|
| `EqListTwo` | 式を横2列で一覧表示する | 問題モードだけ表示する |
| `EqListThree` | 式を横3列で一覧表示する | 問題モードだけ表示する |

## 内部API

| コマンド・長さ | 用途 | 現在値・備考 |
|---|---|---|
| `\LMPrepareEqList` | 式一覧の直前余白を調整する | `\TypeQuestion` 直後かどうかで余白を変える |
| `\EqItemWidth` | `\EqItem` 1項目分の幅 | `25mm` |
| `\EqListArrayStretch` | 式一覧の行間倍率 | `1.6` |

---

# 13. 英語教材・ワードバンク

英語教材では、既存の `\QQ` / `\QQTall` / `\TypeQuestion` と組み合わせて使う。問題形式ごとに専用コマンドを増やしすぎず、英文・選択肢・語群・記述欄などの部品を組み合わせる。

## 英語問題の公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\EngSentence{text}` | 1 | 英文を統一した体裁で表示する | 改行可能。長い英文を箱に閉じ込めない |
| `\EngChoice{items}` | 1 | 適語選択の選択肢を丸括弧で表示する | 区切りの `/` などは引数内に書く |
| `\EngReorder{items}` | 1 | 並べ替え語群を角括弧で表示する | 過不足・活用の指定は問題文側に書く |
| `\EngBlank[width]` | 1 | 適語補充用の横線を表示する | 幅は省略可。初期値は `20mm` |
| `\EngRuledLines[rows]` | 1 | 英字練習用の4本罫を表示する | 段数は省略可。初期値は1段。3本目を基線として少し太くする |
| `\EngWritingLines[rows]` | 1 | `\EngRuledLines` と同じ4本罫を表示する | 初期実装との互換名 |
| `\EngSplitRuledLine` | 0 | 4本罫1段を中央で分け、左右に1つずつ表示する | 短い英文を2回書く問題向け |
| `\EngAnswerLines[rows]` | 1 | 和訳などのための通常の横罫を表示する | 行数は省略可。初期値は1行 |
| `\SetEngWritingLineHeight{length}` | 1 | 英字用4本罫1段の高さを変更する | 初期値は `10mm` |
| `\SetEngAnswerLineHeight{length}` | 1 | 和訳用横罫の行高を変更する | 初期値は `8mm` |
| `\SetEngRuledOuterSpace{top}{bottom}` | 2 | 4本罫1段の前後に置く空白を変更する | 初期値は上 `2.5mm`、下 `3mm`。複数段の間隔は前段の下＋次段の上になる |
| `\SetEngRuledLineGray{light}{base}` | 2 | 補助線3本と基線の灰色濃度を変更する | `0` が黒、`1` が白。初期値は `0.78`、`0.45` |
| `\SetEngRuledLineThickness{light}{base}` | 2 | 補助線3本と基線の太さを変更する | 初期値は `0.25pt`、`0.45pt` |
| `\SetEngSplitGap{length}` | 1 | 左右分割した4本罫の中央の空白幅を変更する | 初期値は `7mm` |
| `\EngAnswerPair{english}{japanese}` | 2 | 英文と和訳を解答欄に2行で表示する | 内部で `\AnswerTwoLines` を使う |
| `\EngWriteQuestion[rows]{prompt}{answer}` | 3 | 英字4本罫つきの標準小問を出す | 段数は省略可。小問番号を進める |
| `\EngWriteQuestionSplit{prompt}{answer}` | 2 | 左右2分割の4本罫つき小問を出す | 短い英文を左右に1回ずつ書かせる |
| `\EngCopy[rows]{english}` | 2 | 英文と英字4本罫の書写欄を出す | 段数は省略可。解答には英文を表示する |
| `\EngCopyTranslate[rows]{english}{japanese}` | 3 | 英文、英字4本罫の書写欄、通常罫の和訳欄を出す | 段数は省略可。和訳欄は1行 |
| `\EngCopyTranslateSplit{english}{japanese}` | 2 | 書写欄と和訳欄を左右に並べる | 短い英文向け。1段に収める |

### 組合せ例

```tex
\TypeQuestion{適切な語を選び、完成した英文を書きなさい。}{beverb_choose}
\EngWriteQuestion{%
  \EngSentence{I \EngChoice{am / is / are} happy.}%
}{I am happy.}

\TypeQuestion{語群を並べ替え、英文を書きなさい。}{simplepresent_reorder}
\EngWriteQuestion{%
  私は毎日英語を勉強します。\par
  \EngReorder{English / every day / study / I}%
}{I study English every day.}

\TypeQuestion{英文を書き写し、日本語に訳しなさい。}{beverb_copy_translate}
\EngCopyTranslateSplit{I am a student.}{私は生徒です。}
```

短い英文の書写・和訳には `\EngCopyTranslateSplit` を使う。英文または想定される和訳が半幅に収まりにくい場合は、上下配置の `\EngCopyTranslate` を使う。長さの判定は問題作成時に行い、自動判定にはしない。

`\EngChoice` や `\EngReorder` は表示用の部品であり、それ自体では小問番号を進めない。丸で囲むだけの問題は既存の `\QQ`、完成文を書かせる問題は `\EngWriteQuestion` と組み合わせる。

## ワードバンクの公開API

| コマンド | 引数 | 用途 | 備考 |
|---|---:|---|---|
| `\WordBank{title}{body}` | 2 | 現在のテーマ番号とワードバンクを登録する | 問題位置には表示せず、`\PrintWordBanks` まで蓄積する |
| `\WB{word}{part}{meaning}{note}` | 4 | ワードバンクの1行を記述する | 第4引数は変化形・注意。不要なら空欄 `{}` |
| `\PrintWordBanks` | 0 | 登録済みワードバンクを登録順にまとめて出力する | 1件もなければ何も出力せず、改ページもしない |

問題ファイルでは、問題の後などに次のように登録する。

```tex
\WordBank{be動詞の基本}{
  \WB{am}{be動詞}{～です、～にいます}{主語が I のときに使う}
  \WB{student}{名詞}{生徒}{複数形 students}
  \WB{every day}{熟語}{毎日}{}
}
```

PDF出力用ファイルでは、全問題を読み込んだ後、`\PrintAnswers` より前に `\PrintWordBanks` を呼ぶ。

```tex
\BeginQuestions
\Use{lesson}{01B}
\Use{lesson}{02B}

\PrintWordBanks
\PrintAnswers
```

出力順は「問題本体 → 改ページ → テーマ番号つきワードバンク → 改ページ → 解答」になる。テーマ番号は `\Use` の第2引数を登録時に固定するため、ワードバンク側で重ねて指定しない。

## 内部API・長さ

原則として `.tex` 側から直接使わない。

| 名前 | 種類 | 用途・現在値 |
|---|---|---|
| `\LMEngWritingLineHeight` | length | 英字用4本罫1段の高さ。初期値 `10mm` |
| `\LMEngAnswerLineHeight` | length | 和訳用横罫の行高。初期値 `8mm` |
| `\LMEngRuledTopSpace` | length | 4本罫1段の上側余白。初期値 `2.5mm` |
| `\LMEngRuledBottomSpace` | length | 4本罫1段の下側余白。初期値 `3mm` |
| `\LMEngGuideRuleThickness` | length | 1・2・4本目の太さ。初期値 `0.25pt` |
| `\LMEngBaseRuleThickness` | length | 3本目の基線の太さ。初期値 `0.45pt` |
| `\LMEngSplitGap` | length | 左右分割した4本罫の中央余白。初期値 `7mm` |
| `LMEngGuideLight` | color | 1・2・4本目の色。初期値は gray `0.78` |
| `LMEngGuideBase` | color | 3本目の基線の色。初期値は gray `0.45` |
| `\LMEngRuledBand` | command | 上線・中線・基線・下線からなる4本罫1段を出す |
| `\LMWordBankList` | macro | 登録されたワードバンクの蓄積先 |
| `\LMResetWordBanks` | command | `\BeginQuestions` 時に登録内容を空にする |
| `\LMPrintWordBankBlock` | command | テーマ番号・題名・表本体をまとめて出力する |
| `\LMWordBankThemeBox` | command | ワードバンクのテーマ番号枠を出す |

解答出力時には問題ファイルが再読込されるが、`\WordBank` は解答モードでは登録を行わない。このためワードバンクが二重登録されることはない。

---

# 14. 状態変数・カウンタ

## 内部API

`.tex` 側から直接変更しない。

| 名前 | 種類 | 用途 |
|---|---|---|
| `\ifLMAnswerMode` | if | 問題モード・解答モードの切替 |
| `\ifLMInAnswerBlock` | if | 解答ブロック中かどうか |
| `\ifLMInstructionUsed` | if | 直前に大問内見出し・指示文を出したかどうか |
| `\ifLMWrapMode` | if | 回り込み図内の小問表示かどうか |
| `LMmajor` | counter | 大問番号 |
| `LMtype` | counter | 大問内タイプ番号 |
| `LMsubq` | counter | 小問番号 |
| `\LMCurrentTheme` | macro | 現在のテーマ番号 |
| `\LMCoverTitle` | macro | 表紙・解答見出し用タイトル |
| `\LMCoverSubtitle` | macro | 表紙・解答見出し用サブタイトル |
| `\LMCurrentProblemDir` | macro | 現在読み込み中の問題ファイルのディレクトリ |

---

# 15. 現行の分割構成

`lotusmath.sty` は入口ファイルとして残し、次の分割ファイルを読み込む。

| 分割ファイル | 収録する主なAPI |
|---|---|
| `lotusmath-core.sty` | 長さ、カウンタ、状態変数、基本設定 |
| `lotusmath-answer.sty` | 解答モード、解答出力、解答幅調整 |
| `lotusmath-layout.sty` | 表紙、ページ制御、大問見出し、タイプ見出し |
| `lotusmath-qanda.sty` | `\Blank`, `\NamedBlank`, `\RefBlank`, 一問一答系補助 |
| `lotusmath-question.sty` | `\Q`, `\QQ`, `\QQTall`, `\QQRow`, `\QQSingle`, 指示文、本文 |
| `lotusmath-figure.sty` | `\LMFig`, `\QQSideFig`, `\QQFigRow`, `\FigProblemBlock`, 回り込み図・表 |
| `lotusmath-symbols.sty` | `\percent`, `\Tri`, `\Ang`, `\Lseg` |
| `lotusmath-english.sty` | 英語問題の表示部品、書写・記述欄、ワードバンクの登録・一括出力 |

現在の `lotusmath.sty` 本体は、おおむね次の入口になっている。

```tex
\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{lotusmath}[2026/09/30 workbook package with English API]

\RequirePackage{lotusmath-core}
\RequirePackage{lotusmath-answer}
\RequirePackage{lotusmath-layout}
\RequirePackage{lotusmath-qanda}
\RequirePackage{lotusmath-question}
\RequirePackage{lotusmath-figure}
\RequirePackage{lotusmath-symbols}
\RequirePackage{lotusmath-english}
```

---

# 16. 変更禁止リスト

少なくとも分割直後は、次を変更しない。

- 公開コマンド名
- 公開コマンドの引数数
- 省略可能引数の有無
- 小問番号・大問番号・タイプ番号の進み方
- 問題モードと解答モードの切替仕様
- 図の表示幅指定の仕様
- `\TypeQuestion{text}{tag}` の第2引数の存在
- `\TypeQuestionSingle{text}{tag}` / `\TypeQuestionDouble{text}{tag}` の互換性
- `\WrapFig` の互換性
- `\usepackage{lotusmath}` で従来通り使えること

---

# 17. 未整理・今後確認する点

- `\TypeQuestion` の第2引数を、将来本当に大問タグとして使うか。
- `\BeginTwoCols` / `\EndTwoCols` は現状ほぼ互換用なので、実使用箇所を確認する。
- `\Q` は旧形式の可能性があるため、既存ファイルでの使用状況を確認する。
- `\LM...` の内部コマンドを既存 `.tex` が直接呼んでいないか確認する。
- qanda系・lesson系・test系で代表ファイルを決め、内部整理の前後でPDF比較できるようにする。
