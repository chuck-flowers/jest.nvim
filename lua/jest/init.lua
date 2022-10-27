local M = {}

local default_options = {}

function M.setup(options)
	local jest_command = require 'jest.commands.jest'
	local jest_watch_command = require 'jest.commands.jest-watch'

	options = options or default_options

	-- Create the user commands
	vim.api.nvim_create_user_command('Jest', jest_command, {})
	vim.api.nvim_create_user_command('JestWatch', jest_watch_command, {})
end

return M
