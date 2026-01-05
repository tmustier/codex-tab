# codex-tab

macOS-only `codex` launcher that updates your terminal tab title based on Codex session state.

It binds to the correct session log by inspecting the `codex` process’ open files via `libproc` (no `lsof`).

Not on macOS? Use the cross-platform Python version: [`codex-title`](https://github.com/tmustier/codex-title).

## Install

Build + install to `~/.local/bin`:

```sh
./install.sh
```

## Usage

Run Codex through the wrapper:

```sh
codex-tab -- --resume --last
```

Customize titles:

```sh
codex-tab --running-title 'codex:🚧' --done-title 'codex:✅' -- --resume --last
```

Inactivity timeout overlay (defaults to 120s):

```sh
codex-tab --inactive-timeout 30 --timeout-title 'codex:🛑' -- --resume --last
```

## Parity with codex-title (Python)

Core behavior is equivalent (launch `codex`, bind to the active session log, update title on running/done, commit-aware done state).

Not implemented (yet): config/env file support, `--yolo`, `--watch-only`/`--status`, `--follow-global-resume`, and the Python “tool-only idle-done” fallback.

## Development

Build + run from the repo (rebuilds only when sources change):

```sh
./codex-tab -- --resume --last
```

Run tests:

```sh
swift test
```
