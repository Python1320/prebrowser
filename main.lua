LOADER_COUNTER=LOADER_COUNTER and LOADER_COUNTER+1 or 0

local p=print require 'wx' print=p


local function MsgBox(msg,asd,title)
	return wx.wxMessageBox(msg,title or "prebrowser",
					asd or (wx.wxOK + wx.wxICON_INFORMATION),
					wx.NULL)
end

local function YesNo(title,msg)
	return MsgBox(msg,wx.wxYES_NO + wx.wxICON_QUESTION,title) == wx.wxYES
end

if LOADER_COUNTER==0 then
	
	
	print"wrapping ourselves"
	local args={...}
	local func = debug.getinfo(1, "f").func
	local ok,err = xpcall(function() func(unpack(args)) end,function(errstr)
		
		local err = debug.traceback(errstr,2)
		MsgBox(err, wx.wxOK + wx.wxICON_ERROR,"prebrowser crashed :(")
		
	end)
	return
end

pcall(require,'winapi')

require'serialize'

local config = loadfile("config.lua")
config = config and config() or {}
for k,v in next,config do
	print(">",k,v)
end

local url,param1 = ...

local str = debug.getinfo(1, "S").source:sub(2)
local mypath = str:match("(.*/)")
print(mypath)


if winapi and not config.browser then
	
	local BROWSERS = [[HKEY_LOCAL_MACHINE\SOFTWARE\Clients\StartMenuInternet]]

	local key,err = winapi.open_reg_key (BROWSERS)



	local t = key:get_keys()


		for _,k in next,t do
			local key,err = winapi.open_reg_key (BROWSERS..'\\'..k..'\\Capabilities')
			local desc = key and key:get_value("ApplicationName") or k
			if key then
				key:close()
			end
			local use = YesNo("Use browser?",desc)
			
			if use then 
				local key,err = winapi.open_reg_key (BROWSERS..'\\'..k..'\\shell\\open\\command')
				if key then
					config.browser = key:get_value()
					break 
				else
					error("notfound "..tostring(err))
				end
			end
			
		end
		
		
	key:close()
	
	
	if not config.browser then
		MsgBox "No more browsers"
		return
	end
	
end

if not config.browser then
	MsgBox "No browser usable :("
	return
end


url=url:gsub('"','')
print("exec",winapi.shell_exec(nil,config.browser,'"'..url..'"',nil,winapi.SW_MINIMIZE))

print("Using",config.browser)

local f=io.open("config.lua",'wb')
f:write(serialize(config))
f:close()
