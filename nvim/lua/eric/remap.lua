vim.g.mapleader = " "

vim.keymap.set('n', '<Leader>VV', ':e /home/eric/dotfiles/nvim/lua/eric/remap.lua<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>VP', ':e /home/eric/dotfiles/nvim/lua/plugins/init.lua<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>v', '[[<Cmd>source /home/eric/dotfiles/nvim/lua/eric/remap.lua<CR>]]', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>d', [[<Cmd>put =strftime('%c')<CR>]])
vim.keymap.set('n', '<Leader>esc', [[<Cmd>!/usr/bin/setxkbmap -option "caps:swapescape"<CR>]])
vim.keymap.set('n', '<Leader>s', ":term<CR>")
vim.keymap.set('n', '<Leader>gs', ":Git<CR>")
vim.keymap.set('n', '<Leader>q', ":e /home/eric/zettelkasten-notes/Hobbykasten/funnel.md<CR>")
vim.keymap.set('n', '<leader>w', [[<Cmd>lua vim.cmd('vsp ' .. Get_work_log_path())<CR>]], { noremap = true, silent = true })
vim.keymap.set('n', '<leader>W', [[<Cmd>lua vim.cmd('e ' .. Get_work_log_path())<CR>]], { noremap = true, silent = true })

vim.keymap.set('n', '<leader>ca', [[<Cmd>lua vim.lsp.buf.code_action()<CR>]], { noremap = true, silent = true })
vim.keymap.set('n', '<leader>lf', [[<Cmd>lua vim.lsp.buf.format()<CR>]], { noremap = true, silent = true })

vim.keymap.set('n', '<Leader>e', ":e /home/eric/zettelkasten-notes/Current Writing Project.md<CR>")

vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)
vim.keymap.set("n", "<leader>G", vim.cmd.Goyo)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>ft', [[<Cmd>Telescope<CR>]])



vim.api.nvim_exec([[autocmd! User GoyoEnter Limelight]], false)
vim.api.nvim_exec([[autocmd! User GoyoLeave Limelight!]], false)

-- vim.api.nvim_exec([[autocmd! BufWritePost *.dart call DartFormatAsync()]], false)
-- vim.api.nvim_exec([[autocmd! BufWritePost *.dart silent !dart format --line-length=120 %]], false)
vim.api.nvim_set_keymap('n', '<Leader>b', ':lua find_backlinks()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader>m', ':lua move_current_file_to_selected_dir()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader><Leader>', ':lua open_oldest_git_file()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader>a', ':lua require("harpoon.mark").add_file()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>h', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>1', ':lua require("harpoon.ui").nav_file(1)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>2', ':lua require("harpoon.ui").nav_file(2)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>3', ':lua require("harpoon.ui").nav_file(3)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>4', ':lua require("harpoon.ui").nav_file(4)<CR>', { noremap = true, silent = true })
