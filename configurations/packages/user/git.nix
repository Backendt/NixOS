{ config, settings, ... }:

{
    programs.git = {
        enable = true;
        userName = settings.gh-username;
        userEmail = settings.gh-email;
        extraConfig = {
            init.defaultBranch = "main";
            pull.rebase = true;
            push.autoSetupRemote = true;
        };
    };
}
