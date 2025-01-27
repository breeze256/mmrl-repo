{
  description = "The flake for MMRL Repo.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.python311
            pkgs.zlib
            (pkgs.python3.withPackages (ps: [
              ps.venvShellHook
            ]))
          ];

          shellHook = ''
            cp -f ./scripts/inject-libmagic.pth ./.venv/lib/python3.11/site-packages/inject-libmagic.pth
            # Add virtual environment.
            python -m venv .venv
            source .venv/bin/activate
            # Install requirements.
            pip install -r requirements.txt
          '';
        };
      });
}