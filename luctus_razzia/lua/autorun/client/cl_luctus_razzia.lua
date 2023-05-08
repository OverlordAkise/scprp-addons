--Luctus Razzia
--Made by OverlordAkise

local color_white = Color(255,255,255)
local darkRed = Color(250, 20, 60, 190)
local backgroundColLight = Color(26,26,26,90)
local accent = Color(255,0,0)
razziaPanel = nil

net.Receive("luctus_razzia",function()
    local isStarting = net.ReadBool()
    chat.AddText(accent,"[razzia] ",color_white,isStarting and LUCTUS_RAZZIA_STARTTEXT or LUCTUS_RAZZIA_ENDTEXT)
    if isStarting then
        LuctusRazziaCreateBox()
        LuctusRazziaPlaySounds(LUCTUS_RAZZIA_STARTSOUND)
    else
        LuctusRazziaPlaySounds(LUCTUS_RAZZIA_ENDSOUND)
        if not IsValid(razziaPanel) then return end
        timer.Create("razzia_blink_panel",0,8,function()
            razziaPanel.Blink = not razziaPanel.Blink
        end)
        razziaPanel:SizeTo(1,50,1,0)
        timer.Simple(1,function()
            if razziaPanel then razziaPanel:Remove() end
        end)
    end
end)

function LuctusRazziaPlaySounds(sounds)
    local delay = 0
    for k,v in pairs(sounds) do
        timer.Simple(delay,function()
            surface.PlaySound(v)
        end)
        delay = delay + SoundDuration(v)
    end
end

--Blur doesnt work inside panels docked to HUD?
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

function LuctusRazziaCreateBox()
    if IsValid(razziaPanel) then razziaPanel:Remove() end
    razziaPanel = vgui.Create("DPanel")
    razziaPanel:ParentToHUD()
    razziaPanel:SetText("")
    razziaPanel:SetPos(ScrW()/2-100,ScrH()/7)
    razziaPanel:SetSize(1,50)
    razziaPanel:SizeTo(200,50,1,0)
    function razziaPanel:Paint(w,h)
        if self.Blink then return end
        LuctusDrawEdgeBox(0,0,w,h)
        draw.SimpleText("RAZZIA", "Trebuchet24", 100, 25, darkRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    timer.Create("razzia_blink_panel",0.05,8,function()
        razziaPanel.Blink = not razziaPanel.Blink
    end)
end

print("[luctus_razzia] cl loaded!")
