{ config, pkgs, ... }:

{
    stylix.targets.nixvim.enable = false;
    programs.nixvim.colorschemes.poimandres = {
		enable = true;
		settings.disable_background = true;
    };
}
