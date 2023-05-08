--Luctus SCP Radio
--Made by OverlordAkise

util.AddNetworkString("luctus_radio")
resource.AddWorkshop("635535045")

luctus_radio_teams = {}

LuctusLog = LuctusLog or function()end

lradioHear = {}

for _, ply in pairs(player.GetAll()) do
    lradioHear[ply] = {}
end

timer.Simple(1,function()

    timer.Create("luctus_radio_main", DarkRP.voiceCheckTimeDelay, 0, function()
        local players = player.GetHumans()
        for _, ply in ipairs(players) do
            lradioHear[ply] = {}
            for kk,ply2 in pairs(player.GetAll()) do
                if not ply.lradioOn or not ply2.lradioOn or ply.lradioChannel != ply2.lradioChannel then continue end
                if IsValid(ply2:GetActiveWeapon()) and ply2:GetActiveWeapon():GetClass() == "luctus_radio" then
                    lradioHear[ply][ply2] = true
                end
            end
        end
    end)

end)

hook.Add("PlayerCanHearPlayersVoice","luctus_radio",function(listener, talker)
    if lradioHear[listener] and lradioHear[listener][talker] then
        return true, false
    end
end)

hook.Add("PlayerInitialSpawn", "luctus_radio_spawnset", function(ply)
    ply.lradioOn = false
    ply.lradioCooldown = CurTime() + 0.5
    ply.lradioChannel = "none"
end)


function LuctusAddRadioReceiver(ply,bol)
    if not ply:IsPlayer() then return end
    if ply.lradioCooldown > CurTime() then return end
    ply.lradioCooldown = CurTime() + 0.5
    ply.lradioOn = bol
    if bol then
        DarkRP.notify(ply,0,5,"You logged into radio channel "..ply.lradioChannel.."!")
        DarkRP.notify(ply,0,5,"People only hear you if you got the device in your hand!")
    else
        DarkRP.notify(ply,1,5,"You logged out of the radio channel!")
    end
end

function LuctusResetRadio(ply)
    ply.lradioOn = false
    ply.lradioChannel = "none"
end
hook.Add("PostPlayerDeath","luctus_radio_reset",LuctusResetRadio)
hook.Add("PlayerSpawn","luctus_radio_reset",LuctusResetRadio)


net.Receive("luctus_radio", function(len,ply)
    local channel = net.ReadString()
    if not LUCTUS_RADIO_CHANNELS[channel] then return end
    if not table.HasValue(LUCTUS_RADIO_CHANNELS[channel],ply:Team()) then return end
    
    ply.lradioChannel = channel
    DarkRP.notify(ply,0,5,"Channel switched to "..channel)
    LuctusLog("Radio",ply:Nick().."("..ply:SteamID()..") his channel to "..ply.lradioChannel)
end)

print("[luctus_sradio] sv loaded!")