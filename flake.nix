{
    description = "A Nix & Home-manager configuration";

    inputs = {
        # NixPkgs
        nixpkgs.url = "nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

        # Home manager
        home-manager.url = "github:nix-community/home-manager/release-26.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
	    # NixVim
	    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    
        # Stylix
        stylix.url = "github:danth/stylix/release-26.05";
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
                # Configurations
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
