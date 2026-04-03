{ config, pkgs, ... }:

{
  boot.kernelModules = [ "ntsync" ];
  boot.kernel.sysctl = {
    "kernel.split_lock_mitigate" = 0;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  services.udev.packages = [ pkgs.game-devices-udev-rules ];

  environment.systemPackages = with pkgs; [
    mangohud
    gamescope
    steam-run
    protonup-qt
    winetricks
    protontricks
    mcpelauncher-ui-qt
    (prismlauncher.override { jdks = [ jdk8 jdk21 graalvm-ce ]; })
  ];
}
