--- @class PickerItem
--- @field str string
--- @field value? any
--- @field bufnr? integer
--- @field highlight? { [1]: integer, [2]: integer, [3]: string }[]

--- @class PickerSource
--- @field get function
--- @field default_action function
--- @field preview_win boolean
--- @field preview function
--- @field set function
--- @field actions? table|function action tables <key binding> - <function>
--- @field enabled? function returning false means source can not be used.
--- @field state? table filter state
--- @field filter_items table
--- @field redraw_actions? function

---@class PickerFeatureMap
---@field document_symbols 'textDocument/documentSymbol'
---@field references 'textDocument/references'
---@field definitions 'textDocument/definition'
---@field type_definitions 'textDocument/typeDefinition'
---@field implementations 'textDocument/implementation'
---@field workspace_symbols 'workspace/symbol'
---@field incoming_calls 'callHierarchy/incomingCalls'
---@field outgoing_calls 'callHierarchy/outgoingCalls'
---@field declarations 'textDocument/declaration'

---@class PickerCtagsOutput
---@field name string
---@field _type any
---@field path string
---@field pattern string
---@field language string
---@field line integer
---@field kind string

---@class PickerLayout
---@field prompt_buf integer
---@field prompt_win integer
---@field list_buf integer
---@field list_win integer
---@field preview_buf integer
---@field preview_win integer

---@class PickerSourceConfig
---@field name string
---@field desc string
---@field func function
---@field preview_win? integer

--- A matcher module implementing the fuzzy matching interface.
--- Built-in matchers: fzy, matchfuzzy, levenshtein.
--- Custom matchers must implement at least `positions()` and
--- `get_implementation_name()`.
---@class PickerMatcher
---@field has_match fun(needle: string, haystack: string, case_sensitive?: boolean): boolean Check if needle is a subsequence of haystack
---@field positions fun(needle: string, haystack: string, case_sensitive?: boolean): table<integer, integer>, number Return matched positions and score
---@field score? fun(needle: string, haystack: string, case_sensitive?: boolean): number Return only the score
---@field filter? fun(needle: string, haystacks: string[], case_sensitive?: boolean): { [1]: integer, [2]: table<integer, integer>, [3]: number, [4]: string }[] Filter and score multiple candidates
---@field get_implementation_name? fun(): string Return the active implementation name (e.g. 'ffi', 'lua', 'vim')
---@field get_score_min? fun(): number Return the minimum possible score
---@field get_score_max? fun(): number Return the maximum possible score
---@field get_max_length? fun(): integer Return the maximum supported string length
---@field get_score_floor? fun(): number Return the practical score floor
---@field get_score_ceiling? fun(): number Return the practical score ceiling

---@class PickerConfigFilter
---@field ignorecase? boolean
---@field matcher? string|PickerMatcher Matcher name (e.g. 'fzy', 'matchfuzzy', 'levenshtein') or a custom matcher module

-- NOTE: (DrKJeff16) What other values does `window.layout` take?

---@class PickerConfigWindow
---@field layout? 'default'|string
---@field width? number
---@field height? number
---@field col? number
---@field row? number
---@field current_icon? string
---@field current_icon_hl? string
---@field enable_preview? boolean
---@field preview_timeout? integer
---@field show_score? boolean

---@class PickerConfigHighlight
---@field matched? string
---@field score? string

---@class PickerConfigPrompt
---@field position? 'bottom'|'top'
---@field icon? string
---@field icon_hl? string
---@field insert_timeout? integer
---@field title? boolean

---@class PickerConfigMappings
---@field close? string
---@field next_item? string
---@field previous_item? string
---@field open_item? string
---@field toggle_preview? string

---@class PickerConfig
---@field filter? PickerConfigFilter
---@field window? PickerConfigWindow
---@field highlight? PickerConfigHighlight
---@field prompt? PickerConfigPrompt
---@field mappings? PickerConfigMappings

