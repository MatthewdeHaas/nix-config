final: prev: {
  vimPlugins = prev.vimPlugins // {
    markdown-preview-nvim = prev.vimPlugins.markdown-preview-nvim.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "MatthewdeHaas";
        repo = "markdown-preview.nvim";
        rev = "9326a486bf56e7d247ecf4971ae3bbb74297a0ae";
        hash = "sha256-ExdsKBM+XSz86yNhyfIx0hrEMeBn4PPM8UoTcBYP2Kc=";
      };
    });
  };
}
