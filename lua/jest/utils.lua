local M = {}

---Merges the content of one table into another
---@param target table The table which is modified
---@param source table The table which overwrites the target
function M.merge_tables(target, source)
	for key, source_value in pairs(source) do
		local target_value = target[key]

		if type(target_value) == 'table' and type(source_value) == 'table' then
			if type(source_value) == 'table' then
				M.merge_tables(target_value, source_value)
			else
				target[key] = source_value
			end
		else
			target[key] = source_value
		end
	end
end

return M
