{ config, pkgs, ... }:

let
  vars = import ../../modules/vars.nix;
in
{
  imports = [
      ./cli-tools/btop.nix
      ./cli-tools/base-tools.nix
  ];

  programs = {
    kitty = {
      enable = true;
      font.name = "CaskaydiaMono Nerd Font Mono";
      settings = {
        # Background options
        background_opacity = 0.9;
        background_blur = 25;
        background_image = "${vars.homeDir}/kitty.jpg";
        background_tint = 0.3;
        confirm_os_window_close = 0;
      };
    };
    starship = {
      enable = true;
      settings = {
        command_timeout = 5000;
        add_newline = false;
        format = "[](#3B4252)$python$username[](bg:#434C5E fg:#3B4252)$directory[](fg:#434C5E bg:#4C566A)$git_branch$git_status[](fg:#4C566A bg:#86BBD8)$golang$java$nodejs$rust[](fg:#86BBD8 bg:#06969A)$docker_context[](fg:#06969A bg:#33658A)$time[ ](fg:#33658A)";
        directory = {
          style = "bg:#434C5E";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
        };
        username = {
          show_always = true;
          style_user = "bg:#3B4252";
          style_root = "bg:#3B4252";
          format = "[$user ]($style)";
        };
        git_branch = {
          symbol = "";
          style = "bg:#4C566A";
          format = "[ $symbol $branch ]($style)";
        };
        git_status = {
          style = "bg:#4C566A";
          format = "[$all_status$ahead_behind ]($style)";
        };
        python = {
          style = "bg:#3B4252";
          format = "[(\($virtualenv\) )]($style)";
        };
        rust = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };
        nodejs = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };
        java = {
          symbol = " ";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };
        golang = {
          symbol = " ";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };
        time = {
          disabled = false;
          time_format = "%R"; # Hour:Minute Format
          style = "bg:#33658A";
          format = "[ $time ]($style)";
        };
      };
    };
  };
}
