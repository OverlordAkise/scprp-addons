--Luctus Raidhelper
--Made by OverlordAkise

LUCTUS_RAIDHELPER_ALLOWIDS = LUCTUS_RAIDHELPER_ALLOWIDS or {}
LUCTUS_RAIDHELPER_COOLDOWNS = LUCTUS_RAIDHELPER_COOLDOWNS or {}

hook.Add("PlayerSay","luctus_raidhelper",function(ply,text)
    if text == LUCTUS_RAIDHELPER_REQCMD then
        LuctusRaidHelperAskAdmin(ply)
    end
    if string.StartWith(text,LUCTUS_RAIDHELPER_ALLOWCMD) then
        local acceptNum = string.Split(text," ")[2]
        if not acceptNum or not tonumber(acceptNum) then return end
        local raidLeader = LUCTUS_RAIDHELPER_ALLOWIDS[acceptNum]
        if not raidLeader then
            ply:PrintMessage(HUD_PRINTTALK, "[raid] No raid request with this id found")
            return
        end
        LuctusRaidHelperStart(raidLeader)
        LuctusRaidHelperTellAdmins("Raid for "..raidLeader:Nick().."("..team.GetName(raidLeader:Team())..") has been accepted by "..ply:Nick())
        LUCTUS_RAIDHELPER_ALLOWIDS[acceptNum] = nil
    end
    if text == LUCTUS_RAIDHELPER_LEAVECMD then
        if ply:GetNW2String("IsRaiding","") == "" then
            ply:PrintMessage(HUD_PRINTTALK, "[raid] You are not in a raid")
            return
        end
        LuctusRaidHelperLeave(ply,"left raid voluntarily")
    end
    if text == LUCTUS_RAIDHELPER_STOPCMD then
        local jobname = team.GetName(ply:Team())
        if not LUCTUS_RAIDHELPER_JOBS[jobname] then
            ply:PrintMessage(HUD_PRINTTALK,"[raid] You can not stop a raid")
            return
        end
        for id,rply in pairs(LUCTUS_RAIDHELPER_ALLOWIDS) do
            if rply == ply then
                LuctusRaidHelperTellAdmins(ply:Nick().." ("..team.GetName(ply:Team())..") canceled his raid request.")
                return
            end
        end
        if not LuctusRaidHelperIsLive(jobname) then
            ply:PrintMessage(HUD_PRINTTALK,"[raid] There is no raid ongoing")
            return
        end
        LuctusRaidHelperStop(jobname,"canceled by leader")
    end
end)

function LuctusRaidHelperTellAdmins(text)
    for k,ply in ipairs(player.GetHumans()) do
        if not ply:IsAdmin() then continue end
        ply:PrintMessage(HUD_PRINTTALK,"[raid] "..text)
    end
end

function LuctusRaidHelperAskAdmin(ply)
    local jobname = team.GetName(ply:Team())
    if LUCTUS_RAIDHELPER_COOLDOWNS[jobname] then
        ply:PrintMessage(HUD_PRINTTALK,"[raid] Cooldown until next raid: "..string.NiceTime(LUCTUS_RAIDHELPER_COOLDOWNS[jobname]-CurTime()))
        return
    end
    if not LUCTUS_RAIDHELPER_JOBS[jobname] then
        ply:PrintMessage(HUD_PRINTTALK,"[raid] You can not request a raid")
        return
    end
    if LuctusRaidHelperIsLive(jobname) then
        ply:PrintMessage(HUD_PRINTTALK,"[raid] Raid is already ongoing")
        return
    end
    for num,rply in pairs(LUCTUS_RAIDHELPER_ALLOWIDS) do
        if rply == ply then
            ply:PrintMessage(HUD_PRINTTALK,"[raid] You already requested a raid")
            return
        end
    end
    local acceptNum = math.random(10000,99999)..""
    LUCTUS_RAIDHELPER_ALLOWIDS[acceptNum] = ply
    LuctusRaidHelperTellAdmins("Raid request from "..ply:Nick().." ("..jobname.."). Type '"..LUCTUS_RAIDHELPER_ALLOWCMD.." "..acceptNum.."' to allow the raid.")
    ply:PrintMessage(HUD_PRINTTALK,"[raid] Requesting admins for permission to raid")
    hook.Run("LuctusRaidHelperAsk",ply,jobname,acceptNum)
end

function LuctusRaidHelperStart(ply)
    local leadJob = team.GetName(ply:Team())
    ply:SetNW2String("IsRaiding",leadJob)
    local raidingJobs = LUCTUS_RAIDHELPER_JOBS[leadJob]
    local members = 0
    for k,rply in ipairs(player.GetAll()) do
        if raidingJobs[team.GetName(rply:Team())] then
            rply:SetNW2Bool("IsRaiding",leadJob)
            members = members + 1
        end
    end
    hook.Run("LuctusRaidHelperStart",ply,leadJob,members)
end

function LuctusRaidHelperIsLive(job)
    local raidStillOngoing = false
    for k,ply in ipairs(player.GetAll()) do
        if ply:GetNW2String("IsRaiding","") == job then
            raidStillOngoing = true
            break
        end
    end
    return raidStillOngoing
end

function LuctusRaidHelperCheckRaid(job,reason)
    if not LuctusRaidHelperIsLive(job) then
        LuctusRaidHelperStop(job,reason or "<noreason>")
    end
end

function LuctusRaidHelperStop(job,reason)
    for k,ply in ipairs(player.GetAll()) do
        if ply:GetNW2String("IsRaiding","") == job then
            ply:SetNW2String("IsRaiding","")
        end
    end
    PrintMessage(HUD_PRINTTALK,"[raid] The raid of '"..job.."' ended")
    hook.Run("LuctusRaidHelperEnd",job,reason)
    LUCTUS_RAIDHELPER_COOLDOWNS[job] = CurTime()+LUCTUS_RAIDHELPER_COOLDOWN
    timer.Simple(LUCTUS_RAIDHELPER_COOLDOWN,function()
        LUCTUS_RAIDHELPER_COOLDOWNS[job] = nil
    end)
end

function LuctusRaidHelperLeave(ply,reason)
    local job = ply:GetNW2String("IsRaiding","")
    ply:PrintMessage(HUD_PRINTTALK, "[raid] You left the raid, participation from now on will be punished")
    ply:SetNW2String("IsRaiding","")
    LuctusRaidHelperCheckRaid(job,reason)
    hook.Run("LuctusRaidHelperLeft",ply,job,reason)
end

hook.Add("PlayerSpawn","luctus_raidhelper",function(ply)
    if ply:GetNW2String("IsRaiding","") ~= "" then
        LuctusRaidHelperLeave(ply,"death")
    end
end)

hook.Add("PlayerDisconnect","luctus_raidhelper",function(ply)
    if ply:GetNW2String("IsRaiding","") ~= "" then
        LuctusRaidHelperLeave(ply,"disconnect")
    end
end)


print("[luctus_raidhelper] sv loaded")
