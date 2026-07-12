local function save()
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_call(buf, function()
		vim.cmd("silent! write")
	end)
end

vim.api.nvim_create_augroup("AutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	callback = function() save() end,
	pattern = "*",
	group = "AutoSave",
})

if vim.env.TERM:match("kitty") or vim.env.TERM:match("tmux") then
	vim.cmd([[let &t_EI = "\e[2 q"]])
	vim.cmd([[let &t_SI = "\e[6 q"]])
	vim.cmd([[let &t_SR = "\e[4 q"]])
end
