local JestOutput = require 'jest.models'

---@class JestShell
---@field config JestNvimConfig The plugin configuration
local JestShell = {}
JestShell.__index = JestShell

---Creates a new jest shell object
---@param config JestNvimConfig The plugin configuration
---@return JestShell
function JestShell:new(config)
	---@type JestShell
	local instance = { config = config }
	setmetatable(instance, self)

	return instance
end

---Runs jest once
---@param callback fun(o: JestOutput) The function which should be provided with JestOutput
---@return integer The job id of the jest command
function JestShell:run_jest(callback)
	return self:exec_jest_cmd('npx jest --json', callback)
end

---Runs jest in watch mode
---@param callback fun(JestOutput) The function which should be provided with JestOutput
---@return integer The job id of the jest command
function JestShell:run_jest_watch(callback)
	return self:exec_jest_cmd('npx jest --watch --json', callback)
end

---Executes a shell command asynchronously
---@param cmd string
---@param callback fun(output: JestOutput)
---@return integer The job id of the running shell command
function JestShell:exec_jest_cmd(cmd, callback)
	if self.config.debug then
		print('JestShell:exec_jest_cmd(' .. cmd .. ', callback)')
	end

	local curr_line = ''
	local function output_line()
		if curr_line ~= '' then
			if self.config.debug then
				print('Parsing output line of jest: ' .. curr_line)
			end

			local jest_output = JestOutput:new(curr_line)
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

return JestShell
