{
    username = "mat";
    system = "x86_64-linux";
    flake-directory = "~/.dotfiles";

    # Github
    gh-username = null;
    gh-email = null;

    # Desktop environment
    desktop = ./configurations/desktop-environment/hyprland.nix;
    theme = ./configurations/themes/poimandres.nix;
}
