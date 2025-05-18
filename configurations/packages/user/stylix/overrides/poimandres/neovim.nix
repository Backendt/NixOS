{ config, pkgs, ... }:

{
    stylix.targets.neovim.enable = false;

    programs.neovim = {
        plugins = [ pkgs.vimPlugins.poimandres-nvim ];

	extraLuaConfig = ''
	    require('poimandres').setup {
                disable_background = true,
	    }
        vim.cmd('colorscheme poimandres')
	'';
    };
}
