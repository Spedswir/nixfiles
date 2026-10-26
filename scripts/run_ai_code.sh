#!/usr/bin/env bash
# Starts KoboldCpp with code.kcpps and runs Claude Code against it in the home directory.
# Installed as the ai-code command by modules/creative/ai.nix.

cd "$HOME" || exit 1

# Must match the port in code.kcpps.
PORT=5001

CMD1='koboldcpp --config ~/Documents/"AI Models"/code.kcpps'
# Wait for KoboldCpp to finish loading the model before starting Claude Code.
CMD2="echo \"Waiting for KoboldCpp on port $PORT...\"; \
until curl -sf http://localhost:$PORT/v1/models >/dev/null; do sleep 2; done; \
ANTHROPIC_BASE_URL=http://localhost:$PORT \
ANTHROPIC_AUTH_TOKEN=kobold \
ANTHROPIC_MODEL=koboldcpp \
ANTHROPIC_DEFAULT_HAIKU_MODEL=koboldcpp \
claude"

TAB1="Koboldcpp"
TAB2="Claude Code"

if [[ -n "${KITTY_WINDOW_ID:-}" ]]; then
    # Already inside Kitty

    # Rename the current tab
    kitten @ set-tab-title "$TAB2"

    # Launch KoboldCpp in a new tab, but keep focus on this tab
    kitten @ launch \
        --type=tab \
        --tab-title "$TAB1" \
        --keep-focus \
        bash -lc "$CMD1; exec bash"

    # Run Claude Code in the current terminal
    exec bash -lc "$CMD2"

else
    # Not inside Kitty: create a new Kitty window with both tabs

    SESSION=$(mktemp)
    trap 'rm -f "$SESSION"' EXIT

    cat > "$SESSION" <<SESSION_EOF
cd $HOME

new_tab $TAB1
launch bash -lc '$CMD1; exec bash'

new_tab $TAB2
launch bash -lc '$CMD2; exec bash'

focus_tab 1
SESSION_EOF

    kitty --session "$SESSION"
fi
