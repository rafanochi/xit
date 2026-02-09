{
  description = "Build truly native applications with ease!";

  inputs = {
    # Stable for keeping thins clean
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Fresh and new for testing
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # The flake-utils library
    flake-utils.url = "github:numtide/flake-utils";

    # rust-overlays
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { nixpkgs, flake-utils, rust-overlay, ... }:
    # @ inputs
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };

        rustVersion = "latest";
        rust = pkgs.rust-bin.stable.${rustVersion}.default.override {
          extensions = [
            "rustc"
            "cargo"
            "rustfmt"
            "clippy"
            "rust-analyzer"
            "rust-src"
            # "cargo-watch"
          ];
        };

      in {
        # Nix script formatter
        formatter = pkgs.alejandra;

        # Development environment
        devShells.default = import ./shell.nix { inherit pkgs rust; };
      });
}
