{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flakery.url = "github:getflakery/flakes";
    hercules-ci-agent.url = "github:hercules-ci/hercules-ci-agent/stable";

  };

  outputs = { self, nixpkgs, flakery, hercules-ci-agent }: {
    nixosConfigurations.hello-flakery = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        flakery.nixosModules.flakery
        ./configuration.nix 
      ];
      specialArgs = { inherit hercules-ci-agent; };
    };
  };
}