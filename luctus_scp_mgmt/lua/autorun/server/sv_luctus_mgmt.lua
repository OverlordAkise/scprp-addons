--Luctus SCP Management
--Made by OverlordAkise

util.AddNetworkString("luctus_scp_mgmt")

function LuctusMGMTAllowed(ply)
    if not IsValid(ply) then return end
    local pteam = team.GetName(ply:Team())
    if not LUCTUS_SCP_MGMT_ALLOWED_JOBS[pteam] then
        DarkRP.notify(ply,1,5,"[MGMT] You arent allowed to use the management menu!")
        return false
    end
    return true
end

net.Receive("luctus_scp_mgmt",function(len,ply)
    if not LuctusMGMTAllowed(ply) then return end
    local cmd = net.ReadString()
    if cmd == "emergencyon" then
        LuctusMGMTEmergency(true)
    elseif cmd == "emergencyoff" then
        LuctusMGMTEmergency(false)
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

function LuctusMGMTEmergency(shouldStart)   
    if shouldStart then
        if GetGlobal2Bool("mgmt_emergency",false) then return end
        SetGlobal2Bool("mgmt_emergency",shouldStart)
        PrintMessage(HUD_PRINTTALK, "[MGMT] The Foundation has called for an Emergency!")
        PrintMessage(HUD_PRINTTALK, "[MGMT] Emergency Jobs will be available in "..LUCTUS_SCP_MGMT_EMERGENCY_JOB_DELAY.." seconds!")
        timer.Remove("mgmt_emergency_stop")
        timer.Create("mgmt_emergency_start",LUCTUS_SCP_MGMT_EMERGENCY_JOB_DELAY,1,function()
            SetGlobal2Bool("mgmt_emergency_jobs",true)
            PrintMessage(HUD_PRINTTALK, "[MGMT] Emergency Jobs are now available!")
        end)
    else
        if not GetGlobal2Bool("mgmt_emergency",false) then return end
        SetGlobal2Bool("mgmt_emergency",shouldStart)
        PrintMessage(HUD_PRINTTALK, "[MGMT] The Foundation has stopped the Emergency!")
        PrintMessage(HUD_PRINTTALK, "[MGMT] Emergency Jobs are closed and will be changed back in "..LUCTUS_SCP_MGMT_EMERGENCY_JOB_DELAY.." seconds!")
        SetGlobal2Bool("mgmt_emergency_jobs",false)
        timer.Remove("mgmt_emergency_start")
        timer.Create("mgmt_emergency_stop",LUCTUS_SCP_MGMT_EMERGENCY_JOB_DELAY,1,function()
            for k,v in pairs(player.GetAll()) do
                if LUCTUS_SCP_MGMT_EMERGENCY_JOBS[team.GetName(v:Team())] then
                    v:changeTeam(GAMEMODE.DefaultTeam, true)
                end
            end
        end)
    end
end

hook.Add("PostGamemodeLoaded","luctus_scp_mgmt_job_restrict",function()
    for k,v in pairs(RPExtraTeams) do
        if LUCTUS_SCP_MGMT_EMERGENCY_JOBS[v.name] then
            if v.customCheck then
                local oldFunc = v.customCheck
                v.customCheck = function(ply)
                    if not GetGlobal2Bool("mgmt_emergency_jobs",false) then return false end
                    oldFunc(ply)
                end
            else
                v.customCheck = function(ply)
                    return GetGlobal2Bool("mgmt_emergency_jobs",false)
                end
            end
        end
    end
end)

function LuctusMGMTDegradePlayer(target,text,source)
    print("[MGMT] Demote started:",source,source:SteamID(),"demoted",target,target:getJobTable().name,target:SteamID(),"for reason:",text)
    local reason = "[MGMT] You got demoted for: "..text
    LuctusNotify(target,reason,1,30)
    timer.Create(target:SteamID().."_demote",LUCTUS_SCP_MGMT_DEMOTE_DELAY,1,function()
        
        target:teamBan()
        
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
end

function LuctusMGMTStopDegradePlayer(target,source)
    print("[MGMT] Demote stopped for:",target,target:SteamID(),"by",source,source:SteamID())
    local reason = "[MGMT] Your demote process was stopped."
    LuctusNotify(target,reason,1,15)
    timer.Remove(target:SteamID().."_demote")
end

hook.Add("PlayerSay","luctus_scp_mgmt",function(ply,text,team)
    if text == LUCTUS_SCP_MGMT_COMMAND then
        if not LuctusMGMTAllowed(ply) then return end
        net.Start("luctus_scp_mgmt")
        net.Send(ply)
    end
end)

print("[SCPMGMT] SV loaded!")

