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
            (pkgs.python3.withPackages (ps: [
              ps.venvShellHook
            ]))
          ];

          shellHook = ''
            if [ -d "./.venv" ]; then
              # Directly activate.
              source .venv/bin/activate
            else 
              # Create virtual env.
              python -m venv .venv
              
              # Inject libmagic.
              PY_LIB_DIR=".venv/lib/$(python -c 'import sys; print(f"python{sys.version_info.major}.{sys.version_info.minor}")')/site-packages"
              cp -f ./scripts/inject-libmagic.pth "$PY_LIB_DIR/"
              
              # Activate env and install requirements.
              source .venv/bin/activate
              pip install -r requirements.txt
            fi
          '';
        };
      });
}