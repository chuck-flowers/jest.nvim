local M = {}

--- @class JestOutput
M.JestOutput = {
	__tostring = function (output)
		local to_return = ''
		for _, test_result in ipairs(output.test_results) do
			to_return = to_return .. tostring(test_result)
		end

		return to_return
	end
}

--- The constructor for a JestOutput
--- @param line string The line of JSON output to parse
--- @return JestOutput
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

--- @class JestTestResult
M.JestTestResult = {
	__tostring = function (test_result)
		local to_return = test_result.file_path .. '\n'

		for _, assertion_result in ipairs(test_result.assertion_results) do
			to_return = to_return .. '  ' .. tostring(assertion_result) .. '\n'
		end

		return to_return .. '\n'
	end
}

--- The constructor for a JestTestResult
--- @param raw_table table
--- @return JestTestResult
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

--- @class JestAssertionResult
M.JestAssertionResult = {
	name = '',
	status = '',
	--- The stringifier for the JestAssertionResult
	--- @param assertion_result JestAssertionResult
	--- @return string
	__tostring = function (assertion_result)
		--- @type string
		local icon
		if assertion_result.status == 'passed' then
			icon = ''
		else
			icon = 'X'
		end

		return icon .. ' ' .. assertion_result.name
	end
}

--- The constructor for the JestAssertionResult
--- @param raw_assertion_result table
function M.JestAssertionResult:new(raw_assertion_result)
	local instance = {}
	setmetatable(instance, self)

	-- Extracts the relevant data
	instance.name = raw_assertion_result.fullName
	instance.status = raw_assertion_result.status

	return instance
end

return M

