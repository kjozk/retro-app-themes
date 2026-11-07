---
name: retro-ui-metaphor-design
description: Design principles and color palette extraction for retro hardware and classic OS UI themes (Gameboy, Famicom, Super Famicom, Windows 98/2000 Classic, Windows XP Luna). Covers pixel palette extraction, molding vs. silk-print separation, bezel vs. screen metaphors, and 3D bevel geometry.
---

# レトロハードウェア & クラシック OS UI メタファー設計ガイド (Retro UI Metaphor Design)

実在のハードウェア（ゲーム機・AV機器・シンセサイザー等）やクラシック OS をモチーフにした UI テーマ（OBS Studio, Zed エディタ, VS Code 等）を制作する際、**「実機特有のリアリティ」** と **「現代の作業用 UI としての優れた可読性（WCAG AAA 準拠）」** を高次元で両立させるための設計思想・手法です。

---

## 1. 成型パーツ色と印字・ロゴ色の厳格な分離

### 原則
**ボタンやキーパーツに「印字・ロゴ色」を使ってはならない。**
実機に存在しない成型色のボタン（例: 印字やロゴが紫だからといってボタン自体を紫にする等）を作ると、玩具のような安っぽさが生じ、コントラスト設計も破綻します。

- **ボタン・スイッチ・つまみ**: 実機成型色（プラスチック成型色、ラバー色、金属色）をマッピングする。
- **テキスト・アイコン・刻印**: シルク印刷されたテキスト印字色やロゴ色をマッピングする。
- **効果**: 「実機パーツの上に文字が刻印されている」リアリティと、極めて明快なコントラスト比（7.0:1 以上）が成立します。

---

## 2. ベゼルカバー（外枠）とスクリーン（画面）の役割分担

### 原則
ディスプレイ画面を持つ機器（ゲームボーイ、CRTモニター等）を模す場合、画面色と筐体色の境界を厳格に定義します。

1. **プレビュー外周・メイン領域（ベゼルカバー樹脂色）**:
   プレビュー画面の外周は、ディスプレイ画面そのものの色ではなく、画面を覆う「ベゼルカバー樹脂色（スレートグレー等）」を当てます。
2. **液晶・CRT画面メタファー（小型サブディスプレイ）**:
   ディスプレイ画面を模したカラー（STNグリーン、モノクロ液晶、CRTアンバー等）は、設定サイドバーやソースリスト、入力ボックスなどの「四角い情報表示コンテナ」に適用し、小型サブディスプレイとしての没入感を演出します。
3. **画面メタファー領域内への異物混入防止**:
   画面表示を模したコンテナ内部には、ボタン色などの外部パーツカラーを持ち込まず、スクリーンの階調（明ハイライト、暗ドット）や同系色の枠線で完結させます。

---

## 3. 実機画面からのパレット抽出手法（テトリス実機 STN 液晶の例）

ゲームボーイ（DMG-01）などのレトロ液晶を再現する際は、実機写真・実機プレイ映像のピクセルを解析し、以下の 4〜5 段階の階調パレットを導出します：

| 役割 | カラーコード | 説明 |
| :--- | :--- | :--- |
| **ベース液晶背景** | `#8cad28` (RGB: 140, 173, 40) | 未点灯ドットの黄緑液晶色。リスト・入力欄の通常背景。 |
| **最暗ドット前景色** | `#214231` (RGB: 33, 66, 49) | 点灯ドットの最暗色。通常テキスト・アイコン・確定枠線。 |
| **ホバー時背景** | `#9ec03e` (RGB: 158, 192, 62) | マウスホバー時の明オリーブ。枠線は `#709428`。 |
| **確定選択・フォーカス** | `#bce248` (RGB: 188, 226, 72) | 最高明度のオリーブゴールド。選択テキストは `#214231` を維持。 |
| **無効状態 (Disabled)** | `#6e8620` (RGB: 110, 134, 32) | 沈んだオリーブ。文字色は `#3e5020`。 |

### 入力フォーム群への完全同期
リストボックスだけでなく、テキスト入力欄（`QLineEdit`）、コンボボックス（`QComboBox`）、スピンボックス（`QSpinBox`）にも同一の画面パレット（通常・ホバー・フォーカス・選択・無効）を一貫して適用することで、画面全体の統一感とメタファーの説得力が完成します。

---

## 4. クラシック OS の 3D ベベル幾何学 (Windows 98/2000 Classic)

1990 年代の Windows クラシック UI は、4 色の基本システムカラーによる光と影の組み合わせで立体感を表現します。

| 変数名 | 定義色 | 役割 |
| :--- | :--- | :--- |
| `--win_bg` | `#D4D0C8` | ウィンドウ・ボタンの基本グレー背景 |
| `--win_hilight` | `#FFFFFF` | 左上から当たる光のハイライト（外側明線） |
| `--win_shadow` | `#808080` | 右下に落ちる影（内側暗線） |
| `--win_darkshadow` | `#404040` | 右下の最深部シャドウ（外側暗線） |

### 凸ボタン（Raised）と 凹入力欄（Sunken）の立体ルール
- **凸ボタン（通常時）**:
  `border-top: 2px solid var(--win_hilight); border-left: 2px solid var(--win_hilight); border-right: 2px solid var(--win_darkshadow); border-bottom: 2px solid var(--win_darkshadow);`
- **凸ボタン（押下時 / Pressed）**:
  光と影が反転し、ボタンが押し込まれたように見せる。
  `border-top: 2px solid var(--win_darkshadow); border-left: 2px solid var(--win_darkshadow); border-right: 2px solid var(--win_hilight); border-bottom: 2px solid var(--win_hilight);`
- **凹入力欄（テキストボックス・リスト）**:
  常時へこんだ枠線（Sunken ベベル）。
  `border-top: 2px solid var(--win_shadow); border-left: 2px solid var(--win_shadow); border-right: 2px solid var(--win_hilight); border-bottom: 2px solid var(--win_hilight);`

---

## 5. Windows XP Luna の光彩とプラスチック質感

- **シルバー白グラデーション**: ボタン通常時は白からシルバーへの繊細な立体グラデーション（`#FFFFFF` → `#ECE9D8` → `#D8DEE6`）。
- **ゴールド光彩ホバー**: マウスホバー時にオレンジ〜ゴールドの光彩（`#E68B2C`, `#FFEBB8`）を付与。
- **ロイヤルブルーのフォーカス**: 入力欄や確定ボタン（OK・閉じる）に鮮やかな XP ロイヤルブルー（`#0055EA`）のアクセント。
- **フォント**: 日本語 UI では `'MS UI Gothic', 'Tahoma', 'Meiryo UI', sans-serif` を最優先に指定。
