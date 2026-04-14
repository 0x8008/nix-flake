{ config, pkgs, ... }:

{
  programs.droidcam.enable = true;

  boot.kernelModules = [ "snd-aloop" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 card_label="DroidCam"
  '';
}
