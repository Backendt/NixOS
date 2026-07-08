
{ lib, ... }:

{
    imports = [ ./monitors.nix ./workspaces.nix ];

    wayland.windowManager.hyprland.settings = {
        # Disable battery hungry effects
        decoration = {
            shadow.enabled = false;
            blur.enabled = lib.mkForce false;
        };

        # Invert scrolling direction
        input.touchpad.natural_scroll = true;

        # Disable scaling on XWayland
        xwayland.force_zero_scaling = true;
    };
}
