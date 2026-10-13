return {
  {
    "github/copilot.vim",
    branch = "release",
    event = "InsertEnter",
    cmd = "Copilot",
    init = function()
      vim.g.copilot_no_tab_map = true -- Keep Tab for nvim-cmp and snippets.
    end,
  },
  {
    "kkrampis/codex.nvim",
    cmd = { "Codex", "CodexToggle" },
    keys = {
      {
        "<leader>cc",
        function()
          require("codex").toggle()
          if vim.bo.buftype == "terminal" and vim.bo.filetype == "codex" then
            vim.cmd "startinsert"
          end
        end,
        mode = { "n", "t" },
        desc = "Toggle Codex",
      },
    },
    opts = {
      autoinstall = false, -- Use the existing Codex CLI and its login/configuration.
      border = "single",
      width = 0.8,
      height = 0.8,
      keymaps = { quit = "<C-q>" }, -- Hide the window; keep the session running.
    },
  },
}
