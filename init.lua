
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
        "folke/tokyonight.nvim",
        init = function()
            vim.cmd.colorscheme("tokyonight")
        end
    },
    {
        "ellisonleao/gruvbox.nvim",
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("lspconfig").clangd.setup({})
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
            },
            highlight = {
                enable = true
            }
        },
        config = function(_, opts) 
            require("nvim-treesitter.configs").setup(opts)
	end
    },
    {
        "nvim-tree/nvim-tree.lua",
        opts = {

        },
        config = function(_, opts) 
            require("nvim-tree").setup(opts)
        end
    }
})

-- My options
vim.opt.expandtab  = true
vim.opt.shiftwidth = 4
vim.opt.number     = true
vim.opt.hlsearch   = false
vim.opt.mouse      = ""
vim.opt.textwidth  = 79
vim.g.mapleader    = " "

-- Keybindings
vim.keymap.set("n", "<leader>op", function() vim.cmd(":Explore") end)
vim.keymap.set("n", "<leader>ot", function() vim.cmd(":NvimTreeOpen") end)


vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"typescriptreact",},
    callback = function()
        vim.opt.shiftwidth = 2
    end
})

