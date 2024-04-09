{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    meptlpkgs.url = "gitlab:Meptl/meptlpkgs";
  };

  outputs = { self, nixpkgs, meptlpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    devShell.${system} = pkgs.mkShell {
      buildInputs = with pkgs; [
        pre-commit

        # Seems like python is pulled from meptlpkgs which can be outdated.
        # Used by aider.
        python312

        # Custom gdtoolkit 4.0 build.
        meptlpkgs.packages.${system}.gdtoolkit
      ];
      shellHook = ''
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc
        ]}
      '';
    };
  };
}
