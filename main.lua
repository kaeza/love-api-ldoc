#! /usr/bin/env lua

local lfs = require "lfs"
local api = require "api.love_api"

lfs.mkdir("tmp")

local typemap = { }

local conf = assert(io.open("tmp/config.ld", "w"))

assert(conf:write([[
project = "LÖVE ]]..api.version..[["
format = "markdown"

file = {
]]))

local function convtype(t)
	if t == "light userdata" then
		t = "userdata"
	end
	return typemap[t] or t
end

local function formatdesc(desc)
	return (desc:gsub("\n", "\n-- "))
end

local function writefunction(f, func)
	for _, var in ipairs(func.variants) do
		assert(f:write("---"
				.."\n-- "..formatdesc(func.description)
				.."\n-- @function "..func.name
				.."\n"))
		for _, arg in ipairs(var.arguments or { }) do
			assert(f:write("-- @tparam"
					.." "..convtype(arg.type)
					.." "..arg.name
					.." "..formatdesc(arg.description)
					.."\n"))
		end
		for _, ret in ipairs(var.returns or { }) do
			assert(f:write("-- @treturn"
					.." "..convtype(ret.type)
					.." `"..ret.name.."`:"
					.." "..formatdesc(ret.description)
					.."\n"))
		end
		assert(f:write("\n"))
	end
end

local function writetype(name, typ)
	local f = assert(io.open("tmp/"..name..".ldoc", "w"))

	assert(conf:write(("\t%q,\n"):format(name..".ldoc")))

	assert(f:write("---"
			.."\n-- "..formatdesc(typ.description)))

	if typ.constructors then
		local base = name:gsub("[^.]+$", "")
		assert(f:write("\n--"
				.."\n-- **Constructors:**"
				.."\n--"))
		for _, ctor in ipairs(typ.constructors) do
			assert(f:write("\n-- * `"..base..ctor.."`"))
		end
	end

	if typ.parenttype then
		assert(f:write("\n--"
				.."\n-- **Extends:** `"..convtype(typ.parenttype).."`"))
	end
	if typ.subtypes and typ.subtypes[1] then
		assert(f:write("\n--"
				.."\n-- **Subtypes:**"
				.."\n--"))
		for _, st in ipairs(typ.subtypes) do
			assert(f:write("\n-- * `"..convtype(st).."`"))
		end
	end
	assert(f:write("\n--\n-- @classmod "..name))
	assert(f:write("\n\n"))
	for _, func in ipairs(typ.functions or { }) do
		writefunction(f, func)
	end

	assert(f:close())
end

local function writemodule(name, desc, t)
	local f = assert(io.open("tmp/"..name..".ldoc", "w"))

	assert(conf:write(("\t%q,\n"):format(name..".ldoc")))

	assert(f:write("---"
			.."\n-- "..formatdesc(desc)
			.."\n-- @module "..name
			.."\n"))

	for _, typ in ipairs(t.types or { }) do
		assert(f:write("-- @see "..name.."."..typ.name.."\n"))
	end

	assert(f:write("\n"))

	for _, func in ipairs(t.functions or { }) do
		writefunction(f, func)
	end

	assert(f:close())

	for _, typ in ipairs(t.types or { }) do
		writetype(name.."."..typ.name, typ)
	end

	for _, m in ipairs(t.modules or { }) do
		writemodule(name.."."..m.name, m.description, m)
	end
end

local function collecttypes(name, t)
	for _, typ in ipairs(t.types or { }) do
		typemap[typ.name] = name.."."..typ.name
	end
	for _, m in ipairs(t.modules or { }) do
		collecttypes(name.."."..m.name, m)
	end
end

collecttypes("love", api)
writemodule("love", "Core API.", api)

assert(conf:write("}\n")) -- file

assert(conf:close())

os.execute("cd tmp && ldoc . -d ../doc")
