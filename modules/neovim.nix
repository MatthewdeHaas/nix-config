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
			nodejs_20
			gcc
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
		];

		# Extra Neovim config
		initLua = ''

			-- Treesitter
			require('nvim-treesitter.configs').setup({ 
				highlight = { enable = true } 
			})

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
      vim.g.vimtex_view_method = "skim" -- Keep as skim for Mac
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_latexmk = {
        out_dir = ".build",
        options = {
          "-xelatex",
          "-shell-escape",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-file-line-error",
        },
      }

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
    '';
  };
}
