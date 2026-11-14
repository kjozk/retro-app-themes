#!/usr/bin/env bash
set -e

# Zed テーマインストーラー (macOS / Linux)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="${SCRIPT_DIR}/themes"

echo "=========================================================="
echo "  Zed カスタムテーマ インストーラー"
echo "  ・スーパーファミコン (Super Famicom)"
echo "  ・NES (Nintendo Entertainment System)"
echo "  ・SNES (Super Nintendo Entertainment System)"
echo "  ・Wii (Nintendo Wii)"
echo "  ・Switch (Nintendo Switch)"
echo "  ・ファミリーコンピュータ (Family Computer)"
echo "  ・ゲームボーイ (Gameboy)"
echo "=========================================================="
echo ""

# macOS / Linux ともに ~/.config/zed/themes (または $XDG_CONFIG_HOME/zed/themes)
XDG_CONFIG="${XDG_CONFIG_HOME:-${HOME}/.config}"
TARGET_DIR="${XDG_CONFIG}/zed/themes"

echo "インストール先: ${TARGET_DIR}"
mkdir -p "${TARGET_DIR}"

THEME_FILES=(
    "super-famicom.json"
    "family-computer.json"
    "nes.json"
    "snes.json"
    "wii.json"
    "switch.json"
    "gameboy.json"
)

for file in "${THEME_FILES[@]}"; do
    src="${THEMES_DIR}/${file}"
    if [ -f "${src}" ]; then
        cp -f "${src}" "${TARGET_DIR}/"
        echo "  [OK] コピー完了: ${file}"
    else
        echo "  [スキップ] 見つかりません: ${file}"
    fi
done

echo ""
echo "----------------------------------------------------------"
echo "Zed テーマのインストールが完了しました！"
echo "----------------------------------------------------------"
echo ""
echo "【反映方法】"
echo "1. Zed エディタを開きます（起動中の場合は自動リロードされます）。"
echo "2. コマンドパレット (Cmd+K Cmd+T または theme: select) から以下を選択してください："
echo "   - [1983] FC - Family Computer"
echo "   - [1985] NES - Nintendo Entertainment System"
echo "   - [1989] GB - Game Boy"
echo "   - [1990] SFC - Super Famicom"
echo "   - [1991] SNES - Super Nintendo Entertainment System"
echo "   - [2006] Wii - Nintendo Wii"
echo "   - [2017] Switch - Nintendo Switch"
echo ""
