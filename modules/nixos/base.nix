{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    trusted-users = [
      "root"
      "@wheel"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://cache.lantian.pub/lantian"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  security.sudo.wheelNeedsPassword = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    gh
    htop
    lm_sensors
    pciutils
    usbutils
    wget
  ];
}
