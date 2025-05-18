
{ config, lib, pkgs, ... }:

{
    imports = [
        ./common.nix
    ];

    wayland.windowManager.hyprland.settings = {
        # Disable battery hungry effects
        decoration = {
            shadow.enabled = false;
            blur.enabled = lib.mkForce false;
        };
        misc.vfr = true;

        # Invert scrolling direction
        input.touchpad.natural_scroll = true;

        # Disable scaling on XWayland
        xwayland.force_zero_scaling = true;
    };

}
