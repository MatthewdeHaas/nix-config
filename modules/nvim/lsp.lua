vim.filetype.add({
	extension = {
		svx = "markdown",
		svelte = "svelte",
	},
})

vim.treesitter.language.register('typescript', 'svelte')
vim.treesitter.language.register('javascript', 'svelte')

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
	pattern = "svelte",
	callback = function()
		vim.treesitter.start()
	end,
})

vim.diagnostic.config({
	virtual_text = false,
	underline = false,
	signs = false,
	update_in_insert = false,
})

vim.lsp.enable('svelte')
vim.lsp.enable('ts_ls')
