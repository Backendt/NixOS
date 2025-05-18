{ inputs, pkgs, ... }:

{
    imports = [
        inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
	extraSpecialArgs = { inherit inputs; };
        sharedModules = [
            ./git.nix
            ./bash.nix
	    ./nixvim.nix
            ./firefox.nix
            ./programming.nix
            ./kitty.nix
            ./pentest.nix
            {
                home.stateVersion = "24.11";
                home.packages = with pkgs; [
                    gimp
                    onlyoffice-bin
                    vlc
                    feh
                    unstable.vesktop
                    spotify
                    ungoogled-chromium
                    playerctl
                    brightnessctl
                ];
            }
        ];
    };    
}
