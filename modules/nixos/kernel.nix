{ pkgs, ... }:

{
  # CachyOS kernel with the BORE scheduler and Clang ThinLTO.
  #
  # The Xeon E5-2697 v3 (Haswell-EP) supports the x86_64-v3 instruction set.
  # BORE keeps interactive tasks responsive when the CPU is busy. ThinLTO
  # gives better code generation. Both variants are in the lantian binary
  # cache. Alternative: pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3
  # (default EEVDF scheduler, no LTO).
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;

  boot.kernelParams = [ "nowatchdog" ];

  # Proton uses ntsync for Windows synchronization primitives.
  boot.kernelModules = [ "ntsync" ];

  # Wine and Proton need many memory mappings. The old default is 65530.
  boot.kernel.sysctl."vm.max_map_count" = 1048576;
}
