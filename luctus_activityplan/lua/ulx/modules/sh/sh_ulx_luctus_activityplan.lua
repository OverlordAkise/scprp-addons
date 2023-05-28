function ulx.activitypause(calling_ply,text)
    LuctusActivityPause(text)
    ulx.fancyLogAdmin(calling_ply, "#A paused the activityplan with "..text)
end
local activitypause = ulx.command("SCP", "ulx activitypause", ulx.activitypause, "!activitypause" )
activitypause:addParam{ type=ULib.cmds.StringArg, hint="activity text" }
activitypause:defaultAccess( ULib.ACCESS_ADMIN )
activitypause:help( "Stop the activityplan with a custom, infinite one." )

function ulx.activityresume(calling_ply, target_plys)
    LuctusActivityResume()
    ulx.fancyLogAdmin(calling_ply, "#A resumed the activityplan")
end
local activityresume = ulx.command("SCP", "ulx activityresume", ulx.activityresume, "!activityresume" )
activityresume:defaultAccess( ULib.ACCESS_ADMIN )
activityresume:help( "Resume the normal activityplan." )
