# Windows Classic (98/2000) テーマ詳細設計書

1990年代の Windows 95 / 98 / 2000 / NT4.0 で確立されたクラシック UI の 3D ベベル立体幾何学およびシステムカラー定義の完全仕様です。

---

## 1. システムカラー定義

4色の基本システムカラーによる光と影の組み合わせでウィンドウやボタンの立体感を表現します。

| 変数名 | 定義色 | システム名 (Win32 API) | 役割 |
| :--- | :--- | :--- | :--- |
| `--win_bg` | `#D4D0C8` | `COLOR_BTNFACE` (3DFace) | ウィンドウ・ボタンの基本グレー背景 |
| `--win_bg_light`| `#FFFFFF` | `COLOR_WINDOW` | 入力欄・リストボックスの白背景 |
| `--win_hilight` | `#FFFFFF` | `COLOR_BTNHIGHLIGHT` (3DLight) | 左上から当たる光のハイライト（外側明線） |
| `--win_shadow` | `#808080` | `COLOR_BTNSHADOW` (3DShadow) | 右下に落ちる影（内側暗線） |
| `--win_darkshadow` | `#404040` | `COLOR_3DDKSHADOW` | 右下の最深部シャドウ（外側暗線） |
| `--win_title_start` | `#0A246A` | `COLOR_ACTIVECAPTION` | アクティブタイトルバー（左端濃紺） |
| `--win_title_end` | `#A6CAF0` | `COLOR_GRADIENTACTIVECAPTION` | アクティブタイトルバー（右端ペールブルー） |
| `--win_selection` | `#0A246A` | `COLOR_HIGHLIGHT` | 選択行の濃紺背景（文字色は `#FFFFFF`） |

---

## 2. 凸ボタン（Raised）と 凹入力欄（Sunken）の立体ルール

### 1. 凸ボタン（Raised - 通常時）
左上に光（白）、右下に影（2段階グレー）を配置して浮き上がらせる。
```css
QPushButton {
    background-color: var(--win_bg);
    border-top: 2px solid var(--win_hilight);
    border-left: 2px solid var(--win_hilight);
    border-right: 2px solid var(--win_darkshadow);
    border-bottom: 2px solid var(--win_darkshadow);
    padding: 4px 12px;
}
```

### 2. 凸ボタン（Pressed - 押下時）
光と影が反転し、ボタンが押し込まれたように見せる。
```css
QPushButton:pressed, QPushButton:checked {
    background-color: var(--win_bg);
    border-top: 2px solid var(--win_darkshadow);
    border-left: 2px solid var(--win_darkshadow);
    border-right: 2px solid var(--win_hilight);
    border-bottom: 2px solid var(--win_hilight);
    padding: 5px 11px 3px 13px; /* 1px 右下に沈み込むテキストオフセット */
}
```

### 3. 凹入力欄（Sunken - テキストボックス・リスト）
常時へこんだ枠線で画面の向こう側に掘り込まれた領域を表現。
```css
QLineEdit, QListView, QListWidget, QTreeView {
    background-color: var(--win_bg_light);
    border-top: 2px solid var(--win_shadow);
    border-left: 2px solid var(--win_shadow);
    border-right: 2px solid var(--win_hilight);
    border-bottom: 2px solid var(--win_hilight);
}
```
