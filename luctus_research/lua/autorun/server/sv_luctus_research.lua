--Luctus Research
--Made by OverlordAkise

util.AddNetworkString("luctus_research_getall")
util.AddNetworkString("luctus_research_getid")
util.AddNetworkString("luctus_research_save")
util.AddNetworkString("luctus_research_editid")
util.AddNetworkString("luctus_research_deleteid")

hook.Add("PostGamemodeLoaded","luctus_research",function()
    sql.Query("CREATE TABLE IF NOT EXISTS luctus_research(date DATETIME, researcher TEXT, summary TEXT, fulltext TEXT, active INT)")
end)

function LuctusResearchHasAccess(ply)
    if not IsValid(ply) then return false end
    local jobName = team.GetName(ply:Team())
    if LUCTUS_RESEARCH_ALLOWED_JOBS[jobName] or LUCTUS_RESEARCH_ADMINS[jobName] or LUCTUS_RESEARCH_ADMINS[ply:GetUserGroup()] then return true end
    return false
end

function LuctusResearchIsAdmin(ply)
    if LUCTUS_RESEARCH_ADMINS[ply:getJobTable().name] then return true end
    if LUCTUS_RESEARCH_ADMINS[ply:GetUserGroup()] then return true end
    return false
end

function LuctusResearchGetPaper(_rowid)
    local rowid = tonumber(_rowid)
    if not rowid then return {} end
    local ret = sql.QueryRow("SELECT rowid,* FROM luctus_research WHERE rowid = "..rowid)
    if ret == false then
        ErrorNoHaltWithStack(sql.LastError())
        return {}
    end
    if ret then
        return ret
    end
    return {}
end

function LuctusResearchGetPapers(_page,_category,_filter)
    local page = tonumber(_page)
    if not page then return {} end
    local filter = _filter or ""
    if filter != "" then
        if string.find( filter, '[\'\\/%*%?"<>|=]' ) ~= nil then
            return {}
        end
        filter = "%"..filter.."%"
    else
        filter = "%"
    end
    local category = "summary"
    if _category then
        category = _category
    end
    page = page * 24
    local ret = sql.Query("SELECT rowid,date,researcher,summary FROM luctus_research WHERE "..category.." LIKE "..sql.SQLStr(filter).." AND active = 1 ORDER BY date DESC limit 24 offset "..page)
    if ret == false then
        ErrorNoHaltWithStack(sql.LastError())
        return {}
    end
    if ret then
        return ret
    end
    return {}
end

function LuctusResearchSavePaper(researcher,summary,fulltext)
    local res = sql.Query("INSERT INTO luctus_research VALUES( datetime('now') , "..SQLStr(researcher)..", "..SQLStr(summary)..", "..SQLStr(fulltext)..",1)")
    if res == false then
        ErrorNoHaltWithStack(sql.LastError())
        return "ERROR SAVING PAPER!"
    end
    return "Successfully saved the paper!"
end

function LuctusResearchEditPaper(_rowid,researcher,summary,fulltext)
    local rowid = tonumber(_rowid)
    if not rowid then return "ERROR SAVING PAPER; ROWID WAS NOT A NUMBER!" end

    local res = sql.Query("UPDATE luctus_research SET date = datetime('now'), researcher = "..SQLStr(researcher)..", summary = "..SQLStr(summary)..", fulltext = "..SQLStr(fulltext)..", active = 1 WHERE rowid = "..rowid)
    if res == false then
        ErrorNoHaltWithStack(sql.LastError())
        return "ERROR EDITING PAPER!"
    end
    return "Successfully edited the paper!"
end

function LuctusResearchDeletePaper(_rowid)
    if not tonumber(_rowid) then return end
    local rowid = tonumber(_rowid)
    if rowid < 1 then return end
    local res = sql.Query("UPDATE luctus_research SET active = 0 WHERE rowid = "..rowid)
    if res == false then
        ErrorNoHaltWithStack(sql.LastError())
        return "ERROR DELETING PAPER!"
    end
    return "Successfully deleted the paper!"
end

function LuctusResearchShowPlyHome(ply)
    net.Start("luctus_research_getall")
    local t = util.TableToJSON(LuctusResearchGetPapers(0))
    local a = util.Compress(t)
    net.WriteInt(#a,17)
    net.WriteData(a,#a)
    net.Send(ply)
end

hook.Add("PlayerSay","luctus_research",function(ply,text,team)
    if text == LUCTUS_RESEARCH_CHAT_COMMAND and LuctusResearchHasAccess(ply) then
        if LUCTUS_RESEARCH_PC_ONLY then
            ply:PrintMessage(HUD_PRINTTALK,"You can only open this menu by interacting with a PC!")
            return
        end
        LuctusResearchShowPlyHome(ply)
        return ""
    end
end)

local categories = {
    [1] = "summary",
    [2] = "researcher",
}

net.Receive("luctus_research_getall",function(len,ply)
    if not LuctusResearchHasAccess(ply) then return end
    local page = net.ReadInt(32)
    local category = net.ReadInt(4)
    local filter = net.ReadString()
    if category ~= 0 and not categories[category] then return end
    net.Start("luctus_research_getall")
        local t = util.TableToJSON(LuctusResearchGetPapers(page,categories[category],filter))
        local a = util.Compress(t)
        net.WriteInt(#a,17)
        net.WriteData(a,#a)
    net.Send(ply)
end)

net.Receive("luctus_research_getid",function(len,ply)
    if not LuctusResearchHasAccess(ply) then return end
    local rid = net.ReadInt(32)
    local edit = net.ReadBool()
    local paper = LuctusResearchGetPaper(rid)
    paper.edit = edit
    net.Start("luctus_research_getid")
        local t = util.TableToJSON(paper)
        local a = util.Compress(t)
        net.WriteInt(#a,17)
        net.WriteData(a,#a)
    net.Send(ply)
    hook.Run("LuctusResearchGetID",ply,rid)
end)

net.Receive("luctus_research_save",function(len,ply)
    if not LuctusResearchHasAccess(ply) then return end
    local summary = net.ReadString()
    local researcher = net.ReadString()
    local lenge = net.ReadInt(17)
    local data = net.ReadData(lenge)
    local fulltext = util.Decompress(data)
    local ret = LuctusResearchSavePaper(researcher,summary,fulltext)
    ply:PrintMessage(HUD_PRINTTALK, ret)
    hook.Run("LuctusResearchCreate",ply,summary)
end)

net.Receive("luctus_research_editid",function(len,ply)
    if not LuctusResearchHasAccess(ply) then return end
    if not LuctusResearchIsAdmin(ply) then return end
    local rowid = net.ReadInt(32)
    local summary = net.ReadString()
    local researcher = net.ReadString()
    local lenge = net.ReadInt(17)
    local data = net.ReadData(lenge)
    local fulltext = util.Decompress(data)
    local ret = LuctusResearchEditPaper(rowid,researcher,summary,fulltext)
    ply:PrintMessage(HUD_PRINTTALK, ret)
    hook.Run("LuctusResearchEdit",ply,rowid)
end)

net.Receive("luctus_research_deleteid",function(len,ply)
    if not LuctusResearchHasAccess(ply) then return end
    if not LuctusResearchIsAdmin(ply) then return end
    local rowid = net.ReadInt(32)
    local ret = LuctusResearchDeletePaper(rowid)
    ply:PrintMessage(HUD_PRINTTALK, ret)
    hook.Run("LuctusResearchDelete",ply,rowid)
end)

print("[luctus_research] sv loaded")
