--Luctus sNLR
--Made by OverlordAkise

--How many seconds NLR lasts for
LUCTUS_NLR_TIME = 300


--CONFIG END

util.AddNetworkString("luctus_snlr")

hook.Add("playerSetAFK","luctus_snlr",function(ply, newState)
    if newState == false then
        LuctusNLRStop(ply)
    end
end)

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
    if ply.Sleeping then return end
    local extraTime = hook.Run("LuctusNlrExtraTime")
    if extraTime and tonumber(extraTime) then
        ntime = ntime + tonumber(extraTime)
    end
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

--Example for using the hook to add 30s to NLR time if code red is active:
hook.Add("LuctusNlrExtraTime","luctus_code_example",function()
    if LUCTUS_SCP_CODES and LUCTUS_SCP_CODE_CURRENT == "red" then
        return 30
    end
end)

print("[luctus_snlr] sv loaded")
