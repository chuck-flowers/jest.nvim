local JestOutput = require 'jest.models'

---@class JestDisplay
---@field config JestNvimConfig
---@field output_bufnr number?
local JestDisplay = {};
JestDisplay.__index = JestDisplay

---Creates a new JestOutput
---@param config JestNvimConfig The plugin configuration
---@return JestDisplay
function JestDisplay:new(config)
	return setmetatable({
		config = config,
		output_bufnr = nil
	}, self)
end

---Shows jest output within the editor
---@param jest_output JestOutput
---@return nil
function JestDisplay:display_output(jest_output)
	if self.config.debug then
		print('JestDisplay:display_output(' .. vim.inspect(jest_output) .. ')')
	end

	-- Ensure that the incoming param is the correct type
	local param_metatable = getmetatable(jest_output)
	if param_metatable ~= JestOutput then
		print('Passing object which is not JestOutput to display_output')
	end

	-- Create the buffer if necessary
	if self.output_bufnr == nil then
		self.output_bufnr = vim.api.nvim_create_buf(false, true)
		vim.cmd('vert sb' .. self.output_bufnr)
		vim.wo.number = false
		vim.wo.relativenumber = false
	end

	-- Update the content of the buffer
	local lines = vim.split(tostring(jest_output), '\n')
	vim.api.nvim_buf_set_lines(self.output_bufnr, 0, -1, false, lines)
end

return JestDisplay
