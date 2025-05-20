
{ ... }:

{
    imports = [
        ./desktop-monitors.nix
        ./desktop-workspaces.nix
    ];

    wayland.windowManager.hyprland.settings = {
        env = [
            "LIBVA_DRIVER_NAME,nvidia"
            "XDG_SESSION_TYPE,wayland"
            "GDM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        ];

        cursor = {
            default_monitor = "DP-1";
        };
    };
}
