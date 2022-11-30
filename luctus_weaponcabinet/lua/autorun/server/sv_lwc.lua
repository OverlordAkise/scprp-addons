--Luctus Weaponcabinet
--Made by OverlordAkise

util.AddNetworkString("luctus_weaponcabinet")
util.AddNetworkString("luctus_weaponcabinet_r")

hook.Add("PlayerSpawn","luctus_weaponcabinet_reset",function(ply)
    ply.luctus_wc = 0
end)
hook.Add("PlayerInitialSpawn","luctus_weaponcabinet_reset",function(ply)
    ply.luctus_wc = 0
end)

net.Receive("luctus_weaponcabinet",function(len,ply)
    local cat = net.ReadString()
    if not LUCTUS_WEAPONCABINET_S[cat] then return end
    
    if not LUCTUS_WEAPONCABINET_S[cat]["jobs"][ply:getDarkRPVar("job")] then return end
    local ent = net.ReadEntity()
    if ent:GetClass() ~= "luctus_weaponcabinet" then return end
    if ent:GetPos():Distance(ply:GetPos()) > 512 then return end
    if ply.luctus_wc >= LUCTUS_WEAPONCABINET_MAX then return end
    local wep = net.ReadString()
    if ply:HasWeapon(wep) then return end
    if not LUCTUS_WEAPONCABINET_S[cat]["weps"][wep] then return end
    ply.luctus_wc = ply.luctus_wc + 1
    ply:Give(wep)
end)

net.Receive("luctus_weaponcabinet_r",function(len,ply)
    local ent = net.ReadEntity()
    if ent:GetClass() ~= "luctus_weaponcabinet" then return end
    if ent:GetPos():Distance(ply:GetPos()) > 512 then return end
    local wep = net.ReadString()
    if ply:HasWeapon(wep) then
        ply:StripWeapon(wep)
        ply.luctus_wc = math.max(0, ply.luctus_wc-1)
    end
end)

print("[luctus_weaponcabinet] sv loaded")
