local M = {}

--- @class JestOutput
--- @field test_results JestTestResult[]
M.JestOutput = {
	test_results = {},
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
	-- @type JestOutput
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
--- @field file_path string
--- @field assertion_results JestAssertionResult[]
M.JestTestResult = {
	file_path = '',
	assertion_results = {},
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
	--- @type JestTestResult
	local instance = {}

	setmetatable(instance, self)

	instance.file_path = string.gsub(raw_table.name, vim.fn.getcwd() .. '/', '.')
	instance.assertion_results = {}

	for _, raw_assertion_result in ipairs(raw_table.assertionResults) do
		local assertion_result = M.JestAssertionResult:new(raw_assertion_result)
		table.insert(instance.assertion_results, assertion_result)
	end

	return instance
end

---@class JestAssertionResult
---@field name string
---@field status 'passed' | 'failed'
M.JestAssertionResult = {
	name = '',
	status = 'failed',
	---The stringifier for the JestAssertionResult
	---@param assertion_result JestAssertionResult
	---@return string
	__tostring = function (assertion_result)
		---@type '' | 'X'
		local icon
		if assertion_result.status == 'passed' then
			icon = ''
		elseif assertion_result.status == 'failed' then
			icon = 'X'
		else
			error('Unrecognized assertion result status' .. assertion_result.status)
		end

		return icon .. ' ' .. assertion_result.name
	end
}

--- The constructor for the JestAssertionResult
--- @param raw_assertion_result table
function M.JestAssertionResult:new(raw_assertion_result)
	---@type JestAssertionResult
	local instance = {}

	setmetatable(instance, self)

	-- Extracts the relevant data
	instance.name = raw_assertion_result.fullName
	instance.status = raw_assertion_result.status

	return instance
end

return M

