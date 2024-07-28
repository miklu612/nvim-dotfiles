-- [[ _ ____   _(_)_ __ ___  ]]
-- [[| '_ \ \ / | | '_ ` _ \ ]]
-- [[| | | \ V /| | | | | | |]]
-- [[|_| |_|\_/ |_|_| |_| |_|]]

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
                    [[ _ ____   _(_)_ __ ___  ]]
                },
                opts = {
                    position = "center"
                },
            },
            {
                type = "text",
                val = {
                    [[| '_ \ \ / | | '_ ` _ \ ]],
                    [[| | | \ V /| | | | | | |]]
                },
                opts = {
                    position = "center"
                },
            },
            {
                type = "text",
                val = {
                    [[|_| |_|\_/ |_|_| |_| |_|]]
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

