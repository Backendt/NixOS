{ pkgs, ... }:

{
    services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm;
        loadModels = [ "llama3.1" "qwen3-coder" ];
        syncModels = true;
    };
}
