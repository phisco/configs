return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = { "go", "c", "lua", "vim", "vimdoc", "query", "json", "yaml", "bash", "markdown", "markdown_inline" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
          enable = true,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      })
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    name = 'treesitter-context',
    lazy = false,
    config = function()
      require('treesitter-context').setup({
        enable = true,
        max_lines = 1,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 3,
        trim_scope = 'outer',
        mode = 'cursor',
        separator = '-',
        zindex = 20,
        -- Workaround: nvim 0.12 + treesitter-context crash on buffers with
        -- injected languages (`:range()` nil). Disable for those filetypes
        -- until upstream fixes it.
        on_attach = function(buf)
          local dominated_by_injections = { markdown = true, html = true }
          return not dominated_by_injections[vim.bo[buf].filetype]
        end,
      })
    end
  }
}
