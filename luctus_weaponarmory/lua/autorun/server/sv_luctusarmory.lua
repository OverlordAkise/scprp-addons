--Luctus Weaponarmory
--Made by OverlordAkise

util.AddNetworkString("luctus_weaponarmory")
util.AddNetworkString("luctus_weaponarmory_r")

local dbInit = false
hook.Add("PlayerInitialSpawn","luctus_weaponarmory",function(ply)
    if not dbInit then
        local res = sql.Query("CREATE TABLE IF NOT EXISTS luctus_weaponarmory(steamid TEXT, unlocks TEXT)")
        if res == false then ErrorNoHaltWithStack(sql.LastError()) end
        dbInit = true
    end
    ply.LuctusWArmory = {}
    ply.LuctusWArmoryJ = "{}"
     ply.LuctusWArmoryL = {} --limits of takeout
    local res = sql.QueryValue("SELECT unlocks FROM luctus_weaponarmory WHERE steamid = "..sql.SQLStr(ply:SteamID()))
    if res == false then ErrorNoHaltWithStack(sql.LastError()) end
    if not res then
        res = sql.Query("INSERT INTO luctus_weaponarmory(steamid,unlocks) VALUES("..sql.SQLStr(ply:SteamID())..",'{}')")
        if res == false then ErrorNoHaltWithStack(sql.LastError()) end
        return
    end
    ply.LuctusWArmory = util.JSONToTable(res)
    ply.LuctusWArmoryJ = res
end)

function LuctusWeaponArmoryHasUnlocked(ply,cat,wep)
    local plyArm = ply.LuctusWArmory
    if plyArm[cat] and plyArm[cat][wep] then
        return true
    end
    return false
end

function LuctusWeaponArmoryUnlock(ply,cat,wep)
    if not ply.LuctusWArmory[cat] then
        ply.LuctusWArmory[cat] = {}
    end
    ply.LuctusWArmory[cat][wep] = true
    ply.LuctusWArmoryJ = util.TableToJSON(ply.LuctusWArmory)
    local res = sql.Query("UPDATE luctus_weaponarmory SET unlocks = "..sql.SQLStr(ply.LuctusWArmoryJ).." WHERE steamid = "..sql.SQLStr(ply:SteamID()))
    if res == false then error(sql.LastError()) end
    DarkRP.notify(ply,0,5,"Weapon bought!")
end

function LuctusWeaponArmoryLimitAdd(ply,cat)
    if not ply.LuctusWArmoryL[cat] then
        ply.LuctusWArmoryL[cat] = 1
        return
    end
    ply.LuctusWArmoryL[cat] = ply.LuctusWArmoryL[cat] + 1
end
function LuctusWeaponArmoryLimitRem(ply,cat)
    if not ply.LuctusWArmoryL[cat] then return end
    ply.LuctusWArmoryL[cat] = math.max(ply.LuctusWArmoryL[cat] - 1, 0)
end
function LuctusWeaponArmoryLimitReached(ply,cat)
    local limits = ply.LuctusWArmoryL
    if not limits then return false end
    if not limits[cat] then return false end
    return limits[cat] >= LUCTUS_WEAPONARMORY[cat].MaxAllowed
end
hook.Add("PlayerSpawn","luctus_weaponarmory",function(ply)
    ply.LuctusWArmoryL = {}
end)

net.Receive("luctus_weaponarmory",function(len,ply)
    local ent = net.ReadEntity()
    local cat = net.ReadString()
    local wep = net.ReadString()
    if ent:GetClass() ~= "luctus_weaponarmory" then return end
    if ent:GetPos():Distance(ply:GetPos()) > 512 then return end
    if not LUCTUS_WEAPONARMORY[cat] then return end
    local catConfig = LUCTUS_WEAPONARMORY[cat]
    if not catConfig.AllowedJobs[ply:getDarkRPVar("job")] then return end
    if ply:HasWeapon(wep) then
        DarkRP.notify(ply,1,5,"You already have this weapon!")
        return
    end
    if LuctusWeaponArmoryLimitReached(ply,cat) then
        DarkRP.notify(ply,1,5,"Weapon limit reached!")
        return
    end
    if LuctusWeaponArmoryHasUnlocked(ply,cat,wep) then
        ply:Give(wep,LUCTUS_WEAPONARMORY_NOAMMO)
        ply:EmitSound("items/ammo_pickup.wav")
        LuctusWeaponArmoryLimitAdd(ply,cat)
        hook.Run("LuctusWeaponArmoryGet",ply,cat,wep)
        return
    end
    local price = catConfig.Weapons[wep]
    if not price then return end
    if not ply:canAfford(price) then return end
    ply:addMoney(-price)
    LuctusWeaponArmoryUnlock(ply,cat,wep)
    -- ply:Give(wep)
    hook.Run("LuctusWeaponArmoryBuy",ply,cat,wep,price)
end)

net.Receive("luctus_weaponarmory_r",function(len,ply)
    local ent = net.ReadEntity()
    local cat = net.ReadString()
    local wep = net.ReadString()
    
    if not ply:HasWeapon(wep) then return end
    if ent:GetClass() ~= "luctus_weaponarmory" then return end
    if ent:GetPos():Distance(ply:GetPos()) > 512 then return end
    if not LUCTUS_WEAPONARMORY[cat] then return end
    if not LUCTUS_WEAPONARMORY[cat].Weapons[wep] then return end
    
    ply:StripWeapon(wep)
    LuctusWeaponArmoryLimitRem(ply,cat)
    hook.Run("LuctusWeaponArmoryReturn",ply,wep)
end)

print("[luctus_weaponarmory] sv loaded")
