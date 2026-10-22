# deb12dots

Debian 12 Bash and X11 terminal configuration.

## Shared shell configuration

`.aaliases` is shared by Bash and Zsh and detects the sourcing shell with
`BASH_VERSION` or `ZSH_VERSION`. The `ashow` alias opens this shared file,
while `src` reloads the appropriate shell startup file.

lf exports `LF_LEVEL` to shells started from its default `w` binding, Ranger
sets or increments `RANGER_LEVEL` for child processes, and Midnight Commander
sets `MC_SID` for its subshell. Bash uses `case` to check these variables
directly and prepends colored `[ lf ]`, `[ ranger ]`, and `[ mc ]` prompt
markers when their respective variables are nonempty, without walking the
process tree. If multiple variables are inherited, all corresponding markers
appear. Interactive Bash startup also prints an OpenRC-style `.bashrc` marker. The supplied `etc/profile.d/40-user.sh` uses the same ` * Loading … ... [ ok ]` status-line format while configuring user aliases and helper functions.

## Command timer

`bash-command-timer/upstream/bash_command_timer.sh` preserves the exact original timer script uploaded with the repository at baseline commit `cd0dea7755e43371a2a21c67b01d9ccb3f448cd0`. The active implementation is `bash-command-timer/bash_command_timer.sh`. It retains the familiar `[ duration | time ]` display, measures duration with `EPOCHREALTIME` on modern Bash, and uses Bash's built-in `printf %(...)T` clock formatter to avoid per-command `date` processes.

The original timer directly moved the terminal cursor from `PROMPT_COMMAND` and could desynchronize Readline while editing long commands; its standalone hook installation also replaced `DEBUG`/`PROMPT_COMMAND`. The active implementation composes the timer into `PS1`, wrapping nonprinting ANSI sequences in `\[...\]`, preserves existing `PROMPT_COMMAND`, and refuses to replace an existing `DEBUG` trap if bash-preexec is unavailable.

Install the active timer:

```bash
install -Dm0644 bash-command-timer/bash_command_timer.sh "$HOME/.local/lib/bash-command-timer/bash_command_timer.sh"
```

Open a new Bash shell to load it. Set `BASH_COMMAND_TIMER_PATH` before sourcing from `.bashrc` to override the install path.

## xterm and UXTerm

The root `.Xresources` configures XTerm; `.config/Xresources/xterm` is the standalone XTerm resource file, and `.config/Xresources/UXterm` is included by the current setup. The refactor preserves fonts, colors, and scrollback sizes while replacing undocumented scrolling resource names and making UTF-8/autowrap explicit.

After installing the reviewed resource files, run `xrdb -merge ~/.Xresources` and open a new terminal.

## Test

```bash
bash tests/bash-command-timer-smoke.sh
```
