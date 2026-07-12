{ pkgs, ... }:

let
  # Create a combined treesitter package
  myTreesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.svelte
    p.javascript
    p.typescript
    p.css
    p.html
    p.lua
  ]);
in
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
			nodejs_22
			gcc
			svelte-language-server
			tailwindcss-language-server
			typescript-language-server
		];

		plugins = with pkgs.vimPlugins; [
			# --- Grammar & Highlighting ---
			myTreesitter  # Use the one we defined in the 'let' block
			
			# --- UI & Aesthetics ---
			catppuccin-nvim
			bufferline-nvim
			nvim-web-devicons
			
			# --- Navigation & Search ---
			telescope-nvim
			plenary-nvim
			
			# --- Mathematics & Docs ---
			vimtex
			markdown-preview-nvim
			
			# --- Completion (Quiet Intelligence) ---
			nvim-cmp
			cmp-nvim-lsp
			cmp_luasnip
			luasnip
		];

		# Extra Neovim config
		initLua = ''
			vim.opt.runtimepath:prepend("${myTreesitter}")

			local status, treesitter = pcall(require, "nvim-treesitter.configs")
			if status then
				treesitter.setup({
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					}
				})
			end
		'' + builtins.concatStringsSep "\n" [
			(builtins.readFile ./nvim/settings.lua)
			(builtins.readFile ./nvim/ui.lua)
			(builtins.readFile ./nvim/keymaps.lua)
			(builtins.readFile ./nvim/completion.lua)
			(builtins.readFile ./nvim/latex.lua)
			(builtins.readFile ./nvim/lsp.lua)
			(builtins.readFile ./nvim/autocmds.lua)
		];
  };

}
