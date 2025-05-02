--if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.color.transparent-nvim" },
  { import = "astrocommunity.completion.codeium-nvim" },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  { import = "astrocommunity.motion.flash-nvim" },
  -- import/override with your plugins folder
}
