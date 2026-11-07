---
name: obs-theme-authoring
description: Create, customize, and style themes for OBS Studio. Covers OBS theme architecture (.ovt and .qss), Qt StyleSheet selectors, core widget object names (OBSBasic, controls, mixer, status bar), dialog structures, and OS installation paths.
---

# OBS Studio テーマ作成・カスタマイズ総合ガイド (OBS Theme Authoring)

OBS Studio 向けカスタムテーマ（`.ovt` / `.qss`）の構造、主要ウィジェットのオブジェクト名、ダイアログのスタイリング手法、配布パスを網羅した実践ガイドです。

> [!NOTE] 関連スキルとの連携
> - **Qt スタイルシート（QSS）の共通トラブルシューティング**: 擬似状態フォールバック（無効時アイコン同化）、特異度トラップ、セレクタ仕様違反、スクロールバー境界セパレータ等の低レイヤーな QSS デバッグは [`qt-stylesheet-troubleshooting`](file:///e:/obs-studio-theme/.agents/skills/qt-stylesheet-troubleshooting/SKILL.md) を参照してください。
> - **レトロハード & クラシック OS のメタファー設計論**: ゲームボーイ、ファミコン、Windows 98/2000、Windows XP などの実機パレット抽出・成型パーツ色分離原則は [`retro-ui-metaphor-design`](file:///e:/obs-studio-theme/.agents/skills/retro-ui-metaphor-design/SKILL.md) を参照してください。

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
| `categories` (`listWidget`) | `QListWidget` | 設定カテゴリのサイドバー（`OBSBasicSettings QListWidget#categories`） |
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

## 5. OBS 固有のウィジェット階層とセレクタ仕様

### (1) ソースツリー（SourceTreeItem / OBSSourceLabel）の階層構造
OBS 28+ のソースツリーは `QListView` をベースに、各行へ `SourceTreeItem`（`QFrame` 継承）、その内部に `OBSSourceLabel`（`QLabel` 継承）を配置しています。

```css
/* 通常時（未選択時） */
SourceTreeItem,
SourceTreeItem QLabel,
OBSSourceLabel {
    color: var(--text) !important;
}

/* 選択時: Qt標準のサブコントロール状態のみで制御する */
QListView::item:selected,
SourceTree::item:selected {
    background-color: var(--selection_bg) !important;
    color: #FFFFFF !important;
}
```

### (2) ステータスバー（OBSBasicStatusBar / StatusBarWidget）の完全文字色保護
画面下部の録画時間、ビットレート、CPU、FPS、左下メッセージが薄色化・白飛びするのを防ぐため、内部コンテナウィジェットのラベルまで網羅して指定します：

```css
OBSBasicStatusBar,
OBSBasicStatusBar *,
StatusBarWidget,
StatusBarWidget *,
StatusBarWidget QLabel,
QStatusBar,
QStatusBar QLabel,
QStatusBar::item {
    color: var(--text) !important;
}
```

### (3) 水平ミキサーのトラック分離
水平ボリュームコントロール（`#hVolumeWidgets VolumeControl`）に下線と適切なパディングを付与し、各チャンネルの目盛り数値（dB）が次チャンネルのタイトル行に被らないようにします：

```css
#hVolumeWidgets VolumeControl {
    padding: 4px 6px 8px 6px;
    border-bottom: 1px solid var(--border_color);
}
```

### (4) プレビュー外周・ベゼルカバーの独立色指定
プレビュー画面の余白領域（`canvasEditor` や `preview` 背景）は、テーマ背景とは切り離して `--bg_preview` 変数で独立制御し、実機のベゼルやモニター枠としての没入感を確保します。

---

## 6. カスタムアイコン・画像アセットの管理階層と衛生性（Hygiene）ルール

OBS Studio のカスタムテーマで独自の SVG や PNG 画像アセットを使用する場合、ファイル散乱を防ぎ保守性を最大化するため、以下のディレクトリ階層ルールを厳守します。

### (1) テーマルート直下の衛生性（Hygiene 原則）
- **禁止事項**: `obs-studio/themes/` 直下に個別の画像ファイル（`foo.svg`, `bar.png` 等）を直接配置してはなりません。
- **原則**: テーマ直下に存在してよいのは、**`.ovt` ファイル** と **アセット格納用サブディレクトリ** のみです。

```
obs-studio/themes/
  ├── Yami_FamilyComputer.ovt
  ├── Yami_Gameboy.ovt
  ├── Yami_Luna.ovt
  ├── Yami_SuperFamicom.ovt
  ├── Yami_WindowsClassic.ovt
  └── classic/                  ← 専用サブディレクトリに完全集約
      ├── up.svg
      ├── up_disabled.svg
      ├── down.svg
      ├── down_disabled.svg
      ├── slider_h.svg
      └── slider_v.svg
```

### (2) サブディレクトリ集約と命名規則
- **冗長プレフィックスの排除**: ディレクトリ名（例: `classic/`）でスコープが明確なため、ファイル名に `classic_up.svg` のようなプレフィックスを付けず、`up.svg` や `down_disabled.svg` のように簡潔・明瞭に命名します。
- **QSS 内の参照構文**:
  OBS の `theme:` 仮想スキームはサブディレクトリ解決に対応しています。以下のように記述します：
  ```css
  QSpinBox::up-arrow {
      image: url(theme:classic/up.svg);
  }
  QSpinBox::up-arrow:disabled {
      image: url(theme:classic/up_disabled.svg);
  }
  QSlider::handle:horizontal {
      image: url(theme:classic/slider_h.svg);
  }
  ```

### (3) インストーラースクリプトとの連動
アセットをサブディレクトリに集約することで、`install.ps1` や `install.sh` のインストール対象リストに画像ファイルを 1 枚ずつ追加・更新する手間が省け、ディレクトリを 1 つ指定するだけで安全に一括再帰コピーが可能になります：
```powershell
$themeFiles = @(
    "Yami_SuperFamicom.ovt",
    "Yami_FamilyComputer.ovt",
    "Yami_Gameboy.ovt",
    "Yami_Luna.ovt",
    "Yami_WindowsClassic.ovt",
    "classic"    # ディレクトリごと一括再帰コピー
)
```
