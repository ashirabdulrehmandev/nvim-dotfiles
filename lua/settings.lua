-- settings.lua - Basic Vim options

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs and indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.foldcolumn = "0"  -- Hide fold column

-- Behavior
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- Completion settings (for LSP)
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.updatetime = 250

-- Split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.o.cmdheight = 2
