-- autopairs for neovim written in lua
-- https://github.com/windwp/nvim-autopairs
return {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
}
