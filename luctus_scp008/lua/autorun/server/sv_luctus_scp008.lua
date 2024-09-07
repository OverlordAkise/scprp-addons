--Luctus SCP008 System
--Made by OverlordAkise

util.AddNetworkString("luctus_scp008_infection")

local cache = {}

function LuctusSCP008StartContainment(openPly)
    local iEnts = ents.FindByClass("luctus_scp008_spreader")
    if table.Count(iEnts) <= 0 then
        error("Couldnt find scp008 spreader entity! Please read the README.txt")
    end
    
    timer.Create("luctus_scp008", 0.1, 0, function()
        for k,ply in ipairs(player.GetAll()) do
            if not ply:Alive() then continue end
            for k,spreader in ipairs(iEnts) do
                if not IsValid(spreader) then continue end
                local trac = util.TraceLine({
                    start = ply:EyePos(),
                    endpos = spreader:GetPos(),
                    filter = function(ent) return ent ~= ply end
                })
                if trac.Entity == spreader then
                    LuctusSCP008StartInfection(ply,LUCTUS_SCP008_DIRECT_EXPOSURE)
                end
            end
        end
    end)
    hook.Run("LuctusSCP008HatchOpened",openPly)
end

function LuctusSCP008IsContaining()
    return timer.Exists("luctus_scp008")
end

function LuctusSCP008StopContainment()
    timer.Remove("luctus_scp008")
    hook.Run("LuctusSCP008HatchClosed")
end

function LuctusSCP008StartInfection(ply,amount)
    if LUCTUS_SCP008_IMMUNEMODELS[ply:GetModel()] then return end
    if ply:GetNW2Bool("scp008_zombie",false) then return end
    
    cache[ply] = cache[ply] or {}
    
    net.Start("luctus_scp008_infection")
        net.WriteBool(true)
    net.Send(ply)
    local inf = ply:GetNW2Float("luctus_scp008_infection",0)
    if inf == 0 then
        hook.Run("LuctusSCP008PlayerInfected",ply,amount)
    end
    ply:SetNW2Float("luctus_scp008_infection",inf+amount)
    if timer.Exists(ply:SteamID().."_scp008_infection") then return end
    
    timer.Create(ply:SteamID().."_scp008",LUCTUS_SCP008_INFECTION_TIME,0,function()
        local infection = ply:GetNW2Float("luctus_scp008_infection",0)
        ply:SetNW2Float("luctus_scp008_infection",infection+LUCTUS_SCP008_INFECTION_TIME_WORSENING)
        if infection > 50 and not cache[ply].heartbeat then
            cache[ply].heartbeat = true
            ply:EmitSound("player/heartbeat1.wav", 45)
        end
        if infection > 75 and not cache[ply].breathe then
            cache[ply].breathe = true
            ply:EmitSound("player/breathe1.wav")
        end
        if infection >= 100 then
            LuctusSCP008TurnIntoZombie(ply)
        end
    end)
end

function LuctusSCP008TurnIntoZombie(ply)
    LuctusSCP008StopInfection(ply)
    ply:SetNW2Bool("scp008_zombie",true)
    ply:SetModel("models/player/zombie_classic.mdl")
    ply:EmitSound("ambient/creatures/town_zombie_call1.wav",90)
    ply:StripWeapons()
    ply:Give("weapon_luctus_scp008")
    ply:SetWalkSpeed(200)
    ply:SetRunSpeed(280)
    ply:SetMaxHealth(1000)
    ply:SetHealth(1000)
    ply:SetArmor(200)
    hook.Run("LuctusSCP008PlayerZombified",ply)
end

function LuctusSCP008StopInfection(ply)
    timer.Remove(ply:SteamID().."_scp008")
    ply:SetNW2Bool("scp008_zombie",false)
    net.Start("luctus_scp008_infection")
        net.WriteBool(false)
    net.Send(ply)
    ply:SetNW2Float("luctus_scp008_infection",0)
    ply:StopSound("player/heartbeat1.wav")
    ply:StopSound("player/breathe1.wav")
    cache[ply] = {}
    hook.Run("LuctusSCP008PlayerInfectionStopped",ply)
end

function LuctusSCP008HealFromZombie(ply)
    local oldPos = ply:GetPos()
    ply:Spawn()
    ply:SetPos(oldPos)
    hook.Run("LuctusSCP008PlayerHealed",ply)
end

hook.Add("PlayerSpawn","luctus_scp008_stop",function(ply)
    LuctusSCP008StopInfection(ply)
end)

--clear cache regularly
timer.Create("luctus_scp008_cache_clear",300,0,function()
    for ply,tab in pairs(cache) do
        if not IsValid(ply) then cache[ply] = nil end
    end
end)


--Logic for hatch open = start infecting

LUCTUS_SCP008_ISACTIVE = LUCTUS_SCP008_ISACTIVE or false

hook.Add("PostCleanupMap","luctus_scp008_reset",function()
    LUCTUS_SCP008_ISACTIVE = false
end)

hook.Add("AcceptInput","luctus_scp008",function(ent,type,ply)
    if type ~= "Use" then return end
    local mid = ent:MapCreationID()
    if mid == -1 or mid ~= LUCTUS_SCP008_HATCH_ENTMAPID then return end
    
    LUCTUS_SCP008_ISACTIVE = not LUCTUS_SCP008_ISACTIVE
    if LUCTUS_SCP008_ISACTIVE then
        LuctusSCP008StartContainment(ply)
    else
        LuctusSCP008StopContainment()
    end
end)

print("[luctus_scp008] sv loaded")
