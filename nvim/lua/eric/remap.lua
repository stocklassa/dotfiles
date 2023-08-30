vim.g.mapleader = " "
-- Both of those do NOT work
-- vim.keymap.set("n", "<leader>v", vim.cmd.so '/home/eric/.config/nvim/init.lua')
-- vim.keymap.set('n', '<leader>v', [[<cmd>luafile ~/.config/nvim/init.lua<CR>]], { noremap = true, silent = true })

vim.keymap.set('n', '<Leader>VV', ':e /home/eric/dotfiles/nvim/lua/eric/remap.lua<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>VP', ':e /home/eric/dotfiles/nvim/lua/plugins/init.lua<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>d', [[<Cmd>put =strftime('%c')<CR>]])
vim.keymap.set('n', '<Leader>esc', [[<Cmd>!/usr/bin/setxkbnoremap -option "caps:swapescape"<CR>]])
vim.keymap.set('n', '<Leader>s', ":term<CR>")
vim.keymap.set('n', '<Leader>gs', ":Git<CR>")
vim.keymap.set('n', '<Leader>w', ":ObsidianToday<CR>")
vim.keymap.set('n', '<Leader>q', ":e /home/eric/zettelkasten-notes/Plugins for Neovim.md<CR>")
vim.keymap.set('n', '<Leader>e', ":e /home/eric/zettelkasten-notes/Current Writing Project.md<CR>")

vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
