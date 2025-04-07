return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        pyright = {
          settings = {
            python = {
              pythonPath = "/Users/sulemlo/Library/Caches/pypoetry/virtualenvs/mazlo-0I5QZlEV-py3.13/bin/python",
            },
          },
        },
        ruff = {},
        dartls = {
          settings = {
            dart = {
              lineLength = 100,
            },
          },
        },
        tsserver = {},
      },
    },
  },
}
