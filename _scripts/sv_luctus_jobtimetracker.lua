--Luctus JobTimeTracker
--Made by OverlordAkise

--A minimalistic script that records the playtime of players in specific jobs
--The function LuctusJttHasMinutesPlaytime checks if a player has x minutes of playtime in a job
--The table below allows you to send custom notifications to players if they reach x minutes of playtime


--Messages for each job after x Minutes of playtime
LUCTUS_JOBTIMETRACKER_EVENTS = {
    ["Medic"] = {
        [1] = "Thanks for playing 1 whole minute!",
    },
    ["Researcher"] = {
        [60] = "You are now able to rank up!",
    }
}

--config end

local lastChange = {}
local timeCache = {}

hook.Add("InitPostEntity","luctus_jobtimetracker",function()
    local res = sql.Query("CREATE TABLE IF NOT EXISTS luctus_jobtimetracker(steamid TEXT, job TEXT, time INT)")
    if res==false then
        error(sql.LastError())
    end
end)

function LuctusJttHasMinutesPlaytime(ply,job,minutes)
    if tonumber(job) then
        job = team.GetName(job)
        if job == "" then return end
    end
    local res = sql.QueryValue("SELECT job FROM luctus_jobtimetracker WHERE steamid="..sql.SQLStr(ply:SteamID()).." AND job="..sql.SQLStr(job).." AND time>"..(minutes*60))
    if res==false then error(sql.LastError()) end
    if res then return true end
    return false
end

function LuctusJobtimetrackerSave(ply,job)
    local newTime = CurTime()-lastChange[ply] + timeCache[ply]
    local res = sql.Query("UPDATE luctus_jobtimetracker SET time="..newTime.." WHERE steamid="..sql.SQLStr(ply:SteamID()).." AND job="..sql.SQLStr(job))
    if res==false then error(sql.LastError()) end
end

timer.Create("luctus_jobtimetracker",60,0,function()
    for k,ply in ipairs(player.GetHumans()) do
        local job = team.GetName(ply:Team())
        if not LUCTUS_JOBTIMETRACKER_EVENTS[job] then continue end
        local sTime = lastChange[ply]
        if not sTime then continue end
        sTime = math.floor((CurTime()-lastChange[ply] + timeCache[ply])/60)
        if LUCTUS_JOBTIMETRACKER_EVENTS[job][sTime] then
            DarkRP.notify(ply,0,10,LUCTUS_JOBTIMETRACKER_EVENTS[job][sTime])
        end
    end
end)

hook.Add("PlayerChangedTeam", "luctus_jobtimetracker", function(ply, beforeNum, afterNum)
    local beforeJob = team.GetName(beforeNum)
    local afterJob = team.GetName(afterNum)
    if lastChange[ply] then
        LuctusJobtimetrackerSave(ply,beforeJob)
    end
    lastChange[ply] = CurTime()
    timeCache[ply] = 0
    local res = sql.QueryRow("SELECT * FROM luctus_jobtimetracker WHERE steamid = "..sql.SQLStr(ply:SteamID()).." AND job="..sql.SQLStr(afterJob))
    if res==false then error(sql.LastError()) end
    --steamid,job,int
    if res then
        timeCache[ply] = res.time
    else
        res = sql.Query("INSERT INTO luctus_jobtimetracker(steamid,job,time) VALUES("..sql.SQLStr(ply:SteamID())..","..sql.SQLStr(afterJob)..",0)")
        if res==false then error(sql.LastError()) end
    end
end)

hook.Add("PlayerDisconnected", "luctus_jobtimetracker", function(ply)
    if lastChange[ply] then
        LuctusJobtimetrackerSave(ply, team.GetName(ply:Team()))
    end
    lastChange[ply] = nil
    timeCache[ply] = nil
end)

hook.Add("ShutDown", "luctus_jobtimetracker", function()
    for k,ply in ipairs(player.GetHumans()) do
        if lastChange[ply] then
            LuctusJobtimetrackerSave(ply, team.GetName(ply:Team()))
        end
    end
end)

print("[luctus_jobtimetracker] sv loaded")
