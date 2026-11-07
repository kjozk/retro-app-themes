#!/usr/bin/env bash
set -e

# OBS Studio テーマインストーラー (macOS / Linux)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="${SCRIPT_DIR}/themes"

echo "=========================================================="
echo "  OBS Studio カスタムテーマ インストーラー"
echo "  ・スーパーファミコン (Super Famicom)"
echo "  ・ファミリーコンピュータ (Family Computer)"
echo "=========================================================="
echo ""

# OS 検出
OS="$(uname -s)"
TARGET_DIRS=()

if [ "${OS}" = "Darwin" ]; then
    # macOS
    TARGET_DIRS+=("${HOME}/Library/Application Support/obs-studio/themes")
elif [ "${OS}" = "Linux" ]; then
    # Linux (通常 / XDG)
    XDG_CONFIG="${XDG_CONFIG_HOME:-${HOME}/.config}"
    TARGET_DIRS+=("${XDG_CONFIG}/obs-studio/themes")
    # Flatpak 版 OBS が存在する場合はそちらも対象に追加
    FLATPAK_DIR="${HOME}/.var/app/com.obsproject.Studio/config/obs-studio/themes"
    if [ -d "${HOME}/.var/app/com.obsproject.Studio" ]; then
        TARGET_DIRS+=("${FLATPAK_DIR}")
    fi
else
    echo "未対応のOSです: ${OS}"
    exit 1
fi

THEME_FILES=(
    "Yami_SuperFamicom.ovt"
    "Yami_FamilyComputer.ovt"
)

for target in "${TARGET_DIRS[@]}"; do
    echo "インストール先: ${target}"
    mkdir -p "${target}"

    for file in "${THEME_FILES[@]}"; do
        src="${THEMES_DIR}/${file}"
        if [ -f "${src}" ]; then
            cp -f "${src}" "${target}/"
            echo "  [OK] コピー完了: ${file}"
        else
            echo "  [スキップ] 見つかりません: ${file}"
        fi
    done
    echo ""
done

echo "----------------------------------------------------------"
echo "OBS Studio テーマのインストールが完了しました！"
echo "----------------------------------------------------------"
echo ""
echo "【反映方法】"
echo "1. OBS Studio を起動（起動中の場合は再起動）します。"
echo "2. 設定 > 外観 > テーマ（または 一般 > テーマ）から以下を選択してください："
echo "   - Super Famicom"
echo "   - Family Computer"
echo ""
