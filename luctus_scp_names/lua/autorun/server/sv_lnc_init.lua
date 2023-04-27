--Luctus Name Change
--Made by OverlordAkise

util.AddNetworkString("luctus_scpnames")

hook.Add("PostGamemodeLoaded","luctus_scpnames",function()
    sql.Query("CREATE TABLE IF NOT EXISTS luctus_scpnames( steamid TEXT, jobcmd TEXT, jobname TEXT )")
end)

hook.Add("onPlayerChangedName","luctus_scpnames_save", function(ply, oldname, newname)
    local entryExists = sql.Query("SELECT * FROM luctus_scpnames WHERE steamid = "..sql.SQLStr(ply:SteamID()).." AND jobcmd = "..sql.SQLStr(RPExtraTeams[ply:Team()].command))
    if entryExists and entryExists ~= false and entryExists[1] then
        local res = sql.Query("UPDATE luctus_scpnames SET jobname = "..sql.SQLStr(newname).." WHERE steamid = "..sql.SQLStr(ply:SteamID()).." AND jobcmd = "..sql.SQLStr(RPExtraTeams[ply:Team()].command))
        if res == false then
            print("[luctus_scpnames] ERROR DURING SQL NAME UPDATE!")
            print(sql.LastError())
            return
        end
        DarkRP.notify(ply,0,5,"[N] Name erfolgreich geändert!")
    else
        local res = sql.Query("INSERT INTO luctus_scpnames (steamid, jobcmd, jobname) VALUES("..sql.SQLStr(ply:SteamID())..", "..sql.SQLStr(RPExtraTeams[ply:Team()].command)..", "..sql.SQLStr(newname)..")")
        if res == false then
            print("[luctus_scpnames] ERROR DURING SQL NAME INSERT!")
            print(sql.LastError())
            return
        end
        DarkRP.notify(ply,0,5,"[N] Name erfolgreich gespeichert!")
    end
end)

hook.Add("OnPlayerChangedTeam","luctus_scpnames_save", function(ply, beforeNum, afterNum)
    local jobname = sql.QueryValue("SELECT jobname FROM luctus_scpnames WHERE steamid = "..sql.SQLStr(ply:SteamID()).." AND jobcmd = "..sql.SQLStr(RPExtraTeams[afterNum].command))
    if jobname then
        ply:setRPName(jobname, false)
    else
        timer.Simple(0.3, function()
            net.Start("luctus_scpnames")
            net.Send(ply)
        end)
    end
end) 

net.Receive("luctus_scpnames", function(len,ply)
    if not ply.scpnamecd then ply.scpnamecd = 0 end
    if ply.scpnamecd > CurTime() then return end
    ply.scpnamecd = CurTime()+1
    
    local newName = net.ReadString()
    if newName == "" then
        DarkRP.notify(ply,1,5,"Error: Name can not be empty")
        return
    end
    print("[luctus_scpnames] "..ply:Nick().." wants to change his name to "..newName)
    local b,m = CheckRPName(newName)
    DarkRP.retrieveRPNames(newName,function(ans)
        --print(ans)
        if b == false then
            DarkRP.notify(ply,1,5,"Error: Name '"..m.."'")
        elseif ans == true then
            DarkRP.notify(ply,1,5,"Error: Name already taken")
        else
            ply:setRPName(newName)
            net.Start("luctus_scpnames")
            net.Send(ply)
        end
    end)
end)

function CheckRPName(name)
    for k,badname in ipairs(LUCTUS_SCPNAMES_NOTALLOWED) do
        print("Checking",string.lower(name),"against",string.lower(badname))
        print("Check:",string.find(string.lower(badname),string.lower(name)))
        if string.find(string.lower(name),string.lower(badname)) then return false, DarkRP.getPhrase("forbidden_name") end
    end
    if not string.match(name, "^[a-zA-ZЀ-џ0-9öäüÖÄÜß\"-_ ]+$") then return false, DarkRP.getPhrase("illegal_characters") end

    local len = string.len(name)
    if len > 30 then return false, DarkRP.getPhrase("too_long") end
    if len < 3 then return false,  DarkRP.getPhrase("too_short") end
end

print("[luctus_scpnames] sv loaded")
