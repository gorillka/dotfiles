-- ================================================================================================
-- TITLE : nvim-tree.lua
-- ABOUT : A file explorer tree for Neovim, written in Lua.
-- LINKS :
--   > github : https://github.com/nvim-tree/nvim-tree.lua
-- ================================================================================================

return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	config = function()
		-- Remove background color from the NvimTree window (ui fix)
		vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])

		require("nvim-tree").setup({
            filters = { custom = { 
                "^.git$",
                ".DS_Store"
            } },
			view = {
				adaptive_size = true,
			},
		})
	end,
}
