vim.cmd [[
augroup MyNeoformat
  autocmd!
  autocmd BufWritePre *.lua undojoin | Neoformat
  autocmd BufWritePre *.nix undojoin | Neoformat
augroup END
]]
