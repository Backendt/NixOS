{ pkgs, ... }:

{
    services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm;
        loadModels = [ "gpt-oss:20b" ];
        syncModels = true;
    };
}
