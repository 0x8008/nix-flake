{ pkgs, ... }:

{
  programs.labwc.enable = true;

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    # greetd does not put /run/current-system/sw/bin in PATH, so use the
    # absolute path of the compositor.
    settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --cmd ${pkgs.labwc}/bin/labwc";
  };

  # AMD Vega 64 (amdgpu) and the 32-bit graphics libraries for Steam.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  services.gnome.gnome-keyring.enable = true;

  fonts = {
    packages = with pkgs; [
      inter
      jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
    ];
    fontDir.enable = true;
    fontconfig.defaultFonts = {
      sansSerif = [ "Inter" ];
      monospace = [ "JetBrains Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    XCURSOR_THEME = "mono_black";
    XCURSOR_SIZE = "32";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
