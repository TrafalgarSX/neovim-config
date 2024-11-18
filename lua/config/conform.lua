local is_ok, conform = pcall(require, "conform")
if not is_ok then
  return
end

conform.setup({
  formatters_by_ft = {
    python = function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format" }
      else
        return { "isort", "black" }
      end
    end,
    -- Use the "_" filetype to run formatters on filetypes that don't
    -- have other formatters configured.
    ["_"] = { "trim_whitespace" },
    javascript = {
      exe = "prettier",
      args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
      stdin = true,
    },
    typescript = {
      exe = "prettier",
      args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
      stdin = true,
    },
    html = {
      exe = "prettier",
      args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
      stdin = true,
    },
    css = {
      exe = "prettier",
      args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
      stdin = true,
    },
    json = {
      exe = "prettier",
      args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
      stdin = true,
    },

    cpp = {
      exe = "clang-format",
      args = {},
      stdin = true,
    },
    c = {
      exe = "clang-format",
      args = {},
      stdin = true,
    },
  },
  -- Set this to change the default values when calling conform.format()
  -- This will also affect the default values for format_on_save/format_after_save
  default_format_opts = {
    lsp_format = "fallback",
  },
  --[[
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
    ]]
  -- Conform will notify you when a formatter errors
  notify_on_error = true,
  -- Conform will notify you when no formatters are available for the buffer
  notify_no_formatters = true,
})

vim.api.nvim_create_user_command('ConformFormat', function()
  conform.format()
end, {})
