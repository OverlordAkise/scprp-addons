--Luctus SCP Jobutils
--Made by OverlordAkise

luctus_scp_noUse = false
luctus_scp_noJump = false
luctus_scp_noDuck = false

function LuctusSCPResetJobUtils()
    luctus_scp_noUse = false
    luctus_scp_noJump = false
    luctus_scp_noDuck = false
end


hook.Add("OnPlayerChangedTeam", "luctus_scp_jobutils", function(ply, beforeNum, afterNum)
    if ply ~= LocalPlayer() then return end
    LuctusSCPResetJobUtils()
    local tab = RPExtraTeams[afterNum]
    if tab.noUse then
        luctus_scp_noUse = true
    end
    if tab.noJump then
        luctus_scp_noJump = true
    end
    if tab.noDuck then
        luctus_scp_noDuck = true
    end
end)


hook.Add("CreateMove", "luctus_scp_jobutils", function(cmd)
    if LocalPlayer():Alive() then
        if luctus_scp_noUse then
            cmd:RemoveKey(IN_USE)
        end
        if luctus_scp_noJump then
            cmd:RemoveKey(IN_JUMP)
        end
        if luctus_scp_noDuck then
            cmd:RemoveKey(IN_DUCK)
        end
    end
end)

net.Receive("luctus_jobutils_hull",function()
    local ply = net.ReadEntity()
    local vecMin = net.ReadVector()
    local vecMax = net.ReadVector()
    ply:SetHull(vecMin,vecMax)
    --ply:SetHullDuck(vecMin,vecMax)
end)

net.Receive("luctus_jobutil_joinsound",function()
    local soundString = net.ReadString()
    if string.StartsWith(soundString,"http") then
        sound.PlayURL(soundString,"",function(s,errorid,errorname)
            if IsValid(s) then
                s:Play()
            else
                print("ERROR PLAYING JOINSOUND")
                print(soundString)
                print(errorid)
                print(errorname)
            end
        end)
    else
        surface.PlaySound(soundString)
    end
end)

hook.Add("PlayerFootstep","luctus_scp_jobutils",function(ply)
    if ply:getJobTable().noFootsteps or ply:getJobTable().customFootsteps then return true end
end)

print("[luctus_jobutils] CL loaded!")

