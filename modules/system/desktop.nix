{ config, pkgs, ... }:

{
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

}
