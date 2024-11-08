return {
  "NvChad/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup{
      filetypes = { 
        "*",
        rasi = {      -- Specific configuration for .rasi files
          RGB      = true;       -- #RGB hex codes
          RRGGBB   = true;       -- #RRGGBB hex codes
          RRGGBBAA = true;       -- #RRGGBBAA hex codes with opacity
          rgb_fn   = true;       -- Enable CSS-like `rgb()` and `rgba()` functions
          hsl_fn   = true;       -- Enable `hsl()` and `hsla()` functions
          mode     = "background"; -- Set display mode to background
        },
      },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue or blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = true, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        tailwind = false, -- Enable tailwind colors
        sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
        virtualtext = "■",
        always_update = false
      }
    }
  end,
}
