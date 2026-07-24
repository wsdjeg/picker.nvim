---@class Picker.Filter
local M = {}

--- Cancellation token: each async filter call increments this.
--- Old coroutines check if their id still matches before resuming.
M._filter_id = 0

--- Chunk size: items processed per coroutine yield
local CHUNK_SIZE = 500

---@param input string
---@param source PickerSource
---@param ignorecase boolean
function M.filter(input, source, ignorecase)
  local config = require('picker.config').get()
  local ok, matcher =
    pcall(require, 'picker.matchers.' .. config.filter.matcher)
  if not ok then
    matcher = require('picker.matchers.fzy')
  end
  if input == '' then
    local i = 0
    source.filter_items = vim.tbl_map(function(t)
      i = i + 1
      return { i, {}, 0, t }
    end, source.state.items)
  else
    if
      source.state.previous_input
      and string.len(source.state.previous_input) > 0
      and source.filter_items
      and #source.filter_items > 0
      and matcher.has_match(source.state.previous_input, input, ignorecase)
    then
      local rst = {}
      for i, v in ipairs(source.filter_items) do
        if matcher.has_match(input, v[4].str, ignorecase) then
          local p, s = matcher.positions(input, v[4].str, ignorecase)
          table.insert(rst, { i, p, s, v[4] })
        end
      end
      if source.state.filter_count and source.state.filter_count < #source.state.items then
        for i = source.state.filter_count, #source.state.items do
          if
            matcher.has_match(input, source.state.items[i].str, ignorecase)
          then
            local p, s =
              matcher.positions(input, source.state.items[i].str, ignorecase)
            table.insert(rst, { i, p, s, source.state.items[i] })
          end
        end
      end
      source.filter_items = rst
    else
      local rst = {}
      for i = 1, #source.state.items do
        if
          matcher.has_match(input, source.state.items[i].str, ignorecase)
        then
          local p, s =
            matcher.positions(input, source.state.items[i].str, ignorecase)
          table.insert(rst, { i, p, s, source.state.items[i] })
        end
      end
      source.filter_items = rst
    end
    table.sort(source.filter_items, function(a, b)
      return a[3] > b[3]
    end)
  end
  source.state.previous_input = input
  source.state.filter_count = #source.state.items
end

--- Async filter using Lua coroutines.
--- Processes items in chunks, yielding between chunks to keep UI responsive.
--- Automatically cancels when a newer filter is started.
---@param input string
---@param source PickerSource
---@param ignorecase boolean
---@param on_done function Called when filtering is complete
function M.filter_async(input, source, ignorecase, on_done)
  local config = require('picker.config').get()
  local ok, matcher =
    pcall(require, 'picker.matchers.' .. config.filter.matcher)
  if not ok then
    matcher = require('picker.matchers.fzy')
  end

  -- Increment id to cancel any running coroutine
  M._filter_id = M._filter_id + 1
  local my_id = M._filter_id

  -- Empty input: all items, synchronous (fast enough)
  if input == '' then
    local i = 0
    source.filter_items = vim.tbl_map(function(t)
      i = i + 1
      return { i, {}, 0, t }
    end, source.state.items)
    source.state.previous_input = input
    source.state.filter_count = #source.state.items
    on_done()
    return
  end

  -- Determine search base (progressive filtering optimization)
  ---@type PickerItem[], integer[]?
  local base_items, base_indices
  if
    source.state.previous_input
    and string.len(source.state.previous_input) > 0
    and source.filter_items
    and #source.filter_items > 0
    and matcher.has_match(source.state.previous_input, input, ignorecase)
  then
    -- Filter from previous results + new items
    base_items = {}
    base_indices = {}
    for _, v in ipairs(source.filter_items) do
      table.insert(base_items, v[4])
      table.insert(base_indices, v[1])
    end
    if
      source.state.filter_count
      and source.state.filter_count < #source.state.items
    then
      for i = source.state.filter_count + 1, #source.state.items do
        table.insert(base_items, source.state.items[i])
        table.insert(base_indices, i)
      end
    end
  else
    -- Full scan
    base_items = source.state.items
    base_indices = nil
  end

  local total = #base_items
  local results = {}

  -- Create coroutine for chunked processing
  local co = coroutine.create(function()
    local i = 1
    while i <= total do
      local chunk_end = math.min(i + CHUNK_SIZE - 1, total)
      for k = i, chunk_end do
        local item = base_items[k]
        if matcher.has_match(input, item.str, ignorecase) then
          local p, s = matcher.positions(input, item.str, ignorecase)
          local orig_idx = base_indices and base_indices[k] or k
          table.insert(results, { orig_idx, p, s, item })
        end
      end
      i = chunk_end + 1
      if i <= total then
        coroutine.yield()
      end
    end

    -- Sort by score descending
    table.sort(results, function(a, b)
      return a[3] > b[3]
    end)

    return results
  end)

  -- Resume loop: called via vim.defer_fn to let UI breathe between chunks
  local function resume()
    -- Cancelled by a newer filter?
    if M._filter_id ~= my_id then
      return
    end

    local ok, result = coroutine.resume(co)
    if not ok then
      vim.schedule(function()
        vim.notify('Filter error: ' .. tostring(result), vim.log.levels.ERROR)
      end)
      return
    end

    if coroutine.status(co) ~= 'dead' then
      -- Still running, schedule next chunk on next event loop tick
      vim.defer_fn(resume, 0)
    else
      -- Done! Final cancellation check
      if M._filter_id ~= my_id then
        return
      end
      source.filter_items = result
      source.state.previous_input = input
      source.state.filter_count = #source.state.items
      on_done()
    end
  end

  resume()
end

return M

