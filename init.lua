
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
--    {
--        "neovim/nvim-lspconfig",
--        opts = {},
--        config = function(_, opts) 
--            require("lspconfig").rust_analyzer.setup({
--                settings = {
--                    ['rust-analyzer'] = {}
--                }
--            })
--            require("lspconfig").clangd.setup({
--                settings = {
--                    cmd = {
--                        "clangd",
--                    }
--                }
--            })
--        end
--    },
})

-- My options
vim.opt.expandtab  = true
vim.opt.shiftwidth = 4
vim.opt.number     = true
vim.opt.hlsearch   = false
vim.opt.mouse      = ""
vim.opt.textwidth  = 79
vim.opt.signcolumn = "yes:1"
vim.g.mapleader    = " "
vim.g.netrw_banner = 0

vim.cmd.colorscheme("gruvbox")

vim.keymap.set("n", "<leader>op", function() vim.cmd(":Explore") end)
