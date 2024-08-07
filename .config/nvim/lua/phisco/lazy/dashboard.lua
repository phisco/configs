return {
  'nvimdev/dashboard-nvim',
  lazy = false,
  config = function()
    require('dashboard').setup {
      shortcut_type = 'number',
      config = {
        week_header = {
          enable = true,
        }
      }
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
