local JestDisplay = require 'jest.output'
local JestShell = require 'jest.shell'

---The implementation of the :JestWatch command
---@param config JestNvimConfig
---@return fun(): nil
return function (config)
	return function ()
		local output = JestDisplay:new(config)
		local shell = JestShell:new(config)

		---@type JestOutput?
		local jest_output = nil

		---@param o JestOutput
		local function update_output(o)
			if jest_output == nil then
				jest_output = o
			else
				print('jest_output = ', vim.inspect(jest_output))
				jest_output:merge(o)
			end

			output:display_output(jest_output)
		end

		shell:run_jest_watch(update_output)
	end
end
