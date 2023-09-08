--Luctus Keycard Animation
--Made by OverlordAkise

local endRange = 0
local animationTime = 0.2
local curwep = nil

net.Receive("guthscp_animation",function()
    --if not LocalPlayer():GetActiveWeapon().GuthSCPLVL then return end
    local ply = LocalPlayer()
    local start = SysTime()
    if net.ReadBool() then
        if ply:GetActiveWeapon().GuthSCPLVL then
            curwep = ply:GetActiveWeapon()
        end
        timer.Create("guthscp_animation",0,100,function()
            if not ply:GetActiveWeapon().GuthSCPLVL then return end
            ply:GetActiveWeapon().ViewModelFOV = Lerp( (SysTime() - start)/animationTime, 55, 100 )
            endRange = Lerp( (SysTime() - start)/animationTime, 55, 100 )
        end)
    else
        if not ply:GetActiveWeapon().GuthSCPLVL then
            curwep.ViewModelFOV = 55
            return
        end
        timer.Create("guthscp_animation",0,100,function()
            if not ply:GetActiveWeapon().GuthSCPLVL then return end
            ply:GetActiveWeapon().ViewModelFOV = Lerp( (SysTime() - start)/animationTime, endRange, 55 )
        end)
    end
end)

print("[luctus_keycard_animation] cl loaded")
