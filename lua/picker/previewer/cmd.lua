local M = {}

local preview_timer_id = -1

local timerout = 500

local preview_bufnr
local preview_cmd
local context = {}

local function preview_timer(_)
  if not preview_cmd then
    return
  end
  if preview_bufnr and vim.api.nvim_buf_is_valid(preview_bufnr) then
    local ok, job = pcall(require, 'job')
    if ok then
      context = {}
      job.start(preview_cmd, {
        on_stdout = function(id, data)
          for _, v in ipairs(data) do
            table.insert(context, v)
          end
        end,
        on_exit = function(id, data, single)
          if data == 0 and single == 0 then
            vim.api.nvim_set_option_value(
              'modifiable',
              true,
              { buf = preview_bufnr }
            )
            vim.api.nvim_buf_set_lines(preview_bufnr, 0, -1, false, context)
          end
        end,
      })
    else
      vim.api.nvim_set_option_value(
        'modifiable',
        true,
        { buf = preview_bufnr }
      )
      vim.api.nvim_buf_set_lines(
        preview_bufnr,
        0,
        -1,
        false,
        vim.fn.systemlist(preview_cmd)
      )
    end
  end
end

---@param cmd string|table<string>
---@param buf integer
function M.preview(cmd, _, buf)
  vim.fn.timer_stop(preview_timer_id)
  preview_bufnr = buf
  preview_cmd = cmd
  preview_timer_id = vim.fn.timer_start(timerout, preview_timer)
end

return M
