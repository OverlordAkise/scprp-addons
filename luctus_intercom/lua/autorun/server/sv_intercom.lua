--Luctus Intercom
--Made by OverlordAkise

intercomplayer = {}

util.AddNetworkString("luctus_intercom_sync")

timer.Create("intercom_use", 3, 0, function()
    old_players = intercomplayer or {}
    intercomplayer = {}
    local iEnts = ents.FindByClass("luctus_intercom")
    if table.Count(iEnts) <= 0 then
        return
    end
    local iEnt = iEnts[1]
    if not IsValid(iEnt) then return end
    local entPlayers = ents.FindInSphere(iEnt:GetPos(),256)
    for k,v in pairs(entPlayers) do
        if v:IsPlayer() and v:Alive() then
            intercomplayer[v] = true
            if not old_players[v] then
                DarkRP.notify(v,2,3,"[intercom] You are now live!")
                net.Start("luctus_intercom_sync")
                    net.WriteBool(true)
                net.Send(v)
            end
        end
    end
    for k,v in pairs(old_players) do
        if not intercomplayer[k] then
            DarkRP.notify(k,2,3,"[intercom] Others can't hear you anymore!")
            net.Start("luctus_intercom_sync")
                net.WriteBool(false)
            net.Send(k)
        end
    end
end)

hook.Add("PlayerCanHearPlayersVoice","luctus_intercom_global_talk",function(listener, talker)
    if intercomplayer[talker] then
        return true, false
    end
end)

print("[luctus_intercom] sv loaded!")
