vim.api.nvim_create_user_command('Picker', function(opt)
  local input
  for _, argv in ipairs(opt.fargs) do
    if vim.startswith(argv, '--input=') then
      input = string.sub(argv, 9)
      if input == '<cword>' then
        input = vim.fn.expand(input)
      end
    end
  end
  require('picker').open(opt.fargs, {
    buf = vim.api.nvim_get_current_buf(),
    input = input,
  })
end, {
  nargs = '*',
  complete = function(ArgLead, CmdLine, CursorPos)
    if vim.startswith(ArgLead, '-') then
      return { '--input=' }
    end
    local sources =
      vim.api.nvim_get_runtime_file('lua/picker/sources/*.lua', true)
    local rst = vim.tbl_map(function(t)
      return vim.fn.fnamemodify(t, ':t:r')
    end, sources)
    return vim.tbl_filter(function(t)
      return vim.startswith(t, ArgLead)
    end, rst)
  end,
})
