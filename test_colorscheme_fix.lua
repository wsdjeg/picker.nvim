#!/usr/bin/env nvim -l
-- Test script for colorscheme restore fix

-- Save original colorscheme
local original_colorscheme = vim.g.colors_name or 'default'
print('Original colorscheme: ' .. original_colorscheme)

-- Simulate opening colorscheme picker
local colorscheme_source = require('picker.sources.colorscheme')
local colorscheme_previewer = require('picker.previewer.colorscheme')

-- Test 1: Verify that original colorscheme is saved
print('\nTest 1: Verify original colorscheme is saved')
local saved_colorscheme = colorscheme_previewer._original_colorscheme
if saved_colorscheme == original_colorscheme then
  print('✓ Original colorscheme correctly saved: ' .. saved_colorscheme)
else
  print('✗ Failed to save original colorscheme')
  print('  Expected: ' .. original_colorscheme)
  print('  Got: ' .. tostring(saved_colorscheme))
end

-- Test 2: Simulate preview and restore
print('\nTest 2: Simulate preview and restore')
-- Get available colorschemes
local colorschemes = vim.fn.getcompletion('colorscheme ', 'cmdline')
if #colorschemes > 1 then
  local test_colorscheme = colorschemes[1]
  if test_colorscheme ~= original_colorscheme then
    -- Preview a different colorscheme
    colorscheme_previewer.preview(test_colorscheme, nil, nil)
    
    -- Wait for timer
    vim.wait(600, function()
      return vim.g.colors_name == test_colorscheme
    end, 100, false)
    
    print('Preview colorscheme: ' .. test_colorscheme)
    print('Current colorscheme: ' .. (vim.g.colors_name or 'default'))
    
    -- Restore
    colorscheme_previewer.restore()
    print('Restored colorscheme: ' .. (vim.g.colors_name or 'default'))
    
    if vim.g.colors_name == original_colorscheme then
      print('✓ Colorscheme successfully restored')
    else
      print('✗ Failed to restore colorscheme')
      print('  Expected: ' .. original_colorscheme)
      print('  Got: ' .. tostring(vim.g.colors_name))
    end
  else
    print('⊘ Skipped: No different colorscheme available for testing')
  end
else
  print('⊘ Skipped: Not enough colorschemes available')
end

-- Test 3: Test cleanup function
print('\nTest 3: Test cleanup function')
if colorscheme_source.cleanup then
  -- Change colorscheme
  if #colorschemes > 1 then
    local test_colorscheme = colorschemes[2]
    vim.cmd.colorscheme(test_colorscheme)
    print('Changed to: ' .. test_colorscheme)
    
    -- Call cleanup
    colorscheme_source.cleanup()
    print('After cleanup: ' .. (vim.g.colors_name or 'default'))
    
    if vim.g.colors_name == original_colorscheme then
      print('✓ Cleanup function successfully restored colorscheme')
    else
      print('✗ Cleanup function failed to restore colorscheme')
      print('  Expected: ' .. original_colorscheme)
      print('  Got: ' .. tostring(vim.g.colors_name))
    end
  end
else
  print('✗ Cleanup function not found')
end

-- Restore original colorscheme
vim.cmd.colorscheme(original_colorscheme)
print('\nFinal colorscheme: ' .. (vim.g.colors_name or 'default'))
print('\nAll tests completed!')
