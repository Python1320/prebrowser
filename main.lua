dofile'src/ui.lua'

-- wrap us in pcall for popup error
LOADER_COUNTER=LOADER_COUNTER and LOADER_COUNTER+1 or 0 
if LOADER_COUNTER==0 then
	--print"wrapping ourselves"
	local args={...}
	local func = debug.getinfo(1, "f").func
	local ok,err = xpcall(function() func(unpack(args)) end,function(errstr)
		
		local err = debug.traceback(errstr,2)
		MsgBox(err, wx.wxOK + wx.wxICON_ERROR,"prebrowser crashed :(")
		
	end)
	return
end

pcall(require,'winapi')
local url,param1 = ...




-- Configuration

	dofile'src/config.lua'
	

-- Constants
	local BROWSERS = [[HKEY_LOCAL_MACHINE\SOFTWARE\Clients\StartMenuInternet]]
	
	local appnames = {
		["IEXPLORE.EXE"]="Internet Explorer"
	}
	local function getappname(a) return appnames[a] or a end

	
-- default browser selection :|
if winapi and not config.browser then


	local browsernames = {}
	local browser_paths = {}
	
	--- Do you want to use this browser?
	local function checkbrowser(k)
		local key,err = winapi.open_reg_key (BROWSERS..'\\'..k..'\\Capabilities')
		local desc = key and key:get_value("ApplicationName") or k
		
		if key then key:close() else 
			desc = getappname(k)
			--print("noappname",k,"->",desc) 
		end
		
		
		local key,err = winapi.open_reg_key (BROWSERS..'\\'..k..'\\shell\\open\\command')
		local path = key and key:get_value()
		if key then key:close() else print("nopath1",k) return end
		if not path then print("nopath",k) return end
		
		table.insert(browsernames,desc or "???")
		table.insert(browser_paths,path or "???")
	end


	local key,err = winapi.open_reg_key (BROWSERS)

	local t = key:get_keys()
	
	for _,k in next,t do
		if k~="PreBrowser" then
			checkbrowser(k)
		end
	end
	
	key:close()
	
	local chosen = Chooser(browsernames,"Choose","Browser")
	
	if not chosen then return end
	local path = browser_paths[chosen]
	print(chosen,path)
	
	config.browser = path or error"???"
	
	
end

if not config.browser then
	MsgBox "No browser usable :("
	return
end

assert(winapi.shell_exec(nil, 	config.browser,
								'"'..url:gsub('"','')..'"',
								nil,winapi.SW_MINIMIZE))

saveconfig()
