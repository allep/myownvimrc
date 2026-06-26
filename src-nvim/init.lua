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

map("n", "<C-h>", "<C-w>h", { desc = "Finestra sinistra" })
map("n", "<C-j>", "<C-w>j", { desc = "Finestra sotto" })
map("n", "<C-k>", "<C-w>k", { desc = "Finestra sopra" })
map("n", "<C-l>", "<C-w>l", { desc = "Finestra destra" })

