{ config, pkgs, lib, host, ... }:

let
  vars = import ../modules/vars.nix;
  # `host` is the flake output name (desktop, laptop, gaming-tv), passed in from flake.nix.
  flake = "${config.home.homeDirectory}${vars.nixConfDir}/#${host}";
  flakeUpdate = "sudo nix flake update --flake ${config.home.homeDirectory}${vars.nixConfDir}/";

  # Build limits for rebuild-limit. Hosts not listed use the default.
  rebuildLimits = {
    desktop = "--cores 6 -j 3";
  };
  rebuildLimit = rebuildLimits.${host} or "--cores 4 -j 2";

  # Runs the given command string, but first warns if a VPN is up and asks before continuing.
  # Proton VPN uses proton0 (WireGuard) or tun* (OpenVPN); wg* catches other WireGuard tunnels.
  vpnGuard = pkgs.writeShellScript "vpn-guard" ''
    vpns=$(ls /sys/class/net | grep -E '^(proton|tun|wg)[0-9]*$' || true)
    if [ -n "$vpns" ]; then
      printf '\e[1;33mWarning:\e[0m a VPN is connected (%s). Disconnect it before rebuilding.\n' "$(echo $vpns)"
      read -r -p "Continue anyway? [y/N] " answer
      case "$answer" in
        [yY]*) ;;
        *) echo "Rebuild cancelled."; exit 1 ;;
      esac
    fi
    exec ${pkgs.bash}/bin/bash -c "$1"
  '';
  guarded = cmd: "${vpnGuard} '${cmd}'";
in
{
  programs = {
    command-not-found.enable = false;

    bash = {
      enable = true;

      initExtra = ''
        # usage: git-commit "message"
        git-commit() {
          git add . && git commit -m "$1" && git push
        }
      '';
    };

    # Same function for fish (only takes effect where fish is enabled).
    fish.functions.git-commit = "git add . && git commit -m $argv[1] && git push";
  };

  # home.shellAliases applies to every enabled shell (bash and fish).
  home = {
      shellAliases = {
        # NixOS rebuilds for this host
        # Each one warns and asks first if a VPN is connected (see vpnGuard above).
        rebuild = guarded "${flakeUpdate}; sudo nixos-rebuild switch --flake ${flake}";
        rebuild-verbose = guarded "${flakeUpdate}; sudo nixos-rebuild switch --flake ${flake} --show-trace";
        rebuild-dry = guarded "sudo nixos-rebuild dry-build --flake ${flake}";
        rebuild-dry-verbose = guarded "sudo nixos-rebuild dry-build --flake ${flake} --show-trace";
        # This stops a rebuild of something like CUDE eating all of the CPU cores and RAM and crashing the PC.
        rebuild-limit = guarded "${flakeUpdate}; sudo nixos-rebuild switch --flake ${flake} ${rebuildLimit}";

        # NixOS Garbage Collection
        garbage = "sudo nix-collect-garbage --delete-older-than 14d";
        garbage-all = "sudo nix-collect-garbage";

        # NixOS updates
        nix-conf-pull = "cd ${config.home.homeDirectory}${vars.nixConfDir}; git pull --rebase";

        # NixOS full cleanup - This can take a long time
        cleanup = "garbage; nix store optimise";
      };
  };
}
