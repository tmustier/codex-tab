#!/usr/bin/env sh
set -eu

BIN_DIR="${CODEX_TAB_BIN_DIR:-$HOME/.local/bin}"
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

mkdir -p "$BIN_DIR"

(cd "$ROOT" && swift build -c release --product codex-tab)

cp -f "$ROOT/.build/release/codex-tab" "$BIN_DIR/codex-tab"
chmod +x "$BIN_DIR/codex-tab"

echo "Installed codex-tab to $BIN_DIR/codex-tab"
echo "Ensure $BIN_DIR is on your PATH."
