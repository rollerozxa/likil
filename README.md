# Likil
Simple static site generator written in Lua with a Wiki-like structure. Write pages in Markdown with the ability to call templates written in Lua, or write pages completely generated with Lua.

An example test site is provided at `test/`.

## Usage
I am lazy and won't write a full README, but these are the most important details:

You need luafilesystem/lua-filesystem/lfs/whatever and lpeg installed. Use LuaJIT.

To listen on edits to the site files and generate whenever something has updated, you could run something like this:

```bash
while true; do inotifywait -e modify,create,delete -r . && ../likil.lua; done
```

To test the site in a GitHub Pages-like environment, you can use the Jekyll WEBrick server (gosh so hacky), running it in the `.output/` folder and generating the site to some separate temporary folder:

```bash
jekyll serve -d /tmp/likil_site
```
