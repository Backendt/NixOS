{ pkgs, ... }:

{
    stylix.targets.neovim.enable = false;

    programs.neovim = {
        plugins = [ pkgs.vimPlugins.poimandres-nvim ];

        initLua = ''
            require('poimandres').setup {
                    disable_background = true,
            }
            vim.cmd('colorscheme poimandres')
        '';
    };
}
