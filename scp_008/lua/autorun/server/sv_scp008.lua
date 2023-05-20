--Luctus SCP008 System
--Made by OverlordAkise

util.AddNetworkString("luctus_scp008_infection")

function LuctusSCP008StartContainment()
    local iEnts = ents.FindByClass("luctus_scp008_spreader")
    if table.Count(iEnts) <= 0 then
        PrintMessage(HUD_PRINTTALK, "ERROR: COULDNT FIND SCP008 SPREADER ENTITY!")
        return
    end
    local sent = iEnts[1]
    if not IsValid(sent) then return end
    
    timer.Create("luctus_scp008", 0.1, 0, function()
        local entPlayers = ents.FindInSphere(sent:GetPos(),2048)
        for k,v in pairs(entPlayers) do
            if v:IsPlayer() and v:Alive() then
                local trac = util.TraceLine({
                    start = v:EyePos(),
                    endpos = sent:GetPos(),
                    filter = function(ent) return ent ~= v end
                })
                --Without the filter it would be blocked by the players own head o3o
                if trac.Entity and IsValid(trac.Entity) and trac.Entity == sent then
                    LuctusSCP008StartInfection(v,LUCTUS_SCP008_DIRECT_EXPOSURE)
                end
            end
        end
    end)
end

function LuctusSCP008IsContaining()
    return timer.Exists("luctus_scp008")
end

function LuctusSCP008StopContainment()
    timer.Remove("luctus_scp008")
end

function LuctusSCP008StartInfection(ply,val)
    if LUCTUS_SCP008_IMMUNEMODELS[ply:GetModel()] then return end
    if LUCTUS_SCP008_DEBUG then
        PrintMessage(HUD_PRINTTALK,"Infecting player:"..ply:Nick()..math.random())
    end
    if ply:GetNWBool("luctus_scp008_zombie",false) then return end
    net.Start("luctus_scp008_infection")
        net.WriteBool(true)
    net.Send(ply)
    local inf = ply:GetNWInt("luctus_scp008_infection",0)
    ply:SetNWInt("luctus_scp008_infection",inf+val)
    if not timer.Exists(ply:SteamID().."_scp008_infection") then
        timer.Create(ply:SteamID().."_scp008_infection",LUCTUS_SCP008_INFECTION_TIME,0,function()
            local infection = ply:GetNWInt("luctus_scp008_infection",0)
            ply:SetNWInt("luctus_scp008_infection",infection+LUCTUS_SCP008_INFECTION_WORSENING)
            if infection > 50 and not ply.scp008_50inf then
                ply.scp008_50inf = true
                ply:EmitSound("player/heartbeat1.wav", 45)
            end
            if infection > 80 and not ply.scp008_80inf then
                ply.scp008_80inf = true
                ply:EmitSound("player/breathe1.wav")
            end
            if ply:GetNWInt("luctus_scp008_infection",0) >= 100 then
                LuctusSCP008DoneInfection(ply)
            end
        end)
    end
end

function LuctusSCP008DoneInfection(ply) --infection finished
    timer.Remove(ply:SteamID().."_scp008_infection")
    ply:SetNWBool("luctus_scp008_zombie",true)
    net.Start("luctus_scp008_infection")
        net.WriteBool(false)
    net.Send(ply)
    ply:SetNWInt("luctus_scp008_infection",0)
    ply:StopSound("player/heartbeat1.wav")
    ply:StopSound("player/breathe1.wav")
    ply.scp008_50inf = false
    ply.scp008_80inf = false
    
    ply:SetModel("models/player/zombie_classic.mdl")
    ply:EmitSound("ambient/creatures/town_zombie_call1.wav",90)
    ply:StripWeapons()
    ply:Give("weapon_scp008")
    ply:SetWalkSpeed(200)
    ply:SetRunSpeed(280)
    ply:SetMaxHealth(1000)
    ply:SetHealth(1000)
    ply:SetArmor(200)
end

function LuctusSCP008Stop(ply)
    timer.Remove(ply:SteamID().."_scp008_infection")
    ply:SetNWBool("luctus_scp008_zombie",false)
    net.Start("luctus_scp008_infection")
        net.WriteBool(false)
    net.Send(ply)
    ply:SetNWInt("luctus_scp008_infection",0)
    ply:StopSound("player/heartbeat1.wav")
    ply:StopSound("player/breathe1.wav")
    ply.scp008_50inf = false
    ply.scp008_80inf = false
end

hook.Add("PlayerSpawn","luctus_scp008_stop",function(ply)
    LuctusSCP008Stop(ply)
end)

print("[SCP008] SV Loaded!")
