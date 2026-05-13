{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      droidcam = prev.droidcam.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          ../../packages/droidcam/fix-tjTransform-heap-corruption.patch
        ];
      });
    })
  ];

  programs.droidcam.enable = true;

  boot.kernelModules = [ "snd-aloop" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 card_label="DroidCam"
    options snd-aloop enable=1
  '';
}
