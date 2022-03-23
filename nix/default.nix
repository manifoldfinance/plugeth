{ system ? builtins.currentSystem
, nixpkgs ? import ./nixpkgs.nix { inherit system; }
}:
let
  sources = import ./sources.nix;

  devshell = import sources.devshell { pkgs = nixpkgs; };
in
rec {
  inherit nixpkgs;

  # Docs: https://numtide.github.io/devshell/modules_schema.html
  env = devshell.mkShell {
    env = [
      # Configure nix to use nixpgks
      { name = "NIX_PATH"; value = "nixpkgs=${toString nixpkgs.path}"; }
    ];

    packages = [
      # geth
      nixpkgs.go_1_17

      # utils
      nixpkgs.gitAndTools.git-absorb
      nixpkgs.just
      nixpkgs.niv
      nixpkgs.websocat
    ];

    commands = [
      { name = "j"; category = "dev"; help = "just a command runner"; command = ''${nixpkgs.just}/bin/just "$@"''; }
    ];
  };
}
