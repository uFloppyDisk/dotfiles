return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      explorer = { enabled = false },
      picker = { enabled = false },
      scroll = { enabled = false },

      indent = {
        animate = { enabled = false },
      },
    },
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
    },
  },
}
