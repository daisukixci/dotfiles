return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- configure lazyvim to load gruvbox
  {
    "lazyvim/lazyvim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
