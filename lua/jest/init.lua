local M = {}

local default_options = {}

function M:setup(options)
	local models = require('jest.models')

	options = options or default_options

	vim.api.nvim_create_user_command('Jest', function ()
		vim.fn.jobstart('npx jest --json', {
			on_stdout = function (_, data)
				for _, line in ipairs(data) do
					local jest_output = models.JestOutput:new(line)
					print(jest_output)
				end
			end,
			stdout_buffered = true
		})
	end, {})
end

return M

