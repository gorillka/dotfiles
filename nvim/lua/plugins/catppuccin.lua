return {
    -- add gruvbox
    {
        "catppuccin/nvim",
        opts = {
            flavour = "auto", -- latte, frappe, macchiato, mocha
            background = {    -- :h background
                light = "macchiato",
                dark = "mocha",
            },
            transparent_background = true, -- disables setting the background color.
        },
    },

    -- Configure LazyVim to load gruvbox
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "catppuccin-mocha",
      },
    }
  }