
-- Installing lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
    {
        "ellisonleao/gruvbox.nvim",
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        config = function()
            require("lualine").setup()
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "c",
                "cpp",
                "javascript",
                "typescript",
                "lua",
                "vimdoc",
            },
            highlight = {
                enable = true,
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end
    },
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("alpha").setup(require("startup.screen").config)
        end
    },
    require("lspconfig_config"),
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim'
        }
    },
})

local formatting_enabled = true

-- My options
vim.opt.expandtab   = true
vim.opt.shiftwidth  = 4
vim.opt.number      = true
vim.opt.hlsearch    = false
vim.opt.mouse       = ""
vim.opt.textwidth   = 79
vim.opt.signcolumn  = "yes:1"
vim.opt.cursorline  = true
vim.opt.completeopt = "menu,noinsert"
vim.g.mapleader     = " "
vim.g.netrw_banner  = 0

vim.cmd.colorscheme("gruvbox")

local telescope = require("telescope.builtin")

vim.keymap.set("n", "<leader>op", function() vim.cmd(":Explore") end)
vim.keymap.set("n", "<leader>of", function() telescope.live_grep() end)
vim.keymap.set("n", "<leader>ol", function() vim.lsp.buf.code_action() end)
vim.keymap.set("n", "<leader>ot", function() vim.cmd(":terminal") end)
vim.keymap.set("n", "<C-c>", function() print("Skill issue") end)
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.api.nvim_create_user_command("DisableFormatting", function()
    formatting_enabled = false
end, {})

vim.api.nvim_create_user_command("EnableFormatting", function()
    formatting_enabled = true
end, {})

vim.api.nvim_create_autocmd({"BufRead"}, {
    pattern = {"*.f90"},
    callback = function(ev)
        vim.opt_local.shiftwidth = 2
    end
})

vim.api.nvim_create_autocmd({"BufWritePost"}, {
    pattern = {"*.cpp", "*.hpp", "*.c", "*.h"},
    callback = function(ev)
        if formatting_enabled then
            local view = vim.fn.winsaveview()
            vim.system({"clang-format", "-i", ev.match}):wait()
            vim.cmd(":e!")
            vim.fn.winrestview(view)
        end
    end
})

vim.api.nvim_create_autocmd({"BufWritePost"}, {
    pattern = {"*.rs"},
    callback = function(ev)
        local view = vim.fn.winsaveview()
        vim.system({"rustfmt", ev.match}):wait()
        vim.cmd(":e!")
        vim.fn.winrestview(view)
    end
})

