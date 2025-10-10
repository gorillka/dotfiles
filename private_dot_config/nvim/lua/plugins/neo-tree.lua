-- ================================================================================================
-- TITLE : neo-tree.nvim
-- ABOUT : Neovim plugin to manage the file system and other tree like structures.
-- LINKS :
--   > github : https://github.com/nvim-neo-tree/neo-tree.nvim
-- ================================================================================================

return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    keys = {
        { "<leader>e",     ":Neotree toggle float<CR>", desc = "Float Neo-tree" },
        { "<leader><tab>", ":Neotree toggle left<CR>",  desc = "Left side Neo-tree" },
    },
}
