--Luctus Name Change
--Made by OverlordAkise

local accentColor = Color(0, 195, 165)
local greyColor = Color(47, 49, 54)

net.Receive("luctus_scpnames",function()
    if IsValid(NameFrame) then 
        NameFrame:Close()
        return
    end
    NameFrame = vgui.Create("DFrame")
    NameFrame:SetSize(400, 200)
    NameFrame:Center()
    NameFrame:SetTitle("")
    NameFrame:SetDraggable(true)
    NameFrame:ShowCloseButton(false)
    NameFrame:MakePopup()
    NameFrame.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, accentColor)
        draw.RoundedBox(5, 1, 1, w-2, h-2, Color(47,49,54,254))
        draw.SimpleText(GetHostName(), "Trebuchet24", 10, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("Please set a name for your job", "Trebuchet24", w/2, h/2 - 50, color_white, TEXT_ALIGN_CENTER)
    end

    local parent_x, parent_y = NameFrame:GetSize()
    local CloseButton = vgui.Create( "DButton", NameFrame )
    CloseButton:SetPos( parent_x-31, 1 )
    CloseButton:SetSize( 30, 30 )
    CloseButton:SetText("X")
    CloseButton:SetTextColor(Color(255,0,0))
    CloseButton.DoClick = function()
        NameFrame:Close()
    end
    CloseButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if self.Hovered then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end

    local fname = vgui.Create("DTextEntry",NameFrame)
    fname:SetPos(parent_x/2 -100, parent_y/2 -10) 
    fname:SetSize(200,30)
    fname:SetPlaceholderText("Peter Hans Wurst")
    fname:SetDrawLanguageID(false)
  
    local BuyButton = vgui.Create("DButton", NameFrame)
    BuyButton:SetText("")
    BuyButton:SetPos(parent_x/2-40,parent_y/2 + 50)
    BuyButton:SetSize(85,25)
    BuyButton.DoClick = function() 
        net.Start("luctus_scpnames")
        net.WriteString(fname:GetValue())
        net.SendToServer()
        --NameFrame:Close()
    end
    BuyButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, accentColor)
        if self.Hovered then
            draw.RoundedBox(0, 1, 1, w-2, h-2, Color(197,199,194))
            draw.SimpleText("Set Name", "Trebuchet18", 0+w/2, 0+h/2-10, Color(0,0,0,255), TEXT_ALIGN_CENTER)
        else
            draw.RoundedBox(0, 1, 1, w-2, h-2, Color(17,19,14))
            draw.SimpleText("Set Name", "Trebuchet18", 0+w/2, 0+h/2-10, Color(255,255,255), TEXT_ALIGN_CENTER)
        end
    end
end) 

print("[luctus_scpnames] cl loaded")
