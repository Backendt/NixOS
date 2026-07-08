{
    imports = [ ./default.nix ];

    programs.waybar = {
        systemd.targets = [ "hyprland-session.target" ];
        settings.main = {
            modules-left = ["hyprland/workspaces"];

            "hyprland/workspaces" = {
                all-outputs = true;
                persistent-workspaces = {
                    "*" = [1 2 3 4 5 6 7 8 9 10];
                };
            };
        };
    };
}
