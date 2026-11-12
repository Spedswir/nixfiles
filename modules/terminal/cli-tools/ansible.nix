{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        # Ansible is installed inside a Python environment that also has PyYAML, instead of the
        # standalone `ansible` package. matrix-docker-ansible-deploy's `just roles` runs its scripts
        # with the interpreter that runs Ansible; with the standalone package that is a bare Python
        # without PyYAML, so installing roles fails. This also puts `python3` (with PyYAML) on the PATH.
        (python3.withPackages (ps: [
            ps.ansible-core
            ps.pyyaml
        ]))
        ansible-lint
        just
    ];
}
