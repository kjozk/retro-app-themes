# Zed Themes: FC / SFC / GB / NES / SNES / Wii / Switch

次世代高性能エディタ [Zed](https://zed.dev/) 向けのカスタムテーマです。  
任天堂の伝説的名機である **ファミリーコンピュータ（FC）**、**スーパーファミコン（SFC）**、**ゲームボーイ（GB）**、北米版の **NES / SNES**、**Wii**、および **Nintendo Switch** の実機カラーパレットとデザイン言語を忠実に落とし込んでいます。

| ファミリーコンピュータ | ゲームボーイ |
| :---: | :---: |
| ![Family Computer Preview](../screenshots/zed/fc_preview.png) | ![Gameboy Preview](../screenshots/zed/gb_preview.png) |

---

## 収録テーマ

### 1. ファミリーコンピュータ (Family Computer) - `family-computer.json`
- **実機再現アイボリー**: 本体の成型色（ベース背景）に温かみのあるクラシックなトーン。
- **えんじ色 & 真鍮ゴールド**: アクティブ要素やタブのハイライトに伝統のえんじ色と真鍮ゴールド。
- **構文ハイライト**: 視認性に優れたコントラストとレトロハードの調和。

### 2. スーパーファミコン (Super Famicom) - `super-famicom.json`
- **実機再現ライトグレー**: スーファミ本体のクールなライトグレーとスレートグレーの2トーン構成。
- **ABXY 4色アクセント**: 赤・黄・青・緑をコードシンタックスやステータス表示のアクセントカラーとして採用。
- **[Blurred] / 通常バリアント**: 背景ブラー透過や通常モードに対応。

### 3. ゲームボーイ (Gameboy) - `gameboy.json`
- **実機再現オリーブ液晶**: 初代ゲームボーイ（DMG-01）のSTN液晶グリーン（`#8C9E5B`）をベースに採用。
- **青紫ロゴ & マゼンタボタン**: ロゴの青紫色（`#393C9F`）と A/B ボタンのマゼンタ（`#9E285A`）をアクセントに配置。
- **画面ベゼルフレーム**: スレートグレーの画面枠と、本体成型色のオフホワイトタブバー。
- **[Blurred] / 通常 / Dark バリアント**: 液晶反転・バックライト解釈の Dark モードも完備。

### 4. Nintendo Switch - `switch.json`
- **Switch システムフラットデザイン**: ミニマルな無彩色ベース（Dark: `#2D2D2D` / Light: `#ECECEC`）と、鮮烈なシアン（`#00D2F3`）および決定ブルー（`#2052FF`）の点滅キャレット。
- **Joy-Con ネオンカラー & ホーム丸アイコン展開**: マゼンタ、オレンジ、コバルトブルーをマルチカーソル（Player 2〜4）やシンタックスハイライトに機能的マッピング。
- **Dark / Light / [Blurred] 完全対応**: 4 バリアント（Dark, Dark [Blurred], Light, Light [Blurred]）を収録。

### 5. Wii (Nintendo Wii) - `wii.json`
- **クリーン＆ミニマルホワイト**: Wii 本体の白い成型色を土台に、WiiWare 水色（`#22B2E9`）やスロット LED 濃青（`#136185`）のアクセント。

### 6. NES & SNES (北米版コンソール) - `nes.json` / `snes.json`
- **NES**: 完全無彩色グレー × マットブラック × レーシングレッド。
- **SNES**: ニュートラルクールグレー × ディープパープル × ラベンダー。

---

## インストール方法

### 自動インストール（推奨）

- **Windows**:
  - `zed/` 内の **`install.bat` をダブルクリック**（または PowerShell から `.\install.ps1` を実行）します。
- **macOS / Linux**:
  - ターミナルで `zed/` に移動し、以下を実行します：
    ```bash
    bash install.sh
    ```

### 手動インストール

`themes/` 内の `.json` ファイルを、各OSのテーマフォルダーにコピーしてください。

- **Windows**: `%APPDATA%\Zed\themes\`
- **macOS / Linux**: `~/.config/zed/themes/`（または `$XDG_CONFIG_HOME/zed/themes/`）

---

## 適用方法
1. Zed を開きます。
2. コマンドパレット（`Ctrl+Shift+P`）を開き、`theme: select`（または `Ctrl+K Ctrl+T`）を入力します。
3. 一覧から以下のいずれかを選択します：
   - **[1983] FC - Family Computer**（同 **[Blurred]**, **Dark**）
   - **[1985] NES - Nintendo Entertainment System**（同 **[Blurred]**, **Dark**）
   - **[1989] GB - Game Boy**（同 **[Blurred]**, **Dark**）
   - **[1990] SFC - Super Famicom**（同 **[Blurred]**, **Dark**）
   - **[1991] SNES - Super Nintendo Entertainment System**（同 **[Blurred]**, **Dark**）
   - **[2006] Wii - Nintendo Wii**（同 **[Blurred]**, **Dark**）
   - **[2017] Switch - Nintendo Switch**（同 **[Blurred]**, **Dark**, **Dark [Blurred]**）
