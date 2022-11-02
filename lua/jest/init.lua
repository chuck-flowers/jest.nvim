local M = {}

---Configures and starts the plugin
---@param user_config JestNvimConfig
function M.setup(user_config)
	local jest_command = require 'jest.commands.jest'
	local jest_watch_command = require 'jest.commands.jest-watch'
	local JestNvimConfig = require 'jest.config'

	--- Resolve the configuration
	local config = JestNvimConfig:new()
	config:merge(user_config or {})

	-- Create the user commands
	vim.api.nvim_create_user_command('Jest', jest_command(config), {})
	vim.api.nvim_create_user_command('JestWatch', jest_watch_command(config), {})
end

return M
