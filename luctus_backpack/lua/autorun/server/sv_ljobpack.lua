--Luctus Backpack
--Made by OverlordAkise

util.AddNetworkString("luctus_jobbackpack_buy")

net.Receive("luctus_jobbackpack_buy", function(len, ply)
    if not ply.backpack_cooldown then ply.backpack_cooldown = 0 end
    if ply.backpack_cooldown > CurTime() then return end
    ply.backpack_cooldown = CurTime() + 0.5
    local id = net.ReadInt(32)
    local job = ply:Team()
    if not LUCTUS_BACKPACK[job] then return end
    if not LUCTUS_BACKPACK[job][id] then return end
    local weapon = LUCTUS_BACKPACK[job][id][1]
    local price = LUCTUS_BACKPACK[job][id][2]
    if not weapon or not isstring(weapon) then return end
    if not price or not isnumber(price) then return end
    
    if not ply:canAfford(price) then return end
    ply:addMoney(-1*price)
    
    local plyAngle = ply:EyeAngles()
    plyAngle.pitch = 0
    local enti = ents.Create(weapon)
    enti:SetPos(ply:GetPos()+Vector(0,0,20)+plyAngle:Forward()*120)
    enti:Spawn()
    enti:Activate()
end)


print("[luctus_jobbackpack] sv loaded!")
