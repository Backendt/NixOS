{ pkgs, ... }:

let
    ponytail_version = "v5.3.2";
    ponytail_hash = "sha256-IJlhfkdXI6pMZZCZO7XBRg88LBiNfzc5Gnm4ofGybL8=";
    profile = ./claude-code.profile;
    sandboxed_wrapper = ./claude-sandboxed-wrapper.sh;
    claude_bin = pkgs.unstable.claude-code;
    wrapper_bin = pkgs.writeShellApplication {
        name = "claude";
        runtimeInputs = [ claude_bin ];
        text = (
            builtins.replaceStrings
                [ "@PROFILE@" "@CLAUDE@" ]
                [ "${profile}" "${claude_bin}/bin/claude" ]
            (builtins.readFile sandboxed_wrapper)
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
