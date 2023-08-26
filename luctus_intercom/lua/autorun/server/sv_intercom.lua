--Luctus Intercom
--Made by OverlordAkise

LUCTUS_INTERCOM_LISTENERS = {}

util.AddNetworkString("luctus_intercom_sync")

function LuctusIntercomAdd(ply,ent)
    if not LUCTUS_INTERCOM_LISTENERS[ply] then
        ent.Speakers[ply] = true
        LUCTUS_INTERCOM_LISTENERS[ply] = true
        net.Start("luctus_intercom_sync")
            net.WriteBool(true)
        net.Send(ply)
    end
end

function LuctusIntercomRemoveCheck(ply,ent,forceDelete)
    if not IsValid(ply) then
        ent.Speakers[ply] = nil
        LUCTUS_INTERCOM_LISTENERS[ply] = nil
        return
    end
    if ply:GetPos():Distance(ent:GetPos()) > 256 or forceDelete then
        ent.Speakers[ply] = nil
        LUCTUS_INTERCOM_LISTENERS[ply] = nil
        net.Start("luctus_intercom_sync")
            net.WriteBool(false)
        net.Send(ply)
    end
end

hook.Add("PlayerCanHearPlayersVoice","luctus_intercom_global_talk",function(listener, talker)
    if LUCTUS_INTERCOM_LISTENERS[ply] then
        return true, false
    end
end)

print("[luctus_intercom] sv loaded!")
