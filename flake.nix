{
  description =
    "A flake giving access to fonts that I use, outside of nixpkgs.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        font_squirrel = name: "https://www.fontsquirrel.com/fonts/download/${name}"; 
        font_install_command = type:
          if type == "ttf" then
            ''              
              mkdir -p $out/share/fonts/truetype/
              install -Dm644 *.ttf $out/share/fonts/truetype/
            ''
          else if type == "otf" then
            ''
              mkdir -p $out/share/fonts/opentype/
              install -Dm644 *.otf $out/share/fonts/opentype/
            ''
          else type
        ;   
        make_font_squirrel = {name, sha, type}:
          pkgs.stdenvNoCC.mkDerivation {
                  # defaultPackage = pkgs.stdenvNoCC.mkDerivation {
                    name = name;
                    # dontConfigue = true;
                    src = pkgs.fetchurl {
          
                      url = font_squirrel name;
                      sha256 = sha;
                      # stripRoot = false;
                    };
                    unpackPhase = ''
                      runHook preUnpack
                      # echo "hello"
                      # ls $src
                      unzip $src

                      runHook postUnpack
                    '';
                    installPhase = ''
                      runHook preInstall
                      # ls *.ttf
                      # unzip alex-brush.zip
                      ${font_install_command type}
                      # mkdir -p $out/share/fonts/truetype/
                      # install -Dm644 *.ttf $out/share/fonts/truetype/

                      runHook postInstall
                    '';
                    meta = { description = "A flowy font named alex brush"; };
                    nativeBuildInputs = [pkgs.unzip];
                  };
      in {
        defaultPackage = pkgs.symlinkJoin {
          name = "myfonts-0.1.4";
          paths = builtins.attrValues
            self.packages.${system}; # Add font derivation names here
        };

        packages.alex-brush = make_font_squirrel {
          name = "alex-brush";
          sha = "sha256-M6NYNrEKJoAod1WJEwqgReUeOe/KfnO0zi+FURKd85w=";
          type = "ttf";
        };

        packages.quicksand = make_font_squirrel {
          name = "quicksand";
          sha = "sha256-FB0KsUFIduZYNlaVnmdPdax3SdI8ABr1j79tS2M64/Y=";
          type = "otf";
        };

        packages.arizonia = make_font_squirrel {
          name = "arizonia";
          sha = "sha256-ZXH2ZPP/VK0SnLKr41h5WBMuTczCm1FqxLNQ3+Mb+7g=";
          type = "ttf";
        };

        packages.caviar-dreams = make_font_squirrel {
          name = "caviar-dreams";
          sha = "sha256-IetJKRLl6xbruSVNNbBDqp2bIwDlpaWkX5sBblMV2W0=";
          type = "ttf";
        };
        # packages.alex-brush = pkgs.stdenvNoCC.mkDerivation {
        # # defaultPackage = pkgs.stdenvNoCC.mkDerivation {
        #   name = "alex-brush";
        #   # dontConfigue = true;
        #   src = pkgs.fetchurl {
          
        #     url = font_squirel "alex-brush";
        #     sha256 = "sha256-M6NYNrEKJoAod1WJEwqgReUeOe/KfnO0zi+FURKd85w=";
        #     # stripRoot = false;
        #   };
        #   unpackPhase = ''
        #     runHook preUnpack
        #     # echo "hello"
        #     # ls $src
        #     unzip $src

        #     runHook postUnpack
        #   '';
        #   installPhase = ''
        #     runHook preInstall
        #     ls *.ttf
        #     # unzip alex-brush.zip
        #     mkdir -p $out/share/fonts/truetype/
        #     install -Dm644 *.ttf $out/share/fonts/truetype/

        #     runHook postInstall
        #   '';
        #   meta = { description = "A flowy font named alex brush"; };
        #   nativeBuildInputs = [pkgs.unzip];
        # };

        # packages.quicksand = pkgs.stdenvNoCC.mkDerivation {
        # # defaultPackage = pkgs.stdenvNoCC.mkDerivation {
        #   name = "quicksand";
        #   # dontConfigue = true;
        #   src = pkgs.fetchurl {
          
        #     url = font_squirel "quicksand";
        #     sha256 = "sha256-Bh4K79gLu7mnnGEzzDQjorTTPhy4Cx6uBhG3u6CzcE8=";
        #     # stripRoot = false;
        #   };
        #   unpackPhase = ''
        #     runHook preUnpack
        #     # echo "hello"
        #     # ls $src
        #     unzip $src

        #     runHook postUnpack
        #   '';
        #   installPhase = ''
        #     runHook preInstall
        #     ls *.otf
        #     # unzip alex-brush.zip
        #     mkdir -p $out/share/fonts/opentype/
        #     install -Dm644 *.otf $out/share/fonts/opentype/

        #     runHook postInstall
        #   '';
        #   meta = { description = "A flowy font named alex brush"; };
        #   nativeBuildInputs = [pkgs.unzip];
        # };
        # packages.gillsans = pkgs.stdenvNoCC.mkDerivation {
        #   name = "gillsans-font";
        #   dontConfigue = true;
        #   src = pkgs.fetchzip {
        #     url =
        #       "https://freefontsvault.s3.amazonaws.com/2020/02/Gill-Sans-Font-Family.zip";
        #     sha256 = "sha256-YcZUKzRskiqmEqVcbK/XL6ypsNMbY49qJYFG3yZVF78=";
        #     stripRoot = false;
        #   };
        #   installPhase = ''
        #     runhook PreInstall

        #     mkdir -p $out/share/fonts/opentype/
        #     cp -R $src $out/share/fonts/opentype/

        #     runhook PostInstall
        #   '';
        #   meta = { description = "A Gill Sans Font Family derivation."; };
        # };

        # packages.palatino = pkgs.stdenvNoCC.mkDerivation {
        #   name = "palatino-font";
        #   dontConfigue = true;
        #   src = pkgs.fetchzip {
        #     url =
        #       "https://www.dfonts.org/wp-content/uploads/fonts/Palatino.zip";
        #     sha256 = "sha256-FBA8Lj2yJzrBQnazylwUwsFGbCBp1MJ1mdgifaYches=";
        #     stripRoot = false;
        #   };
        #   installPhase = ''
        #     runhook PreInstall

        #     mkdir -p $out/share/fonts/truetype/
        #     cp -R $src/Palatino $out/share/fonts/truetype/

        #     runhook PostInstall
        #   '';
        #   meta = { description = "The Palatino Font Family derivation."; };
        # };
      });
}
