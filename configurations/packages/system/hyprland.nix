{ pkgs, ...}:

{
    programs.hyprland.enable = true;

    environment.systemPackages = [ pkgs.egl-wayland ];
    
    # Enable greetd display manager
    services.greetd = {
        enable = true;
        vt = 2;
        settings = {
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
                user = "greeter";
            };
        };
    };
}
