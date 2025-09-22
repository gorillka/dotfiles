-- A fancy, configurable, notification manager for NeoVim
-- https://github.com/rcarriga/nvim-notify
return {
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        opts = {
            timeout = 500,
            render = "compact",
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.25)
            end,
            on_open = function(win)
                vim.api.nvim_win_set_config(win, { zindex = 100 })
            end,
        },
        config = function()
            local notify = require("notify")

            local filtered_message = { "No information available" }

            -- Override notify function to filter out messages
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.notify = function(message, level, opts)
                local merged_opts = vim.tbl_extend("force", {
                    on_open = function(win)
                        local buf = vim.api.nvim_win_get_buf(win)
                        vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
                    end,
                }, opts or {})

                for _, msg in ipairs(filtered_message) do
                    if message == msg then
                        return
                    end
                end
                return notify(message, level, merged_opts)
            end
       end,
    },
}
