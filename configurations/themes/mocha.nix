{ ... }:

{
    imports = [
        ../packages/user/stylix
        ../packages/user/stylix/overrides/mocha
    ];

    stylix = {
        image = ../packages/user/stylix/wallpapers/mocha.png;
        base16Scheme = ../packages/user/stylix/styles/mocha.yaml;

        opacity = {
            terminal = 0.6;
            desktop = 0.3;
        };
    };
}
