--Luctus Activityplan
--Made by OverlordAkise

local tag = "[ACTIVITYPLAN]"
local actText = "The activity changed to"
local color_white = Color(255,255,255)
local color_tag = Color(255,100,50)

luctusCurrentActivity = "UNKNOWN"
net.Receive("luctus_activity_sync",function()
    luctusCurrentActivity = net.ReadString()
    local timerTime = net.ReadInt(16)
    timer.Create("luctus_activity_timer",timerTime,1,function()end)
    if not IsValid(LocalPlayer()) or not LUCTUS_ACTIVITY_SHOW_JOB[team.GetName(LocalPlayer():Team())] then return end
    chat.AddText(color_tag,tag," ",color_white,actText," '"..luctusCurrentActivity.."'!")
    surface.PlaySound("HL1/fvox/bell.wav")
end)


local color_white = Color(255,255,255,255)
local color_black = Color(0,0,0,255)
local color_grey = Color(32, 34, 37)
local accentColor = Color(0, 195, 165)
local font = "DermaDefault"


local function DrawBox(x, y, w, h)
    draw.RoundedBox(0, x, y, w, h, accentColor)
    draw.RoundedBox(0, x+1, y+1, w-2, h-2, color_grey)
end

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
    local timeLeft = timer.TimeLeft("luctus_activity_timer")
    if not timeLeft then timeLeft = 0 end
    local minutes = math.floor(timeLeft/60)
    if string.len(minutes) < 2 then minutes = "0"..minutes end
    local seconds = (math.Round(timeLeft)%60)
    if string.len(seconds) < 2 then seconds = "0"..seconds end
    DrawBox(ScrW()-120, 210, 100, 50)
    draw.SimpleTextOutlined(luctusCurrentActivity, font, ScrW()-70, 220, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
    draw.SimpleTextOutlined(minutes..":"..seconds, font, ScrW()-70, 235, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
end)

print("[luctus_activity] CL loaded!")
