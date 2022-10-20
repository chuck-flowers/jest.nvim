local shell = require 'jest.shell'

return function()
	local output = require 'jest.output'

	shell:run_jest(function (outputs)
		output:display_output(outputs[1])
	end)
end
