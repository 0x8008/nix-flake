{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/kernel.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/apps.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/shell.nix
  ];

  networking.hostName = "c612";
  networking.networkmanager.enable = true;
  services.openssh.enable = true;

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };
  console.keyMap = "pl2";

  # XKB layout for the graphical session. wlroots does not read the vconsole
  # keymap, so labwc also exports XKB_DEFAULT_LAYOUT (home/a/labwc.nix).
  # "pl" is the programmer's layout: QWERTY with Polish letters on AltGr.
  services.xserver.xkb.layout = "pl";

  users.users.a = {
    isNormalUser = true;
    description = "a";
    shell = pkgs.zsh;
    extraGroups = [
      "audio"
      "gamemode"
      "input"
      "networkmanager"
      "render"
      "video"
      "wheel"
    ];
    # Replace this password after the first login with `passwd`.
    initialPassword = "changeme";
  };

  boot.loader.limine = {
    enable = true;
    maxGenerations = 5;

    # Monochrome boot menu, no wallpaper.
    style = {
      wallpapers = [ ];
      backdrop = "0B0B0B";
      interface = {
        branding = "NixOS";
        brandingColor = "E6E6E6";
        helpColor = "6A6A6A";
        helpColorBright = "FFFFFF";
      };
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;

  zramSwap.enable = true;

  # 24 GiB swapfile, created automatically on activation.
  swapDevices = [
    {
      device = "/swap";
      size = 24576;
    }
  ];

  system.stateVersion = "26.05";
}
