{
  description = ''LaTeX cv '';
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {inherit system;};
    tex = pkgs.texlive.combine {
      inherit (pkgs.texlive)
      scheme-basic
      xetex
      beamer
      beamertheme-metropolis
      pgfopts xkeyval fontaxes fancyvrb
      booktabs caption # table
      xecjk ctex unicode-math ipaex
      adjustbox
      amsmath
      babel
      capt-of
      dvisvgm
      dvipng # for preview and export as html
      digestif
      enumitem
      # fontenc
      fontawesome5
      fira
      fp
      framed
      geometry
      graphicxpsd
      pst-graphicx
      hyperref
      # inputenc
      ifmtarg
      jknapltx
      lipsum
      latex-uni8
      luainputenc
      listingsutf8
      marvosym
      microtype
      mlmodern
      paralist
      pdfcol
      pgf
      pgfkeyx
      rsfs
      scheme-medium
      tcolorbox
      tikzfill
      titlesec
      titling
      trimspaces
      wrapfig
      ucs
      ulem
      upquote
      url
      xcolor
      xifthen
      ;
    };
    fontsConf = pkgs.makeFontsConf {
      fontDirectories = [
        "${tex}/share/texmf/"
      ];
    };
  in rec {
    packages = {
      cv = pkgs.runCommand "cv" {
        buildInputs = [ pkgs.coreutils tex pkgs.pandoc ];
        FONTCONFIG_FILE = fontsConf;
        name = "cv.tex";
        src = ./.;
      } ''
        cp -r $src/* ./
        mkdir $out
        ${tex}/bin/latexmk \
        --pdf \
        -outdir=$out \
        cv.tex

      '';
    };
    defaultPackage = packages.cv;
  });
  nixConfig = {
    extra-substituters = [
      "https://cache.iog.io"
    ];
    extra-trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
    allow-import-from-derivation = true;
  };
}
