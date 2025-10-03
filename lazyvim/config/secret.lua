local SecretFiles = {}

function SecretFiles.setup()
  local group = vim.api.nvim_create_augroup("no_eof_newline_for_secret", { clear = true })

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufWritePre" }, {
    pattern = "*.secret",
    group = group,
    callback = function()
      vim.opt_local.binary = true
      vim.opt_local.eol = false
    end,
  })
end

return SecretFiles
