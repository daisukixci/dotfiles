-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.wrap = true -- visually wraps long lines
vim.opt.linebreak = true -- wraps at word boundaries
vim.opt.textwidth = 80 -- automatically wrap text at 80 characters
vim.opt.formatoptions:append("t") -- auto-wrap text using textwidth
vim.env.NODE_OPTIONS = "--max-old-space-size=32768" -- force 32G of ram for lSP
vim.g.markdown_syntax_conceal = 0 -- For legacy syntax-based conceal
vim.g.vim_markdown_conceal = 0 -- If using preservim/vim-markdown
vim.g.vim_markdown_conceal_code_blocks = 0
vim.opt.conceallevel = 0 -- Completely disables conceal in all buffers
