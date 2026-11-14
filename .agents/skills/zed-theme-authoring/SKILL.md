---
name: zed-theme-authoring
description: Create, customize, debug, and install Zed editor themes. Covers Zed theme schema (v0.2.0), OS-specific directory structures (Windows %APPDATA% vs macOS/Linux ~/.config), GPUI component color resolution mechanisms (text, icon, element, ghost_element), and practical authoring best practices.
---

# Zed テーマ作成・カスタマイズ総合ガイド (Zed Theme Authoring)

Zed エディタのカスタムテーマを作成・編集・デバッグ・配布するための汎用実践ノウハウ集です。

---

## 1. ディレクトリ構造とテーマ配置パス (OS別仕様)

Zed は OS によってテーマファイルおよび設定ファイルの探索パスが異なります。

| OS | テーマ配置ディレクトリ | 設定ファイル (`settings.json`) |
| :--- | :--- | :--- |
| **Windows** | **`%APPDATA%\Zed\themes\`**<br>(`C:\Users\<ユーザー名>\AppData\Roaming\Zed\themes\`) | `%APPDATA%\Zed\settings.json` |
| **macOS** | **`~/.config/zed/themes/`** | `~/.config/zed/settings.json` |
| **Linux** | **`~/.config/zed/themes/`**<br>(または `$XDG_CONFIG_HOME/zed/themes/`) | `~/.config/zed/settings.json` |

> [!IMPORTANT]
> **Windows 版の重要な落とし穴**:
> Windows 版 Zed は `~/.config/zed/themes/` ではなく、**`%APPDATA%\Zed\themes\`** を最優先かつ標準として読み込みます。
> `.config` 側に配置しても認識されない、あるいは `%APPDATA%` 側に古いファイルが残っているとそちらが優先され、編集内容が画面に反映されない原因となります。

---

## 2. テーマファイル構造 (`v0.2.0` スキーマ)

Zed のテーマは 1 つの JSON ファイル（拡張子 `.json`）で構成され、複数のテーマバリアント（Light、Dark、Blurred 等）をまとめて定義できます。

公式スキーマ: `https://zed.dev/schema/themes/v0.2.0.json`

### 基本構造
```json
{
  "$schema": "https://zed.dev/schema/themes/v0.2.0.json",
  "name": "My Theme Family",
  "author": "Your Name",
  "themes": [
    {
      "name": "My Theme Light",
      "appearance": "light",
      "style": { ... }
    },
    {
      "name": "My Theme Dark",
      "appearance": "dark",
      "style": { ... }
    },
    {
      "name": "My Theme Light [Blurred]",
      "appearance": "light",
      "style": {
        "background.appearance": "blurred",
        ...
      }
    }
  ]
}
```

### テーマ名の命名規則と設定ファイルの連動
- 日本語を含む任意の Unicode（UTF-8）文字列をテーマ名として使用可能。
- `settings.json` の `"theme"` で指定する文字列と、テーマ定義内の `"name"` は**完全一致**している必要があります。
  ```json
  "theme": {
    "mode": "light",
    "light": "My Theme Light",
    "dark": "My Theme Dark"
  }
  ```
- 名前が一致しない場合、Zed はデフォルトテーマ（One Light / One Dark 等）へフォールバックします。

---

## 3. GPUI コンポーネントのカラー解決ロジック (最重要ノウハウ)

Zed の UI フレームワーク（GPUI）では、テーマの各トークンがどの UI 要素に適用されるか固有のルールと制約が存在します。

### (1) ステータスバー・タイトルバー・Markdown Preview の文字色問題 (共通トークンの制約)
- スキーマには `status_bar.background` や `title_bar.background` が存在しますが、**`status_bar.text` や `title_bar.text` などの個別文字色プロパティは存在しません**。
- ステータスバー内の行番号・言語表示・各種アイコンボタン、およびタイトルバー内のプロジェクト名・ブランチ名ボタンは、内部実装で `Button::new` 経由のデフォルト色（`Color::Default` = **`style.text`**）または `Color::Muted`（**`style.text.muted`**）がそのまま適用されます。
- **さらに重要な落とし穴 (Markdown Preview の白飛び)**:
  - Zed の **Markdown Preview（プレビュー画面）の本文・見出し・テーブル文字色も、テーマ全体の `style.text` を直接参照します**。
  - ライトテーマでステータスバーを白文字にしようとして `text: #FFFFFF`（白）に設定すると、Markdown プレビューの白背景上で文字が完全に白飛びして読めなくなります。
  - したがって、**ライトテーマ（`appearance: "light"`）では `text` は必ず暗色（黒〜濃チャコール）でなければなりません**。

### (2) Light テーマと Dark テーマの役割分担パターン (GPUI 思想への適合)
「濃い象徴色（えんじ色、ネイビー、ブランドカラー等）をバーに敷いて白文字でくっきり見せたい」という要求がある場合、Light と Dark で役割を分担するのが最も美しく破綻しない設計パターンです。

| テーマ種別 | 配色方針 | バー（ステータス/タイトル） | 文字色 (`text`) | 象徴色（アクセント）の配置 |
| :--- | :--- | :--- | :--- | :--- |
| **Light** (`light`) | 清潔感・可読性重視<br>（本体成型色、アイボリー等） | 中間色〜明色<br>（真鍮ゴールド、ライトグレー等） | **暗色（黒）**<br>※Preview白飛び防止 | アイコン、フォーカス枠線、リンク、タグ等 |
| **Dark** (`dark`) | 重厚感・高コントラスト重視<br>（黒カセット、コントローラー等） | **濃い象徴色**<br>（えんじ色、ネイビー等） | **明色（白/アイボリー）** | 真鍮ゴールド、イエロー等の金属色アイコン |

- **Dark テーマの優位性**:
  - `appearance: "dark"` では Markdown Preview も暗色背景になるため、全体文字色 `text` を白に設定してもプレビューが白飛びしません。
  - これにより、「ステータスバーやタイトルバーが濃色 × 文字が白」という高コントラストなデザインを副作用ゼロで実現できます。

### (3) 左右パネルの背景色共通化の制約
- 左側のドック（Agent スレッド、アウトライン等）と、右側のドック（プロジェクトパネル、ターミナル等）は、すべて同一の **`panel.background`** を参照します。
- 「左パネルだけをグレーにして、右パネルだけをアイボリーにする」といった左右個別の塗り分けは、現行の Zed スキーマでは不可能です。

### (4) トグルボタンの ON / OFF 状態と実機ボタンメタファー
- トグルスイッチや選択トグルボタン（検索バーの `Aa` や `.*`、ピン留め等）:
  - **OFF 状態**: `icon`（通常アイコン色）または `Color::Muted`（`text.muted`）
  - **ON 状態**: `Color::Accent`（**`text.accent`** / **`icon.accent`**）
  - **トグル背景**: `ghost_element.selected` や `element.selected`
- **設計指針 (ハードウェア・メタファー)**:
  - 通常時（OFF）を「本体ロゴ色や通常文字色」にし、選択時（ON）を「実機ボタン色（例: ゲームボーイの小豆色 `#8E1E4F`）」に割り当てることで、ボタンを押し込んで点灯したような直感的で気持ちのよい状態変化を演出できます。
  - `text.accent` は白背景・暗色背景の双方に対してコントラスト比 4.5:1 以上（推奨 7:1 以上）を保つ色を選択してください。

### (5) 入力ボックス・ドロップダウン・設定画面 (`element.*`)
- **`element.background`**: 設定画面（Settings）のドロップダウン、数値入力ボックス、トグルスイッチの基本背景。
- **`element.hover`** / **`element.active`**: ホバー・押下時の背景。
- **`element.selected`**: 選択中の背景。
- ⚠️ `element.background` を暗色に設定すると、白背景の設定画面でドロップダウンが真っ黒な四角いブロックになり、内部のテキストが読めなくなります。ライトテーマでは必ず明るい成型色・ニュートラルトーン（`#EFECE4` 等）に設定してください。

### (6) エディタ領域と UI の独立性
- **`editor.foreground`**: エディタ内の通常コードの文字色（UI 全体の `text` とは完全に独立）。
- **`editor.background`**: エディタの背景色（Blurred バリアントでは透明化）。
- **`editor.gutter.background`**: 行番号領域（ガター）の背景色。
- **`editor.line_number`** / **`editor.active_line_number`**: 行番号・現在行番号の文字色。

### (7) プロジェクトパネルの Sticky Scroll（固定ヘッダー）と overlay_*
- **現象**: プロジェクトパネル（ファイルツリー）で階層をスクロールした際、祖先ディレクトリが上部にピン留め（Sticky Scroll）されます。このとき、テーマに `panel.overlay_background` が未定義だと、ライトテーマであっても背景色が真っ黒（デフォルト値 `#000000` 等）になり、ファイルツリー上部に黒い帯が浮いてしまう現象が発生します。
- **内部解決ロジック**: Zed の `project_panel` では、`is_sticky` 状態のアイテム背景に `colors.panel_overlay_background`、ホバー時に `colors.panel_overlay_hover` を参照します。
- **対処法と透過トラップ（注意点）**:
  - `panel.overlay_background`: **必ずアルファ値を含まない完全不透明色（6桁HEX: 例 `#E2E5EA`）を指定してください**。すりガラス（Blurred）バリアントだからといって半透明（8桁HEX: `#E2E5EACC` 等）を指定すると、Sticky ヘッダーの下にスクロールして潜り込んだファイル名・フォルダ名のテキストが透けて二重に重なり、文字が判読不能になる「ゴースト描画」が発生します。
  - `panel.overlay_hover`: `element.hover` や `ghost_element.hover` と揃えることで、ホバー時の視認性を担保します。

### (8) すりガラス（Blurred）Light テーマにおける「透明白（#FFFFFF00）」必須ルール
- **現象**: すりガラス（Blurred）テーマでエディタ領域を透明化する際、安易に `#00000000`（透明黒）を指定すると、**Markdown プレビュー内の Mermaid ダイアグラム（クラス図・フローチャート等）のボックス内文字が真っ黒に沈んで読めなくなる致命的なバグ**が発生します。
- **内部解決ロジック**:
  - Zed の Mermaid レンダラー（`mermaid_render` クレート）は、ダイアグラム内の各ノード背景色を生成する際、アクセントカラーと `colors.editor_background` を `blend_over_background` 関数で内部ブレンド（15% アクセント + 85% 背景色）します。
  - ここで `editor_background` に `#00000000`（RGBがすべて0）が渡されると、アルファ値（`00`）を無視して RGB のみで計算されるため、**85% の「純黒（#000000）」とブレンドされた超暗黒色（濃紺・暗黒緑・暗赤等）のボックス**が生成されてしまいます。
  - Light テーマの文字色 `text` は黒（`#181A1F` 等）であるため、「ほぼ真っ黒なボックスに黒文字が乗る」状態となり、可読性が完全に崩壊します。
- **対処法**:
  - **Light テーマの Blurred バリアントでは、エディタ透明色に必ず白ベースのカラー（`#FFFFFF00` や成型色 `#F3F5F7F0` 等）を指定してください**。
  - これにより、Mermaid レンダラーの内部計算で白ベースの明るいパステルカラー（明度90%以上）がブレンド生成され、黒文字が鮮明に読めるようになります。

### (9) Windows Aero / Fluent Design スタイルの透過バランス設計（外枠アクリル × 本文オクルージョン）
- **思想と設計比率**:
  Windows Aero（キャプションバー透過）や Windows 11 の Mica/Acrylic における基本思想は、「**外枠（非クライアント領域）を美しく透かし、作業領域（本文・クライアント領域）は文字の可読性を最優先して透過率を抑える**」というコントラスト設計です。
- **Zed テーマにおける推奨アルファ設計**:
  - **タイトルバー (`title_bar.background`)**: `8C`（約55% 不透明度）〜 `99`（約60% 不透明度）。背後の壁紙やすりガラス効果がはっきりと確認できるティンテッド・アクリル調。
  - **ステータスバー (`status_bar.background`)**: `8C`（約55% 不透明度）。ウィンドウ下部を美しく引き締めるフレームすりガラス。
  - **メイン作業領域 (`editor.background`, `terminal.background`)**: `F0`（約94% 不透明度）。背後の壁紙のギラつきを完全にシャットアウトし、エディタ本来の快適なコード読み書きを担保。
  - **サイドパネル (`panel.background`)**: `E6`（約90% 不透明度）。外枠の透明感と中央エディタを自然に繋ぐ中間階調。

---

## 4. 実機ハードウェア再現テーマの設計技法 (Hardware Metaphor)

ハードウェア（家庭用ゲーム機、携帯機、計測機器等）をモチーフにしたカスタムテーマを設計する際は、以下の構造化マッピングと原則を適用します。

### (1) 実機パーツと UI トークンのマッピング原則
実機の構造をエディタのレイアウトに対応させます：

| 実機パーツ | 役割 | Zed UI トークン | 設計指針 |
| :--- | :--- | :--- | :--- |
| **本体外枠（ボディ成型色）** | 外側の土台 | `background`, `panel.background` | プラスチック成型色（アイボリー、ライトグレー、オフホワイト等） |
| **画面ベゼル（液晶枠 / スロット）** | 境界・フレーム | `title_bar`, `status_bar`, `tab_bar` | スレートグレー、画面枠のダークグレーなど、エディタを引き締める中間色 |
| **ディスプレイ（画面・液晶）** | 情報表示領域 | `editor.background` | 液晶画面の背景色や、クリーンなペーパーホワイト等 |
| **操作パーツ（ボタン・スイッチ）** | アクセント | `icon`, `border.focused`, `element.selected` | A/Bボタン、十字キー、POWERスイッチ等の象徴色 |
| **インジケーター（LED・ロゴ）** | 状態通知 | `version_control.*`, `warning`, `error` | バッテリーランプ、公式ロゴのマルチカラー等 |

### (2) 大面積ベースと小面積アクセントの黄金比 (9:1 の法則)
- **大面積（90%）**: 実機ボディ・ベゼル・スロット等のインダストリアルな成型色（2〜3トーンのグレーやアイボリー）。
- **小面積（10%）**: アイコン、フォーカス枠、Git インジケーター等の象徴色。
- ⚠️ 実機に存在しない大きな有彩色帯（例: 画面全体を覆うような派手な青や赤のバー）を敷くと、おもちゃ感が出たり、他のブランドに見えてリアリティが損なわれます。

### (3) 有彩色ベース（液晶グリーン・アンバー等）のコントラストと実用性設計
初代ゲームボーイのオリーブグリーン液晶（`#8C9E5B`）のように、白でも純黒でもない有彩色をモチーフにする場合の設計ルール：

1. **Light テーマの実用性優先原則（エディタ背景は白ベース）**:
   - エディタ背景全面を有彩色（オリーブグリーン等）で塗りつぶすと、長時間のコード編集や Markdown プレビューで視覚的負荷が大きく「癖が強すぎる」状態になります。
   - したがって、Light テーマでは**エディタ背景をクリーンな白（成型色オフホワイト／ペーパーホワイト）**に設定し、液晶オリーブグリーンは「検索一致（`search.match_background`）」「Git 追加（`version_control.added`）」などの機能的ハイライトとして要所に活かすのが最も洗練された設計です。
2. **非アクティブタブの視認性担保**:
   - タブバー（`tab_bar.background` / `tab.inactive_background`）に画面枠やベゼルのグレーを濃く適用すると、非アクティブタブのファイル名（`text.muted`）が同化して読めなくなります。
   - タブバーには明るい成型色／明るいカバーグレー（`#B8BAC2` 等）を採用し、`text.muted` を濃いチャコール（`#3D424C` 等）に引き締めることで視認性を完全確保してください。
3. **Dark テーマにおける「彩度抑制（Desaturation）」原則**:
   - 背景に濃緑黒（`#14200E`）などの有彩色ダークを採用する場合、シンタックスハイライトやテキストに高彩度のネオンカラーを乗せるとギラついて可読性が低下します。
   - テキストはセージオリーブ（`#98A882`）、青紫はスレートインディゴ（`#686BA8`）、ボタン色はくすみ小豆色（`#B0426A` / `#8E1E4F`）のように、**彩度（Saturation）を抑えたビンテージトーン**に落とすことで、背景のユニークさを保ちながら目に優しい渋い高級感を生み出せます。

---

## 5. テーマの更新とホットリロード

1. **自動リロード**:
   - Zed 起動中に `%APPDATA%\Zed\themes\`（または `~/.config/zed/themes/`）内の既存 `.json` ファイルが上書き更新されると、Zed は自動的にホットリロードして画面に即座に反映します。
2. **手動で再読み込みする場合**:
   - `Ctrl + K` の後に `Ctrl + T` を押す（または `Ctrl + Shift + P` で `theme: select` を実行）。
   - テーマ一覧から対象テーマを選択し直す。

---

## 6. テーマのインストールと配布

ユーザー環境へのテーマ配布には、各OSのテーマディレクトリへ `.json` をコピーするインストーラースクリプト（Windows: PowerShell / macOS・Linux: Shell script）を同梱するのが一般的です。
※PowerShell スクリプトのエンコーディングや安全な作成ノウハウについては、`powershell-scripting` スキルを参照してください。


---

## 7. 通常（非 Blurred）バリアントでの透過黒 (#00000000) 禁止トラップ

### 現象
通常モードでターミナルやエディタサブヘッダーが完全透明になり、デスクトップが透けて見える。または Mermaid ダイアグラムのノードが黒ボックス化する。

### 原因
- #00000000（透明黒）を erminal.background / editor.subheader.background に設定すると、Blurred バリアントと同じ透過意図でも、通常モードでは背景合成が行われず黒ボックス化・ゴースト描画の原因になり得る（要実機確認）。
- 過去に発生した不具合例: 通常バリアントの terminal.background と editor.subheader.background が #00000000 になっていた。

### 対策
- **通常（非 Blurred）バリアントでは erminal.background / editor.subheader.background を必ず不透明色（6 桁 HEX）で指定する**。
- Blurred バリアントの対応色（例: #FAFAF8BF）からアルファを除いた色（#FAFAF8）を流用すると一貫性が保てる。
- Light テーマの editor.background に #00000000 を使う場合は、Mermaid レンダラー対策として白ベース透明（#FFFFFF00）を必ず使う（→ 本ガイド「3-(8)」参照）。

---

## 8. Dark テーマにおける element.selected 不透明色指定によるファイル名同化トラップ

### 現象
Project Panel（サイドバーのファイルツリー）等でファイルを選択した際、選択行の背景とファイル名の文字色が同化して文字が読めなくなる。

### 原因
Dark テーマにおいて、`element.selected`（選択行の背景色）に不透明なアクセントカラー（例: 不透明ゴールド `#CEA56B` や不透明ライトグレー `#9F9A9A`）を指定すると、ダークテーマ用の明るいテキスト色（`#FFFFFF`, `#F2EDE0` 等）との明度差が失われ、コントラストが著しく低下します。

### 対策
**`element.selected` および `ghost_element.selected` には、必ず 20%〜35% 程度のアルファ透過（HEX 末尾 33〜55）を指定** します。ベース背景の色味を適度に通すことで、明色テキストの視認性を確実に担保できます：

```json
/* 悪い例: 不透明ゴールドで明色テキストが溶ける */
"element.selected": "#CEA56B"

/* 良い例: 25% 透過で文字視認性を完全確保 */
"element.selected": "#CEA56B40"
```

