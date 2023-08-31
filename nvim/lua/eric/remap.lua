vim.g.mapleader = " "

vim.keymap.set('n', '<Leader>VV', ':e /home/eric/dotfiles/nvim/lua/eric/remap.lua<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>VP', ':e /home/eric/dotfiles/nvim/lua/plugins/init.lua<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>d', [[<Cmd>put =strftime('%c')<CR>]])
vim.keymap.set('n', '<Leader>esc', [[<Cmd>!/usr/bin/setxkbmap -option "caps:swapescape"<CR>]])
vim.keymap.set('n', '<Leader>s', ":term<CR>")
vim.keymap.set('n', '<Leader>gs', ":Git<CR>")
vim.keymap.set('n', '<Leader>q', ":e /home/eric/zettelkasten-notes/Plugins for Neovim.md<CR>")
vim.keymap.set('n', '<leader>w', [[<Cmd>lua vim.cmd('vsp ' .. Get_work_log_path())<CR>]], { noremap = true, silent = true })
vim.keymap.set('n', '<leader>W', [[<Cmd>lua vim.cmd('e ' .. Get_work_log_path())<CR>]], { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ca', [[<Cmd>lua vim.lsp.buf.code_action()<CR>]], { noremap = true, silent = true })

vim.keymap.set('n', '<Leader>e', ":e /home/eric/zettelkasten-notes/Current Writing Project.md<CR>")

vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)
vim.keymap.set("n", "<leader>G", vim.cmd.Goyo)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})



vim.api.nvim_exec([[autocmd! User GoyoEnter Limelight]], false)
vim.api.nvim_exec([[autocmd! User GoyoLeave Limelight!]], false)
