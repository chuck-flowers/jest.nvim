local M = {}

M.JestOutput = {
	__tostring = function (output)
		local to_return = ''
		for _, test_result in ipairs(output.test_results) do
			to_return = to_return .. tostring(test_result)
		end

		return to_return
	end
}

function M.JestOutput:new(line)
	-- Create the instance
	local instance = {}
	setmetatable(instance, self)

	-- Parse the line
	local parsed_line = vim.json.decode(line)

	instance.test_results = {}
	local raw_test_results = parsed_line.testResults
	for _, raw_test_result in ipairs(raw_test_results) do
		local test_result = M.JestTestResult:new(raw_test_result)
		table.insert(instance.test_results, test_result)
	end

	return instance
end

M.JestTestResult = {
	__tostring = function (test_result)
		local to_return = test_result.file_path .. '\n'

		for _, assertion_result in ipairs(test_result.assertion_results) do
			to_return = to_return .. '  ' .. tostring(assertion_result) .. '\n'
		end

		return to_return .. '\n'
	end
}

function M.JestTestResult:new(raw_table)
	local instance = {}
	setmetatable(instance, self)

	instance.file_path = raw_table.name
	instance.assertion_results = {}

	for _, raw_assertion_result in ipairs(raw_table.assertionResults) do
		local assertion_result = M.JestAssertionResult:new(raw_assertion_result)
		table.insert(instance.assertion_results, assertion_result)
	end

	return instance
end

M.JestAssertionResult = {
	__tostring = function (assertion_result)
		return assertion_result.name .. ': ' .. assertion_result.status
	end
}

function M.JestAssertionResult:new(raw_assertion_result)
	local instance = {}
	setmetatable(instance, self)

	-- Extracts the relevant data
	instance.name = raw_assertion_result.fullName
	instance.status = raw_assertion_result.status

	return instance
end

return M
