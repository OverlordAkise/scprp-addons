--Luctus Noclip
--Made by OverlordAkise

util.AddNetworkString("luctus_noclip")

hook.Add("PlayerNoClip","luctus_noclip",function(ply,wantsOn)
    --No logging because your logsystem should do it already
    if not LUCTUS_NOCLIP_ALLOWED[ply:GetUserGroup()] then return false end
    if wantsOn then
        if LUCTUS_NOCLIP_INVIS then ULib.invisible(ply, true, 0) end
        if LUCTUS_NOCLIP_GOD then ply:GodEnable() end
        LuctusNoclipSend(ply,wantsOn)
    else
        if LUCTUS_NOCLIP_INVIS then ULib.invisible(ply, false, 255) end
        if LUCTUS_NOCLIP_GOD then ply:GodEnable() end
        LuctusNoclipSend(ply,wantsOn)
    end
end,-1)

function LuctusNoclipSend(ply,state)
    net.Start("luctus_noclip")
        net.WriteBool(state)
    net.Send(ply)
end

print("[luctus_noclip] sv loaded")
