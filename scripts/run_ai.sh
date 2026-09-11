#!/usr/bin/env bash

CMD1='koboldcpp --config ~/Models/default.kcpps'
CMD2='sillytavern --browserLaunchEnabled false'

TAB1="Koboldcpp"
TAB2="SillyTavern"

if [[ -n "${KITTY_WINDOW_ID:-}" ]]; then
    # Already inside Kitty

    # Rename the current tab
    kitten @ set-tab-title "$TAB1"

    # Launch command 2 in a new tab, but keep focus on this tab
    kitten @ launch \
        --type=tab \
        --tab-title "$TAB2" \
        --keep-focus \
        bash -lc "$CMD2; exec bash"

    # Run command 1 in the current terminal
    exec bash -lc "$CMD1"

else
    # Not inside Kitty: create a new Kitty window with two tabs

    SESSION=$(mktemp)
    trap 'rm -f "$SESSION"' EXIT

    cat > "$SESSION" <<EOF
new_tab $TAB1
launch bash -lc '$CMD1; exec bash'

new_tab $TAB2
launch bash -lc '$CMD2; exec bash'

focus_tab 0
EOF

    kitty --session "$SESSION"
fi
