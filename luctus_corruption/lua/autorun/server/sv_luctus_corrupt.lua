--Luctus Corrupt
--Made by OverlordAkise

local function NotifyPlayer(ply,text)
    ply:PrintMessage(3,text)
    DarkRP.notify(ply, 1, 5, text)
end

local function NotifyAdmins(text)
    for k,ply in ipairs(player.GetHumans()) do
        if not LUCTUS_CORRUPT_APPROVER[ply:GetUserGroup()] then continue end
        DarkRP.notify(ply,0,5,text)
        ply:PrintMessage(3,text)
    end
end

hook.Add("OnPlayerChangedTeam", "luctus_corrupt", function(ply, beforejob, afterjob)
    ply.cancorrupt = false
    ply.corruptid = nil
    if ply.IsCorrupt then
        LuctusCorruptStop(ply)
    end
    if LUCTUS_CORRUPT_JOBS[team.GetName(afterjob)] then
        CreateCorruptionTimer(ply)
    else
        timer.Remove(ply:SteamID64().."_corrupttimer")
    end
end)

hook.Add("PlayerDeath","luctus_corrupt",function(ply)
    if ply.IsCorrupt then
        LuctusCorruptStop(ply)
    end
    ply.cancorrupt = false
    ply.corruptid = nil
    if LUCTUS_CORRUPT_JOBS[team.GetName(ply:Team())] then
        CreateCorruptionTimer(ply)
    end
end)

function LuctusCorruptStart(ply,reason)
    ply.cancorrupt = false
    ply.IsCorrupt = true
    NotifyPlayer(ply,"[corrupt] You are now corrupt!")
    NotifyAdmins(ply:Nick().."("..ply:SteamID()..") is now corrupt!")
    hook.Run("LuctusCorruptStart",ply,reason)
end

function LuctusCorruptStop(ply)
    ply.IsCorrupt = false
    CreateCorruptionTimer(ply)
    NotifyPlayer(ply,"[corrupt] You are not corrupt anymore!")
    NotifyAdmins(ply:Nick().."("..ply:SteamID()..") is NOT corrupt anymore!")
    hook.Run("LuctusCorruptStop",ply)
end

function LuctusCorruptSeekApproval(seeker,reason)
    hook.Run("LuctusCorruptRequested",seeker,reason)
    for k,ply in ipairs(player.GetHumans()) do
        if not LUCTUS_CORRUPT_APPROVER[ply:GetUserGroup()] then continue end
        NotifyPlayer(ply,"[corrupt] '"..seeker:Nick().."' wants to become corrupt with reason: "..reason)
        NotifyPlayer(ply,"[corrupt] Type '"..LUCTUS_CORRUPT_ALLOWCMD.." "..seeker.corruptid.."' to approve this (or "..LUCTUS_CORRUPT_DENYCMD..")")
    end
end

hook.Add("PlayerSay", "luctus_corrupt", function(ply, text)
    if string.StartWith(text,LUCTUS_CORRUPT_COMMAND) then
        if not LUCTUS_CORRUPT_JOBS[ply:getJobTable().name] then
            NotifyPlayer(ply,"[corrupt] Your job doesn't allow corruption!")
            return
        end
        if not ply.cancorrupt then
            local timeLeft = ""
            if timer.Exists(ply:SteamID64().."_corrupttimer") then
                timeLeft = " yet! Time left: "..string.NiceTime(timer.TimeLeft(ply:SteamID64().."_corrupttimer"))
            end
            NotifyPlayer(ply,"[corrupt] You can't become corrupt"..timeLeft)
            return
        end
        local reason = string.Split(text,LUCTUS_CORRUPT_COMMAND.." ")[2]
        if not reason then
            NotifyPlayer(ply,"[corrupt] Usage: !corrupt <reason>")
            return
        end
        if LUCTUS_CORRUPT_NEEDS_APPROVAL then
            if ply.corruptid then
                NotifyPlayer(ply,"[corrupt] You already requested a corruption! Your ID: "..ply.corruptid)
                return
            end
            ply.corruptid = ""..math.random(1,9999)
            LuctusCorruptSeekApproval(ply,reason)
            NotifyPlayer(ply,"[corrupt] Your request has been created! Your ID: "..ply.corruptid)
        else
            LuctusCorruptStart(ply,reason)
        end
    end
    if LUCTUS_CORRUPT_APPROVER[ply:GetUserGroup()] and string.StartWith(text,LUCTUS_CORRUPT_ALLOWCMD) then
        local name = string.Split(text,LUCTUS_CORRUPT_ALLOWCMD.." ")
        if not name[2] then return end
        for k,v in ipairs(player.GetAll()) do
            if v.corruptid and v.corruptid == name[2] then
                LuctusCorruptStart(v)
                NotifyPlayer(ply,"[corrupt] Successfully approved!")
                hook.Run("LuctusCorruptApproved",ply,v)
                return
            end
        end
        NotifyPlayer(ply,"[corrupt] Error, ID not found!")
    end
    if LUCTUS_CORRUPT_APPROVER[ply:GetUserGroup()] and string.StartWith(text,LUCTUS_CORRUPT_DENYCMD) then
        local name = string.Split(text,LUCTUS_CORRUPT_DENYCMD.." ")
        if not name[2] then return end
        for k,v in ipairs(player.GetAll()) do
            if v.corruptid and v.corruptid == name[2] then
                CreateCorruptionTimer(v)
                NotifyPlayer(v,"[corrupt] Your corruption has been denied! Cooldown started.")
                NotifyPlayer(ply,"[corrupt] Successfully denied!")
                hook.Run("LuctusCorruptDenied",ply,v)
                return
            end
        end
        NotifyPlayer(ply,"[corrupt] Error, ID not found!")
    end
    if text == LUCTUS_CORRUPT_STOPCMD and ply.IsCorrupt then
        LuctusCorruptStop(ply)
    end
end)

function CreateCorruptionTimer(ply)
    ply.cancorrupt = false
    ply.corruptid = nil
    timer.Create(ply:SteamID64().."_corrupttimer",LUCTUS_CORRUPT_DELAY, 1,function()
        ply.cancorrupt = true
    end)
end

print("[luctus_corrupt] sv loaded")
