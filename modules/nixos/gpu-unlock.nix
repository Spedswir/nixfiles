# Removes the GeForce tensor core cap at boot. https://github.com/Zagitta/gpu-unlock
# gpu_unlock has to run before nvidia binds the card, so it loads in stage 1.
# nvidia is not in the initrd on these hosts, which gives that order for free.
{ config, pkgs, ... }:

let
  version = "2.0.0";
  nvVersion = "610.43.03"; # Only used as a firmware source, independent of the installed driver.

  src = pkgs.fetchFromGitHub {
    owner = "Zagitta";
    repo = "gpu-unlock";
    rev = "7eb51bccae0a0b7e599e084d971170e9a1e82d0c";
    hash = "sha256-1KD/J1S1uyI5GGoTwQ1cU/sXeEKlG54exSvi6U+j73M=";
  };

  nvSource = pkgs.fetchurl {
    url = "https://download.nvidia.com/XFree86/NVIDIA-kernel-module-source/NVIDIA-kernel-module-source-${nvVersion}.tar.xz";
    sha256 = "7e118923c7a23edc36114d63273a46e3e04e9af98695a42203e7ac2dfe9fc1dc";
  };

  nvInstaller = pkgs.fetchurl {
    url = "https://download.nvidia.com/XFree86/Linux-x86_64/${nvVersion}/NVIDIA-Linux-x86_64-${nvVersion}-no-compat32.run";
    sha256 = "e084451db730a6df29d3d74f655749c4d236e3c945f7d94b5205e84318fe2f90";
  };

  firmware = pkgs.stdenvNoCC.mkDerivation {
    pname = "gpu-unlock-firmware";
    inherit version src;

    nativeBuildInputs = [ pkgs.python3 pkgs.zstd ];

    buildPhase = ''
      runHook preBuild
      mkdir nv
      tar -xf ${nvSource} -C nv
      python3 firmware/extract_gsp.py ${nvInstaller} assets
      python3 firmware/extract_boot_assets.py nv/NVIDIA-kernel-module-source-${nvVersion} assets
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      make install-firmware DESTDIR=$out ASSETS=$PWD/assets \
        FWDIR=/lib/firmware/gpu-unlock/${nvVersion} LICENSEDIR=/share/licenses
      runHook postInstall
    '';
  };

  module = config.boot.kernelPackages.callPackage ({ stdenv, kernel }:
    stdenv.mkDerivation {
      pname = "gpu-unlock";
      version = "${version}-${kernel.version}";
      inherit src;
      sourceRoot = "source/kernel/gpu_unlock";

      nativeBuildInputs = kernel.moduleBuildDependencies;
      hardeningDisable = [ "pic" "format" ];
      makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

      installPhase = ''
        runHook preInstall
        install -Dm644 gpu_unlock.ko $out/lib/modules/${kernel.modDirVersion}/extra/gpu_unlock.ko
        runHook postInstall
      '';
    }) { };
in
{
  boot.extraModulePackages = [ module ];
  hardware.firmware = [ firmware ];
  # The firmware follows into the initrd through the module's MODULE_FIRMWARE list.
  boot.initrd.kernelModules = [ "gpu_unlock" ];
  boot.kernelParams = [ "gpu_unlock.targets=all" ];
}
