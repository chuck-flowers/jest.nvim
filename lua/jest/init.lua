local M = {}

local default_options = {}

function M:setup(options)
	local models = require('jest.models')

	options = options or default_options

	local function run_jest(callback)
		vim.fn.jobstart('npx jest --json', {
			on_stdout = function(_, data)
				local outputs = {}
				for _, line in ipairs(data) do
					local jest_output = models.JestOutput:new(line)
					table.insert(outputs, jest_output)
				end

				callback(outputs)
			end,
			stdout_buffered = true
		})
	end

	local output_bufnr = nil
	local function display_output(output)
		if output_bufnr == nil then
			output_bufnr = vim.api.nvim_create_buf(false, true)
			vim.cmd('vert sb' .. output_bufnr)
		end

		vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, vim.split(tostring(output), '\n'))
	end

	vim.api.nvim_create_user_command('Jest', function()
		run_jest(function (outputs)
			display_output(outputs[1])
		end)
	end, {})
end

return M
