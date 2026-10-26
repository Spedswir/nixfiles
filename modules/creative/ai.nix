{ lib, pkgs, ... }:

let
  # Temporary workaround for the CUDA redistributable output-list bug.
  # Apply it to KoboldCpp's CUDA package set, including its dependencies.
  # Pinned to CUDA 13.2: the 595 driver rejects PTX from newer toolkits.
  fixedCudaPackages = pkgs.cudaPackages_13_2.overrideScope (_finalCuda: prevCuda: {
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

    # NVIDIA re-tagged v2.32.3-1 upstream, so nixpkgs' source hash no longer matches.
    nccl = prevCuda.nccl.overrideAttrs (old: {
      src = old.src.overrideAttrs {
        outputHash = "sha256-GnawQUhgwBYnIzJQt6Y+3SX7Rpi/MyAa0q65VkysSY4=";
      };
    });
  });

  koboldcppPackage = (pkgs.koboldcpp.override {
    cublasSupport = true;
    cudaPackages = fixedCudaPackages;
    cudaArches = [ "sm_89" ];
  }).overrideAttrs (old: {
    # nixpkgs copies embd_res/*.embd flat into bin/, but the image generator's tokenizer
    # loads them from bin/embd_res/, so loading any image model aborts. Link them there too.
    postInstall = (old.postInstall or "") + ''
      mkdir -p "$out/bin/embd_res"
      for f in "$out"/bin/*.embd; do
        ln -s "../$(basename "$f")" "$out/bin/embd_res/"
      done
    '';
  });

  koboldcppCuda = pkgs.writeShellScriptBin "koboldcpp" ''
    export LD_PRELOAD="/run/opengl-driver/lib/libcuda.so.1''${LD_PRELOAD:+:$LD_PRELOAD}"
    exec ${koboldcppPackage}/bin/koboldcpp "$@"
  '';

  # ComfyUI on the prebuilt CUDA torch wheels, so it neither builds torch from source nor
  # needs nixpkgs.config.cudaSupport. The wheels link the nixpkgs CUDA libraries, which
  # default to a release the 595 driver rejects, so they get the pinned 13.2 set too.
  comfyuiPython = pkgs.python3.override {
    self = comfyuiPython;
    # torch-bin itself is overridden because torchvision-bin and torchaudio-bin depend on it by name.
    packageOverrides = pyFinal: pyPrev: {
      torch-bin = pyPrev.torch-bin.override { cudaPackages = fixedCudaPackages; };
      torchvision-bin = pyPrev.torchvision-bin.override { cudaPackages = fixedCudaPackages; };
      torchaudio-bin = pyPrev.torchaudio-bin.override { cudaPackages = fixedCudaPackages; };
      torch = pyFinal.torch-bin;
      torchvision = pyFinal.torchvision-bin;
      torchaudio = pyFinal.torchaudio-bin;
    };
  };

  comfyuiPackage = pkgs.comfyui.override {
    python3 = comfyuiPython;
    # Node Manager, so workflows can install their missing custom nodes, plus the Python
    # packages those nodes need, since the Manager cannot pip-install into the store.
    extraPackages = ps: [
      ps.comfyui-manager
      # ComfyUI_Comfyroll_CustomNodes
      ps.matplotlib
      ps.arabic-reshaper
      ps.python-bidi
      # ComfyUI_Mira
      ps.opencv-python-headless
      ps.piexif
      ps.onnxruntime
    ];
  };

  comfyuiCuda = pkgs.writeShellScriptBin "comfyui" ''
    export LD_PRELOAD="/run/opengl-driver/lib/libcuda.so.1''${LD_PRELOAD:+:$LD_PRELOAD}"
    exec ${comfyuiPackage}/bin/comfyui --enable-manager "$@"
  '';

  # Upstream typo: the Horde endpoint reads `nfsw`, so the NSFW toggle never reaches Horde
  # and every image is sent as SFW (and censored). Build fails once upstream fixes it.
  sillytavernPatched = pkgs.sillytavern.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace src/endpoints/horde.js \
        --replace-fail "request.body.nfsw" "request.body.nsfw"
    '';
  });

  # ai-code: KoboldCpp with code.kcpps and Claude Code connected to it, started in ~.
  aiCode = pkgs.writeShellScriptBin "ai-code" (builtins.readFile ../../scripts/run_ai_code.sh);
in
{
  # The current version of CUDA on nix-pkgs is borked, so locking it to a version for KoboldCpp
  # nixpkgs.config.cudaSupport = true;
  nixpkgs.config.cudaCapabilities = [ "8.9" ];

  home.packages = [
      sillytavernPatched
      koboldcppCuda
      comfyuiCuda
      aiCode
  ];
}
