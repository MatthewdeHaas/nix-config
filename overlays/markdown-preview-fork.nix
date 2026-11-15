final: prev: {
  vimPlugins = prev.vimPlugins // {
    markdown-preview-nvim = prev.vimPlugins.markdown-preview-nvim.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "MatthewdeHaas";
        repo = "markdown-preview.nvim";
        rev = "9421d36742dfbcf6286f3ccae223022f30eb7bb4";
				hash = "sha256-7Dtkfr7ET9gKk512nra/CLweh+5nFtMlpmjThbDxS0A=";
      };
    });
  };
}
