--Luctus Intro
--Made by OverlordAkise

--Important: Please enable darkrp's "respawn on job change"

--How long to wait between spot switches, in seconds
LuctusIntroSwitchDelay = 0

--The spots and angles for the camera intros
--speed 1 = 1second
--speed 0.25 = 4 seconds

LuctusIntroSpots = {
    {
        startVec = Vector(-1629.728638, -218.268570, 124.444618),
        startAng = Angle(9.108, -131.117, 0.000),
        endVec = Vector(-1944.978149, -308.059113, 120.832062),
        endAng = Angle(10.494, -31.919, 0.000),
        speed = 0.25,
    },
    {
        startVec = Vector(-810.063477, 3944.468750, 242.319168),
        startAng = Angle(11.137, -142.983, 0.000),
        endVec = Vector(-2084.818848, 3134.341553, 141.981613),
        endAng = Angle(8.035, 143.031, 0.000),
        speed = 0.25,
    },

}

--CONFIG END

util.AddNetworkString("luctus_intro_start")

luctusIntroCurrent = 1
luctusIntroEnt = nil
luctusIntroSwitch = false

function luctusintrocur()
    return luctusIntroCurrent+1
end

hook.Add("PlayerInitialSpawn","luctus_intro",function(ply)
    if not luctusIntroEnt or not IsValid(luctusIntroEnt) then
        luctusCreateIntroEnt()
    end
end)

net.Receive("luctus_intro_start",function(len,ply)
    if not ply.intro then
        ply.intro = true
        ply:StripWeapons()
        ply:Spectate(OBS_MODE_IN_EYE)
        ply:SpectateEntity(luctusIntroEnt)
        net.Start("luctus_intro_start")
            net.WriteEntity(luctusIntroEnt)
        net.Send(ply)
    elseif ply.intro == true then
        ply.intro = "done"
        ply:UnSpectate()
        ply:Spawn()
    end
end)

function luctusCreateIntroEnt()
    luctusIntroEnt = ents.Create("prop_dynamic")
    luctusIntroEnt:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    luctusIntroEnt.stime = SysTime()
    luctusIntroEnt:Spawn()
    luctusIntroCurrent = 1
    luctusIntroEnt:SetPos(LuctusIntroSpots[luctusintrocur()].startVec)
    luctusIntroEnt:SetAngles(LuctusIntroSpots[luctusintrocur()].startAng)
end

hook.Add("Think","luctus_intro",function()
    if luctusIntroEnt and IsValid(luctusIntroEnt) then
        local speed = LuctusIntroSpots[luctusintrocur()].speed
        local curProgress = SysTime()*speed-luctusIntroEnt.stime*speed
        if curProgress > 1 then
            if luctusIntroSwitch then return end
            luctusIntroSwitch = true
            timer.Simple(LuctusIntroSwitchDelay,function()
                luctusIntroCurrent = ((luctusIntroCurrent + 1) % (#LuctusIntroSpots))
                luctusIntroEnt:SetPos(LuctusIntroSpots[luctusintrocur()].startVec)
                luctusIntroEnt:SetAngles(LuctusIntroSpots[luctusintrocur()].startAng)
                timer.Simple(LuctusIntroSwitchDelay,function()
                    luctusIntroEnt.stime = SysTime()
                    luctusIntroSwitch = false
                end)
            end)
            return
        end
        luctusIntroEnt:SetPos(LerpVector(curProgress,LuctusIntroSpots[luctusintrocur()].startVec,LuctusIntroSpots[luctusintrocur()].endVec))
        luctusIntroEnt:SetAngles(LerpAngle(curProgress,LuctusIntroSpots[luctusintrocur()].startAng,LuctusIntroSpots[luctusintrocur()].endAng))
    end
end)

print("[luctus_intro] sv loaded!")
