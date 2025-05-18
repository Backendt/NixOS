{ config, pkgs, ...}:

{
    security.doas = {
        enable = true;

        extraRules = [{
            groups = ["wheel"];
            persist = true;
            setEnv = [ "NIX_PATH" "LOCALE_ARCHIVE" ];
        }];
    };

    # Sudo replacement
    security.sudo.enable = false;
    environment.systemPackages = [
        (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
    ];
}
