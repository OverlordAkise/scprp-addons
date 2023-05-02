--Luctus Intro
--Made by OverlordAkise

luctusIntroWelcomeText = "Welcome to SCPRP"
local welcomeColor = Color(100,200,0)
local color_white = Color(255,255,255)
local backgroundColLight = Color(26,26,26,90)
luctusIntroFrame = nil

local function lLuctusDrawEdgeBox(x, y, w, h, s, b)
    if not s then s = 10 end
    if not b then b = 2 end
    surface.SetDrawColor(backgroundColLight)
    surface.DrawRect(x,y,w,h)
    surface.SetDrawColor(color_white)
    surface.DrawRect(x,y,s,b)
    surface.DrawRect(x,y+b,b,s-b)
    local xr = x+w
    surface.DrawRect(xr-s,y,s,b)
    surface.DrawRect(xr-b,y+b,b,s-b)
    local yb = y+h
    surface.DrawRect(xr-s,yb-b,s,b)
    surface.DrawRect(xr-b,yb-s,b,s-b)
    surface.DrawRect(x,yb-b,s,b)
    surface.DrawRect(x,yb-s,b,s-b)
end

hook.Add("InitPostEntity", "luctus_intro_start", function()
    net.Start("luctus_intro_start")
    net.SendToServer()
end)

net.Receive("luctus_intro_start",function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end
    ent:SetNoDraw(true)
    LuctusIntroFrame()
end)

function LuctusIntroFrame()
    if IsValid(luctusIntroFrame) then luctusIntroFrame:Close() end
    luctusIntroFrame = vgui.Create("DFrame")
    luctusIntroFrame:SetSize(ScrW(), ScrH())
    luctusIntroFrame:Center()
    luctusIntroFrame:SetTitle("")
    luctusIntroFrame:SetDraggable(false)
    luctusIntroFrame:ShowCloseButton(false)
    luctusIntroFrame:MakePopup()
    function luctusIntroFrame:Paint(w,h)
        lLuctusDrawEdgeBox(0,0,w,h)
    end
    
    surface.SetFont("luctus_scp_code_hud_font")
    local wx, wy = surface.GetTextSize(luctusIntroWelcomeText)
    wx = wx + 50
    
    timer.Simple(1,function()
        local introPanel = vgui.Create("DPanel",luctusIntroFrame)
        introPanel:SetText("")
        introPanel:SetPos(ScrW()/2-wx/2,ScrH()/7)
        introPanel:SetSize(1,50)
        introPanel:SizeTo(wx,50,1.5,0)
        function introPanel:Paint(w,h)
            if self.Blink then return end
            lLuctusDrawEdgeBox(0,0,w,h)
            draw.SimpleText(luctusIntroWelcomeText, "DermaLarge", wx/2, 25, welcomeColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        timer.Create("intro_blink_panel",0.1,8,function()
            introPanel.Blink = not introPanel.Blink
        end)
    end)
    timer.Simple(2,function()
        local introButton = vgui.Create("DButton",luctusIntroFrame)
        introButton:SetText("")
        introButton:SetPos(ScrW()/2-100,ScrH()*0.6)
        introButton:SetSize(1,1)
        introButton:SizeTo(200,100,2,0)
        function introButton:Paint(w,h)
            if self.Blink then return end
            if self.Hovered then
                lLuctusDrawEdgeBox(0,0,w,h,12,2)
            else
                lLuctusDrawEdgeBox(0,0,w,h,7,1)
            end
            draw.SimpleText("PLAY", "DermaLarge", 100, 50, darkRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        timer.Create("intro_blink_panel",0.1,8,function()
            introButton.Blink = not introButton.Blink
        end)
        function introButton:DoClick()
            net.Start("luctus_intro_start")
            net.SendToServer()
            luctusIntroFrame:Close()
        end
    end)
end

print("[luctus_intro] cl loaded!")
