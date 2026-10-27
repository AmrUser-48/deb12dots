-- Options {{{
local undo_dir = vim.fn.stdpath('config') .. '/undo'
vim.fn.mkdir(undo_dir, 'p')

local config_options = {
  wildignorecase = true,
  pastetoggle = '<F12>',
  splitbelow = true,
  splitright = true,
  tabstop = 4,
  softtabstop = 4,
  shiftwidth = 4,
  expandtab = true,
  visualbell = true,
  errorbells = false,
  mouse = 'a',
  ignorecase = true,
  smartcase = true,
  showmatch = true,
  incsearch = true,
  history = 10000,
  number = false,
  relativenumber = false,
  wrap = true,
  showcmd = true,
  termguicolors = true,
  background = 'dark',
  undofile = true,
  undodir = undo_dir,
  foldmethod = 'marker',
  foldmarker = '{{{,}}}',
  fillchars = { fold = ' ', vert = '│', eob = ' ', msgsep = '‾' },
  listchars = { tab = '> ', space = '·', extends = '>', precedes = '<', nbsp = '␣', trail = '•', eol = '¬' },
  modeline = true,
  modelines = 5,
}

for option, value in pairs(config_options) do
  vim.opt[option] = value
end

if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
  vim.opt.grepformat = '%f:%l:%c:%m'
end

vim.opt.wildignore:append({
  '*.o', '*.obj', '*.dylib', '*.bin', '*.dll', '*.exe',
  '*/.git/*', '*/.svn/*', '*/__pycache__/*', '*/build/**',
  '*.jpg', '*.png', '*.jpeg', '*.bmp', '*.gif', '*.tiff', '*.svg', '*.ico',
  '*.pyc', '*.pkl',
  '*.DS_Store',
  '*.aux', '*.bbl', '*.blg', '*.brf', '*.fls', '*.fdb_latexmk', '*.synctex.gz', '*.xdv'
})

vim.opt.matchpairs:append({ '<:>', '「:」', '『:』', '【:】', '“:”', '‘:’', '《:》' })
-- }}}

-- Global {{{
local global_vars = {
  loaded_perl_provider = 0,
  loaded_ruby_provider = 0,
  loaded_node_provider = 0,
  loaded_python3_provider = 0,
  did_install_default_menus = 1,
  vimsyn_embed = 'l',
  loaded_netrw = 1,
  loaded_netrwPlugin = 1,
  netrw_liststyle = 3,
  loaded_2html_plugin = 1,
  loaded_tutor_mode_plugin = 1,
  loaded_matchit = 1,
  loaded_matchparen = 1,
  startify_custom_header = {},
  translate_target = 'uk',
}

for var, value in pairs(global_vars) do
  vim.g[var] = value
end
-- }}}

-- Keymaps {{{
vim.g.mapleader = ' '

local function map(mode, lhs, rhs, is_remap)
  vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = not is_remap })
end

map('n', '<leader>w', ':<C-U>update<CR>')
map('n', '<leader>q', ':<C-U>x<CR>')
map('n', '<leader>Q', ':<C-U>qa!<CR>')
map('n', '<leader>[', ':<C-U>bp<CR>')
map('n', '<leader>]', ':<C-U>bn<CR>')
map('n', '<leader>l', ':<C-U>set list!<CR>')
map('n', '<leader>n', ':set invnumber invrelativenumber<CR>')

map({ 'n', 'v', 'i' }, '<F2>', '<Esc>:update <CR>')
map('n', '<F3>', ':<C-U>q<CR>')
map('i', '<F3>', '<C-O>:q<CR>')
map({ 'i', 'v', 'n' }, '<F10>', '<Esc>ZQ')

-- Exit Insert Mode without shifting the cursor backward
map('i', '<C-k>', '<Esc>l')
map('i', 'kj', '<Esc>l')
map('i', 'jk', '<Esc>l')

-- CMD
vim.keymap.set({ 'n', 'x' }, ';', ':', { silent = false, noremap = true })
vim.keymap.set('n', '<C-Up>', ':<C-F>', { silent = false, noremap = true })

-- Clipboard
map({ 'n', 'v' }, '<leader>p', '"+p')
map({ 'n', 'v' }, '<leader>y', '"+y')

-- Black-hole modifications (Visual-only to safeguard normal mode 'd', 'x', and 'c' motions)
map('x', 'c', '"_c')
map('n', 'C', '"_C')
map('n', 'cc', '"_cc')

-- Visual paste workaround that preserves selection register safety rules cleanly
map('x', 'p', '"_dP')

-- J & y Position Restorations
map('n', 'J', 'mzJ`z')
map('n', 'y', 'myy')
map('x', 'y', 'myy')

-- TABS
map('n', '<leader>t', ':tabnew<CR>')
map('n', '<C-PageUp>', 'gT')

-- WINDOWS
map('n', '<Right>', '<C-w>l')
map('n', '<Left>', '<C-w>h')
map('n', '<Down>', '<C-w>j')
map('n', '<Up>', '<C-w>k')
map('n', '<leader>s', '<C-w>s')
map('n', '<leader>v', '<C-w>v')
map('n', '<leader>c', '<C-w>c')
-- }}}

-- Completer {{{
-- 1. Essential options for a clean popup behavior
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.shortmess:append("c") -- Hide extra completion messages like "match 1 of 2"

-- 2. Automatically trigger keyword completion (buffer words) while typing
vim.api.nvim_create_autocmd("TextChangedI", {
  pattern = "*",
  callback = function()
    local col = vim.fn.col(".") - 1
    local line = vim.fn.getline(".")
    local sub = line:sub(col, col)
    -- Trigger completion if the character before the cursor is a letter or number and not a space
    if col > 0 and sub:match("[%w_]") then
      if vim.fn.pumvisible() == 0 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, true, true), "n")
      end
    end
  end,
})

-- 3. Friendly Tab behavior: Tab cycles through completion menu or inserts a normal Tab
vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  else
    return "<Tab>"
  end
end, { expr = true })

vim.keymap.set("i", "<S-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  else
    return "<S-Tab>"
  end
end, { expr = true })
-- }}}

-- Lua Framework Dependencies {{{
require('alpha-nvim')

-- Sudo save function
vim.api.nvim_create_user_command('W', function()
  local file = vim.fn.expand('%:p')
  vim.cmd(string.format("silent write !sudo tee %s > /dev/null", vim.fn.shellescape(file)))
  vim.cmd('edit!')
  vim.notify("Saved via sudo: " .. file, vim.log.levels.INFO)
end, { desc = "Sudo write bypass" })

map('n', '<leader>2', ':W<CR>')

-- }}}

-- Plugins Settings {{{
-- Translate {{{
-- map('n', 'gr', '<Plug>(Translate)', true)
-- map('v', 't', '<Plug>(VTranslate)', true)
-- }}}

-- NvimTree {{{
-- 1. Disable netrw at the absolute start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 2. Optional: Enable true color support
vim.opt.termguicolors = true

-- Use the current nvim-tree setup API (Neovim 0.7-compatible).
local status_ok, nvim_tree = pcall(require, "nvim-tree")
if status_ok then
  nvim_tree.setup({
    view = {
      side = "left",
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
      custom = { "%.git", "node_modules", "%.cache" },
    },
  })
end

-- 5. Global Keymap to toggle the sidebar window
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true })
-- }}}


-- }}}

-- Appearance {{{
-- COLORSCHEME {{{
vim.cmd('packadd vim-gruvbox8')
vim.cmd('colorscheme gruvbox8')
-- }}}

-- Lualine {{{
require('lualine').setup({
  options = {
    theme = 'gruvbox',
    icons_enabled = false,
    section_separators = "",
    component_separators = "",
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {''},
    lualine_c = {'filename'},
    lualine_x = {'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
})
-- extra {{{
-- Match the exact modules found in your tree structure
local lualine_themes = {
  "auto",
  "solarized",
  "dracula",
  "gruvbox",
  "gruvbox_dark",
  "gruvbox_light",
  "gruvbox-material",
  "ayu",
  "base16",
}

vim.api.nvim_create_user_command("SetLualine", function(opts)
  local status_ok, lualine = pcall(require, "lualine")
  if status_ok then
    lualine.setup({ options = { theme = opts.args } })
  else
    print("Lualine not found")
  end
end, {
  nargs = 1,
  complete = function(ArgLead, CmdLine, CursorPos)
    return vim.tbl_filter(function(item)
      return item:find("^" .. ArgLead) ~= nil
    end, lualine_themes)
  end,
})
-- }}}
-- }}}
-- }}}

-- File Manager Configuration (lf) {{{
local function run_lf_filemanager()
  local temp = vim.fn.tempname()
  local cmd = 'lf -selection-path=' .. vim.fn.shellescape(temp)
  
  vim.cmd('tabedit')
  
  vim.fn.termopen(cmd, {
    on_exit = function()
      vim.cmd('tabclose!')
      if vim.fn.filereadable(temp) == 1 then
        local names = vim.fn.readfile(temp)
        if #names > 0 then
          -- FIX: Targeted array indices directly to stop string concatenation failures
          vim.cmd('edit ' .. vim.fn.fnameescape(names[1]))
          for i = 2, #names do
            vim.cmd('argadd ' .. vim.fn.fnameescape(names[i]))
          end
        end
      end
      vim.cmd('redraw!')
    end
  })
  vim.cmd('startinsert')
end

vim.api.nvim_create_user_command('LF', run_lf_filemanager, { bar = true })
vim.keymap.set('n', '<leader>o', run_lf_filemanager, { silent = true, noremap = true })
-- }}}

-- Autocommands {{{
local autogroup = vim.api.nvim_create_augroup('CoreGroup', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = autogroup,
  pattern = '*',
  callback = function()
    -- FIX: Changed highlight group target to 'IncSearch' for baseline cross-colorscheme protection
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400, on_macro = true })
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = autogroup,
  pattern = '*',
  callback = function()
    local last_pos = vim.fn.line([['"]])
    if last_pos > 1 and last_pos <= vim.fn.line('$') then
      vim.cmd([[normal! g'"]])
    end
  end,
})
-- vi: ts=4 sw=4 sts=4 et sr foldmethod=marker foldmarker={{{,}}}
-- }}}

-- Startify: show recent files on demand {{{
local alpha = require("alpha")
local startify = require("alpha.themes.startify")

-- Disable icons without requiring nvim-web-devicons.
startify.nvim_web_devicons.enabled = false

-- Show the global recent-files list only, not a second cwd-specific list.
startify.config.layout = {
  { type = "padding", val = 1 },
  startify.section.header,
  { type = "padding", val = 1 },
  startify.section.mru,
  { type = "padding", val = 1 },
  startify.section.bottom_buttons,
}

vim.api.nvim_create_user_command("AlphaRecent", function()
  if vim.bo.filetype == "alpha" then
    vim.cmd("enew")
  end
  alpha.start(false, startify.config)
end, { desc = "Show recent files" })
-- }}}
