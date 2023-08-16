--Luctus sNLR
--Made by OverlordAkise

--How many seconds NLR lasts for
LUCTUS_NLR_TIME = 300


--CONFIG END

util.AddNetworkString("luctus_snlr")

hook.Add("PlayerSpawn","luctus_snlr",function(ply)
    --if job switching: do not create nlr, delete old one
    if ply.nlrLastJob ~= ply:Team() then
        ply.nlrLastJob = ply:Team()
        LuctusNLRStop(ply)
        return
    end
    LuctusNLRStart(ply,LUCTUS_NLR_TIME)
end)

function LuctusNLRStart(ply,ntime)
    local etime = CurTime()+ntime
    --ply.NLREndTime = etime
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
        net.Start("luctus_snlr")
            net.WriteUInt(0,13)
        net.Send(ply)
        hook.Run("LuctusNLREnd",ply)
    end
    --ply.NLREndTime = 0
end

function LuctusNLRIsActive(ply)
    if timer.Exists(ply:SteamID().."_nlr") then
        return timer.TimeLeft(ply:SteamID().."_nlr")
    end
    return false
end

print("[luctus_snlr] sv loaded")
