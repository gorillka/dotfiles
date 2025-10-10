-- ================================================================================================
-- TITLE: NeoVim keymaps
-- ABOUT: sets some quality-of-life keymaps
-- ================================================================================================
local opts = { noremap = true, silent = true }

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", opts, { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", opts, { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts, { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts, { desc = "Half page up (centered)" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>wv", "<Cmd>vsplit<CR>", opts, { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>wh", "<Cmd>split<CR>", opts, { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>wx", "close<CR>", opts, { desc = "Close current split window" })
vim.keymap.set("n", "<leader>wq", ":q<CR>", opts, { desc = "Quit" })
vim.keymap.set("n", "<leader>ww", ":write!<CR>", opts, { desc = "Write current file" })
-- vim.keymap.set("n", "<leader>wn", "<cmd>noautocmd w <CR>", { desc = "Save file without auto-formatting" })
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Press jk fast to exit insert mode
-- vim.keymap.set({ "n", "i" }, "jk", "<ESC>", { desc = "Press [j][k] fast to exit insert mode" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- File Explorer
-- vim.keymap.set("n", "<leader>m", "<Cmd>NvimTreeFocus<CR>", { desc = "Focus on File Explorer" })
-- vim.keymap.set("n", "<leader>e", "<Cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

-- use gh to move to the beginning of the line in normal mode
-- use ge to move to the end of the line in normal mode
vim.keymap.set({ "n", "v", "o" }, "gh", "0", { desc = "Go to the begining line" })
vim.keymap.set({ "n", "v", "o" }, "gl", "$", { desc = "Got to the end of line" })
-- Move to start/end of line
vim.keymap.set({ "n", "v", "o" }, "H", "^", { desc = "Go to the begining line" })
vim.keymap.set({ "n", "v", "o" }, "L", "g_", { desc = "Got to the end of line" })

-- Split line with X
vim.keymap.set("n", "X", ":keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>", { silent = true })

-- yank/copy to end of line
vim.keymap.set("n", "Y", "y$", { desc = "[Y]ank to end of line" })

-- Select all
vim.keymap.set("n", "<C-a>", "ggVG", opts)

-- Easier interaction with the system clipboard
vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard after the cursor position' })
vim.keymap.set({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard before the cursor position' })

-- Make the file you run the command on, executable, so you don't have to go out to the command line
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
vim.keymap.set("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
vim.keymap.set("n", "<leader>fX", "<cmd>!chmod -x %<CR>", { silent = true, desc = "Remove executable flag" })

-- If this is a bash script, make it executable, and execute it in a tmux pane on the right
-- Using a tmux pane allows me to easily select text
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
vim.keymap.set("n", "<leader>cb", function()
    local file = vim.fn.expand("%")                   -- Get the current file name
    local first_line = vim.fn.getline(1)              -- Get the first line of the file
    if string.match(first_line, "^#!/") then          -- If first line contains shebang
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

-- Copy file path / filepath to the clipboard
vim.keymap.set("n", "<leader>fp", function()
    local filePath = vim.fn.expand("%:~")                -- Gets the file path relative to the home directory
    vim.fn.setreg("+", filePath)                         -- Copy the file path to the clipboard register
    print("File path copied to clipboard: " .. filePath) -- Optional: print message to confirm
end, { desc = "Copy file path to clipboard" })

-- Keep last yanked when pasting
vim.keymap.set("n", "p", '"_dP', { desc = "Keep last yanked when [p]asting" })

-- Replace word under cursor
vim.keymap.set("n", "<leader>j", "*``cgn", { desc = "Replace word under cursor" })

-- Explicitly yank to system clipboard (highlighted and entire row)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', { desc = "Delete single character without copying into register" })

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", opts)
