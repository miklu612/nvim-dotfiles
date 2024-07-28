-- [[ _   _                 _           ]]
-- [[| \ | | ___  _____   _(_)_ __ ___  ]]
-- [[|  \| |/ _ \/ _ \ \ / | | '_ ` _ \ ]]
-- [[| |\  |  __| (_) \ V /| | | | | | |]]
-- [[|_| \_|\___|\___/ \_/ |_|_| |_| |_|]]


vim.api.nvim_set_hl(0, "TitleBlue", {fg="#5BCFFA"})
vim.api.nvim_set_hl(0, "TitleRed",  {fg="#F5ABB9"})
vim.api.nvim_set_hl(0, "TitleWhite",  {fg="#FFFFFF"})

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
                    position = "center",
                    hl = "TitleBlue"
                },
            },
            {
                type = "text",
                val = {
                    [[| \ | | ___  _____   _(_)_ __ ___  ]]
                },
                opts = {
                    position = "center",
                    hl = "TitleRed"
                },
            },
            {
                type = "text",
                val = {
                    [[|  \| |/ _ \/ _ \ \ / | | '_ ` _ \ ]]
                },
                opts = {
                    position = "center",
                    hl = "TitleWhite"
                },
            },
            {
                type = "text",
                val = {
                    [[| |\  |  __| (_) \ V /| | | | | | |]]
                },
                opts = {
                    position = "center",
                    hl = "TitleRed"
                },
            },
            {
                type = "text",
                val = {
                    [[|_| \_|\___|\___/ \_/ |_|_| |_| |_|]]
                },
                opts = {
                    position = "center",
                    hl = "TitleBlue"
                },
            },
            {
                type = "text",
                val = "Trans-pilled Text Editor",
                opts = {
                    position = "center",
                    hl = {
                        {"TitleBlue", 0, 12},
                        {"TitleRed", 12, 18},
                        {"TitleWhite", 18, -1},
                    }
                }
            },
            {
                type = "padding",
                val = 2
            },
            {
                type = "button",
                val = "> New File",
                on_press = function()
                    vim.cmd(":ene")
                end,
                opts = {
                    position = "center",
                }
            },
            {
                type = "button",
                val = "> Time Waster",
                on_press = function()
                    vim.cmd(":e ~/.config/nvim/init.lua")
                end,
                opts = {
                    position = "center",
                }
            },
            {
                type = "button",
                val = "> Netrw",
                on_press = function()
                    vim.cmd.Explore()
                end,
                opts = {
                    position = "center"
                }
            }
        }
    }
}

