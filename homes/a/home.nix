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
}
