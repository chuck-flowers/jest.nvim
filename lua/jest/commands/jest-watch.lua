local output = require 'jest.output'
local shell = require 'jest.shell'

--- The implementation of the :JestWatch command
return function ()
	shell.run_jest_watch(output.display_output)
end
