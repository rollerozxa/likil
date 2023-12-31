#!/usr/bin/luajit

require('lfs')

-- path wrangling bootstrapper
local origindir = lfs.currentdir()
local scriptdir = debug.getinfo(1).source:match("@?(.*/)")

lfs.chdir(scriptdir)
local lunamark = {
	writer = require('lunamark.writer.html'),
	reader = require('lunamark.reader.markdown')
}
local molde = require('molde.molde')
require('utils')
lfs.chdir(origindir)

local site = require('config')

require('templates')

local layout = molde.loadfile('layout.html')

lfs.mkdir('.output/')
cleardir('.output/')
if site.page_base then
	lfs.mkdir('.output/'..site.page_base)
else
	site.page_base = ''
end

local opts = { }
local markdownify = lunamark.reader.new(lunamark.writer.new(opts), opts)

-- Get pagelist
pagelist = {}
for filename, mode in dirtree('pages/') do
	if mode.mode == "file" then
		local name = filename:gsub('pages/', ''):gsub('.md', '.html'):gsub('.lua', '.html')
		local title = name:gsub('.html', ''):gsub('_', ' ')

		if title == "index" then
			title = site.title
		end

		if not site.hidden[title] then
			table.insert(pagelist, {
				name = name,
				title = title
			})
		end
	end
end

table.sort(pagelist, function(a, b)
	return a.title < b.title
end)

for filename, mode in dirtree('pages/') do
	local name = filename:gsub('pages/', ''):gsub('.md', '.html'):gsub('.lua', '.html')
	local title = name:gsub('.html', ''):gsub('_', ' ')

	if mode.mode == "directory" then
		lfs.mkdir('.output/'..name)
	else
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
end

file_write('.output/404.html', layout{
	site = site,
	title = '404',
	content = site.not_found_message or
		"<p>This page couldn't be found. Maybe it was removed, or it hasn't been written yet, or you've received a broken link.</p>"
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
