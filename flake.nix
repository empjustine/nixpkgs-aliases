{
  inputs.i-23-05.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.i-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = {
    self,
    i-23-05,
    i-unstable,
  }: {};
}
