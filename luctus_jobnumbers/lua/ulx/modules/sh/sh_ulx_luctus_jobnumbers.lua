
function ulx.jobnumber(calling_ply, target_ply, newId)
    if not IsValid(target_ply) then return end
    local jobname = team.GetName(target_ply:Team())
    local jobNumTab = LUCTUS_JOBNUMBERS[jobname]
    if not jobNumTab then
        ULib.tsayError(calling_ply, "The player's job doesn't have a jobnumer!", true)
        return
    end
    LuctusJobnumbersSetInternal(target_ply,jobname,newId)
    ulx.fancyLogAdmin(calling_ply, "#A set the jobid of #T for #s to #s", target_ply, jobname, newId)
end
local jobnumber = ulx.command("Utility", "ulx jobnumber", ulx.jobnumber, "!jobnumber")
jobnumber:addParam{ type=ULib.cmds.PlayerArg }
jobnumber:addParam{ type=ULib.cmds.NumArg, min=1, max=99999, default=2, hint="New Jobnumber", ULib.cmds.round }
jobnumber:defaultAccess(ULib.ACCESS_ADMIN)
jobnumber:help("Change players jobnumber")
