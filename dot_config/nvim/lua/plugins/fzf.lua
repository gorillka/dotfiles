-- ================================================================================================
-- TITLE : fzf-lua
-- LINKS :
--   > github : https://github.com/ibhagwan/fzf-lua
-- ABOUT : lua-based fzf wrapper and integration.
-- ================================================================================================

return {
	"ibhagwan/fzf-lua",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
        {
            "<leader><leader>",
            function()
                require("fzf-lua").oldfiles()
            end,
            desc = "Find recently opened files"
        }, 
		{
			"<leader>sf",
			function()
				require("fzf-lua").files()
			end,
			desc = "Search Files",
		},
		{
			"<leader>fg",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "Search by Grep",
		},
		{
			"<leader>sb",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "Search existing Buffers",
		},
		{
			"<leader>sh",
			function()
				require("fzf-lua").help_tags()
			end,
			desc = "Search Help",
		},
		{
			"<leader>sx",
			function()
				require("fzf-lua").diagnostics_document()
			end,
			desc = "FZF Diagnostics Document",
		},
		{
			"<leader>sX",
			function()
				require("fzf-lua").diagnostics_workspace()
			end,
			desc = "FZF Diagnostics Workspace",
		},
		{
			"<leader>ss",
			function()
				require("fzf-lua").lsp_document_symbols()
			end,
			desc = "FZF Document Symbols",
		},
		{
			"<leader>sS",
			function()
				require("fzf-lua").lsp_workspace_symbols()
			end,
			desc = "FZF Workspace Symbols",
		},
        {
            "<leader>s/",
            function()
                require("fzf-lua").grep_curbuf()
            end,
            desc = "Fuzzily search in current buffer"
        }, 
        {
            "<leader>sw",
            function()
                require("fzf-lua").grep_cword()
            end,
            desc = "Search current word"
        },
	},

	opts = {},
}
