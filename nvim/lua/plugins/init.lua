vim.o.termguicolors = true

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
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
	{"nvim-treesitter/playground"},
	{"tpope/vim-unimpaired"},
	{"tpope/vim-fugitive"},
	{"tpope/vim-surround"},
	{"tpope/vim-sleuth"},
	{"ThePrimeagen/harpoon"},
	{"nvim-tree/nvim-web-devicons"},
	{'ryanoasis/vim-devicons'},
	{"vim-airline/vim-airline"},
	{"vim-airline/vim-airline-themes"},
	{
		'morhetz/gruvbox',
		config = function()
			if vim.fn.has('termguicolors') then
				vim.o.termguicolors = true
			end

			vim.cmd [[colorscheme gruvbox]]
		end
	},
	{"junegunn/goyo.vim"},
	{"junegunn/limelight.vim"},
	{"lewis6991/gitsigns.nvim"},
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
	{
		'akinsho/flutter-tools.nvim',
		lazy = false,
		dependencies = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim', -- optional for vim.ui.select
		},
		config = true,
	},
	{"norcalli/nvim-colorizer.lua"},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {} -- this is equalent to setup({}) function
	},
	{"mhartington/formatter.nvim"},
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

local dart_lsp = lsp.build_options('dartls', {})

require("flutter-tools").setup {
	lsp = {
		capabilities = dart_lsp.capabilities,
		settings = {
			lineLength = 120,
		},
	},
}

require("colorizer").setup()
require("gitsigns").setup()

local actions = require('telescope.actions')
require('telescope').setup{}

function find_files_and_paste()
  require('telescope.builtin').find_files({
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local entry = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        if entry then
          local filename = entry.value
          local filepath_without_extension = filename:match("(.+)%..+$")
          if filepath_without_extension then
            vim.api.nvim_put({"[[" .. filepath_without_extension .. "]]"}, "c", true, true)
          else
            vim.api.nvim_put({"[[" .. filename .. "]]"}, "c", true, true)
          end
        end
	vim.fn.feedkeys('a', 'n')
      end)
      return true
    end,
  })
end
-- Create a Vim command to call the function
vim.cmd [[ command! FindFilesAndPaste lua find_files_and_paste() ]]

-- Set up a key mapping in insert mode to call the function when [[ is typed
vim.api.nvim_set_keymap('i', '[[', '<C-o>:lua vim.schedule(function() find_files_and_paste() end)<CR>', { noremap = true, silent = true })


function find_backlinks()
  local current_file = vim.fn.expand('%:p:r')  -- Get the current file name without extension
  local project_root = vim.loop.cwd() -- Get the directory where Neovim was initiated
  local relative_path = string.sub(current_file, #project_root + 2)  -- Get the relative path from Neovim's initiation directory
  if relative_path then
    require('telescope.builtin').grep_string({ search = '[[' .. relative_path .. ']]' })
  else
    print("Could not determine the relative path of the current file.")
  end
end
