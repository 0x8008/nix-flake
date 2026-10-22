{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
      };
      FirefoxHome = {
        Search = false;
        TopSites = false;
        SponsoredTopSites = false;
        Pocket = false;
        SponsoredPocket = false;
        Highlights = false;
        Snippets = false;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
      };
      Preferences = {
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "layout.css.prefers-color-scheme.content-override" = 0;
        "ui.systemUsesDarkTheme" = 1;
        "browser.uidensity" = 1;
        "browser.tabs.warnOnClose" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # Desktop applications.
    vesktop
    telegram-desktop
    file-roller

    # Archive command-line tools.
    p7zip
    unrar
    zip
    unzip

    # Wayland desktop tools.
    foot
    fuzzel
    waybar
    mako
    swaybg
    swaylock
    wl-clipboard
    grim
    slurp
    playerctl
    pavucontrol
  ];
}
