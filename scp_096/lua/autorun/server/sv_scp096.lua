--Luctus SCP096 System
--Made by OverlordAkise

--ADD THE FOLLOWING TO YOUR WORKSHOP COLLECTION:
--https://steamcommunity.com/sharedfiles/filedetails/?id=1315125663
-- ^ Playermodel
--https://steamcommunity.com/sharedfiles/filedetails/?id=2488399203
-- ^ Hand model

resource.AddWorkshop("1315125663") -- SCP096 Playermodel
resource.AddWorkshop("2488399203") -- SCP096 Hand model

util.AddNetworkString("luctus_scp096_update")

LuctusLog = LuctusLog or function()end

scp096_ply = nil
scp096_hunted_players = {}
scp096_hunting = false

hook.Add("OnPlayerChangedTeam","luctus_scp096", function(ply, beforeNum, afterNum)
    if string.EndsWith(RPExtraTeams[afterNum].name,"096") then
        scp096_ply = ply
    end
    if string.EndsWith(RPExtraTeams[beforeNum].name,"096") then
        scp096_ply:StopSound("096/scream.wav")
        scp096_ply:StopSound("096/crying1.wav")
        scp096_ply = nil
        scp096_hunted_players = {}
    end
end)
hook.Add("PlayerDisconnected", "luctus_scp096_plynil", function(ply)
    if ply == scp096_ply then
        scp096_ply = nil
        scp096_hunted_players = {}
    end
end)

function Luctus096HandlePlayerDeath(ply)
    luctus_update_hunted(ply,false)
    if ply == scp096_ply then
        scp096_ply:StopSound("096/scream.wav")
        scp096_ply:StopSound("096/crying1.wav")
        scp096_hunted_players = {}
        net.Start("luctus_scp096_update")
            net.WriteTable({})
        net.Send(scp096_ply)
        LuctusLog("scp",ply:Nick().."("..ply:SteamID()..") died as SCP096, rage ended.")
    end
    if ply:GetNW2Bool("scp096_bag",false) then
        ply:SetNW2Bool("scp096_bag",false)
    end
end

hook.Add("PostPlayerDeath", "luctus_scp096_plynil", Luctus096HandlePlayerDeath)
--gdeathsystem:
hook.Add("PlayerDeath.g", "luctus_scp096_plynil_gd", Luctus096HandlePlayerDeath)



function luctus_update_hunted(ply,newHunted)
    local new = false
    if newHunted and not table.HasValue(scp096_hunted_players,ply) then
        table.insert(scp096_hunted_players,ply)
        new = true
        LuctusLog("scp",ply:Nick().."("..ply:SteamID()..") is being hunted by SCP096.")
    end
    if not newHunted and table.HasValue(scp096_hunted_players,ply) then
        table.RemoveByValue(scp096_hunted_players,ply)
        new = true
        LuctusLog("scp",ply:Nick().."("..ply:SteamID()..") is not being hunted by SCP096 anymore.")
    end

    if #scp096_hunted_players > 0 then
        if not scp096_hunting and new then
            scp096_ply:EmitSound( "096/scream.wav" ) --only scream if triggered first time
            LuctusLog("scp",ply:Nick().."("..ply:SteamID()..") enraged SCP096.")
        end
        scp096_hunting = true
        if new then
            scp096_ply:SetRunSpeed(600)
            scp096_ply:SetWalkSpeed(600)
            scp096_ply:GetActiveWeapon():SetHoldType( "fist" )
        end
    else
        scp096_hunting = false
        if new then
            scp096_ply:SetRunSpeed(240)
            scp096_ply:SetWalkSpeed(160)
            scp096_ply:GetActiveWeapon():SetHoldType( "normal" )
            LuctusLog("scp",ply:Nick().."("..ply:SteamID()..") ended rage of SCP096.")
        end
    end
    if new then
        net.Start("luctus_scp096_update")
            net.WriteTable(scp096_hunted_players)
        net.Send(scp096_ply)
    end
end


--Recontainment logic

function LuctusRecontain096SCP(ply)
    ply:SetNW2Bool("scp096_bag",true)
    --remove hunt if applicable
    if scp096_ply and scp096_ply == ply then
        scp096_ply:StopSound( "096/scream.wav" )
        scp096_ply:StopSound( "096/crying1.wav" )
        scp096_hunted_players = {}
        scp096_hunting = false
        scp096_ply:SetRunSpeed(240)
        scp096_ply:SetWalkSpeed(160)
        scp096_ply:GetActiveWeapon():SetHoldType( "normal" )
        net.Start("luctus_scp096_update")
            net.WriteTable(scp096_hunted_players)
        net.Send(scp096_ply)
        LuctusLog("scp",ply:Nick().."("..ply:SteamID()..") recontained SCP096 with a bag.")
    end
end

hook.Add("PlayerUse", "luctus_scp096_bagremover", function(ply, ent)
    if IsValid(ent) and ent:IsPlayer() and ent:GetNW2Bool("scp096_bag",false) then
        ent:SetNW2Bool("scp096_bag",false)
        ply:Give("weapon_scp096_rec")
        if scp096_ply and scp096_ply == ent then
            LuctusLog("scp",ply:Nick().."("..ply:SteamID()..") removed the bag from SCP096.")
        end
    end
end)

function LuctusRecontain096Remove(ply)
    ply:SetNW2Bool("scp096_bag",false)
end

hook.Add("PostPlayerDeath", "luctus_scp096_rec", LuctusRecontain096Remove)
--gdeathsystem:
hook.Add("PlayerDeath.g", "luctus_scp096_rec_gd", LuctusRecontain096Remove)



if LUCTUS_SCP096_GDEATHSYSTEM then
    local meta = FindMetaTable("Player")
    meta.oldTurnIntoRagdoll = meta.TurnIntoRagdoll
    function meta:TurnIntoRagdoll(knof, vel, dmg, time)
        if (MedConfig.EnableRagdoll and !self:IsKnocked()) then
            hook.Run("PlayerDeath.g",self)
        end
        self:oldTurnIntoRagdoll(knof,vel,dmg,time)
    end
    print("[SCP096] Added hook to gDeathSystem")
end

print("[SCP096] SV Loaded!")
