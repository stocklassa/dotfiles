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
local action_state = require('telescope.actions.state')

local function create_and_insert_file(file_path)
    -- Create a new file at the specified path
    vim.fn.system("touch " .. file_path)

    -- Insert the link into the buffer
    local file_dir, file_name = file_path:match("(.+/)(.+)%..+")
    local link = string.format("[[%s/%s]]", file_dir, file_name)
    vim.api.nvim_put({ link }, "c", true, true)
end


_G.find_files_and_paste = function()
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

  require'telescope.builtin'.find_files {
    prompt_title = "< Vim >",
    cwd = git_root,
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local entry = require"telescope.actions.state".get_selected_entry(prompt_bufnr)
        require"telescope.actions".close(prompt_bufnr)
        local filename = entry.value
        if filename then
          local relative_path = filename:match( "^" .. git_root .. "/(.+)$" ) or filename
          relative_path = relative_path:match("(.+)%..+") or relative_path
          vim.api.nvim_put({'[['..relative_path..']]'}, 'c', true, true)
          vim.api.nvim_feedkeys('a', 'n', true)
        end
      end)


map('i', '<C-x>', function(prompt_bufnr)
  local current_input = require'telescope.actions.state'.get_current_line(prompt_bufnr)
  require"telescope.actions".close(prompt_bufnr)
  if current_input then
    local file_path = git_root .. '/' .. current_input .. '.md'
    local file = io.open(file_path, "w")
    if file then
      file:close()
    else
      print("Could not create file at: " .. file_path)
    end
    local relative_path = current_input:match("(.+)%..+") or current_input
    vim.api.nvim_put({'[['..relative_path..']]'}, 'c', true, true)
    vim.api.nvim_feedkeys('a', 'n', true)
  end
end)

      return true
    end,
  }
end

-- Your autocmd group to set up the mapping
vim.api.nvim_exec([[
  augroup FindFilesAndPaste
    autocmd!
    autocmd FileType markdown inoremap <buffer> [[ <esc>:lua find_files_and_paste()<cr>
  augroup END
]], false)


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
