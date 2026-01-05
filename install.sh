#!/usr/bin/env sh
set -eu

REPO="${CODEX_TAB_REPO:-tmustier/codex-tab}"
REF="${CODEX_TAB_REF:-main}"
BIN_DIR="${CODEX_TAB_BIN_DIR:-$HOME/.local/bin}"

ROOT="$(pwd)"
if [ "${0:-}" != "bash" ] && [ "${0:-}" != "-bash" ]; then
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
  if [ -f "$SCRIPT_DIR/Package.swift" ] && [ -d "$SCRIPT_DIR/Sources" ]; then
    ROOT="$SCRIPT_DIR"
  fi
fi

TMP_DIR=""
cleanup() {
  if [ -n "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
  fi
}
trap cleanup EXIT

if [ ! -f "$ROOT/Package.swift" ] || [ ! -d "$ROOT/Sources" ]; then
  if ! command -v git >/dev/null 2>&1; then
    echo "git is required for remote installs (or run this script from a checked-out repo)." >&2
    exit 1
  fi
  TMP_DIR="$(mktemp -d)"
  git clone --depth 1 --branch "$REF" "https://github.com/$REPO.git" "$TMP_DIR"
  ROOT="$TMP_DIR"
fi

mkdir -p "$BIN_DIR"

if command -v swift >/dev/null 2>&1; then
  (cd "$ROOT" && swift build -c release --product codex-tab)
elif command -v xcrun >/dev/null 2>&1; then
  (cd "$ROOT" && xcrun swift build -c release --product codex-tab)
else
  echo "swift not found. Install Xcode Command Line Tools (xcode-select --install)." >&2
  exit 1
fi

cp -f "$ROOT/.build/release/codex-tab" "$BIN_DIR/codex-tab"
chmod +x "$BIN_DIR/codex-tab"

echo "Installed codex-tab to $BIN_DIR/codex-tab"
echo "Ensure $BIN_DIR is on your PATH."
