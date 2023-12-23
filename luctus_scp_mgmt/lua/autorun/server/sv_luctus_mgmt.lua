--Luctus SCP Management
--Made by OverlordAkise

util.AddNetworkString("luctus_scp_mgmt")

function LuctusMGMTGetPlyJob(ply)
    if LUCTUS_SCP_MGMT_ENABLE_JOBRANKS then
        return ply:getDarkRPVar("job")
    end
    return team.GetName(ply:Team())
end

function LuctusMGMTAllowed(ply)
    if not IsValid(ply) then return end
    local pteam = LuctusMGMTGetPlyJob(ply)
    if not LUCTUS_SCP_MGMT_ALLOWED_JOBS[pteam] then
        DarkRP.notify(ply,1,5,"[MGMT] You arent allowed to use the management menu!")
        return false
    end
    return true
end

net.Receive("luctus_scp_mgmt",function(len,ply)
    if not LuctusMGMTAllowed(ply) then return end
    local cmd = net.ReadString()
    if string.StartsWith(cmd,"emergencyon ") then
        LuctusMGMTEmergency(true,ply,string.Split(cmd," ")[2])
    elseif string.StartsWith(cmd,"emergencyoff ") then
        LuctusMGMTEmergency(false,ply,string.Split(cmd," ")[2])
    elseif cmd == "demote" then
        local targetID = net.ReadString()
        local reason = net.ReadString()
        local tply = player.GetBySteamID(targetID)
        if not tply then
            DarkRP.notify(ply,1,5,"[MGMT] Error: No target player!")
            return
        end
        LuctusMGMTDegradePlayer(tply,reason,ply)
    elseif cmd == "stopdemote" then
        local targetID = net.ReadString()
        local reason = net.ReadString()
        local tply = player.GetBySteamID(targetID)
        if not tply then
            DarkRP.notify(ply,1,5,"[MGMT] Error: No target player!")
            return
        end
        LuctusMGMTStopDegradePlayer(tply,ply)
    else
        DarkRP.notify(ply,1,5,"[MGMT] Error: Invalid command!")
    end
end)

local function LuctusNotify(ply,text,typ,duration)
    ply:PrintMessage(HUD_PRINTTALK, text)
    DarkRP.notify(ply,typ,duration,text)
end

function LuctusMGMTIsEmergencyJob(name)
    for catname,jobs in pairs(LUCTUS_SCP_MGMT_EMERGENCY_JOBS) do
        for jobname,v in pairs(jobs) do
            if jobname == name then return catname end
        end
    end
    return false
end

function LuctusMGMTIsEmergencyLive(name)
    --print("[DEBUG][mgmt]","IsLive:",name,timer.Exists("mgmt_emergency_"..name),GetGlobal2Bool("mgmt_emergency_"..name))
    if timer.Exists("mgmt_emergency_"..name) or GetGlobal2Bool("mgmt_emergency_"..name) then return true end
    return false
end

function LuctusMGMTEmergency(shouldStart,ply,groupName)
    --print("[DEBUG][mgmt]",shouldStart,ply,groupName)
    if not groupName or groupName == "" then return end
    if shouldStart then
        if LuctusMGMTIsEmergencyLive(groupName) then return end
        PrintMessage(HUD_PRINTTALK, "[MGMT] The Foundation has called for an "..groupName.."-Emergency!")
        PrintMessage(HUD_PRINTTALK, "[MGMT] Emergency Jobs will be available in "..LUCTUS_SCP_MGMT_EMERGENCY_JOB_DELAY.." seconds!")
        timer.Create("mgmt_emergency_"..groupName,LUCTUS_SCP_MGMT_EMERGENCY_JOB_DELAY,1,function()
            SetGlobal2Bool("mgmt_emergency_"..groupName,true)
            PrintMessage(HUD_PRINTTALK, "[MGMT] "..groupName.."-Emergency Jobs are now available!")
        end)
        hook.Run("LuctusSGPMGMTEmergencyCall",ply,groupName)
    else
        if not LuctusMGMTIsEmergencyLive(groupName) then return end
        PrintMessage(HUD_PRINTTALK, "[MGMT] The Foundation has stopped the "..groupName.."-Emergency!")
        PrintMessage(HUD_PRINTTALK, "[MGMT] Emergency Jobs are closed and will be changed back in "..LUCTUS_SCP_MGMT_EMERGENCY_JOB_DELAY.." seconds!")
        
        SetGlobal2Bool("mgmt_emergency_"..groupName,false)
        timer.Create("mgmt_emergency_"..groupName,LUCTUS_SCP_MGMT_EMERGENCY_JOB_DELAY,1,function()
            for k,v in pairs(player.GetAll()) do
                if LuctusMGMTIsEmergencyJob(team.GetName(v:Team())) then
                    v:changeTeam(GAMEMODE.DefaultTeam, true)
                end
            end
        end)
        hook.Run("LuctusSGPMGMTEmergencyStop",ply,groupName)
    end
end

hook.Add("playerCanChangeTeam","luctus_scp_mgmt_job_restrict",function(ply,newTeam,force)
    if force then return true, "Job change was forced!" end
    local jobCategory = LuctusMGMTIsEmergencyJob(team.GetName(newTeam))
    if jobCategory then
        if not GetGlobal2Bool("mgmt_emergency_"..jobCategory) then return false, LUCTUS_SCP_MGMT_JOBERROR end
    end
end)

function LuctusMGMTDegradePlayer(target,text,source)
    print("[MGMT] Demote started:",source,source:SteamID(),"demoted",target,target:getJobTable().name,target:SteamID(),"for reason:",text)
    local reason = "[MGMT] You got demoted for: "..text
    LuctusNotify(target,reason,1,30)
    timer.Create(target:SteamID().."_demote",LUCTUS_SCP_MGMT_DEMOTE_DELAY,1,function()
        if LuctusJobbanBan then
            LuctusJobbanBan(target, team.GetName(target:Team()), GAMEMODE.Config.demotetime)
        else
            target:teamBan()
        end
        --get team by name
        local found = false
        local newTeam = nil
        for k,v in pairs(RPExtraTeams) do
            if v.name == LUCTUS_SCP_MGMT_DEMOTE_JOB then
                found = true
                newTeam = k
                break
            end
        end
        target:changeTeam(found and newTeam or GAMEMODE.DefaultTeam, true)
    end)
    hook.Run("LuctusSGPMGMTDemoteStart",source,target)
end

function LuctusMGMTStopDegradePlayer(target,source)
    print("[MGMT] Demote stopped for:",target,target:SteamID(),"by",source,source:SteamID())
    local reason = "[MGMT] Your demote process was stopped."
    LuctusNotify(target,reason,1,15)
    timer.Remove(target:SteamID().."_demote")
    hook.Run("LuctusSGPMGMTDemoteStop",source,target)
end

hook.Add("PlayerSay","luctus_scp_mgmt",function(ply,text,team)
    if text == LUCTUS_SCP_MGMT_COMMAND then
        if not LuctusMGMTAllowed(ply) then return end
        net.Start("luctus_scp_mgmt")
        net.Send(ply)
        return ""
    end
end)

print("[luctus_scp_mgmt] sv loaded")
