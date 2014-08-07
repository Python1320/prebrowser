dofile'src/ui.lua'

function wrapus(...)
	-- wrap us in pcall for popup error
	_LOADER_COUNTER=_LOADER_COUNTER and _LOADER_COUNTER+1 or 0 
	if _LOADER_COUNTER==0 then
		--print"wrapping ourselves"
		local args={...}
		local func = debug.getinfo(2, "f").func
		local ok,err = xpcall(function() func(unpack(args)) end,function(errstr)
			
			local err = debug.traceback(errstr,2)
			MsgBox(err, wx.wxOK + wx.wxICON_ERROR,"prebrowser crashed :(")
			
		end)
		return true
	end
end


-- Constants
	BROWSERS = [[HKEY_LOCAL_MACHINE\SOFTWARE\Clients\StartMenuInternet]]
	
	local appnames = {
		["IEXPLORE.EXE"]="Internet Explorer"
	}
	function getappname(a) return appnames[a] or a end

	