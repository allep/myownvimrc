require("config.lazy")

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Interface
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.wrap = false

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.splitright = true
opt.splitbelow = true

-- Mappings
local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", { desc = "Sx window" })
map("n", "<C-j>", "<C-w>j", { desc = "Below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Dx window" })
map("n", "<C-x>e", ":tabe<CR>", { desc = "New tab" })
map("n", "<C-x>n", "gt<CR>", { desc = "Next tab" })
map("n", "<C-x>p", "gT<CR>", { desc = "Prev tab" })
map("n", "<C-x><space>", ":Exp<CR>", { desc = "Open netrw" })

local telescope_builtin = require('telescope.builtin')
map("n", "<C-x>o", telescope_builtin.grep_string, { desc = "Telescope grep string" })
map("n", "<C-x>i", telescope_builtin.live_grep, { desc = "Telescope live grep" })
map("n", "<C-x>f", telescope_builtin.find_files, { desc = "Telescope find files" })

