--Luctus Weaponcabinet
--Made by OverlordAkise

util.AddNetworkString("luctus_weaponcabinet")
util.AddNetworkString("luctus_weaponcabinet_r")

LuctusLog = LuctusLog or function()end

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
    local cat = net.ReadString()
    if not LUCTUS_WEAPONCABINET_S[cat] then return end
    
    if not LUCTUS_WEAPONCABINET_S[cat]["jobs"][ply:getDarkRPVar("job")] then return end
    local ent = net.ReadEntity()
    if ent:GetClass() ~= "luctus_weaponcabinet" then return end
    if ent:GetPos():Distance(ply:GetPos()) > 512 then return end
    if table.Count(ply.luctus_wc_weps) >= LUCTUS_WEAPONCABINET_MAX then
        DarkRP.notify(ply,1,5,"You took out too many weapons already!")
        return
    end
    local wep = net.ReadString()
    if ply:HasWeapon(wep) then return end
    if not LUCTUS_WEAPONCABINET_S[cat]["weps"][wep] then return end
    ply:Give(wep)
    ply.luctus_wc_weps[wep] = true
    LuctusLog("Weaponcabin",ply:Nick().."("..ply:SteamID()..") used weaponcabinet to get a "..wep)
end)

net.Receive("luctus_weaponcabinet_r",function(len,ply)
    local ent = net.ReadEntity()
    if ent:GetClass() ~= "luctus_weaponcabinet" then return end
    if ent:GetPos():Distance(ply:GetPos()) > 512 then return end
    local wep = net.ReadString()
    if ply:HasWeapon(wep) then
        ply:StripWeapon(wep)
        if ply.luctus_wc_weps[wep] then
            ply.luctus_wc_weps[wep] = nil
        end
        LuctusLog("Weaponcabin",ply:Nick().."("..ply:SteamID()..") used weaponcabinet to return a "..wep)
    end
end)

hook.Add("OnPlayerChangedTeam", "luctus_wc_reset_weps", function(ply, beforeNum, afterNum)
    ply.luctus_wc_weps = {}
end)

print("[luctus_weaponcabinet] sv loaded")
