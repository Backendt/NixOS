{ config, pkgs, ... }:

{
    wayland.windowManager.hyprland.settings = {
        "$mod" = "SUPER";
        bind = [
            # Apps
            "$mod, Return, exec, kitty"
            "$mod, Space, exec, wofi -GiIS drun"
            "$mod, B, exec, firefox --private-window"
            "$mod + SHIFT, B, exec, firefox"
            "$mod + SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"
            ", Print, exec, grim - | wl-copy"
            "$mod, Escape, exit"
            "$mod, L, exec, hyprlock"

            # Replay
            "ALT, twosuperior, exec, replay-save"

            # Volume & Microphone controls
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            "CTRL, XF86AudioMute, exec, notify-send 'Microphone' 'Mute toggled'; wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

            # Media control
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AUdioPrev, exec, playerctl previous"
            ", XF86AUdioNext, exec, playerctl next"

            # Brightness controls
            ", XF86MonBrightnessDown, exec, brightnessctl set 3%-"
            ", XF86MonBrightnessUp, exec, brightnessctl set +3%"
            
            "$mod + SHIFT, Q, killactive"
            "$mod, F, fullscreen"

            # Move focus with arrow keys
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"

            # Move window with arrow keys
            "$mod + SHIFT, left, movewindow, l"
            "$mod + SHIFT, right, movewindow, r"
            "$mod + SHIFT, up, movewindow, u"
            "$mod + SHIFT, down, movewindow, d"

            # Switch workspaces (FRENCH KEYBOARD)
            "$mod, ampersand, workspace, 1"
            "$mod, eacute, workspace, 2"
            "$mod, quotedbl, workspace, 3"
            "$mod, apostrophe, workspace, 4"
            "$mod, parenleft, workspace, 5"
            "$mod, minus, workspace, 6"
            "$mod, egrave, workspace, 7"
            "$mod, underscore, workspace, 8"
            "$mod, ccedilla, workspace, 9"
            "$mod, agrave, workspace, 10"

            # Switch workspaces (NUMPAD)
            "$mod, KP_End, workspace, 1"
            "$mod, KP_Down, workspace, 2"
            "$mod, KP_Next, workspace, 3"
            "$mod, KP_Left, workspace, 4"
            "$mod, KP_Begin, workspace, 5"
            "$mod, KP_Right, workspace, 6"
            "$mod, KP_Home, workspace, 7"
            "$mod, KP_Up, workspace, 8"
            "$mod, KP_Prior, workspace, 9"
            "$mod, KP_Insert, workspace, 10"

            # Move window to workspace (FRENCH KEYBOARD)
            "$mod + SHIFT, ampersand, movetoworkspace, 1"
            "$mod + SHIFT, eacute, movetoworkspace, 2"
            "$mod + SHIFT, quotedbl, movetoworkspace, 3"
            "$mod + SHIFT, apostrophe, movetoworkspace, 4"
            "$mod + SHIFT, parenleft, movetoworkspace, 5"
            "$mod + SHIFT, minus, movetoworkspace, 6"
            "$mod + SHIFT, egrave, movetoworkspace, 7"
            "$mod + SHIFT, underscore, movetoworkspace, 8"
            "$mod + SHIFT, ccedilla, movetoworkspace, 9"
            "$mod + SHIFT, agrave, movetoworkspace, 10"

            # Move window to workspace (NUMPAD)
            "$mod + SHIFT, KP_End, movetoworkspace, 1"
            "$mod + SHIFT, KP_Down, movetoworkspace, 2"
            "$mod + SHIFT, KP_Next, movetoworkspace, 3"
            "$mod + SHIFT, KP_Left, movetoworkspace, 4"
            "$mod + SHIFT, KP_Begin, movetoworkspace, 5"
            "$mod + SHIFT, KP_Right, movetoworkspace, 6"
            "$mod + SHIFT, KP_Home, movetoworkspace, 7"
            "$mod + SHIFT, KP_Up, movetoworkspace, 8"
            "$mod + SHIFT, KP_Prior, movetoworkspace, 9"
            "$mod + SHIFT, KP_Insert, movetoworkspace, 10"

            # Super Tab to switch workspaces
            "$mod, tab, workspace, e+1"
            "$mod + SHIFT, tab, workspace, e-1"
        ];

        bindm = [
            # Move/resize windows with mod + LMB/RMB and dragging
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
        ];
    };
}
