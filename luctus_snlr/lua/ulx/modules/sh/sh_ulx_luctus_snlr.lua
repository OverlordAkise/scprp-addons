function ulx.nlrstart(calling_ply, target_ply, nlrTime)
    LuctusNLRStart(target_ply,nlrTime)
    ulx.fancyLogAdmin(calling_ply, "#A started NLR for #T (#ss)",target_ply,nlrTime)
end
local nlrstart = ulx.command("SCP", "ulx nlrstart", ulx.nlrstart, "!nlrstart")
nlrstart:addParam{ type=ULib.cmds.PlayerArg }
nlrstart:addParam{ type=ULib.cmds.NumArg, default=300, min=1, hint="Seconds how long the NLR should last" }
nlrstart:defaultAccess( ULib.ACCESS_ADMIN )
nlrstart:help( "Start NLR for a player" )

function ulx.nlrstop(calling_ply, target_ply)
    LuctusNLRStop(target_ply)
    ulx.fancyLogAdmin(calling_ply, "#A stopped NLR for #T",target_ply)
end
local nlrstop = ulx.command("SCP", "ulx nlrstop", ulx.nlrstop, "!nlrstop")
nlrstop:addParam{ type=ULib.cmds.PlayerArg }
nlrstop:defaultAccess( ULib.ACCESS_ADMIN )
nlrstop:help( "Stop NLR for a player" )
