{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # limine
  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };

  # networking
  networking.hostName = "ryzen";
  networking.networkmanager.enable = true;

  # locale
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


  # plasma
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true; # Force SDDM to use Wayland
  services.desktopManager.plasma6.enable = true;
  
  # fuck x11
  services.xserver.enable = false;
  # theoretically for xwayland fallback?
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.cpu.amd.updateMicrocode = true;


  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  console.keyMap = "pl2";

  services.printing.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.flatpak.enable = true;

  # User Account
  users.users.a = {
    isNormalUser = true;
    description = "a";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ kdePackages.kate ];
  };

  # Programs & Nix Settings
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
