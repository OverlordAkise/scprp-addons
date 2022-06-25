--Lucid Name Change
--Made by OverlordAkise

hook.Add("InitPostEntity", "luctus_scpnames", function()
	net.Start("luctus_checkscpnames")
	net.SendToServer()
end)

local oneNameJobs = {
  ["Serpents Hand Commander"] = true,
  ["Serpents Hand Medic"] = true,
  ["Serpents Hand Assault"] = true,
  ["Serpents Hand Heavy"] = true,
  ["Chaos Insurgency"] = true,
  ["Chaos Insurgency Commander"] = true,
  ["Chaos Insurgency Medic"] = true,
  ["Chaos Insurgency Hund"] = true,
  ["SCP 999"] = true,
  ["SCP 173"] = true,
  ["SCP 131"] = true,
  ["SCP 008-1"] = true,
  ["SCP 106"] = true,
  ["SCP 682"] = true,
  ["SCP 035"] = true,
  ["SCP 527"] = true,
  ["SCP 9527"] = true,
  ["MTF E6"] = true,
  ["MTF Gamma12"] = true,
  ["MTF Nu7"] = true,
  ["MTF E9"] = true,
  ["MTF Epsilon 11"] = true,
  ["Alpha 1"] = true,
}

net.Receive("luctus_scpnames",function()
  if IsValid(NameFrame) then 
    NameFrame:Close()
    return 
  end
  NameFrame = vgui.Create("DFrame")
  NameFrame:SetSize(500, 300)
  NameFrame:Center()
  NameFrame:SetTitle("")
  NameFrame:SetDraggable(false)
  NameFrame:ShowCloseButton(true) 
  NameFrame:MakePopup()
  NameFrame.Paint = function(self, w, h)
    draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 254))
    draw.RoundedBox(0, 0, 0, w, 30, Color(50,50,50,255))
    draw.SimpleText(GetHostName(), "Trebuchet24", w/2, 15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Please set a name for your job", "Trebuchet24", w/2, h/2 - 100, color_white, TEXT_ALIGN_CENTER)
  end
  
  local parent_x, parent_y = NameFrame:GetSize()
    
  local fname = vgui.Create( "DTextEntry", NameFrame )
  fname:SetPos( parent_x/2 - 80, parent_y/2 - 50 ) 
  fname:SetSize( 160 , 30 )
  fname:SetPlaceholderText( "Nickname" )
  
  local lname = nil
  if oneNameJobs[LocalPlayer():getJobTable().name] then
    --nothing
  else
    lname = vgui.Create( "DTextEntry", NameFrame )
    lname:SetPos( parent_x/2 - 80, parent_y/2 - 20 ) 
    lname:SetSize( 160 , 30 )
    lname:SetPlaceholderText( "Nachname" )
    fname:SetPlaceholderText( "Vorname" )
  end
  
  local BuyButton = vgui.Create("DButton", NameFrame)
  BuyButton:SetText("")
  BuyButton:SetPos(parent_x/2-40,parent_y/2 + 50)
  BuyButton:SetSize(85,25)
  BuyButton.DoClick = function() 
    net.Start("luctus_scpnames")
    net.WriteString(fname:GetValue())
    if oneNameJobs[LocalPlayer():getJobTable().name] then
      net.WriteString("")
    else
      net.WriteString(lname:GetValue())
    end
    net.SendToServer()
    --NameFrame:Close()
  end
  BuyButton.Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,255))
    draw.SimpleText("Set Name", "Trebuchet24", 0+w/2, 0+h/2-13, Color(0,0,0,255), TEXT_ALIGN_CENTER)
  end
end)
