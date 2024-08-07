return {
  'nvim-lualine/lualine.nvim',
  event = "VeryLazy",
  enabled = true,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      theme = 'auto',
      disabled_filetype = {
        'neo-tree',
        'NvimTree',
        'startify',
        'dashboard'
      },
      sections = {
        lualine_c = {
          {
            'filename',
            path = 1,
          }
        },
      }
    })
  end,
}
