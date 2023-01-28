--Luctus Activityplan
--Made by OverlordAkise

luctusCurrentActivity = "UNKNOWN"


net.Receive("luctus_activity_sync",function()
    luctusCurrentActivity = net.ReadString()
    local timerTime = net.ReadInt(16)
    timer.Create("luctus_activity_timer",timerTime,1,function()end)
    chat.AddText(textColor, "The activity changed to "..luctusCurrentActivity.."!")
    surface.PlaySound("HL1/fvox/bell.wav")
end)


local color_white = Color(255,255,255,255)
local color_black = Color(0,0,0,255)
local color_grey = Color(32, 34, 37)
local textColor = Color(0, 195, 165)

hook.Add("HUDPaint","luctus_activity_display",function()
    local timeLeft = timer.TimeLeft("luctus_activity_timer")
    if not timeLeft then return end
    local minutes = math.floor(timeLeft/60)
    if string.len(minutes) < 2 then minutes = "0"..minutes end
    local seconds = (math.Round(timeLeft)%60)
    if string.len(seconds) < 2 then seconds = "0"..seconds end
    draw.RoundedBox(0, ScrW()-120, 210, 100, 50, textColor)
    draw.RoundedBox(0, ScrW()-119, 211, 98, 48, color_grey)
    draw.SimpleTextOutlined(luctusCurrentActivity, "DermaDefault", ScrW()-70, 220, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
    draw.SimpleTextOutlined(minutes..":"..seconds, "DermaDefault", ScrW()-70, 235, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
end)

print("[luctus_activity] CL loaded!")
