{ pkgs, ... }:

{
    wayland.windowManager.hyprland.settings = {
        monitor = [
            "eDP-1, 1920x1200, 0x0, 1.5"
            "Unknown-1, disable"
            " , preferred, auto-left, 1"
        ];

        # Set primary monitor on XWayland
        exec = ["xrandr --output 'eDP-1' --primary"];
    };

    home.packages = [ pkgs.xorg.xrandr ];
}
