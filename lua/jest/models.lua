---@class JestAssertionResult
---@field name string
---@field status 'passed' | 'failed'
local JestAssertionResult = {
	---The stringifier for the JestAssertionResult
	---@param assertion_result JestAssertionResult
	---@return string
	__tostring = function(assertion_result)
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
JestAssertionResult.__index = JestAssertionResult

--- The constructor for the JestAssertionResult
--- @param raw_assertion_result table
function JestAssertionResult:new(raw_assertion_result)
	---@type JestAssertionResult
	local instance = {}

	setmetatable(instance, self)

	-- Extracts the relevant data
	instance.name = raw_assertion_result.fullName
	instance.status = raw_assertion_result.status

	return instance
end

---Merges another JestAssertionResult into this one
---@param other JestAssertionResult
function JestAssertionResult:merge(other)
	self.name = other.name
	self.status = other.status
end

--- @class JestTestResult
--- @field file_path string
--- @field assertion_results JestAssertionResult[]
local JestTestResult = {
	file_path = '',
	assertion_results = {},
	__tostring = function(test_result)
		local to_return = test_result.file_path .. '\n'

		for _, assertion_result in pairs(test_result.assertion_results) do
			to_return = to_return .. '  ' .. tostring(assertion_result) .. '\n'
		end

		return to_return .. '\n'
	end
}
JestTestResult.__index = JestTestResult

--- The constructor for a JestTestResult
--- @param raw_table table
--- @return JestTestResult
function JestTestResult:new(raw_table)
	--- @type JestTestResult
	local instance = {}

	setmetatable(instance, self)

	instance.file_path = string.gsub(raw_table.name, vim.fn.getcwd() .. '/', '.')
	instance.assertion_results = {}

	for _, raw_assertion_result in pairs(raw_table.assertionResults) do
		local assertion_result = JestAssertionResult:new(raw_assertion_result)
		instance.assertion_results[assertion_result.name] = assertion_result
	end

	return instance
end

---Merges another JestTestResult into this one
---@param other JestTestResult
function JestTestResult:merge(other)
	for key, value in pairs(other.assertion_results) do
		local assertion_result = self.assertion_results[key]
		if assertion_result ~= nil then
			assertion_result:merge(value)
		else
			self.assertion_results[key] = value
		end
	end
end

--- @class JestOutput
--- @field test_results { [string]: JestTestResult }
local JestOutput = {
	__tostring = function(output)
		local to_return = ''
		for _, test_result in pairs(output.test_results) do
			to_return = to_return .. tostring(test_result)
		end

		return to_return
	end
}
JestOutput.__index = JestOutput

--- The constructor for a JestOutput
--- @param line string The line of JSON output to parse
--- @return JestOutput
function JestOutput:new(line)
	-- @type JestOutput
	local instance = {}
	setmetatable(instance, self)

	-- Parse the line
	local parsed_line = vim.json.decode(line)

	instance.test_results = {}
	local raw_test_results = parsed_line.testResults
	for _, raw_test_result in pairs(raw_test_results) do
		local test_result = JestTestResult:new(raw_test_result)
		instance.test_results[test_result.file_path] = test_result
	end

	return instance
end

---Merges another JestOutput into this one
---@param other JestOutput
function JestOutput:merge(other)
	for key, value in pairs(other.test_results) do
		local jest_test_result = self.test_results[key]
		if jest_test_result ~= nil then
			jest_test_result:merge(value)
		end
	end
end

return JestOutput
