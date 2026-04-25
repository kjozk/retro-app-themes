# OBS フロントエンド・ダイアログ・リファレンス

このドキュメントは、OBS Studio の `frontend/dialogs` ディレクトリにあるダイアログの実装ファイルを分析した結果をまとめたものです。これらは `frontend/forms` にある UI 定義を C++ で制御している、あるいはコード内で動的に構築されている UI 要素です。

## 1. 主要なダイアログ一覧

| ファイル名 | 対応する UI | 説明 |
|------------|-------------|------|
| `NameDialog` | (動的構築) | ソース名やシーン名の変更、新規作成時に使用される汎用的な名前入力ダイアログ。 |
| `OBSBasicAdvAudio` | `OBSAdvAudio.ui` | 「オーディオの詳細プロパティ」ウィンドウ。 |
| `OBSBasicFilters` | `OBSBasicFilters.ui` | ソースや音声デバイスの「フィルタ」管理ウィンドウ。 |
| `OBSBasicProperties` | `OBSBasicProperties.ui` | ソースやデバイスの「プロパティ」設定ウィンドウ。 |
| `OBSBasicSourceSelect` | `OBSBasicSourceSelect.ui` | 新しいソースを追加する際の選択ダイアログ。 |
| `OBSBasicTransform` | `OBSBasicTransform.ui` | ソースの「変換の編集」ウィンドウ。 |
| `OBSBasicVCamConfig` | `OBSBasicVCamConfig.ui` | 仮想カメラの設定ダイアログ。 |
| `OBSRemux` | `OBSRemux.ui` | 録画ファイルの「再多重化（Remux）」ツール。 |
| `OBSLogViewer` | `OBSLogViewer.ui` | OBS のログを表示するビューアー。 |
| `LogUploadDialog` | `LogUploadDialog.ui` | ログファイルのアップロードと URL 発行を行うダイアログ。 |

## 2. その他のダイアログ・ウィンドウ

| ファイル名 | 説明 |
|------------|------|
| `OAuthLogin` | YouTube や Twitch 等のサービスと連携する際の OAuth ログインウィンドウ。 |
| `OBSAbout` | OBS のバージョン情報やクレジットを表示するウィンドウ。 |
| `OBSExtraBrowsers` | カスタムブラウザドックの管理ウィンドウ。 |
| `OBSMissingFiles` | シーンコレクション読み込み時に不足しているファイルを再リンクするためのダイアログ。 |
| `OBSYoutubeActions` | YouTube ライブのスケジュール設定や配信管理を行うインターフェース。 |
| `OBSWhatsNew` | メジャーアップデート後に新機能を紹介する「新機能」ウィンドウ。 |
| `OBSUpdate` | アップデート確認および更新通知ダイアログ。 |
| `OBSIdianPlayground` | テーマ（CSS）の動作をテストするための開発者向けプレイグラウンド。 |

## 3. テーマ制作における重要ポイント

- **動的コンポーネント**: `NameDialog` のように `.ui` ファイルがないものは、`QLineEdit` や `QLabel` といった基本的な Qt クラス名をターゲットにしてスタイリングする必要があります。
- **オブジェクト名の継承**: 多くのダイアログは `QDialog` を継承しており、ルートのオブジェクト名（例: `#OBSBasicProperties`）を使用して、そのダイアログ内の要素のみを特定してスタイリングすることが可能です。
- **カスタムウィジェット**: 一部の高度な設定（詳細音声など）では、コード内で独自のカスタムウィジェットが生成されている場合があり、それらはクラス名で直接指定する必要があります。

---
*Antigravity AI によって生成されたダイアログ実装の分析リファレンス。*
