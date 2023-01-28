--Luctus Funk
--Made by OverlordAkise

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
