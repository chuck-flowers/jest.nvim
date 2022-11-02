local JestDisplay = require 'jest.output'
local JestShell = require 'jest.shell'

---Creates the Jest command handler
---@param config JestNvimConfig The configuration to use
---@return fun(): nil
return function(config)
	return function()
		local output = JestDisplay:new(config)
		local shell = JestShell:new(config)

		shell:run_jest(function(o)
			output:display_output(o)
		end)
	end
end
