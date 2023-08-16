--Luctus Activityplan
--Made by OverlordAkise

local tag = "[ACTIVITYPLAN]"
local actText = "The activity changed to"
local color_white = Color(255,255,255,255)
local color_chat_tag = Color(255,100,50)
local color_black = Color(0,0,0,255)
local color_grey = Color(32, 34, 37)
local accentColor = Color(0, 195, 165)
local font = "DermaDefault"

luctusCurrentActivity = luctusCurrentActivity or "UNKNOWN"
LUCTUS_ACTIVITY_ENDTIME = LUCTUS_ACTIVITY_ENDTIME or 0
net.Receive("luctus_activity_sync",function()
    luctusCurrentActivity = net.ReadString()
    local timerTime = net.ReadInt(16)
    LUCTUS_ACTIVITY_ENDTIME = CurTime()+timerTime
    if not IsValid(LocalPlayer()) or not LUCTUS_ACTIVITY_SHOW_JOB[team.GetName(LocalPlayer():Team())] then return end
    chat.AddText(color_chat_tag,tag," ",color_white,actText," '"..luctusCurrentActivity.."'!")
    surface.PlaySound("HL1/fvox/bell.wav")
end)

local function DrawBox(x, y, w, h)
    draw.RoundedBox(0, x, y, w, h, accentColor)
    draw.RoundedBox(0, x+1, y+1, w-2, h-2, color_grey)
end

--EdgeHUD Design Support
if EdgeHUD then
    print("[luctus_activity] edgehud found, loading design")
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


hook.Add("HUDPaint","luctus_activity_display",function()
    if not LUCTUS_ACTIVITY_SHOW_JOB[team.GetName(LocalPlayer():Team())] then return end
    local timeLeft = math.max(0,LUCTUS_ACTIVITY_ENDTIME-CurTime())

    DrawBox(ScrW()-120, 210, 100, 50)
    draw.SimpleTextOutlined(luctusCurrentActivity, font, ScrW()-70, 220, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
    draw.SimpleTextOutlined(string.ToMinutesSeconds(timeLeft), font, ScrW()-70, 235, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
end)

print("[luctus_activity] CL loaded!")
