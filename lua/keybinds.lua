-- keybinds.lua - Organized keybindings without conflicts
--
-- ╭──────────────────────────────────────────────────────────╮
-- │                    KEY REFERENCE                         │
-- ├──────────────────────────────────────────────────────────┤
-- │ LEADER KEY: <space>                                      │
-- │                                                          │
-- │ FILES & SEARCH:                                          │
-- │   <leader>ff  - Find Files                               │
-- │   <leader>fg  - Live Grep                                │
-- │   <leader>fb  - Find Buffers                             │
-- │   <leader>fh  - Help Tags                                │
-- │   <leader>ft  - File Explorer                            │
-- │                                                          │
-- │ HARPOON:                                                 │
-- │   <leader>h   - Toggle Harpoon menu                      │
-- │   <leader>ha  - Add file to Harpoon                      │
-- │   <leader>1   - Go to Harpoon file 1                     │
-- │   <leader>2   - Go to Harpoon file 2                     │
-- │   <leader>3   - Go to Harpoon file 3                     │
-- │   <leader>4   - Go to Harpoon file 4                     │
-- │   Shift+J     - Move entry down (in menu)                │
-- │   Shift+K     - Move entry up (in menu)                  │
-- │                                                          │
-- │ CODE ACTIONS:                                            │
-- │   <leader>ca  - Code Action                              │
-- │   <leader>cf  - Format current buffer                    │
-- │   <leader>rn  - Rename                                   │
-- │                                                          │
-- │ GIT OPERATIONS:                                          │
-- │   <leader>gs  - Stage hunk                               │
-- │   <leader>gr  - Reset hunk                               │
-- │   <leader>gS  - Stage buffer                             │
-- │   <leader>gu  - Undo stage hunk                          │
-- │   <leader>gR  - Reset buffer                             │
-- │   <leader>gp  - Preview hunk                             │
-- │   <leader>gb  - Blame line                               │
-- │   <leader>gtb - Toggle line blame                        │
-- │   <leader>gd  - Diff this                                │
-- │   <leader>gD  - Diff this ~                              │
-- │   <leader>gtd - Toggle deleted                           │
-- │   <leader>gc  - Git commit staged (with auto-setup)      │
-- │   <leader>gC  - Stage all and commit (with auto-setup)   │
-- │   <leader>gA  - Stage current file and commit (auto)     │
-- │   <leader>ga  - Stage current file                       │
-- │   <leader>gaa - Stage all files                          │
-- │   <leader>gps - Git push (with auto-setup on errors)     │
-- │   <leader>gpl - Git pull (with auto-setup on errors)     │
-- │   <leader>gst - Git status (in terminal)                 │
-- │   <leader>gl  - Git log (in terminal)                    │
-- │   <leader>gid - Set git identity (global)                │
-- │   <leader>glt - Set git identity (local)                 │
-- │   <leader>gcr - Set git credentials                      │
-- │   <leader>gsh - Setup SSH for git                        │
-- │   <leader>gco - Show git config                          │
-- │   <leader>gt  - Toggle git signs                         │
-- │   <leader>gi  - Toggle indent lines                      │
-- │   ]c          - Next git hunk                            │
-- │   [c          - Previous git hunk                        │
-- │                                                          │
-- │ BUFFERS:                                                 │
-- │   <leader>bn  - Next Buffer                              │
-- │   <leader>bp  - Previous Buffer                          │
-- │   <leader>bd  - Delete Buffer                            │
-- │                                                          │
-- │ UTILITIES:                                               │
-- │   <leader>nh  - Clear search highlights                  │
-- │   <leader>w   - Save file                                │
-- │   <leader>q   - Quit                                     │
-- │   <leader>Q   - Force quit                               │
-- │   <leader>ln  - Fix line numbers                         │
-- │                                                          │
-- │ FOLDING:                                                 │
-- │   za          - Toggle fold                              │
-- │   zc          - Close fold                               │
-- │   zo          - Open fold                                │
-- │   zR          - Open all folds                           │
-- │   zM          - Close all folds                          │
-- │                                                          │
-- │ COMMENTING:                                              │
-- │   <leader>/   - Toggle comment line/selection            │
-- │   <leader>cb  - Toggle block comment                     │
-- │   gcc         - Toggle comment current line              │
-- │   gbc         - Toggle block comment current line        │
-- │   gc{motion}  - Toggle comment with motion               │
-- │   gcO         - Add comment above current line           │
-- │   gco         - Add comment below current line           │
-- │   gcA         - Add comment at end of line               │
-- │                                                          │
-- │ SURROUND (text objects):                                 │
-- │   ys{motion}{char} - Add surround (e.g., ysiw" for word) │
-- │   yss{char}   - Add surround to entire line              │
-- │   S{char}     - Add surround to visual selection         │
-- │   ds{char}    - Delete surround (e.g., ds" removes ")    │
-- │   cs{old}{new} - Change surround (e.g., cs"' changes     │
-- │                  quotes from " to ')                     │
-- │   Aliases: b=), B=}, r=], a=>, q=quotes, s=any           │
-- │                                                          │
-- │ AUTO-PAIRS (automatic):                                  │
-- │   Type ( → automatically adds )                          │
-- │   Type [ → automatically adds ]                          │
-- │   Type { → automatically adds }                          │
-- │   Type " → automatically adds "                          │
-- │   Type ' → automatically adds '                          │
-- │   Backspace between pairs deletes both                   │
-- │   Type closing bracket to skip over it                   │
-- │                                                          │
-- │ STATUS LINE (automatic):                                 │
-- │   Shows: Mode | Branch | Diff | Diagnostics | File      │
-- │   Also shows: LSP servers | Encoding | Line:Col         │
-- │   Bottom bar displays all file and project info          │
-- │                                                          │
-- │ HELP COMMANDS:                                           │
-- │   <leader>?   - Show this keybindings guide (popup)      │
-- │   :KeybindsHelp - Show keybindings guide                 │
-- │   :GitHelp      - Show git troubleshooting help          │
-- │   :CheckLineNumbers - Check line number settings         │
-- │   :FixLineNumbers   - Force enable line numbers          │
-- │                                                          │
-- │ LSP (non-leader):                                        │
-- │   gd          - Go to definition                         │
-- │   K           - Hover documentation                      │
-- │   gi          - Go to implementation                     │
-- │   <C-k>       - Signature help                           │
-- │   gr          - Find references                          │
-- │                                                          │
-- │ WINDOW NAVIGATION:                                       │
-- │   <C-h>       - Left window                              │
-- │   <C-j>       - Down window                              │
-- │   <C-k>       - Up window                                │
-- │   <C-l>       - Right window                             │
-- ╰──────────────────────────────────────────────────────────╯

-----------------------------------------------------------
-- WINDOW NAVIGATION
-----------------------------------------------------------
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'Go to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'Go to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'Go to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'Go to right window' })

-----------------------------------------------------------
-- BUFFER NAVIGATION
-----------------------------------------------------------
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })

-----------------------------------------------------------
-- LSP KEYBINDINGS (Set in LspAttach autocmd in init.lua)
-----------------------------------------------------------
-- These are documented here but actually set in init.lua's LspAttach callback:
-- gd, K, gi, <C-k>, <leader>rn, <leader>ca, gr

-----------------------------------------------------------
-- FORMATTING
-----------------------------------------------------------
vim.keymap.set("n", "<leader>cf", function()
    local ok, conform = pcall(require, "conform")
    if ok then
        conform.format({ async = true, lsp_fallback = true })
    else
        vim.lsp.buf.format({ async = true })
    end
end, { desc = "Format current buffer" })

-----------------------------------------------------------
-- QUICK ACTIONS
-----------------------------------------------------------
vim.keymap.set('n', '<leader>nh', function()
    vim.cmd('nohlsearch')
    vim.fn.setreg('/', '')
end, { desc = 'Clear search highlights and pattern' })
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>Q', '<cmd>q!<cr>', { desc = 'Force quit' })

-----------------------------------------------------------
-- TELESCOPE KEYBINDINGS (if available)
-----------------------------------------------------------
vim.keymap.set('n', '<leader>ff', function()
    local ok, telescope = pcall(require, 'telescope.builtin')
    if ok then
        telescope.find_files()
    else
        vim.notify("Telescope not available", vim.log.levels.WARN)
    end
end, { desc = 'Find files' })

vim.keymap.set('n', '<leader>fg', function()
    local ok, telescope = pcall(require, 'telescope.builtin')
    if ok then
        telescope.live_grep()
    else
        vim.notify("Telescope not available", vim.log.levels.WARN)
    end
end, { desc = 'Live grep' })

vim.keymap.set('n', '<leader>fb', function()
    local ok, telescope = pcall(require, 'telescope.builtin')
    if ok then
        telescope.buffers()
    else
        vim.notify("Telescope not available", vim.log.levels.WARN)
    end
end, { desc = 'Find buffers' })

vim.keymap.set('n', '<leader>fh', function()
    local ok, telescope = pcall(require, 'telescope.builtin')
    if ok then
        telescope.help_tags()
    else
        vim.notify("Telescope not available", vim.log.levels.WARN)
    end
end, { desc = 'Help tags' })

-----------------------------------------------------------
-- FILE EXPLORER (if neo-tree available)
-----------------------------------------------------------
-- vim.keymap.set('n', '<leader>ft', function()
--     local ok = pcall(vim.cmd, 'Neotree toggle')
--     if not ok then
--         vim.notify("Neo-tree not available", vim.log.levels.WARN)
--     end
-- end, { desc = 'Toggle file explorer' })

-----------------------------------------------------------
-- GITSIGNS KEYBINDINGS (if available)
-----------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        local ok, gitsigns = pcall(require, 'gitsigns')
        if not ok then return end

        -- Navigation
        vim.keymap.set('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gitsigns.next_hunk() end)
            return '<Ignore>'
        end, { expr = true, desc = 'Next git hunk' })

        vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gitsigns.prev_hunk() end)
            return '<Ignore>'
        end, { expr = true, desc = 'Previous git hunk' })

        -- Actions
        vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
        vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
        vim.keymap.set('v', '<leader>gs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Stage hunk' })
        vim.keymap.set('v', '<leader>gr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Reset hunk' })
        vim.keymap.set('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
        vim.keymap.set('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })
        vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
        vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
        vim.keymap.set('n', '<leader>gb', function() gitsigns.blame_line{full=true} end, { desc = 'Blame line' })
        vim.keymap.set('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = 'Toggle line blame' })
        vim.keymap.set('n', '<leader>gd', gitsigns.diffthis, { desc = 'Diff this' })
        vim.keymap.set('n', '<leader>gD', function() gitsigns.diffthis('~') end, { desc = 'Diff this ~' })
        vim.keymap.set('n', '<leader>gtd', gitsigns.toggle_deleted, { desc = 'Toggle deleted' })
    end
})

-----------------------------------------------------------
-- GIT COMMANDS (Terminal-based)
-----------------------------------------------------------
vim.keymap.set('n', '<leader>gst', '<cmd>terminal git status<cr>', { desc = 'Git status' })
vim.keymap.set('n', '<leader>gl', '<cmd>terminal git log --oneline --graph --decorate --all<cr>', { desc = 'Git log' })

-----------------------------------------------------------
-- COMMENTING (Comment.nvim keybindings)
-----------------------------------------------------------
-- Comment.nvim sets these automatically:
-- gcc - toggle comment line
-- gbc - toggle block comment
-- gc{motion} - toggle comment with motion
-- <leader>/ is set in the Comment.nvim plugin config

-----------------------------------------------------------
-- SURROUND (nvim-surround keybindings)
-----------------------------------------------------------
-- nvim-surround sets these automatically:
-- ys{motion}{char} - add surround
-- yss{char} - add surround to line
-- S{char} - add surround to visual selection (visual mode)
-- ds{char} - delete surround
-- cs{old}{new} - change surround