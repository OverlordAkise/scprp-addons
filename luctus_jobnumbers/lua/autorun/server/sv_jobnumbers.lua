--Luctus Jobnames
--Made by OverlordAkise

luctus_jobnumbers = {}

--CONFIG START

--Can users change their own ID?
luctus_jobnumbers_USERS_CAN_CHANGE = true

--[JobName] = {Prefix,MinValue,MaxValue}
--%d gets replaced by the number
luctus_jobnumbers["D-Klasse"] = {"[D-%d]",1000,9999}
luctus_jobnumbers["O5"] = {"[O5-%d]",1,15}
luctus_jobnumbers["Citizen"] = {"[C-%d]",100,999}
luctus_jobnumbers["Hobo"] = {"[USELESS]",100,999}

--CONFIG END

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


hook.Add("PlayerSay", "luctus_jobnumber_set", function(ply,text,plyteam)
    if string.StartWith(text,"!setid") then
        local t = string.Split(text," ")
        if not t[2] or not t[3] then return end
        if not tonumber(t[3]) then return end
        if not luctus_jobnumbers[team.GetName(ply:Team())] then return end
        if not luctus_jobnumbers_USERS_CAN_CHANGE and not ply:IsAdmin() then return end
        local newId = tonumber(t[3])
        local jobname = team.GetName(ply:Team())
        if newId < luctus_jobnumbers[jobname][2] or newId > luctus_jobnumbers[jobname][3] then return end
        
        local tPly = luctusGetPlayer(t[2])
        if not tPly then
            ply:PrintMessage(HUD_PRINTTALK, "ERROR: Too many players found!")
            return
        end
        if luctus_jobnumbers_USERS_CAN_CHANGE and not ply:IsAdmin() and not ply != tPly then return end
        
        ply:SetNWString("l_numtag",string.format(luctus_jobnumbers[jobname][1],newId))
        local res = sql.Query("UPDATE luctus_jobnumbers SET jobnumber="..newId.." WHERE steamid="..sql.SQLStr(ply:SteamID()).." AND jobname="..sql.SQLStr(jobname))
        if res == false then
            error(sql.LastError())
        end
        ply:PrintMessage(3,"[jobnumbers] Updated successfully!")
    end
end)



hook.Add("OnPlayerChangedTeam", "luctus_numtags", function(ply, beforeNum, afterNum)
    if luctus_jobnumbers[team.GetName(beforeNum)] then
        ply:SetNWString("l_numtag","")
    end

    if luctus_jobnumbers[team.GetName(afterNum)] then
        local jobname = team.GetName(afterNum)
        local jconf = luctus_jobnumbers[jobname]
        local randomNumber = math.random(jconf[2],jconf[3])
        ply:SetNWString("l_numtag",string.format(jconf[1],randomNumber))
        local res = sql.Query("SELECT * FROM luctus_jobnumbers WHERE steamid = "..sql.SQLStr(ply:SteamID()).." AND jobname = "..sql.SQLStr(jobname))
        if res == false then
            error(sql.LastError())
        end
        if res and res[1] then
            ply:SetNWString("l_numtag",string.format(jconf[1],res[1].jobnumber))
        else
            res = sql.Query("INSERT INTO luctus_jobnumbers(steamid,jobname,jobnumber) VALUES("..sql.SQLStr(ply:SteamID())..","..sql.SQLStr(jobname)..","..randomNumber..")")
            if res == false then
                error(sql.LastError())
            end
        end
    end
end)

print("[luctus_jobnumbers] sv loaded!")
