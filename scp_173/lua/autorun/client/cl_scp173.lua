--Luctus SCP173 System
--Made by OverlordAkise

local SCP173_BLINKING = false

net.Receive("luctus_scp173_blink",function()
    local duration = net.ReadFloat()
    SCP173_BLINKING = true
    timer.Simple(duration, function()
        SCP173_BLINKING = false
    end)
end)

--local ent = LocalPlayer():GetEyeTrace().Entity

hook.Add("PostDrawHUD", "luctus_scp173", function()
    if SCP173_BLINKING then
        surface.SetDrawColor(0,0,0,255)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    end
end)

hook.Add("InitPostEntity","lucid_scp173_createmove",function()
    timer.Simple(5,function()
        hook.Add("CreateMove", "luctus_scp173_disablemovement", function(cmd)
            if LocalPlayer():getJobTable().name == "SCP 173" then
                if LocalPlayer():Alive() then
                    cmd:RemoveKey(IN_JUMP)
                    cmd:RemoveKey(IN_DUCK)
                    cmd:RemoveKey(IN_USE)
                end
            end
        end)
    end)
end)


print("[SCP173] CL Loaded!")