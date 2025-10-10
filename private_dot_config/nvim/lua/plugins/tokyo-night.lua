return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        -- style = "day",      -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        -- transparent = true, -- Enable this to disable setting the background color
    },
    config = function()
        vim.cmd.colorscheme("tokyonight-storm")
    end
}
