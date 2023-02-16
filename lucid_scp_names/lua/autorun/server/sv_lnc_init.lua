--Luctus Name Change
--Made by OverlordAkise

util.AddNetworkString("luctus_scpnames")
util.AddNetworkString("luctus_checkscpnames")

hook.Add("onPlayerFirstJoined","luctus_scpnames",function(ply, data)
    ply.luctusShouldNameChange = true
end)

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

net.Receive("luctus_checkscpnames", function(len,ply)
    if IsValid(ply) and ply.luctusShouldNameChange then
        net.Start("luctus_scpnames")
        net.Send(ply)
        return
    end
    --Get default job name
    local djob = GAMEMODE.DefaultTeam
    if not djob or djob < 1 then return end
    local djobtable = RPExtraTeams[djob]
    if not djobtable then return end
    local djobname = djobtable.command
    if not djobname then return end
    
    local jobname = sql.QueryValue("SELECT jobname FROM luctus_scpnames WHERE steamid = "..sql.SQLStr(ply:SteamID()).." AND jobcmd = "..sql.SQLStr(djobname))
    if jobname == false then
        print("[luctus_scpnames] ERROR DURING SQL ONJOIN NAMECHANGE!")
        print(sql.LastError())
        return
    end
    if jobname then
        ply:setRPName(jobname, false)
    end
end)

net.Receive("luctus_scpnames", function(len,ply)
    local fname = net.ReadString()
    local lname = net.ReadString()
    local newName = fname
    if lname ~= "" then
        newName = fname.." "..lname
    end
    print("[luctus_scpnames] "..ply:Nick().." wants to change his name to "..newName)
    local b,m = hook.Run("CanChangeRPName",ply,newName)
    DarkRP.retrieveRPNames(newName,function(ans)
        --print(ans)
        if b == false then
            DarkRP.notify(ply,1,5,"Error: Name '"..m.."'")
        elseif ans == true then
            DarkRP.notify(ply,1,5,"Error: Name 'already taken'")
        --elseif fname:match("%W") then
        --  DarkRP.notify(ply,1,5,"Error: Name 'has illegal characters'")
        else
            ply:setRPName(newName)
            net.Start("luctus_scpnames")
            net.Send(ply)
        end
    end)
end)

print("[luctus_scpnames] sv loaded")
