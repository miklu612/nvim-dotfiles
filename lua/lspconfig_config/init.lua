return {
    "neovim/nvim-lspconfig",
    opts = {},
    enabled = true,
    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                --local client = vim.lsp.get_client_by_id(args.data.client_id)
                vim.bo[bufnr].completefunc = "v:lua.vim.lsp.omnifunc"
                -- copied from the nvim documentation. See 'compl-autocomplete'
                local triggers = {"."}
                vim.api.nvim_create_autocmd("InsertCharPre", {
                    buffer = vim.api.nvim_get_current_buf(),
                    callback = function()
                        if vim.fn.pumvisible() == 1 or vim.fn.state("m") == "m" then
                            return
                        end
                        local char = vim.v.char
                        if vim.list_contains(triggers, char) then
                            local key = vim.keycode("<C-x><C-u>")
                            vim.api.nvim_feedkeys(key, "m", false)
                        end
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
        if vim.fn.executable("lua-language-server") == 1 then
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
    end
}
