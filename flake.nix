{
  description =
    "A flake giving access to fonts that I use, outside of nixpkgs.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        font_squirel = name: "https://www.fontsquirrel.com/fonts/download/${name}"; 
      in {
        # defaultPackage = pkgs.symlinkJoin {
        #   name = "myfonts-0.1.4";
        #   paths = builtins.attrValues
        #     self.packages.${system}; # Add font derivation names here
        # };

        # packages.alex-brush = pkgs.stdenvNoCC.mkDerivation {
        defaultPackage = pkgs.stdenvNoCC.mkDerivation {
          name = "alex-brush";
          # dontConfigue = true;
          src = pkgs.fetchurl {
          
            url = font_squirel "alex-brush";
            sha256 = "sha256-M6NYNrEKJoAod1WJEwqgReUeOe/KfnO0zi+FURKd85w=";
            # stripRoot = false;
          };
          unpackPhase = ''
            runHook preUnpack
            # echo "hello"
            ls $src
            unzip $src

            runHook postUnpack
          '';
          installPhase = ''
            runHook preInstall
            ls *.ttf
            # unzip alex-brush.zip
            mkdir -p $out/share/fonts/truetype/
            install -Dm644 *.ttf $out/share/fonts/truetype/

            runHook postInstall
          '';
          meta = { description = "A flowy font named alex brush"; };
          nativeBuildInputs = [pkgs.unzip];
        };

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
