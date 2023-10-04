{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      apps.xrandr = { type = "app"; program = "${pkgs.xorg.xrandr}/bin/xrandr"; };
      packages.xrandr = pkgs.xorg.xrandr;
      # package doesn't contain binaries, or binary name doesn't match package name
      packages.bash-preexec = pkgs.bash-preexec;
      # package doesn't contain binaries, or binary name doesn't match package name
      packages.wlroots = pkgs.wlroots;

      # special case for az
      apps.az = { type = "app"; program = "${pkgs.azure-cli}/bin/az"; };
      packages.az = pkgs.azure-cli;

      # special case for git-gui, from /libexec/git-core/git-gui
      apps.git-gui = { type = "app"; program = "${pkgs.gitFull}/libexec/git-core/git-gui"; };
      packages.git-gui = pkgs.gitFull;

      # special case for gitk
      apps.gitk = { type = "app"; program = "${pkgs.gitFull}/bin/gitk"; };
      packages.gitk = pkgs.gitFull;
    });
}
