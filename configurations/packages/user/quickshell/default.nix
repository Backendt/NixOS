{ pkgs, config, ... }:

let
    colors = config.lib.stylix.colors.withHashtag;
    themeFile = pkgs.writeText "Theme.qml" ''
        import QtQuick

        QtObject {
            readonly property color base00: "${colors.base00}" // Desktop Background
            readonly property color base01: "${colors.base01}" // Surface / Panel
            readonly property color base02: "${colors.base02}" // Surface highlight
            readonly property color base03: "${colors.base03}" // Comments / Invisible text
            readonly property color base04: "${colors.base04}" // Dark text
            readonly property color base05: "${colors.base05}" // Default Foreground text
            readonly property color base0D: "${colors.base0D}" // Primary Accent (usually Blue)
            readonly property color base0E: "${colors.base0E}" // Secondary Accent (usually Purple)
            readonly property color base08: "${colors.base08}" // Error / Red
        }
    '';
in {
    programs.quickshell = {
        enable = true;
        systemd.enable = true;
        systemd.target = "hyprland-session.target";

        configs = {
            "shell.qml" = ./shell.qml;
            "Theme.qml" = themeFile;
        };
    };
}
