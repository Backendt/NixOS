{ settings, ... }:

{
    programs.bash = {
        enable = true;
        shellAliases = {
            la = "ls -lA";
	        battery = "cat /sys/class/power_supply/BAT0/capacity";
            nixclean = "doas nix-collect-garbage -d";
            nixbuild = "doas nixos-rebuild switch --flake ${settings.flake-directory}";
            nixtest = "echo 'WARNING: This build is not persistent'; doas nixos-rebuild test --flake ${settings.flake-directory}";
            update = "doas nix flake update --flake ${settings.flake-directory} && nix flake update --flake ${settings.flake-directory} && echo 'Done ! Please rebuild NixOS.'";
        };

        historyIgnore = [
            "ls"
            "la"
            "cd"
            "exit"
        ];

        bashrcExtra = ''
            bind '"\e[A":history-search-backward'
            bind '"\e[B":history-search-forward'
            green=$(tput setaf 2)
            reset_color=$(tput sgr0)
            PS1='\W/\[$green\]-> \[$reset_color\]'
        '';
    };
}
