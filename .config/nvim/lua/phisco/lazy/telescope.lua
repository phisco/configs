return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'Myzel394/jsonfly.nvim',
    'ThePrimeagen/harpoon',
  },
  config = function()
    require("telescope").setup({
      defaults = {
        -- exit on q
        mappings = {
          i = {
            ["<esc>"] = require("telescope.actions").close,
            ['<c-d>'] = require('telescope.actions').delete_buffer
          },
          n = {
            ['<c-d>'] = require('telescope.actions').delete_buffer
          }
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--follow",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
        },
      },
    })
    local builtin = require("telescope.builtin")
    vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files({
        hidden = true,
        follow = true,
        no_ignore = true,
      })
    end)
    vim.keymap.set('n', '<leader>b', builtin.buffers)
    vim.keymap.set('n', '<leader>fg', builtin.live_grep)
    vim.keymap.set('n', '<leader>fh', builtin.help_tags)
    vim.keymap.set('n', '<leader>fr', builtin.registers)
    vim.keymap.set('n', '<leader>fc', builtin.commands)
    vim.keymap.set('n', '<leader>fl', builtin.lsp_references)
    vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find)
    require("telescope").load_extension("jsonfly")
    vim.keymap.set('n', '<leader>fj', function()
      vim.cmd('Telescope jsonfly')
    end)

    require("telescope").load_extension('harpoon')
    vim.keymap.set('n', '<leader>fa', function()
      require('harpoon.ui').toggle_quick_menu()
    end)

  end
}
