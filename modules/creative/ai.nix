{ lib, pkgs, ... }:

let
  # Temporary workaround for the CUDA redistributable output-list bug.
  # Apply it to KoboldCpp's CUDA package set, including its dependencies.
  fixedCudaPackages = pkgs.cudaPackages.overrideScope (_finalCuda: prevCuda: {
    buildRedist = lib.extendMkDerivation {
      constructDrv = prevCuda.buildRedist;
      extendDrvArgs = _finalAttrs: old: {
        preFixup = (old.preFixup or "") + "\n" + ''
          # Keep propagatedBuildOutputs as an array for multiple-outputs.sh.
          fixupPropagatedBuildOutputsForMultipleOutputs() {
            return 0
          }

          # CUDA's own propagation hook must also iterate over the array.
          fixupCudaPropagatedBuildOutputsToOut() {
            local output
            mkdir -p "''${out:?}/nix-support"
            for output in "''${propagatedBuildOutputs[@]}"; do
              printWords "''${!output:?}" >> "''${out:?}/nix-support/propagated-build-inputs"
            done
          }
        '';
      };
    };
  });

  koboldcppPackage = pkgs.koboldcpp.override {
    cublasSupport = true;
    cudaPackages = fixedCudaPackages;
    cudaArches = [ "sm_89" ];
  };

  koboldcppCuda = pkgs.writeShellScriptBin "koboldcpp" ''
    export LD_PRELOAD="/run/opengl-driver/lib/libcuda.so.1''${LD_PRELOAD:+:$LD_PRELOAD}"
    exec ${koboldcppPackage}/bin/koboldcpp "$@"
  '';
in
{
  # The current version of CUDA on nix-pkgs is borked, so locking it to a version for KoboldCpp
  # nixpkgs.config.cudaSupport = true;
  nixpkgs.config.cudaCapabilities = [ "8.9" ];

  home.packages = [
      pkgs.sillytavern
      koboldcppCuda
  ];
}
