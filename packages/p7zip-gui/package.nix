{ stdenv
, lib
, fetchurl
, wxwidgets_3_2
, python3
, yasm
, nasm
}:

stdenv.mkDerivation rec {
  pname = "p7zip-gui";
  version = "16.02";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/p7zip/p7zip/${version}/p7zip_${version}_src_all.tar.bz2";
    sha256 = "5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f";
  };

  patches = [
    (fetchurl {
      url = "https://src.fedoraproject.org/rpms/p7zip/raw/f34/f/14-Fix-g++-warning.patch";
      sha256 = "a923c8876f36201064b0efabbc2121e47cf7a78a0700d3974ef24ab3a05bd88a";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/a82b67f5d36f374afd154e7648bb13ec38a3c497/trunk/CVE-2016-9296.patch";
      sha256 = "f9bcbf21d4aa8938861a6cba992df13dec19538286e9ed747ccec6d9a4e8f983";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/a82b67f5d36f374afd154e7648bb13ec38a3c497/trunk/CVE-2017-17969.patch";
      sha256 = "c6af5ba588b8932a5e99f3741fcf1011b7c94b533de903176c7d1d4c02a9ebef";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/a82b67f5d36f374afd154e7648bb13ec38a3c497/trunk/CVE-2018-5996.patch";
      sha256 = "9c92b9060fb0ecc3e754e6440d7773d04bc324d0f998ebcebc263264e5a520df";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/a82b67f5d36f374afd154e7648bb13ec38a3c497/trunk/CVE-2018-10115.patch";
      sha256 = "c397eb6ad60bfab8d388ea9b39c0c13ae818f86746210c6435e35b35c786607f";
    })
    (fetchurl {
      url = "https://src.fedoraproject.org/rpms/p7zip/raw/f34/f/gcc10-conversion.patch";
      sha256 = "f90013d66d3c9865cb56fed2fb0432057a07283d5361e2ae9e98c3d3657f42a1";
    })
    ./p7zip-gui-Implement-exit-P7ZIP-Desktop-from-file-menu.patch
  ];

  nativeBuildInputs = [ python3 ]
    ++ lib.optional stdenv.hostPlatform.isx86_64 yasm
    ++ lib.optional stdenv.hostPlatform.isi686 nasm;

  buildInputs = [ wxwidgets_3_2 ];

  preConfigure = ''
    if [ "${stdenv.hostPlatform.system}" = "x86_64-linux" ]; then
      cp makefile.linux_amd64_asm makefile.machine
    else
      cp makefile.linux_x86_asm_gcc_4.X makefile.machine
    fi
    sed -i 's/x86_64-linux-gnu//g' CPP/7zip/*/*/*.depend
    rm -f GUI/kde4/p7zip_compress.desktop
    cd Utils
    sed -i 's/_do_not_use//g' generate.py
    python3 generate.py
    cd ..
  '';

  buildPhase = ''
    make all5 OPTFLAGS="$CXXFLAGS"
  '';

  installPhase = ''
    make install \
      DEST_DIR="" \
      DEST_HOME="$out" \
      DEST_MAN="$out/share/man"

    install -D -m 644 GUI/p7zip_32.png $out/share/icons/hicolor/32x32/apps/p7zip.png
    install -D -m 644 -t $out/share/kservices5/ServiceMenus GUI/kde4/*.desktop
    install -D -m 644 -t $out/share/kio/servicemenus GUI/kde4/*.desktop
    install -D -m 644 -t $out/share/applications ${./7zFM.desktop}
    
    ln -s 7zCon.sfx $out/lib/p7zip/7z.sfx
    ln -s $out/share/doc/p7zip/DOC/MANUAL $out/lib/p7zip/help
    chmod +x $out/bin/p7zipForFilemanager

    install -d $out/share/licenses/${pname}
    ln -s -t $out/share/licenses/${pname}/ \
      $out/share/doc/p7zip/DOC/License.txt \
      $out/share/doc/p7zip/DOC/unRarLicense.txt

    # remove conflicts with 7zip (p7zip) CLI package and man pages
    rm -f $out/bin/7z $out/bin/7za $out/bin/7zr
    rm -rf $out/share/man
  '';

  meta = with lib; {
    description = "Graphic user interface (alpha quality) for the p7zip file archiver";
    homepage = "http://p7zip.sourceforge.net";
    license = with licenses; [ lgpl21Plus unfree /* unRAR */ ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
