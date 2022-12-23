--Luctus Airsoft
--Made by OverlordAkise

hook.Add("PlayerSay","luctus_airsoft",function(ply,text,team)
    if text == "/airsoft" then
        if ply:GetNWBool("luctus_airsoft_active",false) then
            ply:SetNWBool("luctus_airsoft_active",false)
            DarkRP.notify(ply,0,5,"[AIRSOFT] Deactivated!")
        else
            ply:SetNWBool("luctus_airsoft_active",true)
            DarkRP.notify(ply,0,5,"[AIRSOFT] Activated!")
            ply:SetNWInt("luctus_airsoft_hp",100)
        end
    end
end)

hook.Add("ScalePlayerDamage","luctus_airsoft",function(ply, hitgroup, dmginfo )
    local atk = dmginfo:GetAttacker()
    if atk:IsPlayer() and atk:GetNWBool("luctus_airsoft_active",false) then
        ply:SetNWInt("luctus_airsoft_hp",ply:GetNWInt("luctus_airsoft_hp",100)-dmginfo:GetDamage())
        if ply:GetNWInt("luctus_airsoft_hp",100) < 1 then
            LuctusAirsoftRagdoll(ply)
        end
        return true
    end
end)

function LuctusAirsoftRagdoll(ply)
    ply:CreateRagdoll()
    ply:Spectate(OBS_MODE_CHASE)
    ply:SpectateEntity(ply:GetRagdollEntity())
    ply.airsoft_weapons = {}
    for k,v in pairs(ply:GetWeapons()) do
        table.insert(ply.airsoft_weapons,v:GetClass())
    end
    ply:StripWeapons()
    timer.Create(ply:SteamID().."_airsoft",10,1,function()
        if IsValid(ply) then
            local rag = ply:GetRagdollEntity()
            if IsValid(rag) then
                local newpos = rag:GetPos()
                rag:Remove()
                ply:UnSpectate()
                ply:Spawn()
                ply:SetPos(newpos)
                for k,v in pairs(ply.airsoft_weapons) do
                    ply:Give(v)
                end
            end
            ply:SetNWInt("luctus_airsoft_hp",100)
        end
    end)
end

print("[luctus_airsoft] sv loaded!")
