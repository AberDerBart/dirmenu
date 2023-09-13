{
  description = "dirmenu";
  inputs = { 
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };  
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "direnv";
          src = self;
          buildInputs = with pkgs; [ xorg.libX11 xorg.libXinerama zlib xorg.libXft ];
          installPhase = "mkdir -p $out/bin; install -t $out/bin dirmenu";
        };
      }
    );  
}

