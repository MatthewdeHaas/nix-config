{ pkgs, ... }:

{

	programs.neovim = {

		enable = true;
		defaultEditor = true;	
		viAlias = true;
		vimAlias = true;
		withRuby = false;
		withPython3 = false;
		# Install Neovim dependencies
		extraPackages = with pkgs; [
			ripgrep
			fd
			nodejs_25
			gcc
			svelte-language-server
			svelte-language-server
			tailwindcss-language-server
			typescript-language-server
		];

		plugins = with pkgs.vimPlugins; [
			nvim-treesitter.withAllGrammars
			telescope-nvim
			plenary-nvim
			catppuccin-nvim
			bufferline-nvim
			nvim-web-devicons
			markdown-preview-nvim
			vimtex
			luasnip
			nvim-cmp
			cmp-nvim-lsp
			cmp_luasnip
			nvim-lspconfig
		];

		# Extra Neovim config
		initLua = ''

			-- Treesitter
			local status, treesitter = pcall(require, "nvim-treesitter.configs")
			if status then
				treesitter.setup({
					highlight = { 
					enable = true,
					additional_vim_regex_highlighting = false,
					}
				})
			else
				print("Treesitter not found yet, will load via packadd")
			end

			-- Catppuccin
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


			-- Tabs + Bufferline
			require('bufferline').setup({})


			-- Leader keys
			vim.g.mapleader = " "
			vim.g.maplocalleader = " "

			-- Keymaps: Fuzzy Finder
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files)
			vim.keymap.set("n", "<leader>fg", builtin.live_grep)

			-- Keymaps: Tabs/Buffers
			vim.keymap.set("n", "<Tab>", ":bnext<CR>")
			vim.keymap.set("n", "<S-Tab>", ":bprev<CR>")
			vim.keymap.set("n", "<leader>bd", ":bdelete<CR>")

			-- Keymaps: MarkdownPreview
			vim.keymap.set("n", "<leader>mp", function()
			vim.g.mkdp_theme = "light"
			vim.cmd("MarkdownPreviewToggle")
			end, { desc = "Markdown Preview (light)" })

			vim.keymap.set("n", "<leader>mpd", function()
			vim.g.mkdp_theme = "dark"
			vim.cmd("MarkdownPreviewToggle")
			end, { desc = "Markdown Preview (dark)" })

			-- VimTeX Config
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

			-- Wire Luasnips
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping(function(fallback)
						if luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = { { name = "luasnip" } },
			})

			-- Snippets
			local ls = require("luasnip")
			local s = ls.snippet
			local f = ls.function_node
			local i = ls.insert_node
			local fmta = require("luasnip.extras.fmt").fmta

			ls.setup({
				enable_autosnippets = true,
			})

			ls.add_snippets("tex", {
				-- `mk` for math mode ($$)
				s({trig = "mk", wordTrig = true, snippetType = "autosnippet"},
				  fmta("$<>$", { i(1) })
				),

				-- `dm` for multiline math mode (\[\])
				s({trig = "dm", snippetType = "autosnippet"},
				  fmta("\\[\n\t<>\n\\]", { i(1) })
				),

				-- `ali` for aligned equations
				s({trig = "ali", snippetType = "autosnippet"},
				  fmta("\\begin{align*}\n\t<>\n\\end{align*}", { i(1) })
				),
				
				-- `\\` for creating fractions  
				s({trig = "([%w_^]+)/", trigEngine = "pattern", snippetType = "autosnippet"},
					fmta("\\frac{<>}{<>}", {
						f(function(_, snip) return snip.captures[1] end),
						i(1),
					})
				),


			})

			-- Settings
			vim.opt.number = true
			vim.opt.spell = true
			vim.opt.spelllang = { "en_us" } 
			vim.opt.clipboard = "unnamedplus"
			vim.opt.mouse = "a"
			vim.opt.tabstop = 2
			vim.opt.softtabstop = 2 
			vim.opt.shiftwidth = 2
			vim.opt.expandtab = false
			vim.opt.smarttab = true
			vim.o.inccommand = ""

			-- Search UI tweaks
			vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })

			-- AutoSave hook
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

			-- Terminal cursor shapes
			if vim.env.TERM:match("kitty") or vim.env.TERM:match("tmux") then
			vim.cmd([[let &t_EI = "\e[2 q"]])  -- Normal: block
			vim.cmd([[let &t_SI = "\e[6 q"]])  -- Insert: steady beam
			vim.cmd([[let &t_SR = "\e[4 q"]])  -- Replace: underline
			end

			-- Filetype additions
			vim.filetype.add({
				extension = {
					svx = "markdown",
				},
			})
			vim.filetype.add({
        extension = {
          svelte = "svelte",
        },
      })

			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = "svelte",
				callback = function()
					vim.treesitter.start()
				end,
			})

			vim.diagnostic.config({
				virtual_text = false, -- No text at the end of the line
				underline = false,    -- No red/yellow wavy lines
				signs = false,        -- No icons in the left gutter (signcolumn)
				update_in_insert = false,
			})

			vim.lsp.enable('svelte')	
			vim.lsp.enable('ts_ls')

    '';
  };

}
