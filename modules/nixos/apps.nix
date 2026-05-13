{ pkgs, ... }:

{
  programs.firefox.enable = true;
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    vesktop
    telegram-desktop
    spotify
    qbittorrent
    onlyoffice-desktopeditors
    kdePackages.kate
    (callPackage ../../packages/p7zip-gui/package.nix { })
  ];
}
