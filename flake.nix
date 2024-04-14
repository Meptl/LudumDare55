{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
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

        # Cropping images.
        gthumb
      ];
      shellHook = ''
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc
        ]}
      '';
    };
  };
}
