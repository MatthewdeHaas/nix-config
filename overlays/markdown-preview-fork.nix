final: prev: {
  vimPlugins = prev.vimPlugins // {
    markdown-preview-nvim = prev.vimPlugins.markdown-preview-nvim.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "MatthewdeHaas";
        repo = "markdown-preview.nvim";
        rev = "e55120e5ba5e0b7544857684a65fc831b7960cce";
        hash = "sha256-ExdsKBM+XSz86yNhyfIx0hrEMeBn4PPM8UoTcBYP2Kc=";
      };
    });
  };
}
