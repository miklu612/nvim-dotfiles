
vim.lsp.config.clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" }

}
vim.lsp.enable({"clangd"})

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

