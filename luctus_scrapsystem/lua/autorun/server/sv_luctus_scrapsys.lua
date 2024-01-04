--Luctus Scrapsystem
--Made by OverlordAkise

util.AddNetworkString("luctus_scrapsys_craft")

function LuctusScrapsysAdd(ply,num)
    local plyscrap = ply:GetNW2Int("luctus_scrap",0)
    ply:SetNW2Int("luctus_scrap",plyscrap+num)
    LuctusScrapsysNotify(ply,(num>0 and "+" or "-")..num.." scrap ("..(plyscrap+num)..")")
end

function LuctusScrapsysNotify(ply,text)
    DarkRP.notify(ply,0,5,text)
end

hook.Add("InitPostEntity","luctu_scrapsys",function()
    local res = sql.Query("CREATE TABLE IF NOT EXISTS luctus_scrapsys(steamid TEXT, num INT)")
    if res==false then ErrorNoHaltWithStack(sql.LastError()) end
    print("[luctus_scrapsys] db initialized")
end)

hook.Add("PlayerInitialSpawn","luctu_scrapsys",function(ply)
    if not LUCTUS_SCRAPSYS_SAVE then return end
    local res = sql.QueryValue("SELECT num FROM luctus_scrapsys WHERE steamid="..sql.SQLStr(ply:SteamID()))
    if res==false then ErrorNoHaltWithStack(sql.LastError()) return end
    if not tonumber(res) then
        ply:SetNW2Int("luctus_scrap",0)
        local res = sql.QueryValue("INSERT INTO luctus_scrapsys VALUES("..sql.SQLStr(ply:SteamID())..",0)")
        if res==false then ErrorNoHaltWithStack(sql.LastError()) end
    end
    ply:SetNW2Int("luctus_scrap",tonumber(res))
end)

hook.Add("PlayerDisconnected","luctu_scrapsys",function(ply)
    LuctusScrapsysSavePly(ply)
end)

hook.Add("ShutDown", "luctu_scrapsys", function()
    for k,ply in ipairs(player.GetAll()) do
        LuctusScrapsysSavePly(ply)
    end
end)

function LuctusScrapsysSavePly(ply)
    if not LUCTUS_SCRAPSYS_SAVE then return end
    local res = sql.QueryValue("UPDATE luctus_scrapsys SET num="..ply:GetNW2Int("luctus_scrap",0).." WHERE steamid="..sql.SQLStr(ply:SteamID()))
    if res==false then ErrorNoHaltWithStack(sql.LastError()) end
end

timer.Create("luctus_scrapsys_save",600,0,function()
    for k,ply in ipairs(player.GetAll()) do
        LuctusScrapsysSavePly(ply)
    end
end)

local function IsWeapon(class)
    local swep = weapons.Get(class)
    if swep and swep.PrintName then return true end
    return false
end

net.Receive("luctus_scrapsys_craft",function(len,ply)
    local sitem = net.ReadString()
    local npc = net.ReadEntity()
    if not LUCTUS_SCRAPSYS_CRAFTABLES[sitem] then return end
    if not npc or not IsValid(npc) or npc:GetPos():Distance(ply:GetPos()) > 500 then return end
    if LUCTUS_SCRAPSYS_USE_POCKET and (#ply:getPocketItems() >= GAMEMODE.Config.pocketitems) then
        DarkRP.notify(ply,1,5,"[scrap] Please make room in your pocket!")
        return 
    end
    
    local scrapNeeded = tonumber(LUCTUS_SCRAPSYS_CRAFTABLES[sitem])
    local plyscrap = tonumber(ply:GetNW2Int("luctus_scrap",0))
    if plyscrap < scrapNeeded then
        DarkRP.notify(ply,1,5,"[scrap] You don't have enough scrap to craft that!")
        return
    end
    ply:SetNW2Int("luctus_scrap",plyscrap-scrapNeeded)
    
    
    if IsWeapon(sitem) and not LUCTUS_SCRAPSYS_USE_POCKET then
        ply:Give(sitem)
    else
        local ent = ents.Create(sitem)
        if not ent or not IsValid(ent) then return end
        ent:SetPos(npc:GetPos()+npc:GetPos():Forward()*25)
        ent:Spawn()
        if LUCTUS_SCRAPSYS_USE_POCKET then
            ply:addPocketItem(ent)
        end
    end
    LuctusScrapsysNotify(ply,"[scrap] Successfully crafted "..sitem)
    ply:EmitSound("npc/combine_soldier/gear1.wav")
    hook.Run("LuctusScrapsysCrafted",ply,sitem)
end)

hook.Add("PlayerSay","luctus_scrapsys",function(ply,text)
    if text == "/scrap" then
        LuctusScrapsysNotify(ply,"You have "..ply:GetNW2Int("luctus_scrap",0).." scrap")
    end
end)

print("[luctus_scrapsys] sv loaded")
