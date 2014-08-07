local p=print 
	require 'wx' 
print=p

function MsgBox(msg,asd,title)
	return wx.wxMessageBox(msg,title or "prebrowser",
					asd or (wx.wxOK + wx.wxICON_INFORMATION),
					wx.NULL)
end

function YesNo(title,msg)
	return MsgBox(msg,wx.wxYES_NO + wx.wxICON_QUESTION,title) == wx.wxYES
end

function Chooser(tbl,a,b)
	local chosen_id
	
	local dialog = wx.wxDialog(wx.NULL, wx.wxID_ANY, a or "Choose",
						 wx.wxDefaultPosition, wx.wxDefaultSize)

	local panel = wx.wxPanel(dialog, wx.wxID_ANY)
	local mainSizer = wx.wxBoxSizer(wx.wxVERTICAL)

	local staticBox      = wx.wxStaticBox(panel, wx.wxID_ANY, b or a or "Choose")
	local staticBoxSizer = wx.wxStaticBoxSizer(staticBox, wx.wxVERTICAL)
	local flexGridSizer  = wx.wxFlexGridSizer( 1, 1, 0, 0 )
	flexGridSizer:AddGrowableCol(1, 0)

	local function Btn(button_text, buttonID)
		local button     = wx.wxButton( panel, buttonID, button_text)
		flexGridSizer:Add( button, 0, wx.wxGROW+wx.wxALIGN_CENTER+wx.wxALL, 5 )
		return button
	end
	
	for k,v in next,tbl do 
		local btn = Btn(v,    k   )
	end


	staticBoxSizer:Add( flexGridSizer,  0, wx.wxGROW+wx.wxALIGN_CENTER+wx.wxALL, 5 )
	mainSizer:Add(      staticBoxSizer, 1, wx.wxGROW+wx.wxALIGN_CENTER+wx.wxALL, 5 )

	panel:SetSizer( mainSizer )
	mainSizer:SetSizeHints( dialog )

	dialog:Connect(wx.wxID_ANY, wx.wxEVT_COMMAND_BUTTON_CLICKED,
		function(event)
			local id = event:GetId()
			local exists=tbl[id]
			
			if exists==nil then
				event:Skip()
				return
			end

			chosen_id = id

			--wx.wxMessageBox(tostring(exists),
			--				"Error!",
			--				wx.wxOK + wx.wxICON_EXCLAMATION + wx.wxCENTRE,
			--				dialog)
			
			dialog:Destroy()
			event:Skip()
			
		end)

	dialog:Connect(wx.wxEVT_CLOSE_WINDOW,
		function (event)
			dialog:Destroy()
			event:Skip()
		end)


	dialog:Centre()

	dialog:Show(true)

	wx.wxGetApp():MainLoop()
	
	return chosen_id
end

-- alternative keydown
require 'alien' 

VK_LSHIFT  = 0xA0
VK_RSHIFT  = 0xA1
VK_LCONTROL  = 0xA2
VK_RCONTROL  = 0xA3
VK_LMENU  = 0xA4
VK_RMENU  = 0xA5
VK_PLAY  = 0xFA
VK_ZOOM  = 0xFB
VK_LBUTTON  = 0x01
VK_RBUTTON  = 0x02
VK_CANCEL  = 0x03
VK_MBUTTON  = 0x04
VK_BACK  = 0x08
VK_TAB  = 0x09
VK_CLEAR  = 0x0C
VK_RETURN  = 0x0D
VK_SHIFT  = 0x10
VK_CONTROL  = 0x11
VK_MENU  = 0x12
VK_PAUSE  = 0x13
VK_CAPITAL  = 0x14
VK_ESCAPE  = 0x1B
VK_SPACE  = 0x20
VK_PRIOR  = 0x21
VK_NEXT  = 0x22
VK_END  = 0x23
VK_HOME  = 0x24
VK_LEFT  = 0x25
VK_UP  = 0x26
VK_RIGHT  = 0x27
VK_DOWN  = 0x28
VK_SELECT  = 0x29
VK_PRINT  = 0x2A
VK_EXECUTE  = 0x2B
VK_SNAPSHOT  = 0x2C
VK_INSERT  = 0x2D
VK_DELETE  = 0x2E
VK_HELP  = 0x2F

local ks = alien.User32.GetKeyState  
ks:types{  "int", ret = "short", abi = 'stdcall' } 
local VK_LSHIFT = 0xA0
print(ks(VK_LSHIFT))
function IsKeyDown(key)
	local ret = ks(key or VK_SHIFT)
	return ret <= 127
end