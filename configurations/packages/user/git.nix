{ settings, ... }:

{
    programs.git = {
        enable = true;
        #userName = settings.gh-username;
        #userEmail = settings.gh-email;
        settings = {
            init.defaultBranch = "main";
            pull.rebase = true;
            push.autoSetupRemote = true;
        };
    };
}
