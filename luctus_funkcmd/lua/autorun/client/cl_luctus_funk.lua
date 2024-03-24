--Luctus Funk
--Made by OverlordAkise

local color_white = Color(255,255,255,255)

net.Receive("luctus_funk_chat", function()
    local cmd = net.ReadString()
    local ply = net.ReadEntity()
    local msg = net.ReadString()
    local tab = LUCTUS_FUNK_CUSTOM_CHANNELS[cmd]
    local nick = "<ANON>"
    
    if not tab then return end
    if IsValid(ply) and ply:IsPlayer() and not tab.isAnonymous then
        nick = ply:Nick()
    end
    if not table.HasValue(tab.jobs,team.GetName(LocalPlayer():Team())) and not table.IsEmpty(tab.jobs) then return end
    if tab.needsRadioToFunk and not LocalPlayer():HasWeapon(LUCTUS_FUNK_WEAPON_CLASS) then return end
    
    chat.AddText(tab.color,tab.prefix," ",color_white,nick,": ",msg)
end)

net.Receive("luctus_funk_broadcast", function()
    local sender = net.ReadEntity()
    local receiver = net.ReadString()
    local content = net.ReadString()
    chat.AddText(Color(0,0,255), LUCTUS_FUNK_PREFIX , team.GetColor(sender:Team()) , "  "  ..sender:Nick() .. ": *" .. receiver .. "* " .. content)
end)

net.Receive("luctus_funk_anon", function()
    local message = net.ReadString()
    chat.AddText(Color(0,0,255), LUCTUS_FUNKA_PREFIX , message)
end)

net.Receive("luctus_funk_anon_enc", function()
    local message = net.ReadString()
    chat.AddText(Color(0,0,255), LUCTUS_FUNKE_PREFIX , message)
end)

net.Receive("luctus_funk_opendec", function()
    local terminal = net.ReadEntity()

    local DecoderWindow = vgui.Create( "DFrame" )
    DecoderWindow:SetTitle("Decoder Interface")
    DecoderWindow:SetSize( 500, 200 )
    DecoderWindow:Center()
    DecoderWindow:SetDraggable( true )
    DecoderWindow:MakePopup()

    local EncryptedText = vgui.Create("DTextEntry", DecoderWindow)
    EncryptedText:Dock(TOP)
    EncryptedText:SetValue("Enter radio message!")

    local DecryptButton = vgui.Create("DButton", DecoderWindow)
    DecryptButton:Dock(TOP)
    DecryptButton:SetText("Decrypt!")
    function DecryptButton:DoClick()
        net.Start("luctus_funk_decrypt")
            net.WriteEntity(terminal)
            net.WriteString(EncryptedText:GetValue())
        net.SendToServer()
    end
  
    local DecodedText = vgui.Create("DTextEntry", DecoderWindow)
    DecodedText:Dock(TOP)
    DecodedText:SetHeight(300)
    DecodedText:SetMultiline(true)
    DecodedText:SetEditable(false)

    net.Receive("luctus_funk_decrypt",function()
        DecodedText:SetValue(net.ReadString())
    end)
end)

print("[luctus_funkcmd] cl loaded")
