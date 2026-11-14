{ config, pkgs, ... }:

let
    # Run inside a Screeps code folder to give VS Code autocomplete for the game API.
    # The Steam client syncs code to ~/.config/Screeps/scripts/<server>/<branch>,
    # so that branch folder can be opened in VS Code and edits go straight to the game.
    screeps-init = pkgs.writeShellScriptBin "screeps-init" ''
        set -euo pipefail
        dir="''${1:-.}"
        cd "$dir"

        [ -f package.json ] || ${pkgs.nodejs}/bin/npm init -y >/dev/null
        # Screeps runs lodash 3.10, so pin the matching typings.
        ${pkgs.nodejs}/bin/npm install --save-dev @types/screeps @types/lodash@3.10

        if [ ! -f jsconfig.json ] && [ ! -f tsconfig.json ]; then
            cat > jsconfig.json <<'EOF'
        {
            "compilerOptions": {
                "target": "ES2019",
                "module": "commonjs",
                "checkJs": false
            },
            "exclude": ["node_modules"]
        }
        EOF
        fi

        echo "Screeps typings installed in $(pwd). Open it with: code $(pwd)"
    '';
in
{
    programs.vscode.profiles.default = {
        extensions = with pkgs.vscode-extensions; [
            dbaeumer.vscode-eslint # Linting for Screeps JS/TS code
        ];
        userSettings = {
            # Keep npm's folder out of the explorer and search in Screeps projects.
            "files.exclude"."**/node_modules" = true;
        };
    };

    home.packages = [
        pkgs.nodejs # npm, for Screeps typings and rollup/grunt deploy setups
        screeps-init
    ];
}
