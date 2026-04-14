require "nvchad.autocmds"
require("configs.latex_preview").setup()

-- Re-apply dark mode every time the nvdash (dashboard) renders
vim.api.nvim_create_autocmd("User", {
    pattern = "NvDashReady",
    callback = function()
        vim.schedule(function()
            require("theme_toggle").init()
        end)
    end,
})

-- Re-apply dark mode on VimEnter (catches startup before LazyDone)
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.schedule(function()
            require("theme_toggle").init()
        end)
    end,
})
