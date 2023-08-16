--Luctus sNLR
--Made by OverlordAkise

LUCTUS_NLR_ENDTIME = LUCTUS_NLR_ENDTIME or 0

local color_white = Color(255,255,255,255)
local color_black = Color(0,0,0,255)
local color_grey = Color(32, 34, 37)
local accentColor = Color(0, 195, 165)
local font = "DermaDefault"

net.Receive("luctus_snlr",function()
    local ntime = net.ReadUInt(13)
    if ntime == 0 then
        chat.AddText(Color(255,0,0),"[NLR]",color_white," Your NLR ended!")
        surface.PlaySound("HL1/fvox/bell.wav")
        LUCTUS_NLR_ENDTIME = 0
    else
        LUCTUS_NLR_ENDTIME = CurTime()+ntime
    end
end)

local function DrawBox(x, y, w, h)
    draw.RoundedBox(0, x, y, w, h, accentColor)
    draw.RoundedBox(0, x+1, y+1, w-2, h-2, color_grey)
end

if EdgeHUD then
    print("[luctus_snlr] edgehud found, loading design")
    font = "EdgeHUD:Small"
    DrawBox = function(x,y,width,height,edgeSize,col)
        if not EdgeHUD.Colors or not EdgeHUD.Colors["White_Corners"] then return end
        surface.SetDrawColor(EdgeHUD.Colors["Black_Transparent"])
        surface.DrawRect(x, y, width, height)

        surface.SetDrawColor(EdgeHUD.Colors["White_Outline"])
        surface.DrawOutlinedRect(x, y, width, height)

        surface.SetDrawColor(EdgeHUD.Colors["White_Corners"])
        EdgeHUD.DrawEdges(x, y, width, height, 10)
    end
end

hook.Add("HUDPaint","luctus_snlr",function()
    if LUCTUS_NLR_ENDTIME == 0 then return end
    
    DrawBox(ScrW()/2-50, 60, 100, 50)
    draw.SimpleTextOutlined("NLR", font, ScrW()/2, 70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
    draw.SimpleTextOutlined(string.ToMinutesSeconds(math.max(0,LUCTUS_NLR_ENDTIME-CurTime())), font, ScrW()/2, 85, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
end)

print("[luctus_snlr] cl loaded")
