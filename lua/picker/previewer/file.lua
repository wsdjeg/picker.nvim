---@class Picker.FilePreviewer
local M = {}

local preview_timer_id = -1

local timerout = 500

local preview_winid ---@type integer
local preview_bufid ---@type integer
local preview_linenr ---@type integer
local preview_file ---@type string
local preview_pattern ---@type string|nil
local preview_syntax ---@type string|nil
local preview_cmd ---@type string[]|string

local function preview_timer()
  -- if preview win does exists, return
  if not vim.api.nvim_win_is_valid(preview_winid) then
    return
  end
  local fd = vim.uv.fs_open(preview_file, 'r', tonumber('644', 8))
  local stat = vim.uv.fs_stat(preview_file)
  if not (stat and fd) then
    return
  end

  local context = vim.split(
    vim.uv.fs_read(fd, stat.size, 0),
    '[\r]?\n',
    { trimempty = true }
  )
  vim.uv.fs_close(fd)

  if #context == 0 then
    return
  end
  vim.api.nvim_set_option_value('syntax', '', { buf = preview_bufid })
  vim.api.nvim_buf_set_lines(preview_bufid, 0, -1, false, context)
  local ft = preview_syntax or vim.filetype.match({ filename = preview_file })
  if ft then
    vim.api.nvim_set_option_value('syntax', ft, { buf = preview_bufid })
  else
    local ftdetect_autocmd = vim.api.nvim_get_autocmds({
      group = 'filetypedetect',
      event = 'BufRead',
      pattern = string.format('*.%s', vim.fn.fnamemodify(preview_file, ':e')),
    })
    -- logger.info(vim.inspect(ftdetect_autocmd))
    if
      ftdetect_autocmd[1]
      and ftdetect_autocmd[1].command
      and vim.startswith(ftdetect_autocmd[1].command, 'set filetype=')
    then
      ft = string.gsub(ftdetect_autocmd[1].command, 'set filetype=', '')
      vim.api.nvim_set_option_value('syntax', ft, { buf = preview_bufid })
    end
  end
  if preview_linenr and preview_linenr < #context then
    vim.api.nvim_win_set_cursor(preview_winid, { preview_linenr, 0 })
    vim.api.nvim_win_call(preview_winid, function()
      vim.cmd('noautocmd normal! zz')
    end)
    vim.api.nvim_set_option_value('cursorline', true, { win = preview_winid })
  elseif preview_cmd then
    vim.api.nvim_win_call(preview_winid, function()
      if vim.startswith(preview_cmd, '/') then
        local reg_search = vim.fn.getreg('/')
        pcall(vim.fn.execute, preview_cmd)
        vim.fn.histdel('search', -1) -- remove last search history if preview_cmd starts with /
        vim.fn.setreg('/', reg_search)
      else
        pcall(vim.fn.execute, preview_cmd)
      end
      vim.cmd.normal({ 'zzze', bang = true })
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
---@param win integer
---@param buf integer
---@param opts? integer|{ lnum?: integer, pattern: string, cmd: string, syntax: string }
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
  elseif type(opts) == 'table' then
    preview_linenr = opts.lnum
    preview_pattern = opts.pattern
    preview_syntax = opts.syntax
    preview_cmd = opts.cmd
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  vim.api.nvim_set_option_value('cursorline', false, { win = preview_winid })
  if preview_file and vim.fn.filereadable(preview_file) == 1 then
    preview_timer_id =
      vim.fn.timer_start(timerout, preview_timer, { ['repeat'] = 1 })
  end
end

return M
