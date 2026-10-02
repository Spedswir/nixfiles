{ config, pkgs, lib, ... }:

let
  vars = import ../modules/vars.nix;
in
{
  imports =
  [
    ./bash-aliases-general.nix
  ];

  programs = {
    bash = {
      shellAliases = {
        # AI stuff
        ai-start = "${config.home.homeDirectory}${vars.nixConfDir}/scripts/run_ai.sh";
        kcpp-start = "koboldcpp --config ${config.home.homeDirectory}/Models/default.kcpps";
        st-start = "sillytavern --browserLaunchEnabled false";

        # Matrix updates
        matrix-update-git = "cd ~/Documents/git-repos/matrix-docker-ansible-deploy/; git reset --hard; git pull --rebase; just roles";
        matrix-update-server = "cd ~/Documents/git-repos/matrix-docker-ansible-deploy/; sudo ansible-playbook -i inventory/hosts setup.yml --tags=setup-all,ensure-matrix-users-created,start --ask-pass";
      };
    };
  };
}
