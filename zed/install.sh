#!/usr/bin/env bash
set -e

# Zed テーマインストーラー (macOS / Linux)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="${SCRIPT_DIR}/themes"

echo "=========================================================="
echo "  Zed カスタムテーマ インストーラー"
echo "  ・スーパーファミコン (Super Famicom)"
echo "  ・ファミリーコンピュータ (Family Computer)"
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
echo "   - Super Famicom"
echo "   - Family Computer"
echo ""
