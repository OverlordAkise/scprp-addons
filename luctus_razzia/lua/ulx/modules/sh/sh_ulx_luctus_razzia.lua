function ulx.razziastart(calling_ply, target_plys)
    LuctusRazziaUpdate(true)
    ulx.fancyLogAdmin(calling_ply, "#A forced a razzia to start")
end
local razziastart = ulx.command("SCP", "ulx razziastart", ulx.razziastart, "!forcerazziastart" )
razziastart:defaultAccess( ULib.ACCESS_ADMIN )
razziastart:help( "Force a razzia to start." )

function ulx.razziaend(calling_ply, target_plys)
    LuctusRazziaUpdate(false)
    ulx.fancyLogAdmin(calling_ply, "#A forced a razzia to end")
end
local razziaend = ulx.command("SCP", "ulx razziaend", ulx.razziaend, "!forcerazziaend" )
razziaend:defaultAccess( ULib.ACCESS_ADMIN )
razziaend:help( "Force a razzia to end." )
