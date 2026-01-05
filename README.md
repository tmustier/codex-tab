# codex-tab

Small wrapper for developers with too many Codex sessions. Runs `codex` and updates your terminal tab title while it works.

**macOS-only**: uses `libproc` to bind to the correct session log (no `lsof`).

Not on macOS? Use the cross-platform Python version: [`codex-title`](https://github.com/tmustier/codex-title).

Default titles (configurable):

| State | Tab title |
| --- | --- |
| New session | `codex:new` |
| Working | `codex:running...` |
| Done with a commit | `codex:✅` |
| Done but no commit | `codex:🚧` |
| Timeout (no output) | `codex:🛑` |

## Install

One-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/tmustier/codex-tab/main/install.sh | bash
```

From source:

```bash
git clone https://github.com/tmustier/codex-tab
cd codex-tab
./install.sh
```

## Usage

Run Codex through the wrapper:

```bash
codex-tab

# Pass Codex args
codex-tab -- --resume --last
```

Customize titles:

```bash
codex-tab --new-title 'codex:new' --running-title 'codex:thinking' --done-title 'codex:done'
```

Commit-aware done title (override the default):

```bash
codex-tab --no-commit-title 'codex:🚧' -- --resume --last
```

Inactivity timeout overlay (default 120s; set `0` to disable):

```bash
codex-tab --inactive-timeout 30 --timeout-title 'codex:🛑' -- --resume --last
```

## Parity with codex-title (Python)

Core behavior is equivalent (launch `codex`, bind to the active session log, update title on running/done, commit-aware done state).

Not implemented (yet): config/env file support, `--yolo`, `--watch-only`/`--status`, `--follow-global-resume`, and the Python “tool-only idle-done” fallback.

## How it works

Codex writes JSONL session logs under `~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl`.
This wrapper tails the correct log and flips the tab title when it sees:

- User message begins processing -> running
- Assistant message (or aborted turn) -> done
- If a successful `git commit` happened during the turn -> done title is `codex:✅` (otherwise `codex:🚧`)
- If the log is completely inactive for `--inactive-timeout` seconds while running -> show `codex:🛑` until activity resumes

## Development

Build + run from the repo (rebuilds only when sources change):

```bash
./codex-tab -- --resume --last
```

Run tests:

```bash
xcrun swift test
```

## Uninstall

```bash
rm -f ~/.local/bin/codex-tab
```

## License

MIT
