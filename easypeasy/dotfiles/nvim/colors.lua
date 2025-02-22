-- lua/config/colors.lua
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        -- Disable background color
        vim.cmd([[
          function! RemoveBackground()
            highlight Normal ctermbg=NONE guibg=NONE
            highlight NonText ctermbg=NONE guibg=NONE
            highlight LineNr ctermbg=NONE guibg=NONE
            highlight SignColumn ctermbg=NONE guibg=NONE
            highlight EndOfBuffer ctermbg=NONE guibg=NONE
          endfunction
          autocmd ColorScheme * call RemoveBackground()
        ]])

        -- Use terminal colors
        vim.o.termguicolors = false

        -- Set a very basic colorscheme that will be mostly overridden by terminal colors
        return "default"
      end,
    },
  },

  -- Disable other colorscheme plugins
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", enabled = false },

  -- Configure other UI elements to use terminal colors
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "16color",
      },
    },
  },
}
