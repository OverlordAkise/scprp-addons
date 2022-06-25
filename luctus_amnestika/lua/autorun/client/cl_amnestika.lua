--Luctus Amnestika
--Made by OverlordAkise

local color_white = Color(255,255,255,255)
local color_black = Color(0,0,0,255)

net.Receive("luctus_amnestika",function()
    local amnestika_type = net.ReadString()
    if not AMNESTIKA_LEVELS[amnestika_type] then
        print("[amnestika] Received invalid type!")
        return
    end
    local w = ScrW()/2
    local h = ScrH()/2-150
    local strength = AMNESTIKA_LEVELS[amnestika_type][1]
    hook.Add("RenderScreenspaceEffects", "luctus_amnestika_blur", function()
        --Trial and error below me
        DrawMotionBlur( 0.1-(strength/200), 0.8+(strength/10), 0.01+(strength/150) )
        draw.SimpleTextOutlined(AMNESTIKA_LEVELS[amnestika_type][3], "DermaLarge", w, h, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black)
    end)
    timer.Simple(AMNESTIKA_LEVELS[amnestika_type][2],function()
        hook.Remove("RenderScreenspaceEffects", "luctus_amnestika_blur")
    end)
end)

--if for whatever reason the blur won't vanish run this LUA code on the player (via ULX or ply:SendLua):
--[[
hook.Remove("RenderScreenspaceEffects", "luctus_amnestika_blur")
--]]

print("amnestika loaded!")
