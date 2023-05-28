--Luctus Razzia
--Made by OverlordAkise

LUCTUS_RAZZIA_ISLIVE = false

util.AddNetworkString("luctus_razzia")

function LuctusRazziaUpdate(state)
    for k,v in pairs(player.GetAll()) do
        if not LUCTUS_RAZZIA_JOBS_RECV[team.GetName(v:Team())] then continue end
        net.Start("luctus_razzia")
            net.WriteBool(state)
            net.WriteBool(true)
        net.Send(v)
    end
    LUCTUS_RAZZIA_ISLIVE = state
    --Luctus Activity Support
    LuctusRazziaActivitySupport(state)
    --AutoStop
    if state then
        timer.Create("luctus_razzia_autostop",LUCTUS_RAZZIA_MAX_TIME,1,function()
            LuctusRazziaUpdate(false)
        end)
    else
        timer.Remove("luctus_razzia_autostop")
    end
end

hook.Add("OnPlayerChangedTeam","luctus_razzia",function(ply,before,after)
    if LUCTUS_RAZZIA_ISLIVE then
        local wasInRazziaJob = LUCTUS_RAZZIA_JOBS_RECV[team.GetName(before)]
        local willBeInRazziaJob = LUCTUS_RAZZIA_JOBS_RECV[team.GetName(after)]
        
        if wasInRazziaJob and willBeInRazziaJob then return end
        
        if wasInRazziaJob and not willBeInRazziaJob then
            net.Start("luctus_razzia")
                net.WriteBool(false)
                net.WriteBool(false)
            net.Send(ply)
        end
        if not wasInRazziaJob and willBeInRazziaJob then
            net.Start("luctus_razzia")
                net.WriteBool(true)
                net.WriteBool(true)
            net.Send(ply)
        end
    end
end)

hook.Add("PlayerSay", "luctus_razzia", function(ply,text)
    if LUCTUS_RAZZIA_JOBS_SEND[team.GetName(ply:Team())] then
        local toSend = nil
        if text == LUCTUS_RAZZIA_STARTCMD then toSend = true end
        if text == LUCTUS_RAZZIA_ENDCMD then toSend = false end
        if toSend == nil then return end
        LuctusRazziaUpdate(toSend)
    end
end)

function LuctusRazziaActivitySupport(isStarting)
    if not LUCTUS_ACTIVITY_ACTIVITIES or not istable(LUCTUS_ACTIVITY_ACTIVITIES) then return end
    if isStarting then
        LuctusActivityPause("RAZZIA")
    end
    if isStarting == false then
        LuctusActivityResume()
    end
end

net.Receive("luctus_razzia",function(len,ply)
    if LUCTUS_RAZZIA_ISLIVE then
        net.Start("luctus_razzia")
            net.WriteBool(true)
            net.WriteBool(false)
        net.Send(ply)
    end
end)

print("[luctus_razzia] sv loaded!")
