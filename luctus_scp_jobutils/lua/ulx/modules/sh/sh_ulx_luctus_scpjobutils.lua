function ulx.setvoice(calling_ply, target_plys, should_disable)
	for i=1, #target_plys do
		local v = target_plys[i]
		if should_disable then
			v.noVoice = true
		else
			v.noVoice = false
		end
	end

	if should_disable then
		ulx.fancyLogAdmin( calling_ply, "#A disabled voicechat for #T", target_plys )
	else
		ulx.fancyLogAdmin( calling_ply, "#A enabled voicechat for #T", target_plys )
	end
end
local scpvoice = ulx.command("SCP", "ulx enablevoice", ulx.setvoice, "!enablevoice")
scpvoice:addParam{ type=ULib.cmds.PlayersArg }
scpvoice:addParam{ type=ULib.cmds.BoolArg, invisible=true }
scpvoice:defaultAccess(ULib.ACCESS_ADMIN)
scpvoice:help("Allow or disallow SCPs to speak via voicechat again.")
scpvoice:setOpposite("ulx disablevoice", {_, _, true}, "!disablevoice")
