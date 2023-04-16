--Luctus SCP049 System
--Made by OverlordAkise

util.AddNetworkString("luctus_scp049_mixing")
resource.AddWorkshop("183901628") -- SCP049 Playermodel

scp049_effects = {
    ["Nothing"] = 60,
    ["Jumpheight"] = 20,
    ["Health"] = 15,
    ["Damage"] = 10,
    ["Speed"] = 10,
    ["Godly"] = 5,
}

scp049_effect_functions = {
    ["Nothing"] = function(ply) end, 
    ["Jumpheight"] = function(ply)
        ply:SetJumpPower(400)
    end,
    ["Health"] = function(ply)
        ply:SetHealth(2000)
        ply:SetMaxHealth(2000)
    end,
    ["Damage"] = function(ply)
        ply:GetWeapons()[1].Primary.Damage = 60
    end,
    ["Speed"] = function(ply)
        ply:SetRunSpeed(ply:GetRunSpeed()*2)
        ply:SetWalkSpeed(ply:GetWalkSpeed()*2)
        ply:SetDuckSpeed(ply:GetWalkSpeed()*2)
    end,
    ["Godly"] = function(ply)
        local spawnPos = ply:GetPos()
        ply:Spawn()
        ply:SetPos(spawnPos)
    end,
}

function LuctusSCP049SpawnZombie(mixedFunc,ply,funcName)
    local spawnPos = ply:GetPos()
    ply:Spawn()
    timer.Simple(0.1,function()--needed for spawnPos
        if not IsValid(ply) then return end
        ply:SetPos(spawnPos)
        if funcName == "Godly" then return end
        ply.scp049_oldJob = ply:getDarkRPVar("job")
        ply:setDarkRPVar("job","SCP049-2")
        ply:StripWeapons()
        ply:Give("weapon_scp049_2")
        ply:SetModel(SCP049_ZOMBIE_MODEL)
        mixedFunc(ply)
    end)
end

scp049_mixtable = scp049_mixtable or {}
function luctusMixTable()
    scp049_mixtable = {}
    local chc = 0
    local lootChc = {}
    local lootClass = ""
    local loot
    for k, v in pairs ( scp049_effects ) do
        lootChc[k] = { min = chc+1, max = chc + v }
        chc = chc + v
    end
    print("[SCP049] The Mixtable is:")
    for i=1,7 do
        scp049_mixtable[i] = {}
        for j=1,7 do
            local rNumber = math.random( 1, chc )
            for k, v in pairs ( lootChc ) do
                if ( rNumber >= v.min and rNumber <= v.max ) then
                    lootClass = k
                    print("["..i.."]["..j.."] = "..k)
                    scp049_mixtable[i][j] = k
                end
            end
        end
    end
    print("[SCP049] End of mixtable")
end

hook.Add("OnPlayerChangedTeam", "luctus_scp049_mix_new", function(ply, beforeNum, afterNum)
    if string.EndsWith(RPExtraTeams[afterNum].name,"049") then
        luctusMixTable()
    end
end)

hook.Add("PlayerSpawn", "luctus_scp049_resetjob", function(ply)
    if ply.scp049_oldJob then
        ply:setDarkRPVar("job",ply.scp049_oldJob)
        ply.scp049_oldJob = nil
    end
end)

net.Receive("luctus_scp049_mixing",function(len,ply)
    ply.scp049_col_one = math.Clamp(net.ReadInt(17),1,7)
    ply.scp049_col_two = math.Clamp(net.ReadInt(17),1,7)
    ply:PrintMessage(HUD_PRINTTALK, "Your mixed ID is "..ply.scp049_col_one..ply.scp049_col_two)
end)

print("[SCP049] SV Loaded!")
