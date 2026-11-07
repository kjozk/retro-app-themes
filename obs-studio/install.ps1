#Requires -Version 5.1
<#
.SYNOPSIS
    OBS Studio のテーマディレクトリに SFC / FC テーマをインストールするスクリプト (Windows / macOS / Linux 対応)
#>

param (
    [switch]$NoWait
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# OS別のテーマ格納ディレクトリを自動判定
$targetDirs = @()
if ($IsMacOS) {
    $targetDirs += "$env:HOME/Library/Application Support/obs-studio/themes"
} elseif ($IsLinux) {
    $xdg = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { "$env:HOME/.config" }
    $targetDirs += "$xdg/obs-studio/themes"
    $flatpak = "$env:HOME/.var/app/com.obsproject.Studio/config/obs-studio/themes"
    if (Test-Path "$env:HOME/.var/app/com.obsproject.Studio") {
        $targetDirs += $flatpak
    }
} else {
    $targetDirs += "$env:APPDATA\obs-studio\themes"
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  OBS Studio カスタムテーマ インストーラー" -ForegroundColor Cyan
Write-Host "  ・スーパーファミコン (Super Famicom)" -ForegroundColor Cyan
Write-Host "  ・ファミリーコンピュータ (Family Computer)" -ForegroundColor Cyan
Write-Host "  ・ゲームボーイ (Gameboy)" -ForegroundColor Cyan
Write-Host "  ・Windows XP Luna" -ForegroundColor Cyan
Write-Host "  ・Windows Classic" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$srcThemeDir = Join-Path $scriptDir "themes"
$themeFiles = @(
    "Yami_SuperFamicom.ovt",
    "Yami_FamilyComputer.ovt",
    "Yami_Gameboy.ovt",
    "Yami_Luna.ovt",
    "Yami_WindowsClassic.ovt",
    "classic"
)

try {
    foreach ($targetDir in $targetDirs) {
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
        Write-Host "インストール先: $targetDir" -ForegroundColor Gray

        foreach ($file in $themeFiles) {
            $srcPath = Join-Path $srcThemeDir $file
            if (Test-Path $srcPath) {
                Copy-Item -Path $srcPath -Destination $targetDir -Recurse -Force
                Write-Host "  [OK] コピー完了: $file" -ForegroundColor Green
            } else {
                Write-Host "  [スキップ] ファイルが見つかりません: $file" -ForegroundColor Yellow
            }
        }
        Write-Host ""
    }

    Write-Host "----------------------------------------------------------" -ForegroundColor Green
    Write-Host "テーマのインストールが正常に完了しました！" -ForegroundColor Green
    Write-Host "----------------------------------------------------------" -ForegroundColor Green
    Write-Host ""
    Write-Host "【反映方法】" -ForegroundColor Cyan
    Write-Host "1. 起動中の OBS Studio を再起動します。"
    Write-Host "2. 設定 > 外観 > テーマ から以下を選択してください。"
    Write-Host "   - Super Famicom"
    Write-Host "   - Family Computer"
    Write-Host "   - Gameboy"
    Write-Host ""
} catch {
    Write-Host "エラーが発生しました: $_" -ForegroundColor Red
}

if (-not $NoWait -and $Host.Name -eq "ConsoleHost") {
    Read-Host "Enterキーを押して終了してください..."
}
