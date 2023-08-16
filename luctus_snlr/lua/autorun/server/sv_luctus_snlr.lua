--Luctus sNLR
--Made by OverlordAkise

--How many seconds NLR lasts for
LUCTUS_NLR_TIME = 30


--CONFIG END

util.AddNetworkString("luctus_snlr")

hook.Add("PlayerSpawn","luctus_snlr",function(ply)
    LuctusNLRStart(ply)
end)

function LuctusNLRStart(ply)
    local ntime = LUCTUS_NLR_TIME
    local etime = CurTime()+ntime
    ply.NLREndTime = etime
    timer.Create(ply:SteamID().."_nlr",ntime,1,function()
        if not IsValid(ply) then return end
        LuctusNLRStop(ply)
    end)
    net.Start("luctus_snlr")
        net.WriteUInt(ntime,13)
    net.Send(ply)
    hook.Run("LuctusNLRStart",ply,ntime,etime)
end

function LuctusNLRStop(ply)
    if timer.Exists(ply:SteamID().."_nlr") then
        timer.Remove(ply:SteamID().."_nlr")
    end
    ply.NLREndTime = 0
    net.Start("luctus_snlr")
        net.WriteUInt(0,13)
    net.Send(ply)
    hook.Run("LuctusNLREnd",ply)
end

function LuctusNLRIsActive(ply)
    if timer.Exists(ply:SteamID().."_nlr") or (ply.NLREndTime and ply.NLREndTime > CurTime()) then return true end
    return false
end

print("[luctus_snlr] sv loaded")
