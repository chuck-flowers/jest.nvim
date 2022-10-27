local M = {}

local default_options = {}

function M.setup(options)
	local jest_command = require 'jest.commands.jest'

	options = options or default_options

	-- Create the user commands
	vim.api.nvim_create_user_command('Jest', jest_command, {})
end

return M
