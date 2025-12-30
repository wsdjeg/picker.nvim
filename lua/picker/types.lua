--- @class PickerItem
--- @field str string
--- @field value? any

--- @class PickerSource
--- @field get function
--- @field default_action function
--- @field preview_win boolean
--- @field preview function
--- @field set function
--- @field actions? table action tables <key binding> - <function>
--- @field enabled? function returning false means source can not be used.
--- @field state? table filter state
--- @field filter_items table

---@class PickerCtagsOutput
---@field name
---@field line
---@field _type
---@field path
---@field pattern
---@field language
---@field line
---@field kind

---@class PickerLayout
---@field prompt_buf integer
---@field prompt_win integer
---@field list_buf integer
---@field list_win integer
---@field preview_buf integer
---@field preview_win integer

---@class PickerConfig
