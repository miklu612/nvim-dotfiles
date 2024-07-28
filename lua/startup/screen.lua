-- [[ _   _                 _           ]]
-- [[| \ | | ___  _____   _(_)_ __ ___  ]]
-- [[|  \| |/ _ \/ _ \ \ / | | '_ ` _ \ ]]
-- [[| |\  |  __| (_) \ V /| | | | | | |]]
-- [[|_| \_|\___|\___/ \_/ |_|_| |_| |_|]]

return {
    config = {
        layout = {
            {
                type = "padding",
                val = 5,
            },
            {
                type = "text",
                val = {
                    [[ _   _                 _           ]]
                },
                opts = {
                    position = "center"
                },
            },
            {
                type = "text",
                val = {
                    [[| \ | | ___  _____   _(_)_ __ ___  ]]
                },
                opts = {
                    position = "center"
                },
            },
            {
                type = "text",
                val = {
                    [[|  \| |/ _ \/ _ \ \ / | | '_ ` _ \ ]]
                },
                opts = {
                    position = "center"
                },
            },
            {
                type = "text",
                val = {
                    [[| |\  |  __| (_) \ V /| | | | | | |]]
                },
                opts = {
                    position = "center"
                },
            },
            {
                type = "text",
                val = {
                    [[|_| \_|\___|\___/ \_/ |_|_| |_| |_|]]
                },
                opts = {
                    position = "center"
                },
            },
            {
                type = "padding",
                val = 2
            },
            {
                type = "button",
                val = "[New File]",
                on_press = function()
                    vim.cmd(":ene")
                end,
                opts = {
                    position = "center"
                }
            }
        }
    }
}

