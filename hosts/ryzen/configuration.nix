{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # limine
  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = with config.boot.kernelPackages; [ it87 ];
  boot.kernelModules = [ "coretemp" "it87" ];
  boot.kernelParams = [ "acpi_enforce_resources=lax" ];
  boot.extraModprobeConfig = ''
    options it87 force_id=0x8623
  '';
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };

  # networking
  networking.hostName = "ryzen";

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


  # zram
  zramSwap.enable = true;

  hardware.cpu.amd.updateMicrocode = true;




  console.keyMap = "pl2";

  services.printing.enable = true;


  services.flatpak.enable = true;

  # User Account
  users.users.a = {
    isNormalUser = true;
    description = "a";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [ kdePackages.kate ];
    shell = pkgs.zsh;
  };

  # Programs & Nix Settings
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
