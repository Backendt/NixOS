{ config, pkgs, ... }:

{
    programs.kitty = {
        enable = true;
        shellIntegration.enableBashIntegration = true;

        settings = {
            confirm_os_window_close = 0;
            cursor_shape = "beam";
            enable_audio_bell = false;
            window_padding_width = 20;
        };
    };
}
