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
opt.grepprg = "rg --vimgrep"

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

-- Ctags
opt.tags = opt.tags + {"/media/workspace/workspace/UnrealEngine/tags"}

-- Wildcard ignore
opt.wildignore:append(".git,*.o,*.so,Intermediate/**,Plugins/**,Binaries/**,Build/**")

-- Mappings
local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", { desc = "Sx window" })
map("n", "<C-j>", "<C-w>j", { desc = "Below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Dx window" })
map("n", "<C-x>e", ":tabe<CR>", { desc = "New tab" })
map("n", "<C-x>n", "gt<CR>", { desc = "Next tab" })
map("n", "<C-x>p", "gT<CR>", { desc = "Prev tab" })
map("n", "<Leader><F4>", ":!genctags.sh<CR>", { desc = "Generate ctags database" })
map("n", "<C-x>w", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit nvim init.lua" })

-- netrw
map("n", "<C-x><space>", ":Exp<CR>", { desc = "Open netrw" })

-- quickfix
map("n", "cn", ":cnext<CR>", { desc = "Next quickfix entry" })
map("n", "cp", ":cprev<CR>", { desc = "Prev quickfix entry" })
map("n", "<C-x>j", [[:vim /\C<C-R><C-W>/ **/*.cpp **/*.h<CR>]], { desc = "Search current word in the codebase" })

vim.o.errorformat = table.concat({
  "%f:%l:%c: %trror: %m",
  "%f:%l:%c: %tarning: %m",
  "%f:%l:%c: %tote: %m",
  "%f:%l:%c: %m",
  "%f:%l: %m",
}, ",")

local telescope_builtin = require('telescope.builtin')
map("n", "<C-x>o", telescope_builtin.grep_string, { desc = "Telescope grep string" })
map("n", "<C-x>i", telescope_builtin.live_grep, { desc = "Telescope live grep" })
map("n", "<C-x>f", telescope_builtin.find_files, { desc = "Telescope find files" })

-- Just
vim.api.nvim_create_user_command("Just", function(opts)
  local args = opts.args ~= "" and opts.args or "build"
  local cur_win = vim.api.nvim_get_current_win()

  -- create or reuse existing just buffer
  local bufname = "just://output"
  local buf = vim.fn.bufnr(bufname)
  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, true) -- listed=false, scratch=true
    vim.api.nvim_buf_set_name(buf, bufname)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "hide"
    vim.bo[buf].swapfile = false
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  vim.bo[buf].modifiable = false

  -- opens just buffer in a vertical split if not already present
  local win = vim.fn.bufwinid(buf)
  if win == -1 then
    vim.cmd("vsplit")
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.wo[win].number = false
    vim.wo[win].wrap = false
  end

  -- re-focus on the previous pane
  vim.api.nvim_set_current_win(cur_win)

  local function append(data)
    if not data then return end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
    vim.bo[buf].modifiable = false
    -- auto-scroll 
    local w = vim.fn.bufwinid(buf)
    if w ~= -1 then
      local n = vim.api.nvim_buf_line_count(buf)
      vim.api.nvim_win_set_cursor(w, { n, 0 })
    end
  end

  local all = {}
  vim.fn.jobstart("just " .. args, {
    cwd = vim.fn.getcwd(),
    on_stdout = function(_, d) append(d); if d then vim.list_extend(all, d) end end,
    on_stderr = function(_, d) append(d); if d then vim.list_extend(all, d) end end,
    on_exit = function(_, code)
      append({ "", "── just completed (exit " .. code .. ") ──" })
      vim.fn.setqflist({}, " ", { title = "just " .. args, lines = all, efm = vim.o.errorformat })
      vim.notify("just completed (exit " .. code .. ")")
    end,
  })
end, { nargs = "*" })

-- build
map("n", "<Leader><F6>", ":Just build<CR>", { desc = "Build" })
map("n", "<Leader><F7>", ":Just editor<CR>", { desc = "Build editor" })

-- Switch header / cpp 
local function switch_source_header()
  local ext = vim.fn.expand('%:e')
  local stem = vim.fn.expand('%:t:r')  -- file name without path

  local targets
  if ext == 'cpp' or ext == 'cc' or ext == 'cxx' then
    targets = { 'h', 'hpp', 'hxx' }
  elseif ext == 'h' or ext == 'hpp' or ext == 'hxx' then
    targets = { 'cpp', 'cc', 'cxx' }
  else
    return
  end

  local root = vim.fs.root(0, { '.git', '.uproject' }) or vim.fn.getcwd()

  local patterns = {}
  for _, e in ipairs(targets) do
    table.insert(patterns, stem .. '.' .. e)
  end

  local matches = vim.fs.find(patterns, { path = root, type = 'file', limit = 10 })

  if #matches == 0 then
    vim.notify('No corresponding file found', vim.log.levels.WARN)
  elseif #matches == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(matches[1]))
  else
    vim.ui.select(matches, { prompt = 'More occurrences found:' }, function(choice)
      if choice then vim.cmd('edit ' .. vim.fn.fnameescape(choice)) end
    end)
  end
end

vim.api.nvim_create_user_command('SwitchHeader', switch_source_header, {})
map('n', '<C-x>s', switch_source_header, { desc = 'Switch source/header' })

-- Clang format on save
local function clang_format_on_save()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd("silent! %!clang-format")
    -- Se clang-format fallisce (es. non trovato, o errore di sintassi),
    -- vim.v.shell_error sarà diverso da 0: meglio annullare per non svuotare il buffer
    if vim.v.shell_error ~= 0 then
        vim.cmd("silent! undo")
        vim.notify("clang-format fallito", vim.log.levels.ERROR)
        return
    end
    pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
end

vim.api.nvim_create_augroup("ClangFormatOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = "ClangFormatOnSave",
    pattern = { "*.h", "*.cc", "*.cpp", "*.hpp" },
    callback = clang_format_on_save,
})
