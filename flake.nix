{
    description = "A Nix & Home-manager configuration for 3 computers";

    inputs = {
        # NixPkgs
        nixpkgs.url = "nixpkgs/nixos-24.11";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

        # Home manager
        home-manager.url = "github:nix-community/home-manager/release-24.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
	    # NixVim
	    nixvim.url = "github:nix-community/nixvim/nixos-24.11";
	    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    
        # Stylix
        stylix.url = "github:danth/stylix/release-24.11";
    };

    outputs = inputs@{ nixpkgs, ... }: 
        let
            settings = import ./settings.nix;
        in {
            nixosConfigurations = {
                # Configurations
                nixos-work = nixpkgs.lib.nixosSystem {
                    system = settings.system;
                    specialArgs = { inherit inputs; inherit settings; };
                    modules = [ ./configurations/nixos-work.nix ./configurations ];
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
