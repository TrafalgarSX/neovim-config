return vim.tbl_deep_extend("force", 
  require('config.snacks.bigfile'),
  require('config.snacks.dashboard')
)
