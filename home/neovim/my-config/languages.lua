vim.cmd [[
augroup neoformat
  autocmd!
  autocmd BufWritePre *.lua undojoin | Neoformat
augroup END
]]
