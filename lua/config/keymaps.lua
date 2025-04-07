-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Use <space> - | instead
-- vim.keymap.set("n", "<leader>vs", "<cmd>vsplit <CR>", { desc = "Split buffer vertically" })

vim.keymap.set("n", "<leader>vs", "<cmd>vsplit <CR>", { desc = "Split buffer vertically" })
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")
