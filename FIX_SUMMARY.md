# Fix for Issue #18: Colorscheme Picker Not Reverting on Escape

## Problem

When using `:Picker colorscheme`, previewing a colorscheme without selecting it, and then pressing `<Esc>` to cancel, the colorscheme would not revert back to the original colorscheme.

## Root Cause

The colorscheme previewer (`lua/picker/previewer/colorscheme.lua`) would change the colorscheme during preview, but there was no mechanism to restore the original colorscheme when the picker was cancelled.

## Solution

The fix implements a cleanup mechanism that restores the original colorscheme when the picker is cancelled:

### 1. Save Original Colorscheme (`lua/picker/previewer/colorscheme.lua`)

```lua
local original_colorscheme = vim.g.colors_name or 'default'

--- Restore the original colorscheme
function M.restore()
  vim.fn.timer_stop(preview_timer_id)
  if original_colorscheme then
    vim.cmd.colorscheme(original_colorscheme)
  end
end
```

### 2. Add Cleanup Function (`lua/picker/sources/colorscheme.lua`)

```lua
--- Cleanup function to restore original colorscheme
function M.cleanup()
  previewer.restore()
end
```

### 3. Call Cleanup on Cancel (`lua/picker/windows.lua`)

```lua
vim.keymap.set('i', config.mappings.close, function()
  -- ... close windows ...
  -- cleanup: restore preview state if needed
  if source.cleanup then
    source.cleanup()
  end
end, { buffer = layout.prompt_buf })
```

## Implementation Details

- The original colorscheme is saved when the previewer module is first loaded
- The `restore()` function stops any pending preview timer and applies the original colorscheme
- The `cleanup()` function is only called when the picker is cancelled with `<Esc>`, not when an item is selected
- This design ensures that:
  - Cancelled operations restore the original state
  - Selected colorschemes persist as expected

## Files Modified

1. `lua/picker/previewer/colorscheme.lua` - Added restore functionality
2. `lua/picker/sources/colorscheme.lua` - Added cleanup function
3. `lua/picker/windows.lua` - Added cleanup call on cancel

## Testing

A test script (`test_colorscheme_fix.lua`) has been provided to verify the fix works correctly.
