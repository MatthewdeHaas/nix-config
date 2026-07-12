vim.g.vimtex_view_method = "skim"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_build_dir = ".build"
vim.g.vimtex_compiler_latexmk = {
	executable = "latexmk",
	out_dir = ".build",
	options = {
		"-pdfxe",
		"-shell-escape",
		"-synctex=1",
		"-interaction=nonstopmode",
		"-file-line-error",
	},
}
