{ settings, ... }:

{
    imports = [ ../packages/system/hyprland.nix ];
    home-manager.users.${settings.username}.imports = [ ../packages/user/hyprland ../packages/user/waybar/hyprland.nix ];
}
