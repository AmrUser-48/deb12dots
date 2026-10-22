Frozen baseline snapshot
========================

This is the exact timer script committed to deb12dots before the Readline-safety refactor.
Repository: https://github.com/AmrUser-48/deb12dots
Baseline commit: cd0dea7755e43371a2a21c67b01d9ccb3f448cd0
Path at baseline: bash-command-timer/bash_command_timer.sh
Git blob ID: 3d91cf2080dda03c0d58d121976ef8b02b3433fa
Upstream project: https://github.com/jichu4n/bash-command-timer

The frozen script is preserved for comparison and rollback. Do not source it as the active implementation: it moves the terminal cursor from PROMPT_COMMAND and overwrites DEBUG/PROMPT_COMMAND hooks in standalone mode.
