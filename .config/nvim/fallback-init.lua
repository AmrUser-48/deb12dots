-- ========================================================================== --
-- 1. CORE OPTIONS (:help options)
-- ========================================================================== --
vim.opt.number = true             -- Show absolute line numbers
vim.opt.relativenumber = true     -- Show relative line numbers for easy jumping
vim.opt.mouse = 'a'               -- Enable mouse support in all modes
vim.opt.termguicolors = true      -- Enable 24-bit RGB colors

-- Indentation & Tabs
vim.opt.tabstop = 4               -- Number of spaces a tab counts for
vim.opt.softtabstop = 4           -- Number of spaces a tab counts for while editing
vim.opt.shiftwidth = 4            -- Size of an indent
vim.opt.expandtab = true          -- Convert tabs to spaces
vim.opt.smartindent = true        -- Insert indents automatically

-- Search Behavior
vim.opt.ignorecase = true         -- Case-insensitive searching
vim.opt.smartcase = true          -- Case-sensitive if search contains capitals
vim.opt.incsearch = true          -- Show match previews while typing

-- Splitting Windows
vim.opt.splitbelow = true         -- Horizontal splits open below
vim.opt.splitright = true         -- Vertical splits open to the right

-- Undo & Backup Management
vim.opt.undofile = true           -- Save undo history to file across restarts
vim.opt.swapfile = false          -- Disable swap files
vim.opt.backup = false            -- Disable backup files

-- Global variables (Leader key must be set before any mappings)
vim.g.mapleader = ' '

-- ========================================================================== --
-- 2. KEYMAPS (:help vim.keymap.set)
-- ========================================================================== --
local function map(mode, lhs, rhs, opts)
  local options = { silent = true, noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Clear search highlights on pressing Escape in Normal Mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Fast File Saving / Quitting
map('n', '<leader>w', '<cmd>update<CR>')
map('n', '<leader>q', '<cmd>quit<CR>')
map('n', '<leader>Q', '<cmd>qa!<CR>')

-- Window Navigation (Using Control + Directions)
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Clean Exit Insert Mode (Keeps cursor in its exact column position)
map('i', 'jk', '<Esc>l')
map('i', 'kj', '<Esc>l')

-- Better Visual Mode Indentation (Keeps text selected when shifting)
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Clipboard Integration (Use Leader to interface with System Clipboard)
map({'n', 'v'}, '<leader>y', '"+y')
map({'n', 'v'}, '<leader>p', '"+p')

-- ========================================================================== --
-- 3. AUTOCOMMANDS (:help autocmd)
-- ========================================================================== --
local augroup = vim.api.nvim_create_augroup('CoreGroup', { clear = true })

-- Briefly highlight yanked text on copy (:help vim.highlight.on_yank)
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- Return to last edit position when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup,
  pattern = '*',
  callback = function()
    local last_pos = vim.fn.line([['"]])
    if last_pos > 1 and last_pos <= vim.fn.line('$') then
      vim.cmd([[normal! g'"]])
    end
  end,
})
