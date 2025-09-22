function setColor()
    -- Option 1
    -- vim.o.background = "dark"
    -- vim.cmd([[colorscheme gruvbox]])

    -- Option 2
    -- vim.cmd.colorscheme "catppuccin"
    -- setup must be called before loading
    -- vim.cmd.colorscheme "catppuccin"
    vim.cmd.colorscheme "tokyonight" 
end

setColor()
