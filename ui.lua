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
