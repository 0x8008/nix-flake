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
    # The lantian cache serves the CachyOS kernel builds. The cache moved to
    # cache.lantian.pub with a new signing key after the October 2026 incident
    # (xddxdd/nix-cachyos-kernel#110).
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
    htop
    lm_sensors
    pciutils
    usbutils
    wget
  ];
}
