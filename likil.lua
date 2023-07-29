-- UwU

require('lfs')
lfs.chdir('../')
local lunamark = {
	writer = require('lunamark.writer.html'),
	reader = require('lunamark.reader.markdown')
}
local molde = require('molde.molde')
require('utils')
lfs.chdir('vmc/')

local site = require('config')

local layout = molde.loadfile('layout.html')

lfs.mkdir('.output/')

for filename in dirtree('pages/') do
	local content = file_get_contents(filename)

	local name = filename:gsub('pages/', ''):gsub('.md', '.html')
	local title = name:gsub('.html', ''):gsub('_', ' ')

	print('Processing file: '..name)

	local opts = { }
	local parse = lunamark.reader.new(lunamark.writer.new(opts), opts)

	local output = layout{
		site = site,
		title = title,
		content = parse(content)
	}

	file_write('.output/'..name, output)
end

local function rur(filename)
	local content = file_get_contents(filename, "rb")

	local name = filename:gsub('static/', '')

	print('Copying static file: '..name)

	file_write('.output/'..name, content, "wb")
end

for filename, mode in dirtree('static/') do
	local name = filename:gsub('static/', '')

	if mode.mode == "directory" then
		lfs.mkdir('.output/'..name)
	else
		local content = file_get_contents(filename, "rb")
		print('Copying static file: '..name)
		file_write('.output/'..name, content, "wb")
	end
end
