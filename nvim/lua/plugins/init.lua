local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local opts = {}

local plugins = {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'akinsho/flutter-tools.nvim',
		lazy = false,
		dependencies = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim',
		},
		config = true,
	},
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
	{"nvim-treesitter/playground"},
	{"tpope/vim-unimpaired"},
	{"tpope/vim-fugitive"},
	{"tpope/vim-surround"},
	{"vim-airline/vim-airline"},
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		dependencies = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{'williamboman/mason.nvim'},           -- Optional
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},     -- Required
			{'hrsh7th/cmp-nvim-lsp'}, -- Required
			{'L3MON4D3/LuaSnip'},     -- Required
		}
	},
-- 	{
-- 		"epwalsh/obsidian.nvim",
-- 		lazy = true,
-- 		event = { "BufReadPre /home/eric/zettelkasten-notes/**.md" },
-- 		dependencies = {
-- 			"nvim-lua/plenary.nvim",
-- 		},
-- 		opts = {
-- 			dir = "~/zettelkasten-notes",
-- 		},
-- 	},
}

require("lazy").setup(plugins, opts)

require'nvim-treesitter.configs'.setup {
	ensure_installed = { "markdown", "json", "dart", "python", "lua", "ruby", "bash" },
	highlight = {
		enable = true
	}
}

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

-- require ("obsidian").setup {
-- 	dir = "~/zettelkasten-notes",
-- 	completion = {
-- 		nvim_cmp = true,
-- 		min_chars = 2,
-- 	},
-- 	mappings = {
-- 		["gf"] = require("obsidian.mapping").gf_passthrough(),
-- 	},
-- }
require("flutter-tools").setup {}
