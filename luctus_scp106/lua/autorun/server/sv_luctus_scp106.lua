--Luctus SCP106
--Made by OverlordAkise

util.AddNetworkString("luctus_scp106_tp")
util.AddNetworkString("luctus_scp106_tpscreen")

--false=nocollide
hook.Add("ShouldCollide", "luctus_scp106_runthroughdoors", function(ply, ent)
	if not ply:IsPlayer() or ply:Team() ~= TEAM_SCP106 then return true end
    if not LUCTUS_SCP106_WALKABLE_ENTS[ent:GetClass()] then end
    if LUCTUS_SCP106_WALKABLE_EXCEPTIONS[ent:MapCreationID()] then return true end
    if LUCTUS_SCP106_UNWALKABLE_MODELS[ent:GetModel()] then return true end
    return false
end)

local upvec = Vector(0,0,5)
hook.Add("PlayerFootstep", "luctus_scp106", function(ply, pos)
	if ply:Team() ~= TEAM_SCP106 then return false end
    util.Decal("Scorch", pos+upvec, pos-upvec, ply)
    return false
end)

hook.Add("PlayerSpawn", "luctus_scp106_customcollide", function(ply)
	if string.EndsWith(team.GetName(ply:Team()),"106") then
		ply:SetCustomCollisionCheck(true)
	else
		ply:SetCustomCollisionCheck(false)
	end
end)


local arrivevec = Vector(0,0,63)
function LuctusSCP106Teleport(ply,destination)
    if not IsValid(ply) then return end
    if LUCTUS_SCP106_IMMUNE_MODELS[ply:GetModel()] then return end
    if LUCTUS_SCP106_IMMUNE_JOBS[team.GetName(ply:Team())] then return end
    
    ply:Lock()
    ply:EmitSound(LUCTUS_SCP106_TP_SOUND)
    net.Start("luctus_scp106_tpscreen")
    net.Send(ply)
    local tpvec = Vector(0,0,LUCTUS_SCP106_TP_SPEED)
    local steamid = ply:SteamID()
    local goingDown = true
    local tickcounter = 0
    hook.Add("Tick","luctus_scp106_tp_"..steamid,function()
        if not IsValid(ply) then
            hook.Remove("Tick","luctus_scp106_tp_"..steamid)
            return
        end
        if not ply:Alive() then
            ply:UnLock()
            hook.Remove("Tick","luctus_scp106_tp_"..steamid)
            return
        end
        if goingDown then
            if tickcounter >= 63 then
                goingDown = false
                ply:SetPos(destination-arrivevec)
                return
            end
            ply:SetPos(ply:GetPos()-tpvec)
            tickcounter = tickcounter + LUCTUS_SCP106_TP_SPEED
        else
            ply:SetPos(ply:GetPos()+tpvec)
            tickcounter = tickcounter - LUCTUS_SCP106_TP_SPEED
            if tickcounter <= 0 then
                ply:UnLock()
                hook.Remove("Tick","luctus_scp106_tp_"..steamid)
            end
        end
    end)
end

net.Receive("luctus_scp106_tp",function(l,ply)
    if ply:Team() ~= TEAM_SCP106 then return end
    if not ply.last106TP then ply.last106TP = 0 end
    if ply.last106TP > CurTime() then return end
    local dname = net.ReadString()
    local pos = LUCTUS_SCP106_TP_POINTS[dname]
    ply.last106TP = CurTime() + LUCTUS_SCP106_TELEPORT_COOLDOWN
    if dname == "last" and ply.LastTP then
        pos = ply.LastTP
    end
    if not pos then return end
    
    ply.LastTP = ply:GetPos()
    net.Start("luctus_scp106_tp")
        net.WriteVector(ply:GetPos())
    net.Send(ply)
    
    LuctusSCP106Teleport(ply,pos)
end)

concommand.Add("cl_getpos",function(ply)
    if not IsValid(ply) then return end
    local pos = ply:GetPos()
    ply:PrintMessage(HUD_PRINTCONSOLE,"Vector("..pos.x..","..pos.y..","..pos.z..")")
end)

function LuctusSCP106CreateOrbAndLaunch(ply)
    local ang = ply:GetAngles()
    local cballspawner = ents.Create("point_combine_ball_launcher")
    cballspawner:SetAngles(ang)
    cballspawner:SetPos(ply:GetPos()+ang:Forward()*10+Vector(0,0,64))
    cballspawner:SetKeyValue("minspeed",LUCTUS_SCP106_ATTACK_FLYSPEED)
    cballspawner:SetKeyValue("maxspeed",LUCTUS_SCP106_ATTACK_FLYSPEED)
    cballspawner:SetKeyValue("maxballbounces",5)
    cballspawner:SetKeyValue("launchconenoise",0)
    cballspawner:Spawn()
    cballspawner:Activate()
    cballspawner:Fire("LaunchBall")
    cballspawner:Fire("kill","",0)
end

print("[SCP106] sv loaded")
