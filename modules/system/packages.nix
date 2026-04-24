{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    wget
    git
    antigravity-fhs
    trayscale
    tailscale-systray
    unrar
    rar
    lm_sensors
    onlyoffice-desktopeditors
    (callPackage ../../packages/p7zip-gui { })
  ];
}
