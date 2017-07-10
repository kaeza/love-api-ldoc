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

local function writetype(f, typ)
	--print("type: "..typ.name)
	assert(f:write("---"
			.."\n-- "..formatdesc(typ.description)
			.."\n"))
	if typ.parenttype then
		assert(f:write("--"
				.."\n-- **Extends:** `"..convtype(typ.parenttype).."`"))
	end
	if typ.subtypes and typ.subtypes[1] then
		assert(f:write("--"
				.."\n-- **Subtypes:**"
				.."\n--"))
		for _, st in ipairs(typ.subtypes) do
			assert(f:write("\n-- * `"..convtype(st).."`"))
		end
	end
	assert(f:write("\n--\n-- @type "..typ.name))
	if typ.constructor then
		assert(f:write("\n-- @see "..typ.constructor))
	end
	assert(f:write("\n\n"))
	for _, func in ipairs(typ.functions or { }) do
		writefunction(f, func)
	end
end

local function writemodule(name, desc, t)
	local f = assert(io.open("tmp/"..name..".ldoc", "w"))

	assert(conf:write(("\t%q,\n"):format(name..".ldoc")))

	assert(f:write("---"
			.."\n-- "..formatdesc(desc)
			.."\n-- @module "..name
			.."\n\n"))

	for _, func in ipairs(t.functions or { }) do
		writefunction(f, func)
	end

	for _, typ in ipairs(t.types or { }) do
		writetype(f, typ)
	end

	assert(f:close())

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
