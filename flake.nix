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
            pkgs.python311Full
            (pkgs.python3.withPackages (ps: [
              ps.pip
            ]))
          ];

          shellHook = ''
            if ! pip freeze | grep -q mmrl-util==; then
              pip install mmrl-util
            fi
          '';
        };
      });
}