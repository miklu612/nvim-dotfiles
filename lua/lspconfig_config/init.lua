
local window = -1
local buffer = -1
local autocmd_id = -1


local function inject_completion_controls(items)
    vim.keymap.set("i", "<Down>", function()
        local cursor = vim.api.nvim_win_get_cursor(window)
        cursor[1] = cursor[1] + 1
        vim.api.nvim_win_set_cursor(window, cursor)
    end)
    vim.keymap.set("i", "<Up>", function()
        local cursor = vim.api.nvim_win_get_cursor(window)
        cursor[1] = cursor[1] - 1
        vim.api.nvim_win_set_cursor(window, cursor)
    end)
    vim.keymap.set("i", "<Enter>", function()
        local cursor = vim.api.nvim_win_get_cursor(window)
        local index = cursor[1]

        vim.api.nvim_win_close(window, true)
        window = -1

        vim.api.nvim_buf_set_text(
            0,
            items[index].textEdit.range.start.line,
            items[index].textEdit.range.start.character,
            items[index].textEdit.range["end"].line,
            items[index].textEdit.range["end"].character+1,
            {items[index].textEdit.newText}
        )

        local text = items[index].textEdit.newText
        local length = #text

        cursor = vim.api.nvim_win_get_cursor(0)
        cursor[2] = cursor[2] + length - items[index].textEdit.range["end"].character
        vim.print(items[index])
        vim.api.nvim_win_set_cursor(0, cursor)

        vim.keymap.del("i", "<Enter>")
        vim.keymap.del("i", "<Down>")
        vim.keymap.del("i", "<Esc>")
        vim.keymap.del("i", "<Up>")

    end)


    vim.keymap.set("i", "<Esc>", function()
        vim.api.nvim_win_close(window, true)
        window = -1
        vim.keymap.del("i", "<Enter>")
        vim.keymap.del("i", "<Down>")
        vim.keymap.del("i", "<Esc>")
        vim.keymap.del("i", "<Up>")
    end)
end

local function completion_listbox(items)

    if window ~= -1 then
        --vim.api.nvim_win_close(window, true)
        --window = -1
        local entries = {}
        for k, v in ipairs(items) do
            table.insert(entries, v.insertText)
        end
        vim.api.nvim_buf_set_lines(buffer, 0, -1, false, entries)
    else

        buffer = vim.api.nvim_create_buf(false, true)

        local entries = {}
        for k, v in ipairs(items) do
            table.insert(entries, v.insertText)
        end
        buffer = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buffer, 0, -1, false, entries)

        window = vim.api.nvim_open_win(buffer, false, {
            relative = "win",
            row = vim.fn.line("."),
            col = vim.fn.col("."),
            width = 50,
            height = 20,
            title = "Hideri",
            border = "single"
        })
        vim.api.nvim_set_option_value("number", false, {win = window})
        vim.api.nvim_set_option_value("signcolumn", "no", {win = window})
    end

    inject_completion_controls(items)

end

return {
    "neovim/nvim-lspconfig",
    opts = {},
    enabled = true,
    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                vim.bo[bufnr].completefunc = "v:lua.vim.lsp.omnifunc"
                -- copied from the nvim documentation. See 'compl-autocomplete'
                --local triggers = {"."}
                vim.api.nvim_create_autocmd("InsertCharPre", {
                    buffer = vim.api.nvim_get_current_buf(),
                    callback = function()
                        if vim.fn.pumvisible() == 1 or vim.fn.state("m") == "m" then
                            return
                        end

                        local client = vim.lsp.get_client_by_id(args.data.client_id)
                        assert(client ~= nil)


                        -- I am too tired of trying to figure out Neovim's
                        -- completion system, so I will just rewrite it how I
                        -- want to be.
                        local params = vim.lsp.util.make_position_params()
                        params.context = {
                            triggerKind = 1
                        }

                        client.request("textDocument/completion", params, function(err, result)
                            if err then
                                print("RIP")
                            end
                            local items = result.items
                            table.sort(items, function(a, b) return a.score > b.score end)
                            vim.schedule(function() completion_listbox(items) end)
                        end)

                        --local result = client.request_sync(
                        --    "textDocument/completion",
                        --    params,
                        --    1000,
                        --    0
                        --).result


                    end
                })
            end
        })
        require("lspconfig").rust_analyzer.setup({
            settings = {
                ['rust-analyzer'] = {}
            },
        })
        if vim.fn.executable("clangd") == 1 then
            require("lspconfig").clangd.setup({
                settings = {
                    cmd = {
                        "clangd",
                    }
                },
            })
        end
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
