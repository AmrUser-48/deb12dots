# bash-command-timer

The active script at `bash_command_timer.sh` is a maintained, Readline-aware derivative. The original uploaded script is preserved unchanged under `upstream/`; the Apache-2.0 license is included at this directory root.

Install the active script:

```bash
install -Dm0644 bash-command-timer/bash_command_timer.sh "$HOME/.local/lib/bash-command-timer/bash_command_timer.sh"
```

`~/.bashrc` sources this path using the same `[ -f ... ] && source ...` pattern as the fzf setup. Open a new shell after installation.

The active version prints the duration/time row inside `PS1` with Readline-safe nonprinting markers, avoids cursor movement, and composes with existing prompt hooks. The fallback `DEBUG` trap checks `BCT_AT_PROMPT` before calling a function, avoiding a function dispatch for every simple command. Timer-generated timestamps are trusted internally, so the hot path avoids redundant regular-expression checks; helper input is still validated before arithmetic. Run `bash tests/bash-command-timer-smoke.sh` from the repository root.
