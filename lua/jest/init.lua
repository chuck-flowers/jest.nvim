local M = {}

local default_options = {}

function M:setup(options)
	options = options or default_options
	vim.api.nvim_create_user_command('Jest', function ()
		print('Jest')
	end, {})
end

return M

