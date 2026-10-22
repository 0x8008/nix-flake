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
    runHook postInstall
  '';

  meta = {
    description = "Posy's cursors improved by wrinkdater, mono black scheme";
    homepage = "https://github.com/wrinkdater/Posys-Cursors-Improved-by-wrinkdater";
    license = lib.licenses.cc-by-nc-40;
    platforms = lib.platforms.unix;
  };
})
