{ pkgs, ... }:

{
  boot.kernelModules = [ "ntsync" ];
  boot.kernel.sysctl = {
    "kernel.split_lock_mitigate" = 0;
    # Wine/Star Citizen need a huge mmap count.
    "vm.max_map_count" = 2147483642;
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
  # game-devices-udev-rules + Steam's own 60-steam-input.rules grant uaccess
  # on Valve hidraw/USB nodes, but neither pins USB runtime PM. The kernel
  # default (usbcore.autosuspend=2s) lets the Steam Controller 2026 dongle
  # autosuspend whenever Steam is not actively polling — which derails
  # firmware flashes mid-write and adds wake-up latency to trackpad
  # cursor input. Force runtime PM "on" on add+change so resume cycles do
  # not silently flip it back to "auto".
  services.udev.extraRules = ''
    ACTION!="remove", SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", ATTR{power/control}="on"
  '';

  environment.systemPackages = with pkgs; [
    mangohud
    gamescope
    steam-run
    protonup-qt
    winetricks
    protontricks
    mcpelauncher-ui-qt
    heroic
    (prismlauncher.override { jdks = [ jdk8 jdk21 graalvmPackages.graalvm-ce ]; })
  ];
}
