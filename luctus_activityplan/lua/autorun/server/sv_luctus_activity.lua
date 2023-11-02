--Luctus Activityplan
--Made by OverlordAkise

luctusCurrentActivityID = 0

util.AddNetworkString("luctus_activity_sync")

net.Receive("luctus_activity_sync",function(len,ply)
    net.Start("luctus_activity_sync")
        net.WriteString(LUCTUS_ACTIVITY_ACTIVITIES[luctusCurrentActivityID][1])
        net.WriteInt(luctusActivityTimeLeft(),16)
    net.Send(ply)
end)

hook.Add("PlayerInitialSpawn", "luctus_activity_start", function(ply)
    luctusActivityStartNext()
    hook.Remove("PlayerInitialSpawn", "luctus_activity_start")
end)

function luctusActivityTimeLeft()
    return timer.TimeLeft("luctus_activity_timer")
end

function luctusActivityStartNext()
    if timer.Exists("luctus_activity_timer") then
        timer.Remove("luctus_activity_timer")
    end
    luctusCurrentActivityID = (luctusCurrentActivityID % #LUCTUS_ACTIVITY_ACTIVITIES)+1
    timer.Create("luctus_activity_timer",LUCTUS_ACTIVITY_ACTIVITIES[luctusCurrentActivityID][2], 1, function()
        luctusActivityStartNext()
    end)
    
    local timeLeft = luctusActivityTimeLeft()
    local name = LUCTUS_ACTIVITY_ACTIVITIES[luctusCurrentActivityID][1]
    net.Start("luctus_activity_sync")
        net.WriteString(name)
        net.WriteInt(timeLeft,16)
    net.Broadcast()
end

function LuctusActivityPause(text)
    timer.Pause("luctus_activity_timer")
    net.Start("luctus_activity_sync")
        net.WriteString(text)
        net.WriteInt(0,16)
    net.Broadcast()
end

function LuctusActivityResume()
    timer.UnPause("luctus_activity_timer")
    net.Start("luctus_activity_sync")
        net.WriteString(LUCTUS_ACTIVITY_ACTIVITIES[luctusCurrentActivityID][1])
        net.WriteInt(luctusActivityTimeLeft(),16)
    net.Broadcast()
end

hook.Add("lockdownStarted","luctus_activity",function()
    LuctusActivityPause("LOCKDOWN")
end)

hook.Add("lockdownEnded","luctus_activity",function()
    LuctusActivityResume()
end)

hook.Add("PlayerSay","luctus_activity_resync",function(ply,text,team)
    if text == "!activity_resync" then
        net.Start("luctus_activity_sync")
            net.WriteString(LUCTUS_ACTIVITY_ACTIVITIES[luctusCurrentActivityID][1])
            net.WriteInt(luctusActivityTimeLeft(),16)
        net.Broadcast()
    end
    if text == "!activity_skip" then
        if not ply:IsAdmin() then return end
        luctusActivityStartNext()
    end
end)

print("[luctus_activity] sv loaded")
