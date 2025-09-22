
return {
    "neovim/nvim-lspconfig",
    opts = {},
    enabled = true,
    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                vim.lsp.inlay_hint.enable(true)
                vim.lsp.completion.enable(true, args.data.client_id, bufnr)
                vim.bo[bufnr].completefunc = "v:lua.vim.lsp.omnifunc"

                vim.keymap.set("n", "<Leader>od", function()
                    vim.print(vim.diagnostic.get())
                end)

                vim.api.nvim_create_autocmd("InsertCharPre", {
                    buffer = vim.api.nvim_get_current_buf(),
                    callback = function()
                        vim.lsp.completion.get()
                    end
                })
            end
        })
        if vim.fn.executable("rust-analyzer") == 1 then
            vim.lsp.config.rust_analyzer = {
                    ['rust-analyzer'] = {}
            }
            vim.lsp.enable("rust-analyzer")
        end
        if vim.fn.executable("clangd") == 1 then
            vim.lsp.config.clangd = {
                cmd = {
                    "clangd",
                },
            }
            vim.lsp.enable("clangd")
        end
        if vim.fn.executable("fortls") == 1 then
            vim.lsp.config.fortls = {
                cmd = {
                    'fortls',
                    '--lowercase_intrinsics',
                    '--hover_signature',
                    '--hover_language=fortran',
                    '--use_signature_help',
                }
            }
        end
        if vim.fn.executable("lua-language-server") == 1 then
            vim.lsp.config.lua_ls = {
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
                Lua = {}
            }
        end
    end
}
