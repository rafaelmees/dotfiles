local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- 'master' is frozen and does not support Neovim 0.12+
    lazy = false,
    build = ":TSUpdate",
  },

  { "christoomey/vim-tmux-navigator" },

  { "lewis6991/gitsigns.nvim" },

  { "nvim-lualine/lualine.nvim" },

  { "windwp/nvim-autopairs" },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },

})

-- Theme: lackluster (grayscale) with a transparent background.
-- setup() must come BEFORE the colorscheme to take effect.
require("lackluster").setup({
  tweak_background = {
    normal = "none",    -- editor main background (and gutter/line numbers)
    popup = "none",     -- floating windows (lsp, cmp, etc.)
    menu = "none",      -- menus (wildmenu / cmp)
    telescope = "none", -- telescope windows
  },
})
vim.cmd.colorscheme("lackluster")

-- Plugin setup (they were only declared before, never initialized)
require("gitsigns").setup()
require("nvim-autopairs").setup()

require("lualine").setup({
  options = {
    theme = "lackluster",
    icons_enabled = true,
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
})

-- nvim-treesitter branch 'main' ('master' is frozen and won't run on Neovim 0.12+).
-- The API changed: instead of modules, we install the parsers and enable highlight
-- per filetype using Neovim's native treesitter.
require("nvim-treesitter").install({
  "bash", "json", "lua", "toml", "tmux", "markdown", "vim", "vimdoc",
})

-- Enable treesitter highlight + indentation in any buffer that has a parser.
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    if pcall(vim.treesitter.start) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Options
vim.opt.number = true
vim.opt.cursorline = true

vim.opt.swapfile = true
vim.opt.directory = "/tmp"

vim.opt.clipboard = "unnamedplus"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false

vim.opt.mouse = "a"
vim.opt.termguicolors = true

vim.g.mapleader = ","

-- Keymaps
local map = vim.keymap.set

-- Replace word under the cursor (inherited from the old .vimrc)
map("n", "<C-d>", "cgn")

-- File explorer (neo-tree replaces NERDTree)
map("n", "<C-e>", ":Neotree toggle<CR>", { silent = true })

-- Tabs (Mac style: Ctrl is the tab modifier)
map("n", "<C-t>", ":tabnew<CR>", { silent = true, desc = "New tab" })
map("n", "<C-Tab>", "gt", { silent = true, desc = "Next tab" })
map("n", "<C-S-Tab>", "gT", { silent = true, desc = "Previous tab" })

-- Telescope (replaces ctrlp)
local telescope = require("telescope.builtin")
map("n", "<C-p>", telescope.find_files, { desc = "Find files" })
map("n", "<leader>f", telescope.find_files, { desc = "Find files" })
map("n", "<leader>g", telescope.live_grep, { desc = "Live grep" })
map("n", "<leader>b", telescope.buffers, { desc = "Open buffers" })

-- Save (inherited from the old .vimrc)
map("n", "<C-s>", ":w<CR>", { silent = true })

-- Comments: Neovim 0.10+ already has native 'gcc'/'gc'

-- Convert indentation (functions inherited from the old .vimrc)
vim.api.nvim_create_user_command("Convert4SpacesTo2", function()
  vim.cmd("set ts=4 sts=4 noet | retab! | set ts=2 sts=2 et | retab")
end, {})

vim.api.nvim_create_user_command("Convert2SpacesTo4", function()
  vim.cmd("set ts=2 sts=2 noet | retab! | set ts=4 sts=4 et | retab")
end, {})

-- Smart quit
local function is_empty_buffer(buf)
    return vim.api.nvim_buf_get_name(buf) == ""
       and vim.api.nvim_buf_line_count(buf) == 1
       and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
       and not vim.bo[buf].modified
end

local function smart_quit(force)
    if vim.fn.winnr("$") > 1 then
        vim.cmd(force and "q!" or "q")
        return
    end

    local buf = vim.api.nvim_get_current_buf()

    if is_empty_buffer(buf) then
        return
    end

    if vim.bo[buf].modified and not force then
        vim.cmd("confirm q")
        return
    end

    vim.cmd("enew")

    if vim.api.nvim_buf_is_valid(buf) then
        vim.cmd((force and "bdelete! " or "bdelete ") .. buf)
    end
end

vim.api.nvim_create_user_command("SmartQuit", function(opts)
    smart_quit(opts.bang)
end, { bang = true })

vim.cmd([[
    cnoreabbrev <expr> q  getcmdtype() == ':' && getcmdline() ==# 'q'  ? 'SmartQuit'  : 'q'
    cnoreabbrev <expr> q! getcmdtype() == ':' && getcmdline() ==# 'q!' ? 'SmartQuit!' : 'q!'
]])
