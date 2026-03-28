return {{
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform"
}, -- These are some examples, uncomment them if you want to see them work!
{
    "neovim/nvim-lspconfig",
    config = function()
        require "configs.lspconfig"
    end
}, {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup {}
    end
},
{
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    }
},
{
  "folke/which-key.nvim",
  enabled = false,
},
{
    "github/copilot.vim",
    cmd = "Copilot",
    lazy = false,
},
{
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
    cmd = "RenderMarkdown",
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    opts = {
        latex = {enabled = true},
        code = {style = "block"},
    },
},
{
  'Julian/lean.nvim',
  event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

  dependencies = {
    'nvim-lua/plenary.nvim',

    -- optional dependencies:

    -- a completion engine
    --    hrsh7th/nvim-cmp or Saghen/blink.cmp are popular choices

    -- 'nvim-telescope/telescope.nvim', -- for 2 Lean-specific pickers
    -- 'andymass/vim-matchup',          -- for enhanced % motion behavior
    -- 'andrewradev/switch.vim',        -- for switch support
    -- 'tomtom/tcomment_vim',           -- for commenting
  },

  opts = { -- see below for full configuration options
    mappings = true,
  }
},
{ "petRUShka/vim-sage" },
{
    "nvim-treesitter/nvim-treesitter",
    opts = {
        -- 确保这些解析器被安装（对象集）
        ensure_installed = {"vim", "lua", "vimdoc", "html", "css", "cpp", "c", "python"},
        -- 启用功能
        highlight = {
            enable = true,
            use_languagetree = true
        },
        indent = {
            enable = true
        }
    },
    {
      "lervag/vimtex",
      lazy = false, -- 建议不要延迟加载，否则某些功能可能失效
      config = function()
        -- 在这里进行基础配置
        vim.g.vimtex_view_method = 'zathura' -- 指定 PDF 阅读器
      end
    },
    {
        "okuuva/auto-save.nvim",
        lazy = false,
        version = '^1.0.0', -- 
        cmd = "ASToggle", -- optional for lazy loading on command
        event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
        opts = {
            enabled = true,
            debounce_delay = 3000,
            trigger_events = {
                defer_save = { "InsertEnter", "TextChanged" },
            },
            -- your config goes here
            -- or just leave it empty :)
        },
    },
    {
      "CRAG666/code_runner.nvim",
      cmd = {"RunCode"},
      opts = {
        filetype = {
          cpp = {
            "cd $dir &&",
            "g++ $fileName -o $fileNameWithoutExt &&",
            "./$fileNameWithoutExt ;",
            "rm $fileNameWithoutExt",
          },
          sage = {
              "cd $dir &&",
              "sage $fileName",
          },
        },
      },
    },
    {
        'xeluxee/competitest.nvim',
        dependencies = 'MunifTanjim/nui.nvim',
        lazy = false,
        config = function()
            require('competitest').setup {
                local_config_file_name = ".competitest.lua",

                floating_border = "rounded",
                floating_border_highlight = "FloatBorder",
                picker_ui = {
                    width = 0.2,
                    height = 0.3,
                    mappings = {
                        focus_next = {"j", "<down>", "<Tab>"},
                        focus_prev = {"k", "<up>", "<S-Tab>"},
                        close = {"<esc>", "<C-c>", "q", "Q"},
                        submit = "<cr>"
                    }
                },
                editor_ui = {
                    popup_width = 0.4,
                    popup_height = 0.6,
                    show_nu = true,
                    show_rnu = false,
                    normal_mode_mappings = {
                        switch_window = {"<C-h>", "<C-l>", "<C-i>"},
                        save_and_close = "<C-s>",
                        cancel = {"q", "Q"}
                    },
                    insert_mode_mappings = {
                        switch_window = {"<C-h>", "<C-l>", "<C-i>"},
                        save_and_close = "<C-s>",
                        cancel = "<C-q>"
                    }
                },
                focus_on_run = true,
                runner_ui = {
                    interface = "popup",
                    selector_show_nu = false,
                    selector_show_rnu = false,
                    show_nu = true,
                    show_rnu = false,
                    mappings = {
                        ui_close = 'q',
                        terminal_close = 'q',
                        run_again = "R",
                        run_all_again = "<C-r>",
                        kill = "K",
                        kill_all = "<C-k>",
                        view_input = {"i", "I"},
                        view_output = {"a", "A"},
                        view_stdout = {"o", "O"},
                        view_stderr = {"e", "E"},
                        toggle_diff = {"d", "D"},
                        close = {"q", "Q"}
                    },
                    viewer = {
                        width = 0.5,
                        height = 0.5,
                        show_nu = true,
                        show_rnu = false,
                        open_when_compilation_fails = true
                    }
                },
                popup_ui = {
                    total_width = 0.8,
                    total_height = 0.8,
                    layout = {{4, "tc"}, {5, {{1, "so"}, {1, "si"}}}, {5, {{1, "eo"}, {1, "se"}}}}
                },
                split_ui = {
                    position = "right",
                    relative_to_editor = true,
                    total_width = 0.3,
                    vertical_layout = {{1, "tc"}, {1, {{1, "so"}, {1, "eo"}}}, {1, {{1, "si"}, {1, "se"}}}},
                    total_height = 0.4,
                    horizontal_layout = {{2, "tc"}, {3, {{1, "so"}, {1, "si"}}}, {3, {{1, "eo"}, {1, "se"}}}}
                },

                save_current_file = true,
                save_all_files = false,
                compile_directory = ".",
                compile_command = {
                    c = {
                        exec = "gcc",
                        args = {"-Wall", "$(FNAME)", "-o", "$(FNOEXT)"}
                    },
                    cpp = {
                        exec = "g++",
                        args = {"-Wall", "$(FNAME)", "-o", "$(FNOEXT)"}
                    },
                    rust = {
                        exec = "rustc",
                        args = {"$(FNAME)"}
                    },
                    java = {
                        exec = "javac",
                        args = {"$(FNAME)"}
                    }
                },
                running_directory = ".",
                run_command = {
                    c = {
                        exec = "./$(FNOEXT)"
                    },
                    cpp = {
                        exec = "./$(FNOEXT)"
                    },
                    rust = {
                        exec = "./$(FNOEXT)"
                    },
                    python = {
                        exec = "python",
                        args = {"$(FNAME)"}
                    },
                    java = {
                        exec = "java",
                        args = {"$(FNOEXT)"}
                    }
                },
                multiple_testing = -1,
                maximum_time = 5000,
                output_compare_method = "squish",
                view_output_diff = false,

                testcases_directory = ".",
                testcases_use_single_file = false,
                testcases_auto_detect_storage = true,
                testcases_single_file_format = "$(FNOEXT).testcases",
                testcases_input_file_format = "$(FNOEXT)_input$(TCNUM).txt",
                testcases_output_file_format = "$(FNOEXT)_output$(TCNUM).txt",

                companion_port = 27121,
                receive_print_message = true,
                start_receiving_persistently_on_setup = false,
                template_file = false,
                evaluate_template_modifiers = false,
                date_format = "%c",
                received_files_extension = "cpp",
                received_problems_path = "$(CWD)/$(PROBLEM).$(FEXT)",
                received_problems_prompt_path = true,
                received_contests_directory = "$(CWD)",
                received_contests_problems_path = "$(PROBLEM).$(FEXT)",
                received_contests_prompt_directory = true,
                received_contests_prompt_extension = true,
                open_received_problems = true,
                open_received_contests = true,
                replace_received_testcases = false
            }
        end,
        ft = {"cpp", "c"}
    }
} -- test new blink
-- { import = "nvchad.blink.lazyspec" },
-- {
-- 	"nvim-treesitter/nvim-treesitter",
-- 	opts = {
-- 		ensure_installed = {
-- 			"vim", "lua", "vimdoc",
--      "html", "css"
-- 		},
-- 	},
-- },
}
