# OBS フロントエンド・コンポーネント・リファレンス

このドキュメントは、OBS Studio の `frontend/forms` ディレクトリにある主要な UI コンポーネントをリスト化したものです。テーマの拡張やカスタマイズの際の参考にしてください。

## 1. メインウィンドウ (`OBSBasic.ui`)

OBS のメインインターフェース。

| オブジェクト名 | クラス | 説明 |
|----------------|-------|------|
| `OBSBasic` | `QMainWindow` | メインウィンドウ本体。 |
| `centralwidget` | `QWidget` | プレビューやコントロールを含む中央のウィジェット。 |
| `preview` | `OBSBasicPreview` | メメインのプレビュー/プログラム・キャンバス。 |
| `canvasEditor` | `QWidget` | プレビューエリアのコンテナ。 |
| `contextContainer` | `QFrame` | プレビュー下部にある、コンテキストボタン（フィルタ、プロパティ等）の水平バー。 |
| `sourcePropertiesButton`| `QPushButton` | 選択したソースの「プロパティ」ボタン。 |
| `sourceFiltersButton` | `QPushButton` | 選択したソースの「フィルタ」ボタン。 |
| `sourceInteractButton` | `QPushButton` | ブラウザソースなどの「相互作用」ボタン。 |
| `menubar` | `QMenuBar` | 上部のメニューバー（ファイル、編集、表示など）。 |

## 2. 基本コントロール (`OBSBasicControls.ui`)

通常、右下（またはドック内）にある操作ボタン。

| オブジェクト名 | クラス | 説明 |
|----------------|-------|------|
| `streamButton` | `QPushButton` | 配信開始/終了ボタン。 |
| `recordButton` | `QPushButton` | 録画開始/終了ボタン。 |
| `pauseRecordButton` | `QPushButton` | 録画一時停止ボタン（録画中のみ表示）。 |
| `broadcastButton` | `QPushButton` | 配信管理ボタン（YouTube 等用）。 |
| `virtualCamButton` | `QPushButton` | 仮想カメラ開始/終了ボタン。 |
| `replayBufferButton` | `QPushButton` | リプレイバッファ開始/終了ボタン。 |
| `saveReplayButton` | `QPushButton` | リプレイ保存ボタン。 |
| `modeSwitch` | `QPushButton` | スタジオモードの切り替えボタン。 |
| `settingsButton` | `QPushButton` | 設定ダイアログを開くボタン。 |
| `exitButton` | `QPushButton` | OBS の終了ボタン。 |

## 3. ステータスバー (`StatusBarWidget.ui`)

ウィンドウ最下部の情報バー。

| オブジェクト名 | クラス | 説明 |
|----------------|-------|------|
| `kbps` | `QLabel` | 現在のアップロードビットレート。 |
| `streamTime` | `QLabel` | 配信経過時間。 |
| `recordTime` | `QLabel` | 録画経過時間。 |
| `cpuUsage` | `QLabel` | 現在の CPU 負荷。 |
| `fpsCurrent` | `QLabel` | 現在のフレームレート。 |
| `droppedFrames` | `QLabel` | ドロップしたフレーム数。 |
| `statusIcon` | `QLabel` | ネットワーク状態を示すアイコン（緑/黄/赤）。 |

## 4. 設定ダイアログ (`OBSBasicSettings.ui`)

詳細設定ウィンドウ。

| オブジェクト名 | クラス | 説明 |
|----------------|-------|------|
| `listWidget` | `QListWidget` | 設定カテゴリ（一般、配信など）のサイドバー。 |
| `settingsPages` | `QStackedWidget`| 選択に応じて切り替わるメイン設定エリア。 |
| `buttonBox` | `QDialogButtonBox`| 下部の OK/キャンセル/適用ボタン。 |

## 5. その他の重要なコンポーネント

- **シーン一覧**: 通常ドック内にあり、`SceneTree` クラスでスタイリング。
- **ソース一覧**: 通常ドック内にあり、`SourceTree` クラスでスタイリング。
- **音声ミキサー**: `#mixerContainer` および `#mixerArea` 配下のコンポーネント。

---
*Antigravity AI によって生成されたテーマ開発用リファレンス。*
