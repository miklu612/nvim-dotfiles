
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
        "folke/tokyonight.nvim",
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
        config = function(_, opts)
            require("alpha").setup(require("startup.screen").config)
        end
    },
    {
        "neovim/nvim-lspconfig",
        opts = {},
        enabled = true,
        config = function(_, opts) 
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    vim.bo[bufnr].completefunc = "v:lua.vim.lsp.omnifunc"
                    vim.api.nvim_set_keymap("i", "<C-K>", "", {
                        callback = function()
                            vim.complete()
                        end
                    })
                end
            })
            require("lspconfig").rust_analyzer.setup({
                settings = {
                    ['rust-analyzer'] = {}
                },
            })
            require("lspconfig").clangd.setup({
                settings = {
                    cmd = {
                        "clangd",
                    }
                },
            })
            require("lspconfig").lua_ls.setup({
                on_init = function(client)
                    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                        runtime = {
                            version = "LuaJIT"
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                            }
                        }
                    })
                end,
                settings = {
                    Lua = {}
                }
            })
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim'
        }
    },
})


-- My options
vim.opt.expandtab   = true
vim.opt.shiftwidth  = 4
vim.opt.number      = true
vim.opt.hlsearch    = false
vim.opt.mouse       = ""
vim.opt.textwidth   = 79
vim.opt.signcolumn  = "yes:1"
vim.opt.cursorline  = true
vim.opt.completeopt = "menu"
vim.g.mapleader     = " "
vim.g.netrw_banner  = 0

vim.cmd.colorscheme("tokyonight-night")

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>op", function() vim.cmd(":Explore") end)
vim.keymap.set("n", "<leader>of", function() telescope.live_grep() end)
