--Luctus SCP914 System
--Made by OverlordAkise

--TODO: DARKRP WEAPON SUPPORT (spawned_weapon)
--EDIT BUTTON IN MENU


local supported_maps = {
    ["rp_liquidrp_ct_site99"] = true,
    ["rp_site65"] = true,
}

util.AddNetworkString("luctus_scp914_save")
util.AddNetworkString("luctus_scp914_edit")
util.AddNetworkString("luctus_scp914_delete")
util.AddNetworkString("luctus_scp914_get")
util.AddNetworkString("luctus_scp914_nomap")

hook.Add("InitPostEntity","luctus_scp914_setup",function()
    local res = sql.Query("CREATE TABLE IF NOT EXISTS luctus_scp914(input TEXT, output TEXT, wheelnum INTEGER, map TEXT);")
    if res == false then
        error(sql.LastError())
    end
end)


function LuctusSCP914GetConfigForMap(curMap)
    local ret = sql.Query("SELECT rowid,* FROM luctus_scp914 WHERE map="..sql.SQLStr(curMap))
    if ret==false then
        ErrorNoHaltWithStack(sql.LastError())
        return {}
    end
    if ret then
        return ret
    end
    return {}
end

function LuctusSCP914GetOutput(input,wheel,map)
    local res = sql.QueryValue("SELECT output FROM luctus_scp914 WHERE input="..sql.SQLStr(input).." AND wheelnum="..wheel.." AND map="..sql.SQLStr(map))
    if res == false then
        ErrorNoHaltWithStack(sql.LastError())
        return nil
    end
    if type(res) ~= "string" then return nil end
    return res
end

net.Receive("luctus_scp914_delete", function(len, ply)
    if not ply:IsValid() or not ply:IsAdmin() then return end
    local rowID = net.ReadInt(32)
    local res = sql.Query("DELETE FROM luctus_scp914 WHERE rowid = "..rowID)
    if res ~= false then
        print("[luctus_scp914] Successfully deleted from list! "..rowID)
        ply:PrintMessage(HUD_PRINTTALK, "[scp914] Deleted successfully!")
    else
        ErrorNoHaltWithStack(sql.LastError())
        ply:PrintMessage(HUD_PRINTTALK, "[scp914] Error during delete!")
    end
    hook.Run("LuctusSCP914ConfigDeleted",ply,rowID)
end)

net.Receive("luctus_scp914_get", function(len, ply)
    if not ply:IsValid() or not ply:IsAdmin() then return end
    local curMap = game.GetMap()
    if not supported_maps[curMap] then
        net.Start("luctus_scp914_nomap") net.Send(ply)
        return
    end
    local liste = LuctusSCP914GetConfigForMap(curMap)
    net.Start("luctus_scp914_get")
        local a = util.Compress(util.TableToJSON(liste))
        net.WriteInt(#a,17)
        net.WriteData(a,#a)
    net.Send(ply)
end)

net.Receive("luctus_scp914_edit", function(len, ply)
    if not ply:IsValid() or not ply:IsAdmin() then return end
    local inputEnt = net.ReadString()
    local outputEnt = net.ReadString()
    local wheelnum = net.ReadInt(8)
    local rowID = net.ReadInt(32)
    local res = sql.Query("UPDATE luctus_scp914 SET input = "..sql.SQLStr(inputEnt)..", output = "..sql.SQLStr(outputEnt)..", wheelnum = "..sql.SQLStr(wheelnum).." WHERE rowid = "..rowID)

    if res ~= false then
        print("[luctus_scp914] Successfully updated list!")
        print("[luctus_scp914] Changed entry to: ",inputEnt," -> ",outputEnt," / ",wheelnum)
        ply:PrintMessage(HUD_PRINTTALK, "[scp914] Changed successfully!")
    else
        ply:PrintMessage(HUD_PRINTTALK, "[scp914] Error during change!")
        ErrorNoHaltWithStack(sql.LastError())
    end
    hook.Run("LuctusSCP914ConfigEdited",ply,inputEnt,outputEnt,wheelnum,rowID)
end)

net.Receive("luctus_scp914_save", function(len, ply)
    if not ply:IsValid() or not ply:IsAdmin() then return end
    local inputEnt = net.ReadString()
    local outputEnt = net.ReadString()
    local wheelnum = net.ReadInt(8)
    local res = sql.Query("INSERT INTO luctus_scp914(input,output,wheelnum,map) VALUES("..sql.SQLStr(inputEnt)..","..sql.SQLStr(outputEnt)..","..wheelnum..", "..sql.SQLStr(game.GetMap())..")")
    if res ~= false then
        print("[luctus_scp914] Successfully updated list!")
        print("[luctus_scp914] New entry: ",inputEnt," -> ",outputEnt," / ",wheelnum)
        ply:PrintMessage(HUD_PRINTTALK, "[scp914] Added successfully!")
    else
        ply:PrintMessage(HUD_PRINTTALK, "[scp914] Error during add!")
        ErrorNoHaltWithStack(sql.LastError())
    end
    hook.Run("LuctusSCP914ConfigAdded",ply,inputEnt,outputEnt,wheelnum)
end)

LUCTUS_SCP914_CURWHEEL = 0

if game.GetMap() == "rp_liquidrp_ct_site99" then

    LUCTUS_SCP914_WORKAROUND_LQRP = false
    local function SetupWheelCounter()
        LUCTUS_SCP914_CURWHEEL = 0
        LUCTUS_SCP914_WORKAROUND_LQRP = false
        print("[luctus_scp914] Successfully loaded wheelcounter!")
    end

    hook.Add("InitPostEntity", "luctus_scp914_wheelreset", SetupWheelCounter)
    hook.Add("PostCleanupMap", "luctus_scp914_wheelreset", SetupWheelCounter)
    
    hook.Add("SCP914_OnWheelPressed", "luctus_scp914", function()
        --Stupid wheel doesn't turn on first press
        if LUCTUS_SCP914_WORKAROUND_LQRP == false then
            LUCTUS_SCP914_WORKAROUND_LQRP = true
            return
        end
        LUCTUS_SCP914_CURWHEEL = (LUCTUS_SCP914_CURWHEEL + 1)%5
    end)
    
    hook.Add("SCP914_OnTeleport", "luctus_scp914", function()
        --I hope this still works, 20240908
        local activator, caller = ACTIVATOR, CALLER
        if not activator or not IsValid(activator) or not activator.GetClass then return end
        local entClass = activator:GetClass()
        if activator.GetWeaponClass then
            entClass = activator:GetWeaponClass()
        end
        local outClass = LuctusSCP914GetOutput(entClass,LUCTUS_SCP914_CURWHEEL,game.GetMap())
        hook.Run("LuctusSCP914Teleported",entClass,outClass,LUCTUS_SCP914_CURWHEEL,game.GetMap())
        if not outClass then return end
        print("[luctus_scp914] Transforming ",entClass,"to",outClass)
        local newPos = activator:GetPos()
        activator:Remove()
        local newEnt = ents.Create(outClass)
        newEnt:SetPos(newPos)
        newEnt:Spawn()
    end)
    
end

if game.GetMap() == "rp_site65" then

    local site65EndChamber = {Vector("-8493.049805 422.969055 -10881.994141"),Vector("-8555.094727 295.926361 -11017.968750")}

    --hook.Add("SCP-914.Activated","a",function() end)
    hook.Add("SCP-914.DialChanged","luctus_scp914",function()
        LUCTUS_SCP914_CURWHEEL = (LUCTUS_SCP914_CURWHEEL+1)%5
    end)
    hook.Add("SCP-914.PostEntTeleport","luctus_scp914",function()
        local tents = ents.FindInBox(site65EndChamber[1],site65EndChamber[2])
        for k,cent in ipairs(tents) do
            local entClass = cent:GetClass()
            if cent.GetWeaponClass then
                entClass = cent:GetWeaponClass()
            end
            local outClass = LuctusSCP914GetOutput(entClass,LUCTUS_SCP914_CURWHEEL,game.GetMap())
            hook.Run("LuctusSCP914Teleported",entClass,outClass,LUCTUS_SCP914_CURWHEEL,game.GetMap())
            if not outClass then return end
            print("[luctus_scp914] Transforming ",entClass,"to",outClass)
            local newPos = cent:GetPos()
            cent:Remove()
            local newEnt = ents.Create(outClass)
            newEnt:SetPos(newPos)
            newEnt:Spawn()
        end
    end)

end

print("[luctus_scp914] sv loaded")
