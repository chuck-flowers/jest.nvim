local shell = require 'jest.shell'

return function()
	local output = require 'jest.output'

	shell.run_jest(output.display_output)
end
