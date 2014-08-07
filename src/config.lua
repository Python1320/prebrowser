
require 'serialize'

local mypath = debug.getinfo(2, "S").source:sub(2):match("(.*/)") or "."
local CFG= mypath ..'/'.. "autoconfig.lua"

local config = loadfile (CFG)
config = config and config() or {}
--for k,v in next,config do print("> ",k,"=",v) end

_G.config=config

function saveconfig()
	local f=io.open(CFG,'wb') 
	f:write(serialize(config)) 
	f:close()
end
