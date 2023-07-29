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

require('templates')

local layout = molde.loadfile('layout.html')

lfs.mkdir('.output/')
if site.page_base then
	lfs.mkdir('.output/'..site.page_base)
else
	site.page_base = ''
end

local opts = { }
local markdownify = lunamark.reader.new(lunamark.writer.new(opts), opts)

for filename in dirtree('pages/') do
	local name = filename:gsub('pages/', ''):gsub('.md', '.html'):gsub('.lua', '.html')
	local title = name:gsub('.html', ''):gsub('_', ' ')

	print('Processing file: '..name)

	if filename:endswith('.md') then
		content = markdownify(molde.loadfile(filename)().."\n\n")
	elseif filename:endswith('.lua') then
		content = dofile(filename)
	end

	local output = layout{
		site = site,
		title = title,
		content = content
	}

	file_write('.output/'..site.page_base..name, output)
end

file_write('.output/404.html', layout{
	site = site,
	title = '404',
	content = "<p>This page couldn't be found. Maybe it was removed, or it hasn't been written yet, or you've received a broken link.</p>"
}, "w")

for filename, mode in dirtree('static/') do
	local name = filename:gsub('static/', '')

	if mode.mode == "directory" then
		lfs.mkdir('.output/'..name)
	else
		if name:endswith('.scss') then
			-- Compile SCSS stylesheets
			os.execute('sassc --style compressed '..filename..' .output/'..name:gsub('.scss', '.css'))
		else
			local content = file_get_contents(filename, "rb")
			print('Copying static file: '..name)
			file_write('.output/'..name, content, "wb")
		end
	end
end
