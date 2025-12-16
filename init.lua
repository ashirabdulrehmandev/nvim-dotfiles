-----------------------------------------------------------
-- CLOSE POPUPS WITH ESC
-----------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "mason", "lazy", "trouble", "notify", "toggleterm", "help", "qf", "fugitive", "git", "startify", "dashboard", "alpha", "TelescopePrompt" },
    callback = function(args)
        vim.keymap.set("n", "<Esc>", "<cmd>q!<cr>", { buffer = args.buf, silent = true, noremap = true })
        vim.keymap.set("n", "q", "<cmd>q!<cr>", { buffer = args.buf, silent = true, noremap = true })
    end
})

-----------------------------------------------------------
-- LAZY.NVIM BOOTSTRAP (Cross-platform)
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-----------------------------------------------------------
-- LOAD PLUGINS
-----------------------------------------------------------
require("lazy").setup({
    spec = require("plugins"),
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true }
})

-----------------------------------------------------------
-- GLOBAL SETTINGS
-----------------------------------------------------------
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

require("settings")
require("keybinds")

-----------------------------------------------------------
-- LSP + AUTOCOMPLETE SETUP (Cross-platform)
-----------------------------------------------------------
vim.schedule(function()
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local opts = { buffer = args.buf }
            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
            end

            map("n", "gd", vim.lsp.buf.definition, "Go to definition")
            map("n", "K", vim.lsp.buf.hover, "Hover documentation")
            map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
            map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
            map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
            map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
            map("n", "gr", vim.lsp.buf.references, "Find references")
        end
    })

    local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    local ok_mason, mason = pcall(require, "mason")
    local ok_mason_lsp, mason_lsp = pcall(require, "mason-lspconfig")

    if not (ok_cmp and ok_mason and ok_mason_lsp) then
        vim.notify("LSP setup skipped: required plugins not found", vim.log.levels.WARN)
        return
    end

    local capabilities = cmp_lsp.default_capabilities()

    mason.setup()

    mason_lsp.setup({
        ensure_installed = {
            "intelephense", "html", "emmet_ls",
            "tailwindcss", "ts_ls"
        },
        automatic_installation = true
    })

    -- Cross-platform Vue path (normalize separators)
    local vue_language_server_path = vim.fn.stdpath("data") .. 
        "/mason/packages/vue-language-server/node_modules/@vue/language-server"
    
    -- Fix: Use proper path normalization for cross-platform compatibility
    if vim.fn.has('win32') == 1 then
        vue_language_server_path = vue_language_server_path:gsub('/', '\\')
    end

    vim.lsp.config.lua_ls = {
        capabilities = capabilities,
        settings = {
            Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false }
            }
        }
    }

    vim.lsp.config.pyright = { capabilities = capabilities }

    local ts_ls_config = {
        capabilities = capabilities,
        filetypes = {
            "javascript", "javascriptreact", "javascript.jsx",
            "typescript", "typescriptreact", "typescript.tsx"
        }
    }

    -- Check if Vue path exists (cross-platform)
    local vue_exists = (vim.uv or vim.loop).fs_stat(vue_language_server_path)
    if vue_exists then
        ts_ls_config.init_options = {
            plugins = {
                {
                    name = "@vue/typescript-plugin",
                    location = vue_language_server_path,
                    languages = { "vue" }
                }
            }
        }
    end

    vim.lsp.config.ts_ls = ts_ls_config
    vim.lsp.config.intelephense = { capabilities = capabilities }
    vim.lsp.config.html = { capabilities = capabilities }
    vim.lsp.config.emmet_ls = { capabilities = capabilities }
    vim.lsp.config.tailwindcss = { capabilities = capabilities }
    vim.lsp.config.volar = { capabilities = capabilities }  -- Fix: Changed vue_ls to volar

    local servers = { "lua_ls", "pyright", "intelephense", "html", "emmet_ls", "tailwindcss", "ts_ls" }
    for _, server in ipairs(servers) do vim.lsp.enable(server) end

    -----------------------------------------------------------
    -- COMPLETION
    -----------------------------------------------------------
    local cmp = require("cmp")
    local lspkind = require("lspkind")

    cmp.setup({
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                else fallback() end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                else fallback() end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp", priority = 1000, entry_filter = function(entry) 
                return not (entry:get_kind() == cmp.lsp.CompletionItemKind.Snippet and vim.bo.filetype == "css") 
            end },
            { name = "luasnip", priority = 800, entry_filter = function() return vim.bo.filetype ~= "css" end },
            { name = "buffer", priority = 500 },
            { name = "path", priority = 250 }
        }),
        formatting = { format = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50, ellipsis_char = "..." }) },
        window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
        sorting = {
            priority_weight = 2,
            comparators = {
                function(entry1, entry2)
                    if vim.bo.filetype == "css" then
                        local kind1, kind2 = entry1:get_kind(), entry2:get_kind()
                        local src1, src2 = entry1.source.name, entry2.source.name
                        local is_snip1 = kind1 == cmp.lsp.CompletionItemKind.Snippet or src1:match("snip")
                        local is_snip2 = kind2 == cmp.lsp.CompletionItemKind.Snippet or src2:match("snip")
                        if is_snip1 ~= is_snip2 then return not is_snip1 end
                    end
                    return nil
                end,
                cmp.config.compare.score, cmp.config.compare.recently_used, cmp.config.compare.locality,
                cmp.config.compare.offset, cmp.config.compare.exact, cmp.config.compare.kind,
                cmp.config.compare.sort_text, cmp.config.compare.length, cmp.config.compare.order,
            }
        }
    })

    require("luasnip").config.setup({ history = true, delete_check_events = "TextChanged" })
end)

-----------------------------------------------------------
-- UI FIXES
-----------------------------------------------------------
vim.cmd([[
    highlight Normal guibg=NONE ctermbg=NONE
    highlight StatusLine guibg=NONE ctermbg=NONE
    highlight StatusLineNC guibg=NONE ctermbg=NONE
    highlight SignColumn guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
    highlight CursorLineNr guibg=NONE ctermbg=NONE
    highlight VertSplit guibg=NONE ctermbg=NONE
    highlight WinSeparator guibg=NONE ctermbg=NONE
]])

-----------------------------------------------------------
-- LINE NUMBERS
-----------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter", "CmdwinLeave" }, {
    callback = function()
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.signcolumn = "yes"
    end,
})

-----------------------------------------------------------
-- LINE NUMBER COMMANDS
-----------------------------------------------------------
vim.api.nvim_create_user_command("CheckLineNumbers", function()
    vim.notify(string.format("number: %s\nrelativenumber: %s\nsigncolumn: %s",
        vim.opt.number:get(), vim.opt.relativenumber:get(), vim.opt.signcolumn:get()), vim.log.levels.INFO)
end, { desc = "Check line number settings" })

vim.api.nvim_create_user_command("FixLineNumbers", function()
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.signcolumn = "yes"
    vim.notify("Line numbers forced on!", vim.log.levels.INFO)
end, { desc = "Force enable line numbers" })

vim.keymap.set('n', '<leader>ln', '<cmd>FixLineNumbers<cr>', { desc = 'Fix line numbers' })

-----------------------------------------------------------
-- GIT SIDEBAR + INDENT LINES (FORCE ENABLE)
-----------------------------------------------------------
vim.opt.signcolumn = "yes:2"  -- 2 columns: git + diagnostics
vim.opt.list = true
vim.opt.listchars = "trail:·,space:·,tab:▸ ,eol:↴,extends:⟩,precedes:⟨"

-- Force gitsigns setup (even if plugin lazy-loaded)
vim.api.nvim_create_autocmd({"BufReadPost", "FileChangedShellPost"}, {
    callback = function()
        vim.schedule(function()
            local ok, gitsigns = pcall(require, "gitsigns")
            if ok then
                gitsigns.setup({
                    signs = {
                        add          = { text = "+" },
                        change       = { text = "~" },
                        delete       = { text = "_" },
                        topdelete    = { text = "‾" },
                        changedelete = { text = "~" },
                    },
                    signcolumn = true,
                    numhl = true,
                    linehl = false,
                    watch_gitdir = { interval = 1000, follow_files = true },
                    attach_to_untracked = true,
                    current_line_blame = false,
                })
            end
        end)
    end,
})

-- Git highlight colors
vim.api.nvim_set_hl(0, "GitSignsAdd",        { fg = "#00ff00" })
vim.api.nvim_set_hl(0, "GitSignsChange",     { fg = "#ffaa00" })
vim.api.nvim_set_hl(0, "GitSignsDelete",     { fg = "#ff0000" })
vim.api.nvim_set_hl(0, "GitSignsAddNr",      { fg = "#00ff00" })
vim.api.nvim_set_hl(0, "GitSignsChangeNr",   { fg = "#ffaa00" })
vim.api.nvim_set_hl(0, "GitSignsDeleteNr",   { fg = "#ff0000" })

-- INDENT LINES (force ibl - indent-blankline v3)
vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile", "FileChangedShellPost"}, {
    callback = function()
        vim.schedule(function()
            local ok, ibl = pcall(require, "ibl")
            if ok then
                ibl.setup({
                    indent = { char = "▏" },
                    exclude = {
                        filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble", "lazy", "mason", "notify", "toggleterm", "lazyterm" }
                    },
                    scope = { enabled = true, show_start = true, show_end = false }
                })
            end
        end)
    end,
})

-- Toggle commands with proper error handling
vim.keymap.set('n', '<leader>gt', function()
    local ok, gitsigns = pcall(require, 'gitsigns')
    if ok then gitsigns.toggle_signs() end
end, { desc = 'Toggle git signs' })

vim.keymap.set('n', '<leader>gi', function()
    local ok, ibl = pcall(require, 'ibl')
    if ok then vim.cmd('IBLToggle') end
end, { desc = 'Toggle indent lines' })

-----------------------------------------------------------
-- CROSS-PLATFORM HELP POPUPS
-----------------------------------------------------------
local function create_help_popup(title, content, width_mult, height_mult)
    local width = math.floor(vim.o.columns * (width_mult or 0.8))
    local height = math.floor(vim.o.lines * (height_mult or 0.8))
    local row, col = math.floor((vim.o.lines - height) / 2), math.floor((vim.o.columns - width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    vim.bo[buf].modifiable = false
    vim.bo[buf].bufhidden = 'wipe'

    vim.api.nvim_open_win(buf, true, {
        relative = 'editor', width = width, height = height, row = row, col = col,
        style = 'minimal', border = 'rounded', title = title, title_pos = 'center'
    })

    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
    vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, silent = true })
end

vim.api.nvim_create_user_command("KeybindsHelp", function()
    create_help_popup(' Keybindings ', {
        "",
        "  NAVIGATION",
        "  ──────────────────────────────────────────────────────",
        "  <C-h/j/k/l>     Navigate windows",
        "  <leader>bp/bn   Previous/next buffer",
        "  <leader>bd      Delete buffer",
        "",
        "  FILES & SEARCH",
        "  ──────────────────────────────────────────────────────",
        "  <leader>ff      Find files",
        "  <leader>fg      Live grep",
        "  <leader>fb      Find buffers",
        "  <leader>fh      Help tags",
        "  <leader>ft      File explorer",
        "",
        "  LEAP (Jump to text)",
        "  ──────────────────────────────────────────────────────",
        "  s               Jump forward (type 2 chars + label)",
        "  S               Jump backward",
        "  x               Leap with operator",
        "  X               Leap backward with operator",
        "",
        "  HARPOON",
        "  ──────────────────────────────────────────────────────",
        "  <leader>h       Toggle harpoon menu",
        "  <leader>ha      Add file to harpoon",
        "  <leader>1-4     Go to harpoon file 1-4",
        "  <S-j>/<S-k>     Move entry down/up (in menu)",
        "",
        "  FOLDING",
        "  ──────────────────────────────────────────────────────",
        "  za              Toggle fold",
        "  zc/zo           Close/open fold",
        "  zR/zM           Open/close all folds",
        "",
        "  GIT",
        "  ──────────────────────────────────────────────────────",
        "  ]c/[c           Next/prev hunk",
        "  <leader>gs/gr   Stage/reset hunk",
        "  <leader>gS      Stage buffer",
        "  <leader>gp      Preview hunk",
        "  <leader>gd      Diff this",
        "  <leader>gb      Blame line",
        "  <leader>gst     Git status",
        "  <leader>gl      Git log",
        "",
        "  EDITING",
        "  ──────────────────────────────────────────────────────",
        "  <leader>/       Toggle comment",
        "  gcc/gbc         Toggle line/block comment",
        "  ys{m}{c}        Add surround",
        "  ds{c}           Delete surround",
        "  cs{o}{n}        Change surround",
        "",
        "  LSP",
        "  ──────────────────────────────────────────────────────",
        "  gd              Go to definition",
        "  K               Hover documentation",
        "  gi              Go to implementation",
        "  gr              Find references",
        "  <leader>rn      Rename",
        "  <leader>ca      Code action",
        "  <leader>cf      Format buffer",
        "",
        "  UTILITIES",
        "  ──────────────────────────────────────────────────────",
        "  <leader>w       Save file",
        "  <leader>q       Quit",
        "  <leader>Q       Force quit",
        "  <leader>nh      Clear search highlight",
        "  <leader>?       Show this help",
        "",
        "  Press q or Esc to close",
        ""
    }, 1.0, 1.0)
end, { desc = "Keybindings help" })

vim.keymap.set('n', '<leader>?', '<cmd>KeybindsHelp<cr>', { desc = 'Keybindings help' })

vim.api.nvim_create_user_command("GitHelp", function()
    create_help_popup(' Git Help ', {
        "gid: Set git identity | gcr: Set credentials",
        "gps: Smart push | gpl: Smart pull",
        "Windows: Add git to PATH | Linux: Ensure git installed",
        "Press q/Esc to close"
    })
end, { desc = "Git help" })



vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter"}, {
  callback = function()
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3B4252", force = true })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#FFFFFF", force = true })
  end,
}) 