{ ... }:

{
    imports = [
        ../packages/user/stylix
        ../packages/user/stylix/overrides/poimandres
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
