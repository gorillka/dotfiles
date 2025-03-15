-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Keymaps for better default experience
local keymap = require("user.utils")

-------------------------------------------------------------------------------
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
keymap.nnoremap("<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
keymap.nnoremap("<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap.tnoremap("<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
keymap.nnoremap("<left>", '<cmd>echo "Use h to move!!"<CR>')
keymap.nnoremap("<right>", '<cmd>echo "Use l to move!!"<CR>')
keymap.nnoremap("<up>", '<cmd>echo "Use k to move!!"<CR>')
keymap.nnoremap("<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
keymap.nnoremap("<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap.nnoremap("<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap.nnoremap("<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap.nnoremap("<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

--- ------------------------------------------------------------------------------
keymap.nnoremap("<space>", "<nop>")
keymap.vnoremap("<space>", "<nop>")

keymap.nnoremap("<Esc>", ":noh<CR>", { desc = "clear highlights" }) -- clear highlights

-- Window management
keymap.nnoremap("<leader>v", "<C-w>v", { desc = "Split window [v]ertically" })
keymap.nnoremap("<leader>h", "<C-w>s", { desc = "Split window [h]orizontally" })
-- u.nnoremap("<leader>se", "<C-w>=", { desc = 'Make [s]plit windows [e]qual width & height' })
keymap.nnoremap("<leader>xs", "close<CR>", { desc = "Close current split window" })

-- save file
keymap.nnoremap("<leader>ww", function()
	vim.cmd("write")
end, { desc = "Write current file" })
keymap.nnoremap("<leader>sn", "<cmd>noautocmd w <CR>", { desc = "Save file without auto-formatting" })
keymap.inoremap("<leader>ww", function()
	vim.cmd("write")
end, { desc = "Write current file" })

-- Set up a keymap to refresh the current buffer
keymap.nnoremap("<leader>br", function()
	-- Reloads the file to reflect the changes
	vim.cmd("edit!")
	print("Buffer reloaded")
end, { desc = "Reload current buffer" })

-- Quit
keymap.nnoremap("<C-q>", "<cmd> :q <CR>")
-- u.nnoremap("<leader>q", "<cmd> :close <CR> :Alpha<CR>", { desc = '[Q]uit all buffers and return to Dashboard' })

-- Vertical scroll and center
keymap.nnoremap("<C-d>", "<C-d>zz")
keymap.nnoremap("<C-u>", "<C-u>zz")

-- Find and center
keymap.nnoremap("n", "nzzzv")
keymap.nnoremap("N", "Nzzzv")

-- Buffers
keymap.nnoremap("<Tab>", ":bnext<CR>")
keymap.nnoremap("<S-Tab>", ":bprevious<CR>")
keymap.nnoremap("<leader>x", ":Bdelete!<CR>:Alpha<CR>", { desc = "[x]close buffer and return to Dashboard" })
keymap.nnoremap("<leader>b", "<cmd> enew <CR>", { desc = "[b]uffer new" })

-- Resize with arrows
keymap.nnoremap("<Up>", ":resize -2<CR>")
keymap.nnoremap("<Down>", ":resize +2<CR>")
keymap.nnoremap("<Left>", ":vertical resize -2<CR>")
keymap.nnoremap("<Right>", ":vertical resize +2<CR>")

-- Toggle line wrapping
keymap.nnoremap("<leader>lw", "<cmd>set wrap!<CR>", { desc = "Toggle [l]ine [w]rapping" })

-- Press jk fast to exit insert mode
keymap.inoremap("jk", "<ESC>", { desc = "Press [j][k] fast to exit insert mode" })
keymap.inoremap("kj", "<ESC>", { desc = "Press [k][j] fast to exit insert mode" })

-- use gh to move to the beginning of the line in normal mode
-- use ge to move to the end of the line in normal mode
keymap.nnoremap("gh", "0", { desc = "Go to the begining line" })
keymap.vnoremap("gh", "0", { desc = "Go to the begining line" })
keymap.nnoremap("gl", "$", { desc = "Got to the end of line" })
keymap.vnoremap("gl", "$", { desc = "Got to the end of line" })

-- yank/copy to end of line
keymap.nnoremap("Y", "y$", { desc = "[Y]ank to end of line" })

-- Make the file you run the command on, executable, so you don't have to go out to the command line
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
keymap.nnoremap("<leader>fx", '<cmd>!chmod +x "%"<CR>', { desc = "Make file executable" })
-- vim.keymap.set("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
keymap.nnoremap("<leader>fX", '<cmd>!chmod -x "%"<CR>', { desc = "Remove executable flag" })
-- vim.keymap.set("n", "<leader>fX", "<cmd>!chmod -x %<CR>", { silent = true, desc = "Remove executable flag" })

-- If this is a bash script, make it executable, and execute it in a tmux pane on the right
-- Using a tmux pane allows me to easily select text
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
keymap.nnoremap("<leader>cb", function()
	local file = vim.fn.expand("%") -- Get the current file name
	local first_line = vim.fn.getline(1) -- Get the first line of the file
	if string.match(first_line, "^#!/") then -- If first line contains shebang
		local escaped_file = vim.fn.shellescape(file) -- Properly escape the file name for shell commands

		-- Execute the script on a tmux pane on the right. On my mac I use zsh, so
		-- running this script with bash to not execute my zshrc file after
		-- vim.cmd("silent !tmux split-window -h -l 60 'bash -c \"" .. escaped_file .. "; exec bash\"'")
		-- `-l 60` specifies the size of the tmux pane, in this case 60 columns
		vim.cmd(
			"silent !tmux split-window -h -l 60 'bash -c \""
				.. escaped_file
				.. "; echo; echo Press any key to exit...; read -n 1; exit\"'"
		)
	else
		vim.cmd("echo 'Not a script. Shebang line not found.'")
	end
end, { desc = "BASH, execute file" })

-- Toggle a tmux pane on the right in bash, in the same directory as the current file
-- Opening it in bash because it's faster, I don't have to run my .zshrc file,
-- which pulls from my repo and a lot of other stuff
keymap.nnoremap("<leader>f.", function()
	local file_dir = vim.fn.expand("%:p:h") -- Get the directory of the current file
	local pane_width = 60
	local right_pane_id =
		vim.fn.system("tmux list-panes -F '#{pane_id} #{pane_width}' | awk '$2 == " .. pane_width .. " {print $1}'")
	if right_pane_id ~= "" then
		-- If the right pane exists, close it
		vim.fn.system("tmux kill-pane -t " .. right_pane_id)
	else
		-- If the right pane doesn't exist, open it
		vim.fn.system("tmux split-window -h -l " .. pane_width .. " 'cd " .. file_dir .. " && zsh'")
	end
end, { desc = "Open (toggle) current dir in right tmux pane" })

-- Copy file path / filepath to the clipboard
keymap.nnoremap("<leader>fp", function()
	local filePath = vim.fn.expand("%:~") -- Gets the file path relative to the home directory
	vim.fn.setreg("+", filePath) -- Copy the file path to the clipboard register
	print("File path copied to clipboard: " .. filePath) -- Optional: print message to confirm
end, { desc = "Copy file path to clipboard" })

-- Stay in indent mode
keymap.vnoremap("<", "<gv")
keymap.vnoremap(">", ">gv")

-- Keep last yanked when pasting
keymap.vnoremap("p", '"_dP', { desc = "Keep last yanked when [p]asting" })

-- Replace word under cursor
keymap.nnoremap("<leader>j", "*``cgn", { desc = "Replace word under cursor" })

-- Explicitly yank to system clipboard (highlighted and entire row)
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Save and load session
keymap.nnoremap("<leader>ss", ":mksession! .session.vim<CR>", { desc = "[s]ave [s]ession" })
keymap.nnoremap("<leader>sl", ":source .session.vim<CR>", { desc = "[s]ource s[l]oad session" })

-- Symbol Outline keybind
keymap.nnoremap("<leader>so", ":SymbolsOutline<cr>", { desc = "[s]ymbol [o]utline" })

-------------------------------------------------------------------------------
-- delete single character without copying into register
keymap.nnoremap("x", '"_x', { desc = "Delete single character without copying into register" })

-------------------------------------------------------------------------------
--                           Folding section
-------------------------------------------------------------------------------

-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
keymap.nnoremap("<CR>", function()
	-- Get the current line number
	local line = vim.fn.line(".")
	-- Get the fold level of the current line
	local foldlevel = vim.fn.foldlevel(line)
	if foldlevel == 0 then
		vim.notify("No fold found", vim.log.levels.INFO)
	else
		vim.cmd("normal! za")
	end
end, { desc = "Toggle fold" })

-------------------------------------------------------------------------------
--                         End Folding section
-------------------------------------------------------------------------------

-- Reload zsh configuration by sourcing ~/.zshrc in a separate shell
keymap.nnoremap("<leader>fz", function()
	-- Define the command to source zshrc
	local command = "source ~/.zshrc"
	-- Execute the command in a new Zsh shell
	local full_command = "zsh -c '" .. command .. "'"
	-- Run the command and capture the output
	local output = vim.fn.system(full_command)
	-- Check the exit status of the command
	local exit_code = vim.v.shell_error
	if exit_code == 0 then
		vim.api.nvim_echo({ { "Successfully sourced ~/.zshrc", "NormalMsg" } }, false, {})
	else
		vim.api.nvim_echo({
			{ "Failed to source ~/.zshrc:", "ErrorMsg" },
			{ output, "ErrorMsg" },
		}, false, {})
	end
end, { desc = "source ~/.zshrc" })
