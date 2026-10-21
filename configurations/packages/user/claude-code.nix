{ pkgs, ... }:

let
    ponytail_version = "v5.3.2";
    ponytail_hash = "sha256-IJlhfkdXI6pMZZCZO7XBRg88LBiNfzc5Gnm4ofGybL8=";
in {
    programs.claude-code = {
        enable = true;
        package = pkgs.unstable.claude-code;
        settings.enabledPlugins = {
            "superpowers@claude-plugins-official" = true;
            "context7@claude-plugins-official" = true;
            "modern-web-guidance@claude-plugins-official" = true;
            "ponytail@ponytail" = true;
            # LSPs
            "typescript-lsp@claude-plugins-official" = true;
            "rust-analyzer-lsp@claude-plugins-official" = true;
        };

        marketplaces = {
            ponytail = pkgs.fetchFromGitHub {
                owner = "dietrichgebert";
                repo = "ponytail";
                rev = ponytail_version;
                hash = ponytail_hash;
            };
        };
    };

    home.packages = [
        pkgs.typescript-language-server
        pkgs.nodejs
    ];
}
