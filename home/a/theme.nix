{ pkgs, ... }:

{
  gtk = {
    enable = true;
    colorScheme = "dark";

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Kora";
      package = pkgs.kora-icon-theme;
    };
    cursorTheme = {
      name = "mono_black";
      package = pkgs.posy-cursors-improved;
      size = 32;
    };
    font = {
      name = "Inter";
      size = 10;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # Posy's theme only ships the classic X11 cursor names. Adwaita is the
  # declared fallback in its index.theme, but it was not installed, so labwc
  # used wlroots' built-in cursors and Firefox had no grab/grabbing hand.
  # With Adwaita present, Xcursor inherits the missing shapes while Posy still
  # provides the arrow and resize cursors.
  home.packages = [ pkgs.adwaita-icon-theme ];

  home.pointerCursor = {
    enable = true;
    name = "mono_black";
    package = pkgs.posy-cursors-improved;
    size = 32;
    gtk.enable = true;
  };

  # libadwaita applications (file-roller) read the color scheme from dconf.
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "adw-gtk3-dark";
    icon-theme = "Kora";
    cursor-theme = "mono_black";
    cursor-size = 32;
    font-name = "Inter 10";
    monospace-font-name = "JetBrains Mono 10";
  };
}
