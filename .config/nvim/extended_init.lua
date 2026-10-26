
-- Options {{{
if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg, vim.opt.grepformat = 'rg --vimgrep --no-heading --smart-case', '%f:%l:%c:%m'
end

vim.opt.wildignore:append({
  '*.o','*.obj','*.dylib','*.bin','*.dll','*.exe','*/.git/*','*/.svn/*','*/__pycache__/*','*/build/**',
  '*.jpg','*.png','*.jpeg','*.bmp','*.gif','*.tiff','*.svg','*.ico','*.pyc','*.pkl','*.DS_Store',
  '*.aux','*.bbl','*.blg','*.brf','*.fls','*.fdb_latexmk','*.synctex.gz','*.xdv'
})

local opts = {
  wildignorecase = true, pastetoggle = '<F12>', splitbelow = true, splitright = true,
  tabstop = 4, softtabstop = 4, shiftwidth = 4, expandtab = true, visualbell = true,
  errorbells = false, mouse = 'a', ignorecase = true, smartcase = true, showmatch = true,
  incsearch = true, history = 10000, number = false, wrap = true, showcmd = false,
  termguicolors = true, background = 'dark', undofile = true, modeline = true, modelines = 5,
  fillchars = { fold = ' ', vert = '│', eob = ' ', msgsep = '‾' },
  listchars = { tab = '> ', space = '·', extends = '>', precedes = '<', nbsp = '␣', trail = '•', eol = '¬' },
  undodir = vim.fn.expand('$HOME/.config/nvim/undo')
}
for k, v in pairs(opts) do vim.opt[k] = v end
vim.opt.matchpairs:append({ '<:>', '「:」', '『:』', '【:】', '“:”', '‘:’', '《:》' })
-- }}}

-- Globals {{{
local globals = {
  loaded_perl_provider = 0, loaded_ruby_provider = 0, loaded_node_provider = 0,
  loaded_python3_provider = 0, did_install_default_menus = 1, vimsyn_embed = 'l',
  loaded_netrw = 1, loaded_netrwPlugin = 1, netrw_liststyle = 3, loaded_2html_plugin = 1,
  loaded_tutor_mode_plugin = 1, loaded_matchit = 1, loaded_matchparen = 1,
  startify_custom_header = {}, translate_target = "uk"
}
for k, v in pairs(globals) do vim.g[k] = v end
-- }}}

-- Keymaps Helper & Definitions {{{
vim.g.mapleader = ' '
local function map(mode, lhs, rhs, remap)
  vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = not remap })
end

map('n', '<leader>w', ':<C-U>update<CR>')
map('n', '<leader>q', ':<C-U>x<CR>')
map('n', '<leader>Q', ':<C-U>qa!<CR>')
map('n', '<leader>[', ':<C-U>bp<CR>')
map('n', '<leader>]', ':<C-U>bn<CR>')
map('n', '<leader>l', ':<C-U>set list!<CR>')
map('n', '<leader>n', ':set invnumber invrelativenumber<CR>')
map({ 'n', 'v' }, '<F2>', '<Esc>:update <CR>')
map('n', '<F3>', '<Esc>ZQ')
map('i', '<F3>', '<C-O>ZQ')
map('i', '<C-k>', '<Esc>')
map('i', 'kk', '<Esc>')
map('i', 'jj', '<C-O>')

-- CMD {{{
vim.keymap.set({ 'n', 'x' }, ';', ':', { silent = false, noremap = true })
vim.keymap.set('n', '<C-Up>', ':<C-F>', { silent = false, noremap = true })
-- }}}

map({ 'n', 'v' }, '<leader>p', '"+p')
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'x' }, 'c', '"_c')
map('n', 'C', '"_C')
map('n', 'cc', '"_cc')
map('x', 'p', '"_c<ESC>p')
map('n', 'J', 'mzJ`z')
map('n', 'y', 'myy')
map('x', 'y', 'myy')
map('n', '<leader>t', ':tabnew<CR>')
map('n', '<C-PageUp>', 'gT')
map('n', '<Right>', '<C-w>l')
map('n', '<Left>', '<C-w>h')
map('n', '<Down>', '<C-w>j')
map('n', '<Up>', '<C-w>k')
map('n', '<leader>q', 'ZQ')
map('n', '<leader>s', '<C-w>s')
map('n', '<leader>v', '<C-w>v')
map('n', '<leader>c', '<C-w>c')
map('n', 'gr', '<Plug>(Translate)', true)
map('v', 't', '<Plug>(VTranslate)', true)
-- }}}

-- UI Plugins Setup {{{
require('alpha-nvim')
require('lualine').setup({
  options = {
    theme = 'gruvbox', icons_enabled = false, section_separators = "", component_separators = "",
    disabled_filetypes = {}, always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'}, lualine_b = {''}, lualine_c = {'filename'},
    lualine_x = {'fileformat', 'filetype'}, lualine_y = {'progress'}, lualine_z = {'location'}
  },
})
vim.cmd('colorscheme gruvbox8')
-- }}}

-- Sudo Save & Custom LF File Manager Wrapper {{{
vim.api.nvim_create_user_command('W', function()
  local file = vim.fn.expand('%:p')
  vim.cmd(string.format("silent write !sudo tee %s > /dev/null", vim.fn.shellescape(file)))
  vim.cmd('edit!')
end, {})

map('n', '<leader>2', ':W<CR>')

local function run_lf()
  local temp = vim.fn.tempname()
  vim.cmd('tabedit')
  vim.fn.termopen('lf -selection-path=' .. vim.fn.shellescape(temp), {
    on_exit = function()
      vim.cmd('tabclose!')
      if vim.fn.filereadable(temp) == 1 then
        local names = vim.fn.readfile(temp)
        if not vim.tbl_isempty(names) then vim.cmd('edit ' .. vim.fn.fnameescape(names[1])) end
      end
      vim.cmd('redraw!')
    end
  })
  vim.cmd('startinsert')
end
vim.api.nvim_create_user_command('LF', run_lf, { bar = true })
vim.keymap.set('n', '<leader>o', run_lf, { silent = true, noremap = true })
-- }}}

-- Autocommands {{{
local group = vim.api.nvim_create_augroup('CustomAutocmds', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = group, pattern = '*', callback = function()
    vim.highlight.on_yank({ higroup = "Substitute", timeout = 400, on_macro = true })
    pcall(vim.cmd, 'normal! `y')
    pcall(vim.fn.delmarks, 'y')
  end
})
vim.api.nvim_create_autocmd('BufReadPost', {
  group = group, pattern = '*', callback = function()
    local last = vim.fn.line([['"]])
    if last > 1 and last <= vim.fn.line('$') then vim.cmd([[normal! g'"]]) end
  end
})
-- }}}

-- vi: ts=4 sw=4 sts=4 et sr foldmethod=marker foldmarker={{{,}}}
