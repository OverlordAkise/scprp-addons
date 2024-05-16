--Luctus Weaponcabinet
--Made by OverlordAkise

util.AddNetworkString("luctus_weaponcabinet")
util.AddNetworkString("luctus_weaponcabinet_r")
util.AddNetworkString("luctus_weaponcabinet_buy")

hook.Add("PlayerSpawn","luctus_weaponcabinet_reset",function(ply)
    timer.Simple(0.1,function() --safety
        if LUCTUS_WEAPONCABINET_KEEPWEPS then
            if not table.IsEmpty(ply.luctus_wc_weps) then
                for k,v in pairs(ply.luctus_wc_weps) do
                    ply:Give(k)
                end
            end
        else
            ply.luctus_wc_weps = {}
        end
    end)
end)
hook.Add("PlayerInitialSpawn","luctus_weaponcabinet_reset",function(ply)
    ply.luctus_wc_weps = {}
end)

net.Receive("luctus_weaponcabinet",function(len,ply)
    local ent = net.ReadEntity()
    if ent:GetClass() ~= "luctus_weaponcabinet" then return end
    if ent:GetPos():Distance(ply:GetPos()) > 512 then return end
    
    local cat = net.ReadString()
    if not LUCTUS_WEAPONCABINET_S[cat] then return end
    if not LUCTUS_WEAPONCABINET_S[cat]["jobs"][ply:getDarkRPVar("job")] then return end
    
    if table.Count(ply.luctus_wc_weps) >= LUCTUS_WEAPONCABINET_MAX then
        DarkRP.notify(ply,1,5,"You took out too many weapons already!")
        return
    end
    local wep = net.ReadString()
    if ply:HasWeapon(wep) then return end
    if not LUCTUS_WEAPONCABINET_S[cat]["weps"][wep] then return end
    ply:Give(wep)
    ply.luctus_wc_weps[wep] = true
    hook.Run("LuctusWeaponCabinetGet",ply,wep)
end)

net.Receive("luctus_weaponcabinet_buy",function(len,ply)
    local ent = net.ReadEntity()
    if ent:GetClass() ~= "luctus_weaponnpc" then return end
    if ent:GetPos():Distance(ply:GetPos()) > 512 then return end
    local cat = net.ReadString()
    if not LUCTUS_WEAPONNPC_WEAPONS[cat] then return end
    local catConfig = LUCTUS_WEAPONNPC_WEAPONS[cat]
    if not table.HasValue(catConfig.AllowedJobs,ply:getDarkRPVar("job")) then return end
    local wep = net.ReadString()
    if ply:HasWeapon(wep) then return end
    local price = catConfig.Weapons[wep]
    if not price then return end
    if not ply:canAfford(price) then return end
    ply:addMoney(-price)
    ply:Give(wep)
    hook.Run("LuctusWeaponCabinetBuy",ply,wep,price)
end)

net.Receive("luctus_weaponcabinet_r",function(len,ply)
    local ent = net.ReadEntity()
    if ent:GetClass() ~= "luctus_weaponcabinet" then return end
    if ent:GetPos():Distance(ply:GetPos()) > 512 then return end
    local wep = net.ReadString()
    if not ply:HasWeapon(wep) then return end
    ply:StripWeapon(wep)
    if ply.luctus_wc_weps[wep] then
        ply.luctus_wc_weps[wep] = nil
    end
    hook.Run("LuctusWeaponCabinetReturn",ply,wep)
end)

hook.Add("OnPlayerChangedTeam", "luctus_wc_reset_weps", function(ply, beforeNum, afterNum)
    ply.luctus_wc_weps = {}
end)

print("[luctus_weaponcabinet] sv loaded")
