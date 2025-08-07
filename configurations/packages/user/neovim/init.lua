-- Main settings
vim.g.mapleader = " ";
vim.g.maplocalleader = " ";
vim.opt.guicursor = "";
vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.wrap = false;
vim.opt.scrolloff = 8;
vim.opt.tabstop = 4;
vim.opt.shiftwidth = 4;
vim.opt.expandtab = true;
vim.opt.smartindent = true;
vim.opt.incsearch = true;
vim.opt.ignorecase = true;
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- Keymaps
vim.keymap.set("n", "<leader><Right>", vim.diagnostic.goto_next);
vim.keymap.set("n", "<leader><Left>", vim.diagnostic.goto_prev);
vim.keymap.set("n", "gd", vim.lsp.buf.definition);
vim.keymap.set("n", "gD", vim.lsp.buf.references);
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition);
vim.keymap.set("n", "gi", vim.lsp.buf.implementation);

-- Plugins

