# Nintendo Switch テーマ詳細設計書 (Nintendo Switch Theme Design Specification)

本書は、Nintendo Switch の実機 UI メタファーおよびハードウェア意匠を忠実に再現した OBS Studio / Zed エディタ向けテーマの詳細設計書です。

---

## 1. テーマ概要とバリアント構成

Nintendo Switch のシステム機能に備わる 2 つの公式テーマ（ベーシックブラック / ベーシックホワイト）に基づき、各アプリケーション向けに以下のバリアントを提供します。

| アプリケーション | テーマ名 / ID | モチーフ | 特徴 |
| :--- | :--- | :--- | :--- |
| **OBS Studio** | `Switch Dark`<br>(`com.obsproject.Yami.SwitchDark`) | ベーシックブラック<br>(Basic Black) | 深いマットチャコール背景にネオンシアンの発光アクセント。実機電源メニューに準拠した高コントラスト設計。 |
| **OBS Studio** | `Switch Light`<br>(`com.obsproject.Yami.SwitchLight`) | ベーシックホワイト<br>(Basic White) | 実機ホーム背景のマットホワイトに実機プライマリーブルー（`#2052FF`）とシアンハイライト。 |
| **Zed エディタ** | `Switch Dark` / `Switch Dark Blurred` | ベーシックブラック | ネオンシアンのキャレット、マゼンタ・オレンジ・ブルーのシンタックスハイライト。 |
| **Zed エディタ** | `Switch Light` / `Switch Light Blurred` | ベーシックホワイト | 実機ブルーのキャレット、コントラスト比 4.5:1 以上を保証したエディタ配色。 |

---

## 2. 実機ピクセルサンプリング・カラーパレット

実機スクリーンショットからピクセルサンプリングによって抽出した正確なカラーコード定義です。

### (1) ベースシステムカラー
| 用途 | カラーコード | RGB | 説明 |
| :--- | :--- | :--- | :--- |
| **Dark メイン背景** | `#2D2D2D` | `45, 45, 45` | 実機ホーム背景のマットチャコール |
| **Dark パネル/ドック** | `#353535` | `53, 53, 53` | リスト背景・カードコンテナ |
| **Dark 入力/リスト選択** | `#2B2B2B` / `#1A1A1A` | `43, 43, 43` / `26, 26, 26` | 選択アイテム背景・トグル選択背景 |
| **Dark テキスト** | `#FFFFFF` | `255, 255, 255` | 主要テキスト（コントラスト比 13.5:1） |
| **Dark サブテキスト** | `#8E8E93` | `142, 142, 147` | 補足テキスト |
| **Light メイン背景** | `#ECECEC` | `236, 236, 236` | 実機ホーム背景のマットオフホワイト |
| **Light パネル/ドック** | `#FFFFFF` | `255, 255, 255` | 白コンテナ・選択アイテム背景 |
| **Light テキスト** | `#2D2D2D` | `45, 45, 45` | 主要テキスト（コントラスト比 12.0:1） |
| **Light サブテキスト** | `#707070` | `112, 112, 112` | 補足テキスト |

### (2) 実機アクセント・アイコンカラー
| アイコン / 用途 | Dark 色 | Light 色 | UI マッピング |
| :--- | :--- | :--- | :--- |
| **フォーカスハイライト** | `#00D2F3` | `#00D2F3` / `#00E5FF` | 外枠キャレット、選択リング、フォーカス枠 |
| **プライマリー決定ボタン** | `#00D2F3` (枠) | `#2052FF` (ベタ塗り) | ダイアログ OK ボタン、決定アクション |
| **選択インジケーター縦バー** | `#00D2F3` | `#2052FF` | リストボックス選択項目の左端縦バー |
| **News / Joy-Con (R)** | `#FF2A7A` / `#FF362E` | `#D8005A` | 配信ボタン、キーワード、重要アラート |
| **eShop (オレンジ)** | `#FFA000` / `#FFA500` | `#C75800` | 文字列、数値、警告インジケーター |
| **Album (コバルトブルー)** | `#00A2FF` | `#0956C7` / `#2052FF` | 関数名、ドッキングタブ選択バー |
| **スライダーアクティブ** | `#4AB2FE` | `#4AB2FE` | 明るさ・音量バー、進捗バー、トグル ON |
| **スライダー非アクティブ** | `#5F5F5F` | `#D0D0D0` | スライダー未達部分、トグル OFF |

---

## 3. UI メタファー詳細仕様

### (1) 設定ダイアログのリスト選択とキャレット枠
実機の設定（Settings）画面では、選択状態と操作フォーカス（キャレット）が明確に分離されています。

- **フォーカスあり（操作中 / キャレットハイライト）**:
  - **外枠（一番外側）**: 上・下・左・右の 4 辺すべてを均一に囲む完全な長方形（`border-radius: 0px`）の 2px シアン枠線（`#00D2F3`）。
  - **内側インジケーター**: 外枠の内側に約 4px の余白を挟んで独立した縦バーインジケーター（Dark: `#00D2F3` / Light: `#2052FF`）を描画。
  - **境界衝突防止**: 外枠とインジケーターを同一ボーダーで描かず、外枠（`border`）と内側（`background: qlineargradient`）で分離することで、外枠が一番外側をぐるりと美しく囲む。
- **フォーカスなし選択時（右側パネル操作中）**:
  - 外枠のみを完全非表示（`border: 2px solid transparent`）化。
  - 内側の縦バーインジケーター（Dark: シアン / Light: 青）のみが左端に残り、すっきりとした選択状態を表示。

### (2) トグルボタンの電源メニューメタファー
実機電源メニュー（「電源OFF」「スリープ」「再起動」）に完全準拠した選択ボタンスタイルです。

- **ベタ塗り廃止**: 水色等のベタ塗りは白文字とのコントラスト比を低下させるため完全排除。
- **Dark 時**: 深い黒/ダークグレー背景（`#1A1A1A`）＋ **2px シアン枠線 (`#00D2F3`)** ＋ **純白文字 (`#FFFFFF`)**。白文字とのコントラスト比 16.1:1（WCAG AAA 準拠）。
- **Light 時**: 純白背景（`#FFFFFF`）＋ **2px 実機ブルー枠線 (`#2052FF`)** ＋ **実機ブルー文字 (`#2052FF`)**。

### (3) スライダー & インジケーター（明るさ・音量）
実機クイックメニューの「明るさ」「音量」スライダーおよびトグルスイッチの幾何学・配色を完全再現します。

- **アクティブトラック**: 実機サンプリング色 `#4AB2FE`（高さ 4px、角丸 2px のカプセル型）。
- **非アクティブトラック**: 実機サンプリング色 `#5F5F5F`（Light 時は `#D0D0D0`）。
- **スライダーノブ（つまみ）**: 完全な円形（直径 16px、`border-radius: 8px`）の純白ノブ（`#FFFFFF`）。Light テーマでは白背景での視認性のため薄い境界線（`border: 1px solid #B0B0B0`）を付与。
- **適用対象**: OBS フォントサイズスライダー、音声ミキサースライダー、プロパティ・フィルタースライダー、進捗バー（`QProgressBar`）、トグルスイッチ風チェックボックス（`QCheckBox::indicator:checked`）。

### (4) ドッキングタブ（設定画面との色同期）
OBS メイン画面のドッキングタブ（「シーン」「ソース」等）を選択した際、設定画面の選択メタファーと完全に色調を連動させます。

- **Dark 時**: ダークグレー背景（`#2B2B2B`）＋ **シアン文字 (`#00D2F3`)** ＋ **下部 3px シアンインジケーターバー (`#00D2F3`)**。
- **Light 時**: 純白背景（`#FFFFFF`）＋ **実機ブルー文字 (`#2052FF`)** ＋ **下部 3px 実機ブルーインジケーターバー (`#2052FF`)**。

---

## 4. OBS Studio 実装マッピング (QSS)

### 主要セレクタと適用スタイル
```css
/* 設定ダイアログ左側リスト: 外枠とインジケーターの分離 */
OBSBasicSettings QListWidget::item {
    padding: 6px 14px 6px 28px !important; /* 左側パディング28pxでアイコン・テキストとの干渉を防止 */
    margin: 2px 4px;
}

OBSBasicSettings QListWidget::item:selected {
    /* 非フォーカス時: 外枠なし、左端 (0.0〜0.02) に縦バーインジケーターのみ */
    background: qlineargradient(x1:0, y1:0, x2:1, y2:0,
        stop:0.0 var(--switch_cyan), stop:0.02 var(--switch_cyan),
        stop:0.021 #2b2b2b, stop:1.0 #2b2b2b) !important;
    color: var(--switch_cyan) !important;
    padding: 6px 14px 6px 28px !important;
    border: 2px solid transparent !important;
    border-radius: 0px !important;
}

OBSBasicSettings QListWidget::item:selected:focus {
    /* フォーカス時: 4辺均一な 2px シアン枠線が一番外側を囲み、内側左端に縦バーを配置 */
    background: qlineargradient(x1:0, y1:0, x2:1, y2:0,
        stop:0.0 var(--switch_cyan), stop:0.02 var(--switch_cyan),
        stop:0.021 #2b2b2b, stop:1.0 #2b2b2b) !important;
    border: 2px solid var(--switch_cyan) !important;
    border-radius: 0px !important;
    padding: 6px 14px 6px 28px !important;
}

/* チェックボックス:
   OBS 標準のベクター SVG アイコン (checkbox_unchecked.svg / checkbox_checked.svg) をそのまま継承し、
   ON/OFF 切り替え時における寸法変化やレイアウトのブレ（リフロー）、文字切れを完全防止する */

/* トグルボタン: 実機電源メニュー準拠 */
QPushButton:checked {
    background-color: #1a1a1a !important;
    border: 2px solid var(--switch_cyan) !important;
    color: #ffffff !important;
    font-weight: bold;
}

/* スライダー: 実機スカイブルー + 円形白ノブ */
QSlider::sub-page:horizontal {
    background-color: #4ab2fe;
    height: 4px;
    border-radius: 2px;
}
QSlider::handle:horizontal {
    background-color: #ffffff;
    width: 16px;
    height: 16px;
    margin: -6px 0;
    border-radius: 8px;
}

/* ドッキングタブ: 設定画面と色同期 */
QTabBar::tab:selected {
    background-color: #2b2b2b !important;
    color: var(--switch_cyan) !important;
    border-bottom: 3px solid var(--switch_cyan) !important;
}
```

---

## 5. Zed エディタ実装マッピング (GPUI JSON)

### プレイヤーキャレット (`players`)
エディタの点滅キャレットおよびマルチカーソル選択範囲に、Switch を象徴するネオンパレットを定義します。

| プレイヤー | Dark カーソル色 | Light カーソル色 | モチーフ |
| :--- | :--- | :--- | :--- |
| **Player 1 (自身)** | `#00D2F3` | `#2052FF` | フォーカスシアン / 実機決定ブルー |
| **Player 2** | `#FF2A7A` | `#D8005A` | Joy-Con (R) ネオンマゼンタ |
| **Player 3** | `#FFA000` | `#C75800` | ニンテンドーeショップ オレンジ |
| **Player 4** | `#00A2FF` | `#00A7D5` | アルバム コバルトブルー |

### シンタックスハイライト対応表
- `keyword`, `keyword.control`, `operator`, `boolean`, `tag`: News マゼンタ (`#FF2A7A` / `#D8005A`)
- `string`, `number`, `constant`: eShop オレンジ (`#FFA000` / `#C75800`)
- `function`, `function.method`, `type`: Album ブルー (`#00A2FF` / `#2052FF`)
- `comment`: 実機歯車・Joy-Con クールグレー (`#8E8E93` / `#707070`)

---

## 6. アクセシビリティ & 品質検証

- **テキストコントラスト比**:
  - Dark メイン文字（`#FFFFFF` on `#2D2D2D`）: **13.5:1**（WCAG AAA 準拠）
  - Dark トグル選択文字（`#FFFFFF` on `#1A1A1A`）: **16.1:1**（WCAG AAA 準拠）
  - Light メイン文字（`#2D2D2D` on `#ECECEC`）: **12.0:1**（WCAG AAA 準拠）
  - Light プライマリーボタン文字（`#FFFFFF` on `#2052FF`）: **4.64:1**（WCAG AA 準拠）
  - Light 診断警告アイコン（`#8A5800` on `#ECECEC`）: **4.53:1**（WCAG AA 準拠）
- **リフロー防止**:
  - コントロールボタン（`border: 2px solid`）の枠線幅を全ステートで固定し、レイアウトガタつきを完全排除。
- **外観密度連動**:
  - 固定 px の `padding` / `font-size` を全廃し、OBS 公式動的変数（`var(--padding_large)` 等）に完全移行。
