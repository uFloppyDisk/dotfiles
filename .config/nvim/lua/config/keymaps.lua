-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

for _, mode in ipairs({ "n", "i", "v" }) do
  vim.keymap.del(mode, "<A-j>")
  vim.keymap.del(mode, "<A-k>")
end
