-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.utility.neodim" },
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.utility.nvzone-menu" },
  { import = "astrocommunity.programming-language-support.csv-vim" },
  { import = "astrocommunity.programming-language-support.nvim-jqx" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.prettier" },
  { import = "astrocommunity.pack.mdx" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.just" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.docker.lazydocker" },
  { import = "astrocommunity.note-taking.venn-nvim" },
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  { import = "astrocommunity.git.gitgraph-nvim" },
  { import = "astrocommunity.game.leetcode-nvim" },
  { import = "astrocommunity.file-explorer.yazi-nvim" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.rustowl" },
  { import = "astrocommunity.editing-support.nvim-origami" },
  { import = "astrocommunity.editing-support.auto-save-nvim" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.colorscheme.everforest" },
  { import = "astrocommunity.utility.hover-nvim" },
  -- import/override with your plugins folder
}
