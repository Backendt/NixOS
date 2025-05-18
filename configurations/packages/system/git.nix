{ pkgs, ... }:

{
    environment.systemPackages = [
        pkgs.git
    ];

    programs.git.config = {
        init.defaultBranch = "main";
        safe.directory = "*";
    };
}
