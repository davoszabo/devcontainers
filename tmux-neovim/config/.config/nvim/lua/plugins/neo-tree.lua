
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.keymap.set("n", "<leader>ee", ":Neotree source=filesystem toggle=true position=left<CR>", {})
    vim.keymap.set("n", "<leader>eb", ":Neotree buffers reveal float<CR>", {})
  end,
}
