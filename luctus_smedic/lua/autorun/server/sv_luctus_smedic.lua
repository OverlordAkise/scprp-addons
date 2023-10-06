--Luctus Medic (SCP)
--Made by OverlordAkise

util.AddNetworkString("luctus_medic_deathscreen")

resource.AddWorkshop("1438545068")


LUCTUS_MEDIC_SCREAMS = {
    "vo/npc/male01/ow01.wav",
    "vo/npc/male01/ow02.wav",
    "vo/npc/male01/pain01.wav",
    "vo/npc/male01/pain02.wav",
    "vo/npc/male01/pain03.wav",
    "vo/npc/male01/pain04.wav",
    "vo/npc/male01/pain05.wav",
    "vo/npc/male01/pain06.wav",
    "vo/npc/male01/pain07.wav",
    "vo/npc/male01/pain08.wav",
    "vo/npc/male01/pain09.wav",
}

function LuctusMedicPlayScream(ent)
    ent:EmitSound(LUCTUS_MEDIC_SCREAMS[math.random(1, #LUCTUS_MEDIC_SCREAMS)],256)
end

---NEW

hook.Add("PlayerDisconnected","luctus_smedic_ragcleanup",function(ply)
    if ply.deathRagdoll and IsValid(ply.deathRagdoll) then
        ply.deathRagdoll:Remove()
    end
end)

hook.Add("PlayerSpawn","luctus_smedic_ragcleanup",function(ply)
    ply.isDead = false
    if IsValid(ply.deathRagdoll) then
        ply.deathRagdoll:Remove()
    end
    ply:SetShouldServerRagdoll(true)
    ply:ResetMedicState()
    net.Start("luctus_medic_deathscreen")
        net.WriteInt(-1,15)
    net.Send(ply)
    ply:AddBleeding(-100)
end)

hook.Add("CreateEntityRagdoll","luctus_smedic_ragowner",function(ply,rag)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if IsValid(ply.deathRagdoll) then
        local oldDeathRagdoll = ply.deathRagdoll
        oldDeathRagdoll:Remove()
    end
    ply.deathRagdoll = rag
    rag.deathOwner = ply
    
    rag:SetOwner(ply)
    rag.deathRagdollHP = LUCTUS_MEDIC_RAGDOLL_HEALTH
    rag:SetNW2Int("state","bleeding out")
    rag.isStabilized = false
    rag.isDeathRagdoll = true
    rag.isBleedingOut = true
    rag.isFullyDead = false
    if LUCTUS_MEDIC_IMMUNE_TEAMS[team.GetName(ply:Team())] then
        rag.isFullyDead = true
        rag.isBleedingOut = false
        rag:SetNW2Int("state","deceased")
    end
end)

--For weapons
hook.Add("PlayerDeath","luctus_smedic_weapons",function(ply)
    ply.deathWeapons = {}
    for k,v in pairs(ply:GetWeapons()) do
        table.insert(ply.deathWeapons,v:GetClass())
    end
end)

--No Voice chat if fullyDead
hook.Add("PlayerCanHearPlayersVoice", "luctus_smedic_voice", function(listener, talker)
    if talker.isFullyDead then return false end
end)

hook.Add("PostPlayerDeath","luctus_smedic_deathscreen",function(ply)

    if ply:getDarkRPVar("AFK") then return end
    net.Start("luctus_medic_deathscreen")

    local plyTeam = team.GetName(ply:Team())
    if LUCTUS_MEDIC_IMMUNE_TEAMS[plyTeam] and not LUCTUS_MEDIC_IMMUNE_BUT_REVIVEABLE[plyTeam] then
        --Instantly Dead
        ply.respawnTime = CurTime()+LUCTUS_MEDIC_RESPAWN_TIME
        net.WriteInt(LUCTUS_MEDIC_RESPAWN_TIME,15)
        net.WriteBool(true)
    else
        --Bleeding out, = reviveable
        ply.respawnTime = CurTime()+LUCTUS_MEDIC_BLEEDOUT_TIME
        net.WriteInt(LUCTUS_MEDIC_BLEEDOUT_TIME,15)
        net.WriteBool(false)
    end  
    net.Send(ply)
    
    ply:AddBleeding(-100)
    ply.isDead = true
    timer.Simple(0.5,function()
        if IsValid(ply.deathRagdoll) then
            ply:Spectate(OBS_MODE_CHASE)
            ply:SpectateEntity(ply.deathRagdoll)
            ply.deathRagdoll:SetNW2Int("respawnTime",ply.respawnTime)
        end
    end)
    LuctusMedicPlayScream(ply)
end)

--Unnecessary? Because spectator cant respawn
hook.Add("PlayerDeathThink","luctus_smedic_deathscreen",function(ply)
    if not ply.respawnTime then return true end
    return ply.respawnTime < CurTime()
end)

hook.Add("KeyPress","luctus_smedic_respawn",function(ply,key)
    if key == 1 and ply.isDead and ply.respawnTime and ply.respawnTime < CurTime() then
        ply:Spawn()
    end
end)

hook.Add("PlayerUse","luctus_smedic_stabilize",function(ply,ent)
    if not IsValid(ent) or not ent.isDeathRagdoll or ent.isStabilized or not ent.isBleedingOut or ent.isFullyDead then return end
    ent.isStabilized = true
    local owner = ent.deathOwner
    if not IsValid(owner) then return end
    owner.respawnTime = owner.respawnTime + LUCTUS_MEDIC_STABILIZE_TIME_ADDED
    ent:SetNW2Int("respawnTime",owner.respawnTime)
    ent:SetNW2String("state","bleeding out (stabilized)")
    DarkRP.notify(ply,0,5,"You stabilized your target!")
end)

hook.Add("playerCanChangeTeam","luctus_smedic_anti_abuse",function(ply,team,force)
    if not force and ply.isDead and not LUCTUS_MEDIC_DEAD_CAN_CHANGE_TEAM then
        return false, "You can't change job while dead!"
    end
end)

---NEW END

hook.Add("EntityTakeDamage", "luctus_smedic_bleed", function(ent, dmginfo)
    if LUCTUS_MEDIC_RAGDOLL_KILLABLE and ent.isDeathRagdoll and ent.isBleedingOut and dmginfo:IsBulletDamage() then
        ent.deathRagdollHP = math.max(0,ent.deathRagdollHP - dmginfo:GetDamage())
        if ent.deathRagdollHP <= 0 then
            ent.isBleedingOut = false
            ent.isFullyDead = true
            local ply = ent.deathOwner
            if not IsValid(ply) then return end
            ply.respawnTime = CurTime()+LUCTUS_MEDIC_RESPAWN_TIME
            ent:SetNW2Int("respawnTime",ply.respawnTime)
            ent:SetNW2Int("state","deceased")
            LuctusMedicPlayScream(ent)
            net.Start("luctus_medic_deathscreen")
                net.WriteInt(LUCTUS_MEDIC_RESPAWN_TIME,15)
                net.WriteBool(true)
            net.Send(ply)
            return true
        end
    end

    if not ent:IsPlayer() then return end
    if LUCTUS_MEDIC_IMMUNE_TEAMS[team.GetName(ent:Team())] then return end
    if ent:HasGodMode() then dmginfo:SetDamage(0) return true end

    if ent:GetNW2Int("chest",100) < 100 then
        local percent = 1 - (ent:GetNW2Int("chest",100) / 100)
        dmginfo:ScaleDamage(1 + percent * LUCTUS_MEDIC_DAMAGE_CHEST)
    end

    if not IsValid(dmginfo:GetAttacker()) then return end

    if LUCTUS_MEDIC_CUSTOM_DAMAGE_SCALING then 
        local hitgroup = ent:LastHitGroup()
        dmginfo:ScaleDamage(LUCTUS_MEDIC_CUSTOM_DAMAGE_SCALE[hitgroup] or 1)
    end
    

    if LUCTUS_MEDIC_DAMAGE_ENABLED then
        local hitgroup = ent:LastHitGroup()
        local groupVar = LUCTUS_MEDIC_HITGROUPS[hitgroup]
        if groupVar then
            ent:SetNW2Int(groupVar,math.max(ent:GetNW2Int(groupVar,100)-dmginfo:GetDamage(),0))
        end
    end

    if LUCTUS_MEDIC_BLEEDING_ENABLED and dmginfo:IsBulletDamage() and math.random(1,100) < LUCTUS_MEDIC_BLEED_CHANCE then
        ent:AddBleeding(dmginfo:GetDamage() * LUCTUS_MEDIC_BLEEDING_RATIO)
        ent.BleedingAttacker = dmginfo:GetAttacker()
    end
end)

function LuctusMedicReturnWeapons(ply)
    if not ply.deathWeapons or table.Count(ply.deathWeapons) == 0 then return end
    for k,v in pairs(ply.deathWeapons) do
        ply:Give(v)
    end
    ply.deathWeapons = {}
end

timer.Create("luctus_smedic_bleeding",1,0,function()
    if not LUCTUS_MEDIC_BLEEDING_ENABLED then return end
    for k,ply in pairs(player.GetAll()) do
        if LUCTUS_MEDIC_IMMUNE_TEAMS[team.GetName(ply:Team())] then continue end
        if not ply:IsBleeding() then continue end
        if math.random(1,100) > ply:GetBleeding() then continue end
        ply:TakeDamage(LUCTUS_MEDIC_BLEED_DAMAGE, ply.BleedingAttacker, ply.BleedingAttacker)
        util.Decal("Blood", ply:GetPos(), Vector(0,0,-64), ply)
        ply:AddBleeding(-1)
    end
end)

hook.Add("PlayerDeathSound", "luctus_smedic_hidesound", function()
    return true
end)

hook.Add("CanPlayerSuicide", "luctus_smedic_disallow_suicide", function(ply)
    return false
end)

--Compatibility:
local meta = FindMetaTable("Player")
--self:IsKnocked()
function meta:TurnIntoRagdoll()end

--Fix jobchange deathscreen
hook.Add("InitPostEntity","luctus_smedic_check",function()
    if not GAMEMODE then return end
    if GAMEMODE.Config.norespawn == false and GAMEMODE.Config.instantjob == false then
        print("[luctus_smedic] WARNING: setting GM.Config.instantjob to true for better compatibility")
        GAMEMODE.Config.instantjob = true
    end
end)

print("[luctus_smedic] sv loaded")
