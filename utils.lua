
function dirtree(dir)
	assert(dir and dir ~= "", "Please pass directory parameter")
	if string.sub(dir, -1) == "/" then
		dir=string.sub(dir, 1, -2)
	end

	local function yieldtree(dir)
		for entry in lfs.dir(dir) do
			if entry ~= "." and entry ~= ".." then
				entry=dir.."/"..entry
				local attr=lfs.attributes(entry)
				coroutine.yield(entry,attr)
				if attr.mode == "directory" then
					yieldtree(entry)
				end
			end
		end
	end

	return coroutine.wrap(function() yieldtree(dir) end)
end

function file_get_contents(filename, mode)
	local file = io.open(filename, mode or "r")
	local content = file:read("a")
	file:close()

	return content
end

function file_write(filename, content, mode)
	local file = io.open(filename, mode or "w")
	file:write(content)
	file:close()
end

function string:endswith(suffix)
    return self:sub(-#suffix) == suffix
end

Buffer = {}
function Buffer.new(self, o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.buffer = {}
	return o
end

function Buffer:write(text, ...)
	table.insert(self.buffer, string.format(text, ...))
end

function Buffer:output()
	return table.concat(self.buffer, "")
end
