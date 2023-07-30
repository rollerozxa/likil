
function test(data)
	local l = Buffer:new()
	l:write('<div>%s</div>', data.message)
	return l:output()
end
