--Luctus SCP Radio
--Made by OverlordAkise

luctusradiomenu = nil

function LuctusRadioOpenMenu()
    if luctusradiomenu and IsValid(luctusradiomenu) then return end
    luctusradiomenu = vgui.Create("DFrame")
    luctusradiomenu:SetTitle("Luctus Radio | Channel Select")
    luctusradiomenu:SetSize( 300, 300 )
    luctusradiomenu:SetPos(ScrW()/2-150, ScrH()/2-250)
    luctusradiomenu:MakePopup()
    luctusradiomenu:ShowCloseButton(false)
    function luctusradiomenu:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0,195,165))--32,34,37
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62))
    end
    
    local CloseButton = vgui.Create("DButton", luctusradiomenu)
    CloseButton:SetText("X")
    CloseButton:SetPos(luctusradiomenu:GetWide()-22,2)
    CloseButton:SetSize(20,20)
    CloseButton:SetTextColor(Color(0,195,165))
    CloseButton.DoClick = function()
        luctusradiomenu:Close()
    end
    CloseButton.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if self.Hovered then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end
    
    local lliste = vgui.Create("DListLayout", luctusradiomenu)
    lliste:Dock(FILL)
    for chName,teamList in pairs(LUCTUS_RADIO_CHANNELS) do
        if not table.HasValue(teamList,LocalPlayer():Team()) and chName ~= "Emergency" then continue end
        local item = lliste:Add("DButton")
        item:Dock(TOP)
        item:DockMargin(10,10,10,0)
        item:SetText(chName)
        item.chName = chName
        function item:DoClick()
            net.Start("luctus_radio")
                net.WriteString(item.chName)
            net.SendToServer()
            luctusradiomenu:Close()
            LocalPlayer():GetActiveWeapon().channel = item.chName
        end
        item.Paint = function(self,w,h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0,195,165))
            draw.RoundedBox(0, 1, 1, w-2, h-2, Color(217, 219, 214))
            if self.Hovered then
                --draw.RoundedBox(0, 0, 0, w, h, Color(0,195,165))
                draw.RoundedBox(0, 1, 1, w-2, h-2, Color(66, 70, 77))
            end
        end
    end
end

function LuctusRadioSwitchNext()
    local channels = {}
    local curName = LocalPlayer():GetActiveWeapon().channel
    local curId = 1
    for chName,teamList in pairs(LUCTUS_RADIO_CHANNELS) do
        if not table.HasValue(teamList,LocalPlayer():Team()) and chName ~= "Emergency" then continue end
        local id = table.insert(channels,chName)
        if chName == curName then
            curId = id
        end
    end
    local newId = math.Clamp((curId+1)%(#channels+1),1,#channels)
    net.Start("luctus_radio")
        net.WriteString(channels[newId])
    net.SendToServer()
    LocalPlayer():GetActiveWeapon().channel = channels[newId]
end

print("[luctus_sradio] cl loaded")
