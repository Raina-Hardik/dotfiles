-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- colorscheme
  { import = "astrocommunity.colorscheme.everforest" },

  -- language packs
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.typescript" }, -- covers JavaScript too
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.bash" }, -- also handles zsh files
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.docker" },

  -- git
  { import = "astrocommunity.git.diffview-nvim" },

  -- tools & utilities
  { import = "astrocommunity.docker.lazydocker" },
  { import = "astrocommunity.editing-support.comment-box-nvim" },
  { import = "astrocommunity.programming-language-support.csv-vim" },
  { import = "astrocommunity.programming-language-support.nvim-jqx" },
  { import = "astrocommunity.quickfix.nvim-bqf" },
  { import = "astrocommunity.terminal-integration.floaterm" },

  -- centered cmdline popup + nicer messages (the LazyVim look)
  { import = "astrocommunity.utility.noice-nvim" },
}
