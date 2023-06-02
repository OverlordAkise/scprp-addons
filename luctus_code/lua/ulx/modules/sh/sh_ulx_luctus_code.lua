function ulx.luctuscode(calling_ply, code)
    if not LUCTUS_SCP_CODES[code] then
        ULib.tsayError( calling_ply, "That code doesn't exist!", true )
		return
    end
    LuctusCodeChange(code,calling_ply)
	ulx.fancyLogAdmin(calling_ply, "#A changed code to #s", code)
end
local luctuscode = ulx.command("SCP", "ulx code", ulx.luctuscode, "!ulxcode")
luctuscode:addParam{ type=ULib.cmds.StringArg, hint="red" }
luctuscode:defaultAccess(ULib.ACCESS_ADMIN)
luctuscode:help("Change the active 'code' (red,yellow,green).")
