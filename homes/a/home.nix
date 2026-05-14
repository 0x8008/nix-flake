{
  home.username = "a";
  home.homeDirectory = "/home/a";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;

    shellAliases = {
      rebuild-nix = "cd ~/Documents/nix-flake && sudo nixos-rebuild switch --flake \".#$(hostname)\"";
    };

    initContent = ''
      autoload -U colors && colors
      autoload -Uz vcs_info
      setopt PROMPT_SUBST

      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:git:*' formats ' %F{magenta}[%b]%f'
      zstyle ':vcs_info:git:*' actionformats ' %F{magenta}[%b|%a]%f'

      precmd() { vcs_info; }

      PROMPT='%F{cyan}[%n@%m]%f %F{blue}%d%f: '
      RPROMPT='%(?..%F{red}[%?]%f)''${vcs_info_msg_0_} %F{243}[%T]%f'

      bindkey "^[[H"  beginning-of-line
      bindkey "^[[F"  end-of-line
      bindkey "^[[3~" delete-char
    '';
  };

  # Win10-style taskbar: pinned launchers and their running task collapse
  # into one slot (separateLaunchers=false), the running task takes the
  # launcher's exact position (launchInPlace=true), and ordering is
  # explicit/draggable instead of reshuffling on virtual-desktop changes
  # (sortingStrategy=0 / "manually"). Applet ID 25 is the
  # org.kde.plasma.taskmanager widget on the existing panel — if the
  # panel is rebuilt and the ID shifts, this section name needs to follow.
  programs.plasma = {
    enable = true;
    configFile."plasma-org.kde.plasma.desktop-appletsrc"."Containments/2/Applets/25/Configuration/General" = {
      separateLaunchers = false;
      launchInPlace = true;
      sortingStrategy = 0;
    };
  };
}
