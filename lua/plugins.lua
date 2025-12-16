return {
    {
        'dasupradyumna/midnight.nvim',
        priority = 1000,
        config = function() 
            vim.cmd.colorscheme("midnight") 
        end
    },
    {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-file-browser.nvim' },
        { 'ahmedkhalf/project.nvim' }
    },
    config = function()
        local telescope = require('telescope')
        local builtin = require('telescope.builtin')
        local project = require('project_nvim')

        project.setup {
            detection_methods = { "pattern" },
            patterns = { ".git", "package.json", "Makefile", "README.md" },
            silent_chdir = true,
        }

        telescope.load_extension('projects')
        telescope.load_extension('file_browser')

        local ignore_patterns = { 'node_modules', 'build/', 'dist/', '.next/', '%.DS_Store' }

        -- Use git_files() - automatically ignores .git contents
        vim.keymap.set('n', '<leader>ff', function()
            builtin.git_files({
                cwd = project.get_project_root(),
                file_ignore_patterns = ignore_patterns
            })
        end, { desc = 'Telescope: Git Files in Project' })

        vim.keymap.set('n', '<leader>fg', function()
            builtin.live_grep({
                cwd = project.get_project_root(),
                file_ignore_patterns = ignore_patterns
            })
        end, { desc = 'Telescope: Live Grep in Project Root' })

        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope: Find Buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope: Help Tags' })
        vim.keymap.set('n', '<leader>fp', function()
            telescope.extensions.projects.projects({})
        end, { desc = 'Telescope: Switch Projects' })

        vim.keymap.set('n', '<leader>ft', function()
            telescope.extensions.file_browser.file_browser({
                path = "%:p:h",
                cwd = vim.fn.expand('%:p:h'),
                respect_gitignore = false,
                hidden = true,
                grouped = true,
                previewer = false,
                initial_mode = "normal",
                layout_config = { height = 40 }
            })
        end, { desc = 'Telescope: File Explorer' })

        telescope.setup {
            defaults = {
                file_ignore_patterns = ignore_patterns,
                mappings = {
                    i = { ["<Esc>"] = require("telescope.actions").close },
                    n = { ["<Esc>"] = require("telescope.actions").close },
                }
            },
            pickers = { 
                find_files = { hidden = true },
                git_files = { hidden = true }
            },
            extensions = {
                file_browser = { theme = "dropdown", hijack_netrw = true },
                projects = {},
            }
        }
    end
},


    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "lua", "python", "javascript", "html", "css", "php", "vue"
                },
                highlight = { 
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { 
                    enable = true 
                },
            }
        end
    },
    {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local hooks = require("ibl.hooks")
        
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3B4252" })
            vim.api.nvim_set_hl(0, "IblScope", { fg = "#FFFFFF" })
        end)

        require("ibl").setup {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = false,
            },
            exclude = {
                filetypes = {
                    "help", "startify", "dashboard", "packer",
                    "neogitstatus", "NvimTree", "Trouble",
                },
            },
        }
    end
},


    {
        "rmagatti/auto-session",
        config = function()
            require("auto-session").setup {
                log_level = "error",
                auto_session_enable_last_session = true,
                auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
                auto_session_enabled = true,
                auto_save_enabled = true,
                auto_restore_enabled = true
            }
        end
    },
    {
        'lambdalisue/suda.vim',
        enabled = false,
    },
    {
        "williamboman/mason.nvim",
        config = function() 
            require("mason").setup() 
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup {
                ensure_installed = { "lua_ls", "pyright" }
            }
        end
    },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    html = { "prettier" },
                    css = { "prettier" },
                    scss = { "prettier" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                },
                format_on_save = { 
                    lsp_fallback = true, 
                    timeout_ms = 500 
                }
            })

            vim.keymap.set("n", "<leader>f", function()
                require("conform").format({ async = true, lsp_fallback = true })
            end, { desc = "Format current buffer" })
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim" }
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip"
        }
    },
    {
        "jwalton512/vim-blade",
        enabled = false
    },
    {
        "nvim-tree/nvim-web-devicons",
        enabled = false,
    },
    {
        "folke/which-key.nvim",
        enabled = false,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = '+' },
                    change       = { text = '~' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,
                watch_gitdir = {
                    follow_files = true
                },
                auto_attach = true,
                attach_to_untracked = true,
                current_line_blame = false,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol',
                    delay = 1000,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil,
                max_file_length = 40000,
                preview_config = {
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
                on_attach = function(bufnr)
                    local gitsigns = require('gitsigns')

                    local function map(mode, lhs, rhs, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, lhs, rhs, opts)
                    end

                    -- Navigation
                    map('n', ']c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ ']c', bang = true })
                        else
                            gitsigns.nav_hunk('next')
                        end
                    end, { desc = 'Next git hunk' })

                    map('n', '[c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ '[c', bang = true })
                        else
                            gitsigns.nav_hunk('prev')
                        end
                    end, { desc = 'Previous git hunk' })

                    -- Actions
                    map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
                    map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
                    map('v', '<leader>gs', function() 
                        gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } 
                    end, { desc = 'Stage hunk' })
                    map('v', '<leader>gr', function() 
                        gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } 
                    end, { desc = 'Reset hunk' })
                    map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
                    map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })
                    map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
                    map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
                    map('n', '<leader>gb', function() 
                        gitsigns.blame_line { full = true } 
                    end, { desc = 'Blame line' })
                    map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = 'Toggle line blame' })
                    map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Diff this' })
                    map('n', '<leader>gD', function() 
                        gitsigns.diffthis('~') 
                    end, { desc = 'Diff this ~' })
                    map('n', '<leader>gtd', gitsigns.toggle_deleted, { desc = 'Toggle deleted' })

                    -- Git commit functionality
                    map('n', '<leader>gc', function()
                        local message = vim.fn.input("Commit message: ")
                        if message and message ~= "" then
                            local result = vim.fn.system({ "git", "commit", "-m", message })
                            if vim.v.shell_error == 0 then
                                vim.notify("Committed: " .. message, vim.log.levels.INFO)
                            else
                                vim.notify("Commit failed: " .. result, vim.log.levels.ERROR)
                            end
                        end
                    end, { desc = 'Git commit' })

                    map('n', '<leader>gC', function()
                        local message = vim.fn.input("Commit message (will stage all): ")
                        if message and message ~= "" then
                            vim.fn.system({ "git", "add", "-A" })
                            local result = vim.fn.system({ "git", "commit", "-m", message })
                            if vim.v.shell_error == 0 then
                                vim.notify("Staged all and committed: " .. message, vim.log.levels.INFO)
                            else
                                vim.notify("Commit failed: " .. result, vim.log.levels.ERROR)
                            end
                        end
                    end, { desc = 'Stage all and commit' })

                    map('n', '<leader>gA', function()
                        local filename = vim.fn.expand('%:t')
                        local message = vim.fn.input("Commit message for " .. filename .. ": ")
                        if message and message ~= "" then
                            vim.fn.system({ "git", "add", vim.fn.expand('%') })
                            local result = vim.fn.system({ "git", "commit", "-m", message })
                            if vim.v.shell_error == 0 then
                                vim.notify("Committed " .. filename .. ": " .. message, vim.log.levels.INFO)
                            else
                                vim.notify("Commit failed: " .. result, vim.log.levels.ERROR)
                            end
                        end
                    end, { desc = 'Stage current file and commit' })

                    -- Git workflow commands
                    map('n', '<leader>gst', function()
                        vim.cmd('vsplit | term git status')
                    end, { desc = 'Git status' })

                    map('n', '<leader>gl', function()
                        vim.cmd('vsplit | term git log --oneline -15 --graph')
                    end, { desc = 'Git log' })

                    map('n', '<leader>ga', function()
                        local result = vim.fn.system({ "git", "add", vim.fn.expand('%') })
                        if vim.v.shell_error == 0 then
                            vim.notify("Staged: " .. vim.fn.expand('%:t'), vim.log.levels.INFO)
                        else
                            vim.notify("Failed to stage: " .. result, vim.log.levels.ERROR)
                        end
                    end, { desc = 'Stage current file' })

                    map('n', '<leader>gaa', function()
                        local result = vim.fn.system({ "git", "add", "-A" })
                        if vim.v.shell_error == 0 then
                            vim.notify("Staged all files", vim.log.levels.INFO)
                        else
                            vim.notify("Failed to stage: " .. result, vim.log.levels.ERROR)
                        end
                    end, { desc = 'Stage all files' })

                    -- Git push/pull
                    map('n', '<leader>gps', function()
                        local result = vim.fn.system({ "git", "push" })
                        if vim.v.shell_error == 0 then
                            vim.notify("Push successful!", vim.log.levels.INFO)
                        else
                            vim.notify("Push failed: " .. result, vim.log.levels.ERROR)
                        end
                    end, { desc = 'Git push' })

                    map('n', '<leader>gpl', function()
                        local result = vim.fn.system({ "git", "pull" })
                        if vim.v.shell_error == 0 then
                            vim.notify("Pull successful!", vim.log.levels.INFO)
                        else
                            vim.notify("Pull failed: " .. result, vim.log.levels.ERROR)
                        end
                    end, { desc = 'Git pull' })

                    -- Text object
                    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })
                end
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = false,
                    theme = "auto",
                    component_separators = { left = "|", right = "|" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        "branch",
                        {
                            "diff",
                            symbols = { added = "+", modified = "~", removed = "-" },
                        },
                        {
                            "diagnostics",
                            sources = { "nvim_lsp" },
                            symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
                        },
                    },
                    lualine_c = {
                        {
                            "filename",
                            file_status = true,
                            path = 1,
                            symbols = {
                                modified = "[+]",
                                readonly = "[RO]",
                                unnamed = "[No Name]",
                            },
                        },
                    },
                    lualine_x = {
                        {
                            function()
                                local clients = vim.lsp.get_clients({ bufnr = 0 })
                                if #clients == 0 then
                                    return ""
                                end
                                return "LSP: " .. clients[1].name
                            end,
                        },
                        "encoding",
                        "fileformat",
                        "filetype",
                    },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local autopairs = require("nvim-autopairs")
            autopairs.setup({
                check_ts = true,
                ts_config = {
                    lua = { 'string', 'source' },
                    javascript = { 'string', 'template_string' },
                },
                disable_filetype = { "TelescopePrompt", "vim" },
                enable_check_bracket_line = true,
            })

            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
    },
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            require("Comment").setup({
                padding = true,
                sticky = true,
                toggler = {
                    line = 'gcc',
                    block = 'gbc',
                },
                opleader = {
                    line = 'gc',
                    block = 'gb',
                },
                extra = {
                    above = 'gcO',
                    below = 'gco',
                    eol = 'gcA',
                },
                mappings = {
                    basic = true,
                    extra = true,
                },
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })

            vim.keymap.set('n', '<leader>/', function()
                require('Comment.api').toggle.linewise.current()
            end, { desc = 'Toggle comment line' })

            vim.keymap.set('v', '<leader>/', function()
                local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
                vim.api.nvim_feedkeys(esc, 'nx', false)
                require('Comment.api').toggle.linewise(vim.fn.visualmode())
            end, { desc = 'Toggle comment selection' })
        end,
    },

    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    insert = "<C-g>s",
                    insert_line = "<C-g>S",
                    normal = "ys",
                    normal_cur = "yss",
                    normal_line = "yS",
                    normal_cur_line = "ySS",
                    visual = "S",
                    visual_line = "gS",
                    delete = "ds",
                    change = "cs",
                },
            })
        end,
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        event = "BufReadPost",
        config = function()
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            local ufo = require("ufo")
            ufo.setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end
            })

            vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
            vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
            vim.keymap.set("n", "za", "za", { noremap = true, desc = "Toggle fold" })
        end
    },
    {
        "theprimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon.setup({
                menu = {
                    width = 60,
                    height = 10,
                    border = "rounded",
                    position = "center",
                }
            })

            vim.keymap.set("n", "<leader>h", function()
                require("harpoon.ui").toggle_quick_menu()
            end, { desc = "Harpoon menu" })

            vim.keymap.set("n", "<leader>ha", function()
                require("harpoon.mark").add_file()
            end, { desc = "Harpoon add" })

            vim.keymap.set("n", "<leader>1", function()
                require("harpoon.ui").nav_file(1)
            end, { desc = "Harpoon 1" })

            vim.keymap.set("n", "<leader>2", function()
                require("harpoon.ui").nav_file(2)
            end, { desc = "Harpoon 2" })

            vim.keymap.set("n", "<leader>3", function()
                require("harpoon.ui").nav_file(3)
            end, { desc = "Harpoon 3" })

            vim.keymap.set("n", "<leader>4", function()
                require("harpoon.ui").nav_file(4)
            end, { desc = "Harpoon 4" })

            -- Custom keymaps for the menu - executed after toggle
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "harpoon",
                callback = function()
                    vim.keymap.set("n", "<S-j>", "ddp", { buffer = true, desc = "Move entry down" })
                    vim.keymap.set("n", "<S-k>", "ddP", { buffer = true, desc = "Move entry up" })
                end
            })
        end
    },
    {
        "onsails/lspkind.nvim"
    },
}