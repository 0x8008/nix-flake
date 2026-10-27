{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "launcher" ''
      set -eu

      # A second Super tap closes the running launcher.
      if ${pkgs.procps}/bin/pgrep -x fuzzel >/dev/null 2>&1; then
        ${pkgs.procps}/bin/pkill -x fuzzel
        exit 0
      fi

      # Applications and files share one fuzzel dmenu. Column 1 is the
      # label, column 2 is the action.
      choice=$(
        {
          declare -A seen
          IFS=: read -r -a data_dirs <<< "''${XDG_DATA_HOME:-$HOME/.local/share}:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

          for dir in "''${data_dirs[@]}"; do
            [ -d "$dir/applications" ] || continue
            for file in "$dir"/applications/*.desktop; do
              [ -e "$file" ] || continue
              id=''${file##*/}
              [ -n "''${seen[$id]:-}" ] && continue
              seen[$id]=1

              entry=$(sed -n '/^\[Desktop Entry\]$/,/^\[/p' "$file")
              grep -qx 'Type=Application' <<< "$entry" || continue
              grep -qx 'Hidden=true' <<< "$entry" && continue
              grep -qx 'NoDisplay=true' <<< "$entry" && continue
              name=$(sed -n 's/^Name=//p' <<< "$entry" | head -n1)
              [ -n "$name" ] || continue

              printf '%s\tapp:%s\n' "$name" "$file"
            done
          done

          cd "$HOME"
          ${pkgs.fd}/bin/fd --type f --type d --exclude node_modules \
            . | while IFS= read -r file; do
              printf '~/%s\tfile:%s/%s\n' "$file" "$HOME" "$file"
            done
        } | ${pkgs.fuzzel}/bin/fuzzel --dmenu --with-nth=1 --accept-nth=2 \
              --only-match --placeholder 'Applications and files'
      ) || exit 0

      case "$choice" in
        app:*) exec ${pkgs.glib}/bin/gio launch "''${choice#app:}" ;;
        file:*)
          path=''${choice#file:}
          if ! ${pkgs.glib}/bin/gio open "$path"; then
            # No default handler (or the portal failed): reveal it in Thunar.
            exec ${pkgs.thunar}/bin/thunar "$path"
          fi
          ;;
      esac
    '')
  ];
}
