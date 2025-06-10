{ pkgs, ... }:

{
    wayland.windowManager.hyprland.settings = {
        monitor = [
            "eDP-1, 1920x1200, 0x0, 1.5"
            "DP-1, preferred, auto-right, 1"
            "DP-2, preferred, auto-left, 1"
            "Unknown-1, disable"
            " , preferred, auto-left, 1"
        ];

        # Set primary monitor on XWayland
        exec = ["xrandr --output 'eDP-1' --primary"];
    };

    home.packages = [ pkgs.xorg.xrandr ];
}
