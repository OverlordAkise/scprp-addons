--Luctus Jobnumbers
--Made by OverlordAkise

local function dbsetup()
    sql.Query("CREATE TABLE IF NOT EXISTS luctus_jobnumbers( steamid TEXT, jobname TEXT, jobnumber INT )")
end
hook.Add("PostGamemodeLoaded","luctus_jobnumbers_dbinit",dbsetup)
hook.Add("DarkRPDBInitialized","luctus_jobnumbers_dbinit",dbsetup)

local function luctusGetPlayer(name)
    local ret = nil
    for k,v in pairs(player.GetAll()) do
        if string.find( string.lower(v:Nick()), string.lower(name) ) then
            if ret ~= nil then
                return nil
            end
            ret = v
        end
    end
    return ret
end

--cache of  jobname -> sql_job_id  lookup
local jobname_cache = {}
for sqlid,jobs in pairs(LUCTUS_JOBNUMBERS_SHAREID) do
    for k,name in pairs(jobs) do
        jobname_cache[name] = sqlid
    end
end

hook.Add("PlayerSay", "luctus_jobnumber_set", function(ply,text,plyteam)
    if string.StartWith(text,"!setid") then
        local t = string.Split(text," ")
        if not t[2] or not t[3] then return end
        if not tonumber(t[3]) then return end
        if not LUCTUS_JOBNUMBERS[team.GetName(ply:Team())] then return end
        if not LUCTUS_JOBNUMBERS_USERS_CAN_CHANGE and not ply:IsAdmin() then return end
        local newId = tonumber(t[3])
        local jobname = team.GetName(ply:Team())
        if newId < LUCTUS_JOBNUMBERS[jobname][2] or newId > LUCTUS_JOBNUMBERS[jobname][3] then return end
        
        local tPly = luctusGetPlayer(t[2])
        if not tPly then
            ply:PrintMessage(HUD_PRINTTALK, "ERROR: Too many players found!")
            return
        end
        if LUCTUS_JOBNUMBERS_USERS_CAN_CHANGE and not ply:IsAdmin() and not ply != tPly then return end
        
        ply:SetNWString("l_numtag",string.format(LUCTUS_JOBNUMBERS[jobname][1],newId))
        local sqlJobName = jobname
        if jobname_cache[jobname] then
            sqlJobName = jobname_cache[jobname]
        end
        local res = sql.Query("UPDATE luctus_jobnumbers SET jobnumber="..newId.." WHERE steamid="..sql.SQLStr(ply:SteamID()).." AND jobname="..sql.SQLStr(sqlJobName))
        if res == false then
            error(sql.LastError())
        end
        ply:PrintMessage(3,"[jobnumbers] Updated successfully!")
    end
end)


hook.Add("OnPlayerChangedTeam", "luctus_numtags", function(ply, beforeNum, afterNum)
    LuctusJobnumbersLoadPlayer(ply,team.GetName(afterNum))
end)


function LuctusJobnumbersLoadPlayer(ply,jobname)
    ply:SetNWString("l_numtag","")
    if not LUCTUS_JOBNUMBERS[jobname] then return end
    local jconf = LUCTUS_JOBNUMBERS[jobname]
    local randomNumber = math.random(jconf[2],jconf[3])
    ply:SetNWString("l_numtag",string.format(jconf[1],randomNumber))
    local sqlJobName = jobname
    if jobname_cache[jobname] then
        sqlJobName = jobname_cache[jobname]
    end
    local res = sql.QueryValue("SELECT jobnumber FROM luctus_jobnumbers WHERE steamid = "..sql.SQLStr(ply:SteamID()).." AND jobname = "..sql.SQLStr(sqlJobName))
    if res == false then
        error(sql.LastError())
    end
    if res then
        ply:SetNWString("l_numtag",string.format(jconf[1],res))
    else
        res = sql.Query("INSERT INTO luctus_jobnumbers(steamid,jobname,jobnumber) VALUES("..sql.SQLStr(ply:SteamID())..","..sql.SQLStr(sqlJobName)..","..randomNumber..")")
        if res == false then
            error(sql.LastError())
        end
    end
end

print("[luctus_jobnumbers] sv loaded!")
