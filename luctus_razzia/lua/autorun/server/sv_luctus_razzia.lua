--Luctus Razzia
--Made by OverlordAkise

util.AddNetworkString("luctus_razzia")
hook.Add("PlayerSay", "luctus_razzia", function(ply,text)
    if LUCTUS_RAZZIA_JOBS_SEND[team.GetName(ply:Team())] then
        local toSend = nil
        if text == LUCTUS_RAZZIA_STARTCMD then toSend = true end
        if text == LUCTUS_RAZZIA_ENDCMD then toSend = false end
        if toSend == nil then return end
        for k,v in pairs(player.GetAll()) do
            if not LUCTUS_RAZZIA_JOBS_RECV[team.GetName(v:Team())] then continue end
            net.Start("luctus_razzia")
                net.WriteBool(toSend)
            net.Send(v)
        end
    end
end)

print("[luctus_razzia] sv loaded!")
