--Luctus SCP 026 DE
--Made by OverlordAkise

--If you look into her eyes you will be killed if you can not solve her puzzle

util.AddNetworkString("luctus_scp026de")

LUCTUS_SCP026DE_INFECTED = LUCTUS_SCP026DE_INFECTED or {}

function LuctusSCP026DEActivateTimer(ply)
    local sid = ply:SteamID()
    if LUCTUS_SCP026DE_INFECTED[sid] then return end
    LUCTUS_SCP026DE_INFECTED[sid] = true
    timer.Create("scp026de_"..sid,LUCTUS_SCP026DE_DEATH_TIMER,1,function()
        if IsValid(ply) then ply:Kill() end
        LUCTUS_SCP026DE_INFECTED[sid] = nil
    end)
    LuctusSCP026DENetwork(ply,true)
    hook.Run("LuctusSCP026DEAdded",ply)
end

function LuctusSCP026DERemove(ply)
    local sid = ply:SteamID()
    if not LUCTUS_SCP026DE_INFECTED[sid] then return end
    LUCTUS_SCP026DE_INFECTED[sid] = nil
    timer.Remove("scp026de_"..sid)
    LuctusSCP026DENetwork(ply,false)
    hook.Run("LuctusSCP026DERemoved",ply)
end

function LuctusSCP026DENetwork(ply,hasBeenInfected)
    net.Start("luctus_scp026de")
        net.WriteEntity(ply)
        net.WriteBool(hasBeenInfected)
    net.Broadcast()
end

net.Receive("luctus_scp026de",function(len,ply)
    if team.GetName(ply:Team()) ~= LUCTUS_SCP026DE_JOBNAME then return end
    local tply = net.ReadEntity()
    if not IsValid(tply) then return end
    local sid = tply:SteamID()
    local shouldKill = net.ReadBool()
    if not LUCTUS_SCP026DE_INFECTED[sid] then return end
    LuctusSCP026DERemove(tply)
    if shouldKill then
        DarkRP.notify(tply,0,5,"SCP-026-DE has taken your life")
        tply:TakeDamage(9999,ply,ply:GetActiveWeapon())
        hook.Run("LuctusSCP026DEKilled",ply,tply)
    else
        DarkRP.notify(tply,0,5,"You have been freed from SCP-026-DE")
        hook.Run("LuctusSCP026DESpared",ply,tply)
    end
end)

hook.Add("OnPlayerChangedTeam","luctus_scp966_view", function(ply, beforeNum, afterNum)
    LuctusSCP026DERemove(ply)
end)
hook.Add("PlayerDeath","luctus_scp026de",function(ply)
    LuctusSCP026DERemove(ply)
end)
hook.Add("PlayerDisconnected","luctus_scp026de",function(ply)
    LuctusSCP026DERemove(ply)
end)

hook.Add("PlayerSay","luctus_scp026de",function(ply,text)
    if not LUCTUS_SCP026DE_VISORJOBS[team.GetName(ply:Team())] then return end
    if text ~= "!visor" then return end
    local currentVisor = ply:GetNW2Bool("scp026de_visoron",false)
    if currentVisor then
        ply:SetNW2Bool("scp026de_visoron",false)
        DarkRP.notify(ply,0,3,"Removed visor")
    else
        ply:SetNW2Bool("scp026de_visoron",true)
        DarkRP.notify(ply,0,3,"Visor equipped")
    end
    
end)

print("[luctus_scp026de] sv loaded")
