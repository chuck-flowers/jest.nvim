local shell = require 'jest.shell'

return function()
	local output = require 'jest.output'

	shell.run_jest(function(o)
		output.display_output(o)
	end)
end
