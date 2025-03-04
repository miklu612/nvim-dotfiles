local window = -1
local buffer = -1
local has_selected = false
local has_injected = false

local select_key = "<Tab>"

local function remove_completion_controls()
    if has_injected then
        vim.keymap.del("i", select_key)
        vim.keymap.del("i", "<Enter>")
        vim.keymap.del("i", "<Down>")
        vim.keymap.del("i", "<Esc>")
        vim.keymap.del("i", "<Up>")
        vim.keymap.del("i", "<Space>")
        vim.keymap.del("i", "<BS>")
        vim.keymap.del("i", ":")
        has_injected = false
    end
end

local function enable_selection()
    has_selected = true
    vim.api.nvim_set_option_value("cursorline", true, {win = window})
end

local function close_window()
    vim.api.nvim_win_close(window, true)
    window = -1
end

local function inject_completion_controls(items)
    if has_injected then
        remove_completion_controls()
    end
    has_injected = true
    vim.keymap.set("i", "<Down>", function()
        if has_selected then
            local cursor = vim.api.nvim_win_get_cursor(window)
            local line_count = vim.api.nvim_buf_line_count(buffer)
            cursor[1] = cursor[1] + 1
            if cursor[1] <= line_count then
                vim.api.nvim_win_set_cursor(window, cursor)
            end
        else
            enable_selection()
        end
    end)

    vim.keymap.set("i", "<Up>", function()
        if has_selected then
            local cursor = vim.api.nvim_win_get_cursor(window)
            cursor[1] = cursor[1] - 1
            if cursor[1] >= 1 then
                vim.api.nvim_win_set_cursor(window, cursor)
            end
        else
            enable_selection()
        end
    end)

    vim.keymap.set("i", select_key, function()

        if has_selected then
            local cursor = vim.api.nvim_win_get_cursor(window)
            local index = cursor[1]

            if window ~= -1 then
                close_window()
            end

            vim.api.nvim_buf_set_text(
                0,
                items[index].textEdit.range.start.line,
                items[index].textEdit.range.start.character,
                items[index].textEdit.range["end"].line,
                items[index].textEdit.range["end"].character+1,
                {items[index].textEdit.newText}
            )

            local text = items[index].textEdit.newText
            local delta = items[index].textEdit.range["end"].character - items[index].textEdit.range.start.character
            delta = delta + 1

            local new_position_delta = #text - delta

            cursor = vim.api.nvim_win_get_cursor(0)
            cursor[2] = cursor[2] + new_position_delta
            vim.print(items[index])
            vim.api.nvim_win_set_cursor(0, cursor)

            remove_completion_controls()

            has_selected = false

        else

            if window ~= -1 then
                close_window()
            end

            remove_completion_controls()

            local keys = vim.keycode("<Enter>")
            vim.api.nvim_feedkeys(keys, "i", false)
        end

    end)

    vim.keymap.set("i", "<Esc>", function()
        if window ~= -1 then
            close_window()
        end

        remove_completion_controls()
        has_selected = false

        local keys = vim.keycode("<Esc>")
        vim.api.nvim_feedkeys(keys, "i", false)

    end)

    vim.keymap.set("i", "<Enter>", function()
        if window ~= -1 then
            close_window()
        end

        remove_completion_controls()
        has_selected = false

        local keys = vim.keycode("<Enter>")
        vim.api.nvim_feedkeys(keys, "i", false)

    end)

    vim.keymap.set("i", "<Space>", function()
        if window ~= -1 then
            close_window()
        end

        remove_completion_controls()
        has_selected = false

        local keys = vim.keycode("<Space>")
        vim.api.nvim_feedkeys(keys, "i", false)
    end)

    vim.keymap.set("i", "<BS>", function()
        if window ~= -1 then
            close_window()
        end

        remove_completion_controls()
        has_selected = false

        local keys = vim.keycode("<BS>")
        vim.api.nvim_feedkeys(keys, "i", false)
    end)

    vim.keymap.set("i", ":", function()
        if window ~= -1 then
            close_window()
        end

        remove_completion_controls()
        has_selected = false

        local keys = vim.keycode(":")
        vim.api.nvim_feedkeys(keys, "i", false)
    end)
end

local function completion_listbox(items)

    if vim.fn.mode() ~= "i" then
        return
    end

    if window ~= -1 then
        local entries = {}
        for _, v in ipairs(items) do
            table.insert(entries, v.insertText)
        end
        vim.api.nvim_buf_set_lines(buffer, 0, -1, false, entries)
        inject_completion_controls(items)
    else

        buffer = vim.api.nvim_create_buf(false, true)

        local entries = {}
        for _, v in ipairs(items) do
            table.insert(entries, v.insertText)
        end
        buffer = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buffer, 0, -1, false, entries)

        local position = vim.api.nvim_win_get_cursor(0)
        position = vim.fn.screenpos(0, position[1], position[2])
        position.row = position.row

        local height = vim.api.nvim_win_get_height(0)
        local hideri_height = math.min(
            height - position.row - 1,
            20
        )

        if hideri_height <= 0 then
            print("Hideri height: " .. tostring(hideri_height))
            return
        end

        window = vim.api.nvim_open_win(buffer, false, {
            relative = "win",
            row = position.row;
            col = vim.fn.col("."),
            width = 50,
            height = hideri_height,
            title = "Hideri",
            border = "single"
        })
        vim.api.nvim_set_option_value("number", false, {win = window})
        vim.api.nvim_set_option_value("signcolumn", "no", {win = window})
        vim.api.nvim_set_option_value("cursorline", false, {win = window})
        inject_completion_controls(items)
    end


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
                vim.api.nvim_create_autocmd("InsertCharPre", {
                    buffer = vim.api.nvim_get_current_buf(),
                    callback = function()

                        if vim.fn.pumvisible() == 1 or vim.fn.state("m") == "m" then
                            return
                        end


                        local invalid_keys = {
                            " ", "(", ")", "{", "}", "=",
                            '"', "'", "+", "-", "=", "*",
                            "/", "!", "<", "?", ">", "\\",
                            "[", "]", "&", "%", "$", "#",
                            "@", ":", "0", "1", "2", "3",
                            "4", "5", "6", "7", "8", "9",
                            "." }
                        if vim.list_contains(invalid_keys, vim.v.char) then
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
                                vim.print("(HIDERI) Error: ", err)
                            elseif result then
                                local items = result.items
                                if items then
                                    items = vim.tbl_filter(function(a) return a.score ~= nil end, items)
                                    table.sort(items, function(a, b) return a.score > b.score end)
                                    if #items > 0 then
                                        vim.schedule(function() completion_listbox(items) end)
                                    end
                                else
                                    vim.print("(HIDERI) No items in: ", result)
                                end
                            else
                                vim.print("(HIDERI) No results")
                            end
                        end)
                    end
                })
            end
        })
        --require("lspconfig").rust_analyzer.setup({
        --    settings = {
        --        ['rust-analyzer'] = {}
        --    },
        --})
        if vim.fn.executable("clangd") == 1 then
            require("lspconfig").clangd.setup({
                settings = {
                    cmd = {
                        "clangd",
                    }
                },
            })
        end
        if vim.fn.executable("fortls") == 1 then
            require("lspconfig").fortls.setup({
                settings = {
                    cmd = {
                        'fortls',
                        '--lowercase_intrinsics',
                        '--hover_signature',
                        '--hover_language=fortran',
                        '--use_signature_help',
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
