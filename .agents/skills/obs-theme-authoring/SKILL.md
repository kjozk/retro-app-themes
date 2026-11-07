---
name: obs-theme-authoring
description: Create, customize, and style themes for OBS Studio. Covers OBS theme architecture (.ovt and .qss), Qt StyleSheet selectors, core widget object names (OBSBasic, controls, mixer, status bar), dialog structures, and OS installation paths.
---

# OBS Studio テーマ作成・カスタマイズ総合ガイド (OBS Theme Authoring)

OBS Studio 向けカスタムテーマ（`.ovt` / `.qss`）の構造、主要ウィジェットのオブジェクト名、ダイアログのスタイリング手法、配布パスを網羅した実践ガイドです。

---

## 1. テーマアーキテクチャ (.ovt と .qss)

OBS Studio (v28+) では、Qt スタイルシート（QSS）を拡張した `.ovt`（OBS Theme）形式が採用されています。

### 基本構文
```css
@OBSThemeMeta {
    name: 'テーマ表示名';
    id: 'com.example.mytheme';
    extends: 'com.obsproject.Yami.Light'; /* 継承元テーマ (Yami / Yami.Light 等) */
    author: '作者名';
    dark: 'false';                        /* 'true' または 'false' */
}

@OBSThemeVars {
    /* テーマ内で再利用するカラーパレット変数 */
    --primary_color: #98161f;
    --accent_gold: #cea56b;
    --bg_base: #f7f6f2;
    --text: #1a1a1c;
}

/* 通常の Qt スタイルシート (QSS) 定義 */
QWidget {
    color: var(--text);
    background-color: var(--bg_base);
}
```

---

## 2. OS別テーマ配置パス

| OS | テーマ配置ディレクトリ |
| :--- | :--- |
| **Windows** | **`%APPDATA%\obs-studio\themes\`**<br>(`C:\Users\<ユーザー名>\AppData\Roaming\obs-studio\themes\`) |
| **macOS** | **`~/Library/Application Support/obs-studio/themes/`** |
| **Linux** | **`~/.config/obs-studio/themes/`** |

---

## 3. 主要 UI コンポーネントとオブジェクト名

OBS の UI は Qt で構築されており、特定のコンポーネントをターゲットにする際はオブジェクト名（`#id`）またはクラス名を使用します。

### (1) メインウィンドウ (`OBSBasic.ui`)
| オブジェクト名 | クラス | 説明 |
| :--- | :--- | :--- |
| `OBSBasic` | `QMainWindow` | メインウィンドウ本体 |
| `centralwidget` | `QWidget` | プレビューやコントロールを含む中央エリア |
| `preview` | `OBSBasicPreview` | メインのプレビュー/プログラム・キャンバス |
| `canvasEditor` | `QWidget` | プレビューエリアのコンテナ |
| `contextContainer` | `QFrame` | プレビュー下部のコンテキストボタン群コンテナ |
| `sourcePropertiesButton` | `QPushButton` | 選択ソースの「プロパティ」ボタン |
| `sourceFiltersButton` | `QPushButton` | 選択ソースの「フィルタ」ボタン |
| `sourceInteractButton` | `QPushButton` | ブラウザソース等の「相互作用」ボタン |
| `menubar` | `QMenuBar` | 上部メニューバー |

### (2) 基本コントロール (`OBSBasicControls.ui`)
| オブジェクト名 | クラス | 説明 |
| :--- | :--- | :--- |
| `streamButton` | `QPushButton` | 配信開始/終了ボタン |
| `recordButton` | `QPushButton` | 録画開始/終了ボタン |
| `pauseRecordButton` | `QPushButton` | 録画一時停止ボタン（録画中のみ表示） |
| `broadcastButton` | `QPushButton` | 配信管理ボタン（YouTube 等用） |
| `virtualCamButton` | `QPushButton` | 仮想カメラ開始/終了ボタン |
| `replayBufferButton` | `QPushButton` | リプレイバッファ開始/終了ボタン |
| `saveReplayButton` | `QPushButton` | リプレイ保存ボタン |
| `modeSwitch` | `QPushButton` | スタジオモード切り替えボタン |
| `settingsButton` | `QPushButton` | 設定ダイアログを開くボタン |
| `exitButton` | `QPushButton` | OBS 終了ボタン |

### (3) ステータスバー (`StatusBarWidget.ui`)
| オブジェクト名 | クラス | 説明 |
| :--- | :--- | :--- |
| `kbps` | `QLabel` | 現在のアップロードビットレート |
| `streamTime` | `QLabel` | 配信経過時間 |
| `recordTime` | `QLabel` | 録画経過時間 |
| `cpuUsage` | `QLabel` | 現在の CPU 負荷 |
| `fpsCurrent` | `QLabel` | 現在のフレームレート |
| `droppedFrames` | `QLabel` | ドロップしたフレーム数 |
| `statusIcon` | `QLabel` | ネットワーク状態アイコン（緑/黄/赤） |

### (4) 設定ダイアログ (`OBSBasicSettings.ui`)
| オブジェクト名 | クラス | 説明 |
| :--- | :--- | :--- |
| `listWidget` | `QListWidget` | 設定カテゴリのサイドバー |
| `settingsPages` | `QStackedWidget` | メイン設定エリアのコンテナ |
| `buttonBox` | `QDialogButtonBox` | 下部の OK / キャンセル / 適用ボタン |

### (5) ドックおよびリスト
- **シーン一覧**: ドック内リスト。`SceneTree` クラスでスタイリング。
- **ソース一覧**: ドック内リスト。`SourceTree` クラスでスタイリング。
- **音声ミキサー**: `#mixerContainer` および `#mixerArea` 配下のコンポーネント。

---

## 4. ダイアログのスタイリングと注意点

### 主要なダイアログ一覧
| ファイル名 / オブジェクト名 | 説明 |
| :--- | :--- |
| `OBSBasicAdvAudio` | 「オーディオの詳細プロパティ」ウィンドウ |
| `OBSBasicFilters` | ソースや音声デバイスの「フィルタ」管理ウィンドウ |
| `OBSBasicProperties` | ソースやデバイスの「プロパティ」設定ウィンドウ |
| `OBSBasicSourceSelect` | 新しいソースを追加する際の選択ダイアログ |
| `OBSBasicTransform` | ソースの「変換の編集」ウィンドウ |
| `OBSBasicVCamConfig` | 仮想カメラ設定ダイアログ |
| `OBSRemux` | 録画ファイルの「再多重化（Remux）」ツール |
| `OBSLogViewer` | OBS ログ表示ビューアー |
| `NameDialog` | ソース名・シーン名変更時の名前入力ダイアログ (動的構築) |

### スタイリングにおける重要ポイント
1. **動的ダイアログのスタイリング**:
   `NameDialog` のように専用の `.ui` ファイルが存在しないものは、`QDialog QLineEdit` や `QDialog QLabel` といった基本 Qt クラスセレクタでスタイリングする必要があります。
2. **ルートオブジェクト名によるスコープ指定**:
   多くのダイアログは `QDialog` を継承しており、ルートのオブジェクト名（例: `#OBSBasicProperties`）を親セレクタにすることで、特定のダイアログ内のみをターゲットにできます。
3. **Qt パレットのフォールバック防止**:
   一部の非QSSウィジェット（ネイティブ描画部分）で文字が溶け込むのを防ぐため、`@OBSThemeVars` 内で Qt システムカラー変数（`--palette_windowText` 等）を明示的に上書きするのがベストプラクティスです。

---

## 5. 実機ハードウェア・メタファー設計原則 (Hardware Metaphor Rules)

ハードウェア（ゲーム機・AV機器・シンセサイザー等）をモチーフにしたテーマを作成する際は、以下の原則を厳守します。

### (1) 成型パーツ色と印字・ロゴ色の厳格な分離
- **ボタンパーツに「印字色」を使わない**:
  実機に存在しない成型色のボタンを作ってはならない（例: 印字やロゴが紫や赤だからといって、ボタンそのものを紫や赤にしない）。
  - **ボタン・スイッチ・つまみ**: 実機成型色（プラスチック成型色、ラバー色、金属色）をマッピングする。
  - **テキスト・アイコン・刻印**: シルク印刷されたテキスト印字色やロゴ色をマッピングする。
  - この分離を守ることで、「実機パーツの上に文字が刻印されている」リアリティと高コントラストが成立する。

### (2) 画面表示と外枠（ベゼルカバー）の役割分担
- **プレビュー外周 (`--bg_preview`)**:
  プレビュー画面の外周は、ディスプレイ画面そのものの色ではなく、画面を覆う「ベゼルカバー樹脂色（スレートグレー等）」を当てる。
- **液晶・CRT画面メタファー**:
  ディスプレイ画面を模したカラー（STNグリーン、モノクロ液晶、CRTアンバー等）は、設定サイドバーやソースリストなどの「四角い情報表示コンテナ」に適用し、小型サブディスプレイとしての没入感を演出する。
- **画面メタファー領域内への異物混入防止**:
  画面表示を模したコンテナ内部には、ボタン色などの外部パーツカラー（小豆色や赤など）を持ち込まず、スクリーンの階調（明ハイライト、暗ドット）や同系色の枠線で完結させる。

---

## 6. Qt / OBS QSS スタイリングの落とし穴と回避策

### (1) 基底テーマ (`Yami.obt`) の多重擬似クラス特異度（Specificity）トラップ
基底テーマに多重擬似クラスが付与されているコントロールボタン（録画中・配信中など）は、単純なセレクタ（`.state-active` や `:hover.state-active`）では特異度で負け、ホバー時に文字色が意図せず上書きされて可読性が崩壊します。
必ず以下の高特異度セレクタを網羅して定義し、`!important` で確実に上書きしてください：
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

### (2) `SourceTree` / `SceneTree` の子要素セレクタ階層
ソースリスト内の文字・アイコン色は、`SourceTree::item:selected` だけでなく内部ウィジェットまで明示的に指定する必要があります：
```css
/* リスト内ウィジェットの通常時文字色 */
SourceTreeItem,
SourceTreeItem QLabel {
    color: var(--text) !important;
}

/* 選択時: 親の selected 状態から子要素ラベルの文字色を強制 */
SourceTree::item:selected SourceTreeItem,
SourceTreeItem:selected QLabel,
SourceTree::item:selected QLabel {
    color: var(--selected_text_color) !important;
    font-weight: bold;
}
```

### (3) `QSlider` の進捗方向定義とコンポーネント構造
水平と垂直で到達側（進捗）と未達側（溝）のセレクタが異なります：
- **水平スライダー**: `sub-page:horizontal`（左＝進捗）、`add-page:horizontal`（右＝未達溝）
- **垂直スライダー**: `add-page:vertical`（下＝進捗）、`sub-page:vertical`（上＝未達溝）
```css
/* 水平スライダー溝 (未達側ベース) */
QSlider::groove:horizontal {
    background: var(--groove_bg);
    border: 1px solid var(--groove_border);
    height: 4px;
    border-radius: 2px;
}
/* 到達側 (アクティブ進捗) */
QSlider::sub-page:horizontal {
    background: var(--accent_color) !important;
    border-radius: 2px;
}
/* 未達側 (残量) */
QSlider::add-page:horizontal {
    background: var(--groove_bg) !important;
    border-radius: 2px;
}

/* つまみ (実機操作ノブ調) */
QSlider::handle:horizontal {
    background: var(--dial_color) !important;
    border: 1px solid #ffffff;
    border-left: 2px solid var(--accent_color);
    border-right: 2px solid var(--accent_color);
    width: 12px;
    height: 20px;
    margin: -8px 0;
    border-radius: 3px;
}
```

### (4) WCAG コントラスト検証とフォント描画対策
- **アンチエイリアスによる実効コントラスト低下**:
  中間明度の背景（グレーなど）上の暗色テキストは、計算上の理論値（例: 5.5:1）を満たしていても、細いフォントストロークによるアンチエイリアスで実効知覚コントラストが半減する現象が起きます。
- **対策**:
  1. 背景色をわずかに明るく調整する。
  2. テキスト色をより濃い色（最暗インディゴや黒）に設定する。
  3. `font-weight: bold;`（または 600）を付与してストローク幅を太くし、実画面上で WCAG AAA 基準（7.0:1 以上）を確実に達成する。

