
local l = Buffer:new()

l:write('<ul>')

for _, page in ipairs(pagelist) do
	l:write('<li><a href="%s">%s</a></li>', page.name, page.title)
end
l:write('</ul>')

return l:output()
