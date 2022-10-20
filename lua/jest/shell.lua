local models = require 'jest.models'

local M = {}

--- @param callback function
function M:run_jest(callback)
	vim.fn.jobstart('npx jest --json', {
		on_stdout = function(_, data)
			local outputs = {}
			for _, line in ipairs(data) do
				local jest_output = models.JestOutput:new(line)
				table.insert(outputs, jest_output)
			end

			callback(outputs)
		end,
		stdout_buffered = true
	})
end

return M
