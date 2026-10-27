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
    gh
    htop
    lm_sensors
    pciutils
    usbutils
    wget

    # gh authenticates `git push` to GitHub. After `gh auth login`, run
    # `gh auth setup-git` so git uses gh as its credential helper.
    # nixsync stages every file and refreshes flake.lock. Nix reads a git
    # flake from the tracked files of the working tree, so new files must be
    # staged before nixos-rebuild can see them. It works in the given
    # directory, or /etc/nixos when no argument is given.
    (writeShellScriptBin "nixsync" ''
      cd -- "''${1:-/etc/nixos}"
      git add -A
      nix flake update
      git add flake.lock
      git status --short --branch
    '')
  ];
}
