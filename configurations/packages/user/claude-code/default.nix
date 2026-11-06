{ pkgs, ... }:

let
    ponytail_version = "v5.3.2";
    ponytail_hash = "sha256-IJlhfkdXI6pMZZCZO7XBRg88LBiNfzc5Gnm4ofGybL8=";
    profile = ./claude-code.profile;
    sandboxed-wrapper = ./claude-sandboxed-wrapper.sh;
    wrapper_bin = pkgs.writeShellApplication {
        name = "claude";
        runtimeInputs = [ pkgs.unstable.claude-code ];
        text = (
            builtins.replaceStrings
                [ "@PROFILE@" "@CLAUDE@" "@NODE@" ]
                [
                    "${profile}"
                    "${pkgs.unstable.claude-code}/bin/claude"
                    "${pkgs.nodejs}/bin"
                ]
            (builtins.readFile sandboxed-wrapper)
        );
    };
in {
    programs.claude-code = {
        enable = true;
        package = wrapper_bin;
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

        skills.git-workflow = ./git-workflow.skill;
    };

    home.packages = [
        wrapper_bin
        pkgs.typescript-language-server
        pkgs.nodejs
    ];
}
