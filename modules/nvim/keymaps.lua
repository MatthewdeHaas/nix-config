-- Fuzzy Finder
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)

-- Tabs/Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>")
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>")

-- MarkdownPreview
vim.keymap.set("n", "<leader>mp", function()
	vim.g.mkdp_theme = "light"
	vim.cmd("MarkdownPreviewToggle")
end, { desc = "Markdown Preview (light)" })

vim.keymap.set("n", "<leader>mpd", function()
	vim.g.mkdp_theme = "dark"
	vim.cmd("MarkdownPreviewToggle")
end, { desc = "Markdown Preview (dark)" })

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })
