{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    devShell.aarch64-darwin = let
      system = "aarch64-darwin";
    in let
      python = nixpkgs.legacyPackages.aarch64-darwin.python39.override {
        enableNoSemanticInterposition = true;
      };
    in
      nixpkgs.legacyPackages.aarch64-darwin.mkShell {
        buildInputs = let
          pkgs = import nixpkgs {
            inherit system;
            #overlays = [poetry2nix.overlay];
          };
        in let
          frameworks = pkgs.darwin.apple_sdk.frameworks;
        in [python pkgs.cargo pkgs.ffmpeg frameworks.Security];

        shellHook = ''
          export PYTORCH_ENABLE_MPS_FALLBACK=1;
        '';
      };
  };
}
