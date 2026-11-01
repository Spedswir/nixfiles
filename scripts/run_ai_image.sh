#!/usr/bin/env bash

CMD='comfyui'

TAB="ComfyUI"

if [[ -n "${KITTY_WINDOW_ID:-}" ]]; then
    # Already inside Kitty: rename the current tab and run ComfyUI here
    kitten @ set-tab-title "$TAB"
    exec bash -lc "$CMD"

else
    # Not inside Kitty: create a new Kitty window with a ComfyUI tab

    SESSION=$(mktemp)
    trap 'rm -f "$SESSION"' EXIT

    cat > "$SESSION" <<SESSION_EOF
new_tab $TAB
launch bash -lc '$CMD; exec bash'
SESSION_EOF

    kitty --session "$SESSION"
fi
