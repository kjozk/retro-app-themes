---
name: qt-stylesheet-troubleshooting
description: Debug, troubleshoot, and bulletproof Qt Style Sheets (QSS). Covers pseudo-state fallback bugs (disabled controls), specificity traps, selector syntax violations, scrollbar geometry, occlusion opacity, and Data URI caveats across Qt/OBS themes.
---

# Qt スタイルシート（QSS）トラブルシューティング & 耐障害性設計ガイド

Qt スタイルシート（QSS）は標準 CSS2.1 をベースにしていますが、Qt 独自のパーサー仕様やウィジェット階層に起因する数多くの落とし穴（アンチパターン）が存在します。
本ガイドは、OBS Studio テーマ開発をはじめとする Qt アプリケーションのスタイリングにおいて、予期せぬ白化・不可視化・レイアウト崩壊を未然に防ぐための実践的デバッグ・防壁設計集です。

---

## 1. サブコントロールの擬似状態フォールバック（無効時アイコン消失トラップ）

### 現象
スピンボックス（`QSpinBox`）やコンボボックス（`QComboBox`）が無効化された際、ボタン背景が白系にフォールバックし、白い矢印アイコンが背景と同化して完全に消えて見えなくなる。

### 原因
`QSpinBox::up-button`, `::down-button` や `QComboBox::drop-down` などのサブコントロールに暗色背景を指定していても、**`:disabled` の疑似状態（pseudo-state）を明示的に定義しない場合**、Qt はネイティブの無効ボタン描画（または親の薄グレー/白背景）を適用します。その上に白系矢印（`theme:Dark/up.svg` 等）が描画されるため、白地に白矢印となり不可視化します。

### 完全防御テンプレート
サブコントロールをカスタムスタイリングする際は、必ず通常時と `:disabled` 状態をペアで定義します：

```css
/* スピンボタン (通常時) */
QSpinBox::up-button, QDoubleSpinBox::up-button {
    subcontrol-origin: padding;
    subcontrol-position: top right;
    width: 18px;
    background-color: #202022;
    border: none;
    border-left: 1px solid #141416;
    border-bottom: 1px solid #141416;
}
QSpinBox::up-arrow, QDoubleSpinBox::up-arrow {
    image: url(theme:Dark/up.svg);
    width: 7px;
    height: 7px;
}

/* スピンボタン (無効時: 暗色背景と矢印を明示維持) */
QSpinBox::up-button:disabled, QDoubleSpinBox::up-button:disabled {
    background-color: #252628;
    border: none;
    border-left: 1px solid #141416;
    border-bottom: 1px solid #141416;
}
QSpinBox::up-arrow:disabled, QDoubleSpinBox::up-arrow:disabled {
    image: url(theme:Dark/up.svg);
    width: 7px;
    height: 7px;
}

/* ドロップダウンボタン (無効時) */
QComboBox::drop-down:disabled, QDateTimeEdit::drop-down:disabled {
    background-color: #252628;
    border: none;
    border-left: 1px solid #141416;
}
QComboBox::down-arrow:disabled, QDateTimeEdit::down-arrow:disabled {
    image: url(theme:Dark/collapse.svg);
    width: 8px;
    height: 8px;
}
```

---

## 2. 基底テーマの多重擬似クラス特異度（Specificity）トラップ

### 現象
録画中・配信中のアクティブ状態ボタン（`#recordButton` 等）で、マウスホバー時に文字色や背景が基底テーマに上書きされ、可読性が崩壊する。

### 原因
基底テーマ側で多重疑似クラス（例: `:!hover:!pressed.state-active`）が定義されている場合、単なる `#recordButton.state-active` や `:hover.state-active` では特異度で負けます。

### 対策
基底テーマの多重擬似クラスパターンを網羅したセレクタを定義し、`!important` で確実に上書きします：

```css
#recordButton:!hover:!pressed.state-active,
#recordButton:hover:!pressed.state-active,
#recordButton.state-active,
#recordButton:checked,
#recordButton:hover:checked,
QPushButton#recordButton.state-active,
QPushButton#recordButton:checked,
QPushButton#recordButton:!hover:!pressed.state-active,
QPushButton#recordButton:hover:!pressed.state-active {
    background-color: var(--active_color) !important;
    color: #ffffff !important;
    font-weight: bold;
}
```

---

## 3. QSS パーサー仕様違反によるルール全体強制適用バグ

### 現象
リスト（ソース一覧等）の未選択行のテキストまで白文字化し、白いリスト背景と同化して文字が消える。

### 原因
`QListView` 内のアイテム（例: `SourceTreeItem`）に対し、以下のような構文を書くと Qt の QSS パーサーエラーが発生します：
- 単なる `QWidget` に未定義の擬似状態（`:selected`）を指定する（例: `SourceTreeItem:selected`）
- サブコントロール（`::item`）の直後に子孫結合子（半角スペース）を続ける（例: `SourceTree::item:selected SourceTreeItem`）

このパーサーエラーにより、未選択行にまで白文字ルール（`color: #FFFFFF !important;`）が常時強制適用されてしまいます。

### 対策
Qt 標準のサブコントロール状態のみで制御し、子ウィジェットの未選択状態は個別基本セレクタで保護します：

```css
/* 未選択時の通常テキスト */
SourceTreeItem,
SourceTreeItem QLabel,
OBSSourceLabel {
    color: var(--text) !important;
}

/* 選択時: Qt標準のサブコントロールのみで制御 */
QListView::item:selected,
SourceTree::item:selected {
    background-color: var(--selection_bg) !important;
    color: #FFFFFF !important;
}
```

---

## 4. スクロールバー端点（矢印ボタンとつまみ）の境界セパレータ原則

### 現象
スクロールバーのつまみが最上部・最下部に達した際、通常表示時（非ホバー時）につまみと矢印ボタンが同色で一体化し、どこからがつまみか見失う。

### 対策
非ホバー時であっても、矢印ボタンとつまみの接触面に常時視認可能なコントラスト境界（1px〜2px の境界ボーダーやスリット）を設けて分離します：

```css
/* 矢印ボタンとつまみの接触面に明確な境界線を確保 */
QScrollBar::sub-line:vertical {
    border-bottom: 2px solid var(--scrollbar_separator_color);
}
QScrollBar::add-line:vertical {
    border-top: 2px solid var(--scrollbar_separator_color);
}
```

---

## 5. 固定要素・ヘッダーのオクルージョン（完全遮蔽）原則

### 現象
ドックのタイトルバー、テーブルヘッダー（`QHeaderView::section`）、固定ツールバー等の背後にコンテンツがスクロールした際、文字が透けて二重に重なりゴースト描画が発生する。

### 対策
全体デザインが半透明・すりガラスであっても、**スクロールコンテンツの上に覆いかぶさる固定ヘッダー・タイトルバーの背景色は必ず完全不透明（Opaque）に設定**してください。

---

## 6. Qt QSS の画像パス解決と Data URI 非対応

- **Data URI 非対応**: Qt QSS パーサーは `data:image/svg+xml;base64,...` をサポートしていません。
- **カレントディレクトリ基準の解決**: 相対パス `url(./icon.svg)` は、`.ovt` ファイルのある場所ではなく **実行ファイル（`bin\64bit\`）基準** で解決されます。内蔵アセットは `url(theme:Light/collapse.svg)` などの `theme:` 仮想スキームを使用してください。
- **二重防壁（フォールバック保護）**: 画像読み込み失敗時にウィジェットが透明になって完全不可視化するのを防ぐため、`background-color` と `border`（立体枠等）を基本スタイルとして常に併記してください。

---

## 7. コンボボックスの同心円設計（Concentric Radius）

外枠の角丸が $R$、枠線幅が $W$ の場合、内側のドロップダウンボタンの角丸は $(R - W)$ に設定します（例: 外枠 3px、枠線 1px のとき、ボタン角丸は 2px）。
小型の直角コンボボックス（`border-radius: 0px`）では、ドロップダウンボタン側にも必ず `border-radius: 0px !important;` を指定し、「D字状の角丸露出」を防止します。
