--Luctus Funk
--Made by OverlordAkise

util.AddNetworkString("luctus_funk_chat")
util.AddNetworkString("luctus_funk_broadcast")
util.AddNetworkString("luctus_funk_anon")
util.AddNetworkString("luctus_funk_anon_enc")
util.AddNetworkString("luctus_funk_opendec")
util.AddNetworkString("luctus_funk_decrypt")

function luctusEncrypt(text)
    textArray = string.Explode("", string.lower(text))
    returnString = ""
    for k,v in ipairs(textArray) do
        if LUCTUS_FUNK_ENCTABLE[v] then
            returnString = returnString .. LUCTUS_FUNK_ENCTABLE[v]
        else
            returnString = returnString .. v
        end
    end
    return returnString
end

function luctusDecrypt(text)
    textArray = string.Explode("", string.lower(text))
    for k,v in ipairs(textArray) do
        for kk,vv in pairs(LUCTUS_FUNK_ENCTABLE) do
            if vv == v then
                textArray[k] = kk
            break
            end
        end
    end
    return string.Implode("", textArray)
end

local function GetPlayer(name)
    local ret = nil
    for k,ply in ipairs(player.GetAll()) do
        if string.find( string.lower(ply:Nick()), string.lower(name) ) then
            if ret ~= nil then
                return nil
            end
            ret = ply
        end
    end
    return ret
end

local funkCommands = {
    [LUCTUS_FUNK_COMMAND] = true,
    [LUCTUS_FUNK_COMMAND_ANON] = true,
    [LUCTUS_FUNK_COMMAND_ENCRYPTED] = true,
}

hook.Add("PlayerSay", "luctus_funk_commands", function(ply, text)
    local sText = string.Explode(" ", text)
    local cmd = string.sub(sText[1],2)
    local rPlyName = sText[2]
    local rPly = (rPlyName and rPlyName ~= "") and GetPlayer(rPlyName) or nil
    --Custom channels
    if LUCTUS_FUNK_CUSTOM_CHANNELS[cmd] then
        local msgAll = string.sub(text, #sText[1]+2, nil)
        local tab = LUCTUS_FUNK_CUSTOM_CHANNELS[cmd]
        if not table.HasValue(tab.jobs,team.GetName(ply:Team())) and not table.IsEmpty(tab.jobs) then
            DarkRP.notify(ply,1,5,"You are not in the correct job for this channel!")
            return ""
        end
        if tab.needsRadioToFunk and not ply:HasWeapon(LUCTUS_FUNK_WEAPON_CLASS) then
            DarkRP.notify(ply,1,5,"You need a radio for this channel!")
            return ""
        end
        net.Start("luctus_funk_chat")
            net.WriteString(cmd)
            net.WriteEntity(ply)
            net.WriteString(msgAll)
        net.Broadcast()
        return ""
    end
    
    if not rPlyName or rPlyName == "" then return end
    if not funkCommands[cmd] then return end
    local msg = string.sub(text, #sText[1] + #sText[2] + 2, nil)
    
    if LUCTUS_FUNK_WEAPONRESTRICT then
        local wep = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() or false
        if not wep or wep != LUCTUS_FUNK_WEAPON_CLASS then
            DarkRP.notify(ply,1,5,"FUNK ERROR: You have no radio!")
            return
        end
    end
    if LUCTUS_FUNK_JOB_WHITELIST_ENABLED and not LUCTUS_FUNK_JOB_WHITELIST[team.GetName(ply:Team())] then
        DarkRP.notify(ply,1,5,"FUNK ERROR: wrong job!")
        return
    end
    
    if cmd == LUCTUS_FUNK_COMMAND then
        net.Start("luctus_funk_broadcast")
            net.WriteEntity(ply)
            net.WriteString(rPlyName)
            net.WriteString(msg)
        net.Broadcast()
        return ""
    end
    if cmd == LUCTUS_FUNK_COMMAND_ANON then
        net.Start("luctus_funk_anon")
            net.WriteString(" Anonymous: *to " .. rPlyName .. "* " .. msg)
        net.Broadcast()
        return ""
    end
    
    if not IsValid(rPly) then return end
    if cmd == LUCTUS_FUNK_COMMAND_ENCRYPTED then
        net.Start("luctus_funk_anon_enc")
            net.WriteString(" Anonymous: *" .. rPlyName .. "* " .. luctusEncrypt(msg))
        net.Broadcast()
        net.Start("luctus_funk_anon_enc")
            net.WriteString(" [DECODED] Anonymous: *" .. rPlyName .. "* " .. msg)
        net.Send(rPly)
        return ""
    end
end)

net.Receive("luctus_funk_decrypt",function(len,ply)
    local terminal = net.ReadEntity()
    if not terminal or not IsValid(terminal) then return end
    if terminal:GetClass() ~= "luctus_funk_decryptor" then return end
    if ply:GetPos():Distance(terminal:GetPos()) > 500 then
        DarkRP.notify(ply,1,5,"You are too far away from the decryptor!")
        return
    end
    local text = net.ReadString()
    net.Start("luctus_funk_decrypt")
        net.WriteString(luctusDecrypt(text))
    net.Send(ply)
end)

print("[luctus_funkcmd] sv loaded")
