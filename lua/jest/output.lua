local models = require 'jest.models'

local M = {}

--- @param jest_output table
function M:display_output(jest_output)

	-- Ensure that the incoming param is the correct type
	local param_metatable = getmetatable(jest_output)
	if param_metatable ~= models.JestOutput then
		print('Passing object which is not JestOutput to display_output')
	end

	-- Create the buffer if necessary
	if self.output_bufnr == nil then
		self.output_bufnr = vim.api.nvim_create_buf(false, true)
		vim.cmd('vert sb' .. self.output_bufnr)
	end

	-- Update the content of the buffer
	vim.api.nvim_buf_set_lines(self.output_bufnr, 0, -1, false, vim.split(tostring(jest_output), '\n'))
end

return M
