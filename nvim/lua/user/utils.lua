local M = {}

M.is_git_directory = function()
	local result = vim.fn.system("git rev-parse --is-inside-work-tree")
	if vim.v.shell_error == 0 and result:find("true") then
		return true
	else
		return false
	end
end

local function bind(op, outerOpts)
	outerOpts = vim.tbl_extend("force", { noremap = true, silent = true }, outerOpts or {})

	return function(lhs, rhs, opts)
		opts = vim.tbl_extend("force", outerOpts, opts or {})
		vim.keymap.set(op, lhs, rhs, opts)
	end
end

M.map = bind("")
M.nmap = bind("n", { noremap = false })
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")
M.tnoremap = bind("t")

return M
