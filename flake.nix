{
    description = "A Nix & Home-manager configuration for 3 computers";

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
                nixos-work = nixpkgs.lib.nixosSystem {
                    system = settings.system;
                    specialArgs = { inherit inputs settings;};
                    modules = [
                        ./configurations/default.nix
                        ./configurations/nixos-work.nix
                        ({ ...}: {
                            nixpkgs.config.allowUnfree = true;
                            nixpkgs.overlays = [
                                (final: prev: { unstable = unstablePkgs;})
                            ];
                        })
                    ];
                };

                nixos-desktop = nixpkgs.lib.nixosSystem {
                    specialArgs = { inherit inputs; inherit settings; };
                    system = settings.system;
                    modules = [ ./configurations/nixos-desktop.nix ./configurations ];
                };

                nixos-laptop = nixpkgs.lib.nixosSystem {
                    specialArgs = { inherit inputs; inherit settings; };
                    system = settings.system;
                    modules = [ ./configurations/nixos-laptop.nix ./configurations ];
                };
            };
        };
}
