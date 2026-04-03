{ pkgs, ... }:

{
  programs.droidcam.enable = true;

  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';

  environment.systemPackages = with pkgs; [
    wget
    vesktop
    telegram-desktop
    git
    antigravity-fhs
  ];
}
