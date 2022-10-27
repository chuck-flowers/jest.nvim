local models = require 'jest.models'

local M = {}

---Executes a shell command asynchronously
---@param cmd string
---@param callback fun(output: JestOutput)
---@return integer The job id of the running shell command
local function exec_jest_cmd(cmd, callback)
	local curr_line = ''
	local function output_line()
		if curr_line ~= '' then
			local jest_output = models.JestOutput:new(curr_line)
			callback(jest_output)
			curr_line = ''
		end
	end

	return vim.fn.jobstart(cmd, {
		on_stdout = function(_, data)
			for _, line in ipairs(data) do
				curr_line = curr_line .. line
				output_line()
			end
		end,
		stdout_buffered = false
	})
end

---Runs jest once
---@param callback fun(JestOutput) The function which should be provided with JestOutput
---@return integer The job id of the jest command
function M.run_jest(callback)
	return exec_jest_cmd('npx jest --json', callback)
end

---Runs jest in watch mode
---@param callback fun(JestOutput) The function which should be provided with JestOutput
---@return integer The job id of the jest command
function M.run_jest_watch(callback)
	return exec_jest_cmd('npx jest --watch --json', callback)
end

return M
