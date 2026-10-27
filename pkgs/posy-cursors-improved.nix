{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

# Posy's cursor set, as improved by wrinkdater. Only the "mono_black" scheme
# is installed. The upstream repository has no tag that contains the Linux
# themes, thus the commit pin. The theme name is "mono_black".
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "posy-cursors-improved";
  version = "0-unstable-2026-03-10";

  src = fetchFromGitHub {
    owner = "wrinkdater";
    repo = "Posys-Cursors-Improved-by-wrinkdater";
    rev = "0eaa77543b8728a2e60aa9b4386a18bc2921f5ac";
    hash = "sha256-GfqDHS8H1sTXfk9pc4R0ByDJMZxnxEUROLGFLVHlYps=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r linux/mono_black $out/share/icons/

    # The Windows scheme has a single hand cursor and no open/closed grab
    # variants, so both cursor-spec grab shapes use Posy's hand.
    # wlroots also asks for edge and corner names when resizing windows.
    cd $out/share/icons/mono_black/cursors
    ln -s hand2 grab
    ln -s hand2 grabbing
    ln -s sb_h_double_arrow left_side
    ln -s sb_h_double_arrow right_side
    ln -s sb_v_double_arrow top_side
    ln -s sb_v_double_arrow bottom_side
    ln -s size_fdiag top_left_corner
    ln -s size_bdiag top_right_corner
    ln -s size_bdiag bottom_left_corner
    ln -s size_fdiag bottom_right_corner
    ln -s sb_h_double_arrow col-resize
    ln -s sb_v_double_arrow row-resize
    ln -s sb_v_double_arrow ns-resize

    # The upstream converter linked ew-resize to the NS cursor; restore the
    # horizontal target.
    ln -sfn sb_h_double_arrow ew-resize

    # The theme used to rely on Adwaita for the missing names; make it
    # self-contained instead.
    sed -i '/^Inherits=/d' $out/share/icons/mono_black/index.theme

    runHook postInstall
  '';

  meta = {
    description = "Posy's cursors improved by wrinkdater, mono black scheme";
    homepage = "https://github.com/wrinkdater/Posys-Cursors-Improved-by-wrinkdater";
    license = lib.licenses.cc-by-nc-40;
    platforms = lib.platforms.unix;
  };
})
