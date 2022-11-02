---@class JestNvimConfig
---@field debug boolean
local JestNvimConfig = {
	debug = false
}

JestNvimConfig.__index = JestNvimConfig

function JestNvimConfig:new()
	---@type JestNvimConfig
	local instance = {}
	setmetatable(instance, self)

	return instance
end

---comment
---@param other { [string]: any }
function JestNvimConfig:merge(other)
	require('jest.utils').merge_tables(self, other)
end

return JestNvimConfig
