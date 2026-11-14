#Requires -Version 5.1
<#
.SYNOPSIS
    Zed エディタのテーマディレクトリに SFC / FC テーマをインストールするスクリプト (Windows / macOS / Linux 対応)
#>

param (
    [switch]$NoWait
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

if ($IsMacOS) {
    $targetDir = "$env:HOME/.config/zed/themes"
} elseif ($IsLinux) {
    $xdg = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { "$env:HOME/.config" }
    $targetDir = "$xdg/zed/themes"
} else {
    # Windows: %APPDATA%\Zed\themes (Zed 公式標準パス)
    $targetDir = Join-Path $env:APPDATA "Zed\themes"

    # 過去のバージョンで誤って配置された ~/.config/zed/themes のクリーンアップ
    $legacyDir = Join-Path $env:USERPROFILE ".config\zed\themes"
    if (Test-Path $legacyDir) {
        try {
            Remove-Item -Path (Join-Path $legacyDir "family-computer.json") -Force -ErrorAction SilentlyContinue
            Remove-Item -Path (Join-Path $legacyDir "super-famicom.json") -Force -ErrorAction SilentlyContinue
            if ((Get-ChildItem $legacyDir).Count -eq 0) {
                Remove-Item -Path $legacyDir -Recurse -Force -ErrorAction SilentlyContinue
            }
            $legacyParent = Join-Path $env:USERPROFILE ".config\zed"
            if ((Test-Path $legacyParent) -and ((Get-ChildItem $legacyParent).Count -eq 0)) {
                Remove-Item -Path $legacyParent -Recurse -Force -ErrorAction SilentlyContinue
            }
        } catch {}
    }
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Zed カスタムテーマ インストーラー" -ForegroundColor Cyan
Write-Host "  ・スーパーファミコン (Super Famicom)" -ForegroundColor Cyan
Write-Host "  ・NES (Nintendo Entertainment System)" -ForegroundColor Cyan
Write-Host "  ・SNES (Super Nintendo Entertainment System)" -ForegroundColor Cyan
Write-Host "  ・Wii (Nintendo Wii)" -ForegroundColor Cyan
Write-Host "  ・Switch (Nintendo Switch)" -ForegroundColor Cyan
Write-Host "  ・ファミリーコンピュータ (Family Computer)" -ForegroundColor Cyan
Write-Host "  ・ゲームボーイ (Gameboy)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$srcThemeDir = Join-Path $scriptDir "themes"

$themeFiles = @(
    "super-famicom.json",
    "family-computer.json",
    "nes.json",
    "snes.json",
    "wii.json",
    "switch.json",
    "gameboy.json"
)

try {
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    Write-Host "インストール先: $targetDir" -ForegroundColor Gray

    foreach ($file in $themeFiles) {
        $srcPath = Join-Path $srcThemeDir $file
        if (Test-Path $srcPath) {
            Copy-Item -Path $srcPath -Destination $targetDir -Force
            Write-Host "  [OK] コピー完了: $file" -ForegroundColor Green
        } else {
            Write-Host "  [スキップ] ファイルが見つかりません: $file" -ForegroundColor Yellow
        }
    }
    Write-Host ""

    Write-Host "----------------------------------------------------------" -ForegroundColor Green
    Write-Host "Zed テーマのインストールが正常に完了しました！" -ForegroundColor Green
    Write-Host "----------------------------------------------------------" -ForegroundColor Green
    Write-Host ""
    Write-Host "【反映方法】" -ForegroundColor Cyan
    Write-Host "1. Zed エディタを開きます（起動中の場合は自動でリロードされます）。"
    Write-Host "2. コマンドパレット (Ctrl+K Ctrl+T または theme: select) から以下を選択してください。"
    Write-Host "   - [1983] FC - Family Computer"
    Write-Host "   - [1985] NES - Nintendo Entertainment System"
    Write-Host "   - [1989] GB - Game Boy"
    Write-Host "   - [1990] SFC - Super Famicom"
    Write-Host "   - [1991] SNES - Super Nintendo Entertainment System"
    Write-Host "   - [2006] Wii - Nintendo Wii"
    Write-Host "   - [2017] Switch - Nintendo Switch"
    Write-Host ""
} catch {
    Write-Host "エラーが発生しました: $_" -ForegroundColor Red
}

if (-not $NoWait -and $Host.Name -eq "ConsoleHost") {
    Read-Host "Enterキーを押して終了してください..."
}
