{ config, inputs, pkgs, settings, ... }:

{
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "old";
        overwriteBackup = true;
	    extraSpecialArgs = { inherit inputs; inherit settings; hostname = config.networking.hostName; };
        sharedModules = [
            ./git.nix
            ./bash.nix
	        ./nixvim.nix
            ./firefox.nix
            ./programming.nix
            ./kitty.nix
            ./pentest.nix
            ./gpg.nix
            ./ssh.nix
            settings.theme
            {
                home.stateVersion = "25.11";
                home.packages = with pkgs; [
                    gimp
                    onlyoffice-desktopeditors
                    vlc
                    feh
                    unstable.vesktop
                    spotify
                    ungoogled-chromium
                    playerctl
                    brightnessctl
                    zip
                    unzip
                    dust
                    tree
                    jq
                    wirelesstools
                    imv
                    obsidian
                ];
            }
        ];
    };
}
