final: prev: {
  vimPlugins = prev.vimPlugins // {
    markdown-preview-nvim = prev.vimPlugins.markdown-preview-nvim.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "MatthewdeHaas";
        repo = "markdown-preview.nvim";
        rev = "6c5bea03e32874154e58ea5f24a07b6967b101ca";
				hash = "sha256-7Dtkfr7ET9gKk512nra/CLweh+5nFtMlpmjThbDxS0A=";
      };
    });
  };
}
