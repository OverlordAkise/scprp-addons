--Luctus SCP049 System
--Made by OverlordAkise

function LuctusSCP049OpenMixMenu()
    local col1 = nil
    local col2 = nil
    local sel1 = nil
    local sel2 = nil
    local window = vgui.Create("DFrame")
    window:SetTitle("Mix Medicine")
    window:SetSize(600,400)
    window:Center()
    window:MakePopup()
    window:ShowCloseButton(false)
    function window.Paint(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(32, 34, 37))
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62))
    end
    
    local CloseButton = vgui.Create("DButton", window)
    CloseButton:SetText("X")
    CloseButton:SetPos(window:GetWide()-22,2)
    CloseButton:SetSize(20,20)
    CloseButton:SetTextColor(Color(0,195,165))
    CloseButton.DoClick = function()
        window:Close()
    end
    CloseButton.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if (self.Hovered) then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end
    
    local saveButton = vgui.Create("DButton",window)
    saveButton:SetText("MIX!")
    saveButton:Dock(BOTTOM)
    function saveButton:DoClick()
        if col1 and col2 then
            net.Start("luctus_scp049_mixing")
                net.WriteInt(col1,17)
                net.WriteInt(col2,17)
            net.SendToServer()
            window:Close()
        end
    end
    saveButton.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(247, 249, 254))
        if (self.Hovered) then
            draw.RoundedBox(0, 0, 0, w, h, Color(0,195,165))
            draw.RoundedBox(0, 1, 1, w-2, h-2, Color(66, 70, 77))
        end
    end
    local list1 = vgui.Create("DPanel",window)
    list1:Dock(LEFT)
    list1:SetSize(290,400)
    list1:SetPaintBackground(false)
    local list2 = vgui.Create("DPanel",window)
    list2:Dock(RIGHT)
    list2:SetSize(290,400)
    list2:SetPaintBackground(false)
    local button = vgui.Create("DButton",list1)
    button:SetText("First Mixture")
    button:Dock(TOP)
    button = vgui.Create("DButton",list2)
    button:SetText("Second Mixture")
    button:Dock(TOP)
    
    for k,v in pairs(LUCTUS_SCP049_MIX_INGREDIENTS) do
        button = vgui.Create("DButton",list1)
        button:Dock(TOP)
        button:SetText(v[1])
        button.selected = false
        button.col = v[2]
        button.id = k
        function button:Paint(w,h)
            draw.RoundedBox(0,0,0,w,h,self.col)
            if sel1 == self then
                surface.SetDrawColor(0,0,0,255)
                surface.DrawOutlinedRect(0, 0, w, h, 3)
            end
        end
        function button:DoClick()
            col1 = self.id
            sel1 = self
        end
    end
    
    for k,v in pairs(LUCTUS_SCP049_MIX_INGREDIENTS) do
        button = vgui.Create("DButton",list2)
        button:Dock(TOP)
        button:SetText(v[1])
        button.selected = false
        button.col = v[2]
        button.id = k
        function button:Paint(w,h)
            draw.RoundedBox(0,0,0,w,h,self.col)
            if sel2 == self then
                surface.SetDrawColor(0,0,0,255)
                surface.DrawOutlinedRect(0, 0, w, h, 3)
            end
        end
        function button:DoClick()
            col2 = self.id
            sel2 = self
        end
    end
end

print("[scp049] cl loaded")
