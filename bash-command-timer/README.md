# bash-command-timer

The active script at `bash_command_timer.sh` is a maintained, Readline-aware derivative. The original uploaded script is preserved unchanged under `upstream/`; the Apache-2.0 license is included at this directory root.

Install the active script:

```bash
install -Dm0644 bash-command-timer/bash_command_timer.sh "$HOME/.local/lib/bash-command-timer/bash_command_timer.sh"
```

`~/.bashrc` sources this path. Set `BASH_COMMAND_TIMER_PATH` before sourcing to use a different path. Open a new shell after installation.

The active version prints the same duration/time row but places it inside `PS1` with Bash Readline's nonprinting markers. It avoids direct cursor movement and preserves existing prompt hooks. Run `bash tests/bash-command-timer-smoke.sh` from the repository root for the formatting smoke test.
