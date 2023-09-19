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


--- BEGIN LINK CREATOR
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
--- END LINK CREATOR


--- BEGIN FIND BACKLINKS
function find_backlinks()
  local current_file = vim.fn.expand('%:p:r')  -- Get the current file name without extension
  local project_root = vim.loop.cwd() -- Get the directory where Neovim was initiated
  local relative_path = string.sub(current_file, #project_root + 2)  -- Get the relative path from Neovim's initiation directory
  local file_name = vim.fn.expand('%:t:r')  -- Get the file name without the extension
  if relative_path then
    require('telescope.builtin').grep_string({ search = '[[' .. relative_path .. ']]|[[' .. file_name .. ']]' })
  else
    print("Could not determine the relative path of the current file.")
  end
end
--- END FIND BACKLINKS



--- BEGIN MOVE FILE
local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values

function move_current_file_to_selected_dir()
  local current_file = vim.fn.expand('%:p')
  
  if current_file == '' then
    print('No file to move')
    return
  end

  local current_dir = vim.fn.expand('%:p:h')
  local dirs = vim.fn.glob(current_dir .. '/*', 0, 1)
  local dir_names = {}
  for _, dir in pairs(dirs) do
    if vim.loop.fs_stat(dir).type == 'directory' then
      table.insert(dir_names, vim.fn.fnamemodify(dir, ':t'))
    end
  end
  
  pickers.new({}, {
    prompt_title = 'Move file to',
    finder = finders.new_table {
      results = dir_names,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local selection = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        local dest_dir = vim.fn.finddir(selection.value, current_dir .. '/*')
        local dest_path = dest_dir .. '/' .. vim.fn.fnamemodify(current_file, ':t')
        os.rename(current_file, dest_path)
        vim.cmd('e ' .. dest_path)
      end)
      
      return true
    end,
  }):find()
end
--- END MOVE FILE



-- BEGIN OPEN OLDEST FILE
function open_oldest_git_file()
  -- Get the root path of the git repository
  local handle = io.popen('git rev-parse --show-toplevel')
  local git_root = handle:read("*a"):gsub("%s+$", "")
  handle:close()

  if #git_root == 0 then
    print("Not in a git repository.")
    return
  end

  -- Get a random oldest file from the git log
  handle = io.popen("git log --diff-filter=A --pretty=format:'' --name-only | grep -E '.*\\.md$' | grep -v '^Sources/' | sort | uniq -u | shuf | head -n 1")
  local oldest_file = handle:read("*a"):gsub("%s+$", "")
  handle:close()

  -- Open the oldest file in Neovim
  if #oldest_file > 0 then
    vim.cmd("e " .. vim.fn.fnameescape(git_root .. "/" .. oldest_file))
  else
    print("Could not find the oldest file.")
  end
end
vim.api.nvim_set_keymap('n', '<Leader><Leader>', ':lua open_oldest_git_file()<CR>', { noremap = true, silent = true })
-- END OPEN OLDEST FILE
