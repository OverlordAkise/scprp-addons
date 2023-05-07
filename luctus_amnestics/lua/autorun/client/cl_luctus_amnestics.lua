--Luctus Amnestics
--Made by OverlordAkise

local color_white = Color(255,255,255,255)
local color_black = Color(0,0,0,255)


net.Receive("luctus_amnestics",function()
    local amnestic_type = net.ReadString()
    if not LUCTUS_AMNESTICS_LEVELS[amnestic_type] then
        print("[amnestics] Received invalid type!",amnestic_type)
        return
    end
    local w = ScrW()/2
    local h = ScrH()/2-150
    local vfunc = LUCTUS_AMNESTICS_LEVELS[amnestic_type]["display"]
    hook.Add("RenderScreenspaceEffects", "luctus_amnestics_blur", function()
        vfunc()
        draw.SimpleTextOutlined(LUCTUS_AMNESTICS_LEVELS[amnestic_type]["text"], "DermaLarge", w, h, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black)
    end)
    timer.Simple(LUCTUS_AMNESTICS_LEVELS[amnestic_type]["duration"],function()
        hook.Remove("RenderScreenspaceEffects", "luctus_amnestics_blur")
    end)
end)

--if for whatever reason the blur won't vanish run this LUA code on the player (via ULX or ply:SendLua):
--[[
hook.Remove("RenderScreenspaceEffects", "luctus_amnestics_blur")
--]]

print("[luctus_amnestics] cl loaded!")
