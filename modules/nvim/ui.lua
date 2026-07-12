require("catppuccin").setup({
	flavour = "mocha",
	integrations = {
		treesitter = true,
		telescope = { enabled = true },
		bufferline = true,
		native_lsp = { enabled = true },
		vimtex = true,
	}
})
vim.cmd.colorscheme "catppuccin"

require('bufferline').setup({})
