return {
  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile" },
    opts = {
      before_run_filetype = function()
        vim.cmd "silent write"
      end,
      filetype = {
        cpp = {
          "cd $dir &&",
          "g++ $fileName -o $fileNameWithoutExt &&",
          "time ./$fileNameWithoutExt ;",
          "rm $fileNameWithoutExt",
        },
        sage = {
          "cd $dir &&",
          "sage $fileName",
        },
        haskell = {
          "cd $dir &&",
          "ghci $fileName",
        },
      },
    },
  },
}
