{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    vesktop
    telegram-desktop
    git
    antigravity-fhs
  ];
}
