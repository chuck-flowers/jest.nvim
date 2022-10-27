local models = require 'jest.models'

local M = {}

--- Runs jest once
--- @param callback function
--- @return integer
function M.run_jest(callback)
	local curr_line = ''
	local function output_line()
		local jest_output = models.JestOutput:new(curr_line)
		callback(jest_output)
	end

	return vim.fn.jobstart('npx jest --json', {
		on_stdout = function(_, data)
			local outputs = {}
			for i, line in ipairs(data) do
				if i == 1 then
					local jest_output = models.JestOutput:new(curr_line .. line)
					curr_line = ''
					callback(jest_output)
				elseif i == #data then
					if line == '' then
						output_line()
					else
						curr_line = line
					end
				else
					curr_line = line
					output_line()
				end

				local jest_output = models.JestOutput:new(line)
				table.insert(outputs, jest_output)
			end
		end,
		stdout_buffered = false
	})
end

return M
