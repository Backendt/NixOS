{ ... }:

{
    imports = let
        overrides = ../packages/user/stylix/overrides/poimandres;
    in [
        ../packages/user/stylix
        (overrides + "/waybar.nix")
        (overrides + "/neovim.nix")
        (overrides + "/nixvim.nix")
        (overrides + "/wofi.nix")
        (overrides + "/vesktop.nix")
    ];

    stylix = {
        image = ../packages/user/stylix/wallpapers/night-nature.jpg;
        base16Scheme = ../packages/user/stylix/styles/poimandres.yaml;

        opacity = {
            terminal = 0.7;
            desktop = 0.4;
        };
    };
}
