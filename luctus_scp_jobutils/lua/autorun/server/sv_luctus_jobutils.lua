--Luctus SCP Jobutils
--Made by OverlordAkise

--CONFIG START

--[[
    The main config is to be set in the jobs.lua
    Available jobs configs:
    
    noUse = false,
    noJump = false,
    noDuck = false,
    noVoice = false,
    noSit = false,
    noFlashlight = false,
    noUse = false,
    noFootsteps = false,
    noWeaponPickup = false,
    customFootsteps = "fart.mp3",
    health = 100,
    armor = 0,
    walkspeed = 100,
    slowwalkspeed = 50,
    runspeed = 150,
    jumppower = 80,
    customJoinSound = "https://example.com/test.mp3",
    
--]]

--This is the "eye height" of the job
--If you are playing e.g. SCP999 then your viewpoint should be lower than a human
LuctusSCPUtilsJobOffsets = {
    ["SCP 999"] = 40,
    ["SCP 066"] = 30,
    ["SCP 682"] = 50,
    ["SCP 173"] = 80,
    ["SCP 131"] = 30,
    ["SCP 939"] = 55,
    --testing:
    ["Hobo"] = 20,
}

--These are the hitboxes of jobs
--You only have to change the 3rd number of max
--This is the height of the player
--On e.g. SCP999 the "hitbox" should be lower than a human
LuctusSCPJobHulls = {
    ["SCP 682"] = {
        min = Vector(-16,-16,0),
        max = Vector(16,16,54)
    },
    ["SCP 999"] = {
        min = Vector(-16,-16,0),
        max = Vector(16,16,45)
    },
    ["SCP 066"] = {
        min = Vector(-16,-16,0),
        max = Vector(16,16,30)
    },
    ["SCP 131"] = {
        min = Vector(-16,-16,0),
        max = Vector(16,16,30)
    },
    --testing:
    ["Hobo"] = {
        min = Vector(-16,-16,0),
        max = Vector(16,16,20)
    }
}

--CONFIG END

util.AddNetworkString("luctus_jobutils_hull")
util.AddNetworkString("luctus_jobutil_joinsound")

function LuctusSCPResetJobUtils(ply)
    ply.noVoice = false
    ply.noSit = false
    ply.noFlashlight = false
    ply.noUse = false
    ply.noFootsteps = false
    ply.customFootsteps = nil
    ply.noWeaponPickup = false
    ply:SetMaxArmor(100)
end

hook.Add("PlayerInitialSpawn","luctus_scp_jobutils",function(ply)
    LuctusSCPResetJobUtils(ply)
end)

hook.Add("OnPlayerChangedTeam", "luctus_scp_jobutils", function(ply, beforeNum, afterNum)
    LuctusSCPResetJobUtils(ply)
    local tab = RPExtraTeams[afterNum]
    if tab.noVoice then
        ply.noVoice = true
    end
    if tab.noSit then
        ply.noSit = true
    end
    if tab.noFlashlight then
        ply.noFlashlight = true
    end
    if tab.noUse then
        ply.noUse = true
    end
    if tab.noFootsteps then
        ply.noFootsteps = true
    end
    if tab.customFootsteps then
        ply.customFootsteps = tab.customFootsteps
    end
    if tab.customJoinSound then
        net.Start("luctus_jobutil_joinsound")
            net.WriteString(tab.customJoinSound)
        net.Broadcast()
    end
end)

hook.Add("PlayerSwitchFlashlight", "luctus_scp_jobutils", function(ply, wantsToTurnOn)
    if ply.noFlashlight and wantsToTurnOn then return false end
end)

hook.Add("PlayerCanHearPlayersVoice", "luctus_scp_jobutils", function(listener, talker)
    if talker.noVoice then return false end
end)

hook.Add("OnPlayerSit", "luctus_scp_jobutils", function(ply)
    if ply.noSit then return false end
    if ply:HasWeapon("weapon_handcuffed") then return false end
end)

hook.Add("PlayerUse", "luctus_scp_jobutils", function(ply, ent)
    if ply.noUse then return false end
end)

hook.Add("PlayerFootstep", "luctus_scp_jobutils", function(ply)
    if ply.customFootsteps then
        ply:EmitSound(ply.customFootsteps)
        return true
    end
    if ply.noFootsteps then return true end
end)

hook.Add("PostPlayerDeath", "luctus_scp_jobutils", function(ply)
    ply.noWeaponPickup = false
end)

hook.Add("PlayerCanPickupWeapon", "luctus_scp_jobutils", function(ply)
    if ply.noWeaponPickup then return false end
end)

hook.Add("PlayerSpawn", "luctus_scp_jobutils_setdelayed", function(ply)
    local tab = RPExtraTeams[ply:Team()]
    timer.Simple(0.3,function()
        if not IsValid(ply) then return end
        if tab.noWeaponPickup then
            ply.noWeaponPickup = true
        end
        if tab.health then
            ply:SetHealth(tab.health)
            ply:SetMaxHealth(tab.health)
        end
        if tab.armor then
            ply:SetArmor(tab.armor)
            ply:SetMaxArmor(tab.armor)
        end
        if tab.walkspeed then
            ply:SetWalkSpeed(tab.walkspeed)
        end
        if tab.slowwalkspeed then
            ply:SetSlowWalkSpeed(tab.slowwalkspeed)
        end
        if tab.runspeed then
            ply:SetRunSpeed(tab.runspeed)
        end
        if tab.jumppower then
            ply:SetJumpPower(tab.jumppower)
        end
        if LuctusSCPUtilsJobOffsets[tab.name] then
            ply:SetViewOffset(Vector(0,0,LuctusSCPUtilsJobOffsets[tab.name]))
        else
            ply:SetViewOffset(Vector(0,0,64)) --Default
        end
        if LuctusSCPJobHulls[tab.name] then
            local vecs = LuctusSCPJobHulls[tab.name]
            ply:SetHull(vecs.min,vecs.max)
            --ply:SetHullDuck(vecs.min,vecs.max)
            net.Start("luctus_jobutils_hull")
                net.WriteEntity(ply)
                net.WriteVector(vecs.min)
                net.WriteVector(vecs.max)
            net.Broadcast()
        end

    end)
end)


--noVoice allow if in support
hook.Add("PlayerSay","luctus_scp_jobutils_noVoice",function(ply,text,team)
    if ply:IsAdmin() and string.StartWith(text,"!togglevoice") then
        local name = string.Split(text,"!togglevoice ")
        local targetPlayer = LuctusUtilGetPlyByName(name[2])
        if targetPlayer then
            if targetPlayer.noVoice then
                targetPlayer.noVoice = false
                ply:PrintMessage(HUD_PRINTTALK, "Toggled noVoice for player OFF!")
            else
                targetPlayer.noVoice = true
                ply:PrintMessage(HUD_PRINTTALK, "Toggled noVoice for player ON!")
            end
        end
    end
end)

function LuctusUtilGetPlyByName(name)
    local myply = nil
    for k,v in pairs(player.GetAll()) do
        local ss,se = string.find(string.lower(v:Nick()), string.lower(name))
        if ss then
            if myply != nil then return nil end
            myply = v
        end
    end
    return myply
end

print("[luctus_jobutils] SV loaded!")
