require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "tinymist" }
vim.lsp.enable(servers)

vim.lsp.config("tinymist", {
    settings = {
        exportPdf = "onSave",
        outputPath = "$root/$dir/$name",
        previewFeature = "enable",
        sysInputs = {},
        pdfOpenCommand = "zathura",
    },
})

-- read :h vim.lsp.config for changing options of lsp servers 
