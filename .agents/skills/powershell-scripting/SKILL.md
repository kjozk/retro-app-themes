---
name: powershell-scripting
description: Best practices for writing, executing, and distributing PowerShell scripts across Windows PowerShell 5.1 and PowerShell 7+. Covers UTF-8 with BOM encoding requirements, ExecutionPolicy bypass wrappers, cross-platform path handling, and robust error handling.
---

# PowerShell スクリプティング・配布総合ガイド (PowerShell Scripting)

Windows PowerShell 5.1（標準同梱）および PowerShell 7+（クロスプラットフォーム）で動作する、安全でポータブルな配布用スクリプトを作成するための実践ノウハウ集です。

---

## 1. 文字エンコーディングの落とし穴 (最重要)

### 問題の根本原因
- **Windows PowerShell 5.1**（Windows 10/11に標準搭載）は、BOMなし UTF-8 ファイルを **CP932 (Shift-JIS)** として解釈します。
- スクリプト内に日本語（非ASCIIコメント・表示メッセージ等）が含まれていると、特殊記号や閉じ括弧が誤認識され、**予期せぬ構文エラー（`TerminatorExpectedAtEndOfString` 等）や文字化け**を引き起こします。

### 鉄則
> [!IMPORTANT]
> 配布用・自動化用の `.ps1` スクリプトは、必ず **UTF-8 with BOM (`utf-8-sig`)** で保存してください。
> - PowerShell 5.1: BOMを認識して正しくUTF-8として解釈します。
> - PowerShell 7+: BOM付きUTF-8も完全サポートしています。

#### Python で UTF-8 with BOM 保存する例
```python
with open("script.ps1", "w", encoding="utf-8-sig") as f:
    f.write(content)
```

---

## 2. 実行ポリシーとラッパースクリプト (.bat)

Windows ではデフォルトでスクリプトの実行が制限（`Restricted`）されているため、ダブルクリックや通常実行ではブロックされます。

### バッチラッパーの定石 (`run.bat` / `install.bat`)
ユーザーがダブルクリックするだけで実行できるように、以下のバッチラッパーを同梱します。

```cmd
@echo off
setlocal
chcp 65001 >nul

:: 同一フォルダの .ps1 を ExecutionPolicy Bypass で実行
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"

endlocal
```

### コマンドラインからの直接実行
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

---

## 3. クロスプラットフォーム対応と安全なパス操作

PowerShell 7+ では macOS や Linux でも動作するため、環境に応じた分岐を設計します。

### OS 判定の定石
`$IsWindows` 変数は PowerShell 5.1 には存在しないため、以下の判定順序が最も安全です。

```powershell
if ($IsMacOS) {
    $targetDir = "$env:HOME/.config/app"
} elseif ($IsLinux) {
    $xdg = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { "$env:HOME/.config" }
    $targetDir = "$xdg/app"
} else {
    # Windows (PowerShell 5.1 および 7+ の両方で動作)
    $targetDir = Join-Path $env:APPDATA "app"
}
```

### パス操作のベストプラクティス
- パス結合には文字列連結（`+`）ではなく、必ず **`Join-Path`** を使用します。
- スクリプト自身の配置ディレクトリを取得する：
  ```powershell
  $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
  ```

---

## 4. エラーハンドリングと終了制御

### エラー時に即座に停止する
スクリプトの先頭で以下を宣言します。
```powershell
$ErrorActionPreference = "Stop"
```

### ディレクトリ作成の安全な書き方
```powershell
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}
```

### ダブルクリック実行時のウィンドウ即時クローズ防止
バッチファイルやダブルクリックで実行された際、実行結果（成功・エラーメッセージ）をユーザーが確認できるよう、末尾にキー入力待ちを配置します。

```powershell
param (
    [switch]$NoWait  # CIや別スクリプトからの呼び出し時は待機をスキップ
)

if (-not $NoWait -and $Host.Name -eq "ConsoleHost") {
    Write-Host ""
    Read-Host "Enterキーを押して終了してください..."
}
```
