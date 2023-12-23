--Luctus Intercom
--Made by OverlordAkise

LUCTUS_INTERCOM_LISTENERS = LUCTUS_INTERCOM_LISTENERS or {}
LUCTUS_INTERCOM_SPEAKERS = LUCTUS_INTERCOM_SPEAKERS or {}
LUCTUS_INTERCOM_POS_ONE = LUCTUS_INTERCOM_POS_ONE or nil
LUCTUS_INTERCOM_POS_TWO = LUCTUS_INTERCOM_POS_TWO or nil

util.AddNetworkString("luctus_intercom_sync")
util.AddNetworkString("luctus_intercom_startsound")

hook.Add("PlayerSay","luctus_intercom",function(ply,text)
    if not ply:IsAdmin() then return end
    if text == "!intercom1" then
        LuctusIntercomSaveLocation(ply:GetPos(),true)
        DarkRP.notify(ply,0,5,"First position saved!")
    end
    if text == "!intercom2" then
        LuctusIntercomSaveLocation(ply:GetPos(),false)
        DarkRP.notify(ply,0,5,"Second position saved!")
    end
    if text == "!intercomreload" then
        LuctusIntercomReloadPos()
        DarkRP.notify(ply,0,5,"Reloaded positions!")
    end
end)

function LuctusIntercomSaveLocation(vector,isFirst)
    if isFirst then
        file.Write("luctus_intercom_vec1.txt",tostring(vector))
    else
        file.Write("luctus_intercom_vec2.txt",tostring(vector))
    end
end

function LuctusIntercomReloadPos()
    if file.Exists("luctus_intercom_vec1.txt","DATA") and file.Exists("luctus_intercom_vec2.txt","DATA") then
        LUCTUS_INTERCOM_POS_ONE = Vector(file.Read("luctus_intercom_vec1.txt","DATA"))
        LUCTUS_INTERCOM_POS_TWO = Vector(file.Read("luctus_intercom_vec2.txt","DATA"))
    else
        ErrorNoHaltWithStack("INTERCOM ERROR: NO POSITIONS FOUND!")
        print("[intercom] Please use '!intercom1' and '!intercom2' to set the positions")
        print("[intercom] of the box where players can hear the intercom!")
        print("[intercom] Then use '!intercomreload' to reload the positions")
    end
end

hook.Add("InitPostEntity","luctus_intercom",function()
    LuctusIntercomReloadPos()
end)

function LuctusIntercomPlayStartSound()
    net.Start("luctus_intercom_startsound")
    net.Broadcast()
end

function LuctusIntercomAdd(ply,ent)
    local plyCountBefore = table.Count(LUCTUS_INTERCOM_SPEAKERS)
    if not LUCTUS_INTERCOM_SPEAKERS[ply] then
        ent.Speakers[ply] = true
        LUCTUS_INTERCOM_SPEAKERS[ply] = true
        net.Start("luctus_intercom_sync")
            net.WriteBool(true)
        net.Send(ply)
        if plyCountBefore <= 0 then
            LuctusIntercomPlayStartSound()
        end
    end
end

function LuctusIntercomRemoveCheck(ply,ent,forceDelete)
    if not IsValid(ply) then
        ent.Speakers[ply] = nil
        LUCTUS_INTERCOM_SPEAKERS[ply] = nil
        return
    end
    if ply:GetPos():Distance(ent:GetPos()) > 256 or forceDelete then
        ent.Speakers[ply] = nil
        LUCTUS_INTERCOM_SPEAKERS[ply] = nil
        net.Start("luctus_intercom_sync")
            net.WriteBool(false)
        net.Send(ply)
    end
end

timer.Create("luctus_intercom",1,0,function()
    LUCTUS_INTERCOM_LISTENERS = {}
    if table.Count(LUCTUS_INTERCOM_SPEAKERS)<1 then
        return
    end
    if not LUCTUS_INTERCOM_POS_ONE or not LUCTUS_INTERCOM_POS_TWO then return end
    for k,ply in ipairs(player.GetAll()) do
        if ply:GetPos():WithinAABox(LUCTUS_INTERCOM_POS_ONE,LUCTUS_INTERCOM_POS_TWO) then
            LUCTUS_INTERCOM_LISTENERS[ply] = true
        end
    end
end)

hook.Add("PlayerCanHearPlayersVoice","luctus_intercom_global_talk",function(listener, talker)
    if LUCTUS_INTERCOM_SPEAKERS[talker] and LUCTUS_INTERCOM_LISTENERS[listener] then
        return true, false
    end
end)

print("[luctus_intercom] sv loaded!")
