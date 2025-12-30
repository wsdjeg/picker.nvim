local M = {}

local preview_timer_id = -1

local timerout = 500

local preview_winid, preview_bufid, preview_file, preview_linenr, preview_pattern, preview_syntax

local function preview_timer(t)
  -- if preview win does exists, return
  if not vim.api.nvim_win_is_valid(preview_winid) then
    return
  end
  local fd = vim.uv.fs_open(preview_file, 'r', 438)
  local stat = vim.uv.fs_fstat(fd)
  local context = vim.split(
    vim.uv.fs_read(fd, stat.size, 0),
    '[\r]?\n',
    { trimempty = true }
  )
  vim.uv.fs_close(fd)

  if #context == 0 then
    return
  end
  vim.api.nvim_buf_set_option(preview_bufid, 'syntax', '')
  vim.api.nvim_buf_set_lines(preview_bufid, 0, -1, false, context)
  local ft = preview_syntax or vim.filetype.match({ filename = preview_file })
  if ft then
    vim.api.nvim_buf_set_option(preview_bufid, 'syntax', ft)
  else
    local ftdetect_autocmd = vim.api.nvim_get_autocmds({
      group = 'filetypedetect',
      event = 'BufRead',
      pattern = '*.' .. vim.fn.fnamemodify(preview_file, ':e'),
    })
    -- logger.info(vim.inspect(ftdetect_autocmd))
    if ftdetect_autocmd[1] then
      if
        ftdetect_autocmd[1].command
        and vim.startswith(ftdetect_autocmd[1].command, 'set filetype=')
      then
        ft = ftdetect_autocmd[1].command:gsub('set filetype=', '')
        vim.api.nvim_buf_set_option(preview_bufid, 'syntax', ft)
      end
    end
  end
  if preview_linenr and preview_linenr < #context then
    vim.api.nvim_win_set_cursor(preview_winid, { preview_linenr, 0 })
    vim.api.nvim_win_call(preview_winid, function()
      vim.cmd('noautocmd normal! zz')
    end)
    vim.api.nvim_set_option_value('cursorline', true, { win = preview_winid })
  elseif preview_pattern then
    vim.api.nvim_win_call(preview_winid, function()
      local line = vim.fn.search(preview_pattern)
      vim.api.nvim_win_set_cursor(preview_winid, { line, 0 })
    end)
  else
    vim.api.nvim_set_option_value(
      'cursorline',
      false,
      { win = preview_winid }
    )
  end
end

---@param path string the path of preview file.
---@param opts? integer | table
function M.preview(path, win, buf, opts)
  opts = opts or {}
  vim.fn.timer_stop(preview_timer_id)
  preview_winid = win
  preview_bufid = buf
  preview_file = path
  if type(opts) == 'number' then
    preview_pattern = nil
    preview_linenr = opts
    preview_syntax = nil
  else
    preview_linenr = opts.lnum
    preview_pattern = opts.pattern
    preview_syntax = opts.syntax
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  if preview_file and vim.fn.filereadable(preview_file) == 1 then
    preview_timer_id =
      vim.fn.timer_start(timerout, preview_timer, { ['repeat'] = 1 })
  end
end

return M
