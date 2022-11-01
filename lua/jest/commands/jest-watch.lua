local output = require 'jest.output'
local shell = require 'jest.shell'

--- The implementation of the :JestWatch command
return function ()
	---@type JestOutput?
	local jest_output = nil

	---@param o JestOutput
	local function update_output(o)
		if jest_output == nil then
			jest_output = o
		else
			jest_output:merge(o)
		end

		output.display_output(jest_output)
	end

	shell.run_jest_watch(update_output)
end
