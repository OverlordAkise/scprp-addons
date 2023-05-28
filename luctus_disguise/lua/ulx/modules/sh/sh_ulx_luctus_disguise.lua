function ulx.undisguise(calling_ply, target_plys)
    for i=1, #target_plys do
        local v = target_plys[ i ]
        LuctusDisguiseUndisguise(v)
    end
    ulx.fancyLogAdmin(calling_ply, "#A undisguised #T", target_plys)
end
local undisguise = ulx.command("SCP", "ulx undisguise", ulx.undisguise, "!undisguise" )
undisguise:addParam{ type=ULib.cmds.PlayersArg }
undisguise:defaultAccess( ULib.ACCESS_ADMIN )
undisguise:help("Remove the disguise of players.")
