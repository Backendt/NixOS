{
    description = "A Nix & Home-manager configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

        home-manager.url = "github:nix-community/home-manager/release-26.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
	    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
        stylix.url = "github:danth/stylix/release-26.05";
        serena.url = "github:oraios/serena/v1.7.0";
        elephant.url = "github:abenz1267/elephant";
        walker = {
          url = "github:abenz1267/walker";
          inputs.elephant.follows = "elephant";
        };
    };

    outputs = inputs@{ nixpkgs, nixpkgs-unstable, ... }:
        let
            settings = import ./settings.nix;
            unstablePkgs = import nixpkgs-unstable {
                system = settings.system;
                config.allowUnfree = true; # Forgive me Richard
            };
        in {
            nixosConfigurations = {
                mbec-nixos = nixpkgs.lib.nixosSystem {
                    system = settings.system;
                    specialArgs = { inherit inputs settings;};
                    modules = [
                        ./configurations/default.nix
                        ({ ...}: {
                            nixpkgs.config.allowUnfree = true;
                            nixpkgs.overlays = [
                                (final: prev: { unstable = unstablePkgs;})
                            ];
                        })
                    ];
                };
            };
        };
}
