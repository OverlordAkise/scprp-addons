--Luctus Amnestika
--Made by OverlordAkise

local color_white = Color(255,255,255,255)
local color_black = Color(0,0,0,255)

LUCTUS_AMNESTIKA_FUNCS = {
    ["A"] = function()
        DrawMotionBlur( 0.05, 0.95, 0.01 )
    end,
    ["B"] = function()
        DrawMotionBlur( 0.05, 0.95, 0.01 )
        DrawBloom( 0, 0.35, 3, 3, 2, 3, 1, 0, 0 )
    end,
    ["C"] = function()
        DrawMotionBlur( 0.05, 0.95, 0.01 )
        DrawBloom( 0, 0.55, 3, 3, 2, 3, 1, 0, 0 )
    end,
    ["D"] = function()
        DrawMotionBlur( 0.05, 0.95, 0.01 )
        DrawBloom( 0, 0.75, 3, 3, 2, 3, 1, 0, 0 )
    end,
    ["E"] = function()
        DrawMotionBlur( 0.05, 0.95, 0.01 )
        DrawBloom( 0, 0.75, 3, 3, 2, 3, 200, 0, 0 )
    end,
    ["F"] = function()
        DrawMotionBlur( 0.05, 0.95, 0.01 )
        DrawBloom( 0, 0.75, 3, 3, 2, 3, 200, 0, 0 )
    end
}


net.Receive("luctus_amnestika",function()
    local amnestika_type = net.ReadString()
    if not AMNESTIKA_LEVELS[amnestika_type] then
        print("[amnestika] Received invalid type!")
        return
    end
    local w = ScrW()/2
    local h = ScrH()/2-150
    local vfunc = LUCTUS_AMNESTIKA_FUNCS[amnestika_type]
    hook.Add("RenderScreenspaceEffects", "luctus_amnestika_blur", function()
        --Trial and error below me
        vfunc()
        draw.SimpleTextOutlined(AMNESTIKA_LEVELS[amnestika_type][2], "DermaLarge", w, h, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black)
    end)
    timer.Simple(AMNESTIKA_LEVELS[amnestika_type][1],function()
        hook.Remove("RenderScreenspaceEffects", "luctus_amnestika_blur")
    end)
end)

--if for whatever reason the blur won't vanish run this LUA code on the player (via ULX or ply:SendLua):
--[[
hook.Remove("RenderScreenspaceEffects", "luctus_amnestika_blur")
--]]

print("amnestika loaded!")
