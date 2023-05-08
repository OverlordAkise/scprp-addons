--Luctus Funk
--Made by OverlordAkise

util.AddNetworkString("luctus_funk_broadcast")
util.AddNetworkString("luctus_funk_anon")
util.AddNetworkString("luctus_funk_anon_enc")
util.AddNetworkString("luctus_funk_opendec")
util.AddNetworkString("luctus_funk_decrypt")

function luctusEncrypt(text)
    textArray = string.Explode("", string.lower(text))
    returnString = ""
    for k, v in pairs(textArray) do
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
    for k,v in pairs(textArray) do
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
    for k,v in pairs(player.GetAll()) do
        if string.find( string.lower(v:Nick()), string.lower(name) ) then
            if ret ~= nil then
                return nil
            end
            ret = v
        end
    end
    return ret
end

hook.Add("PlayerSay", "luctus_funk_commands", function(ply, text)
    local sText = string.Explode(" ", text)
    local cmd = sText[1]
    local rPlyName = sText[2]
    local rPly = (rPlyName and rPlyName ~= "") and GetPlayer(rPlyName) or nil
    
    if not rPlyName or rPlyName == "" then return end
    if cmd == LUCTUS_FUNK_COMMAND then
        local msgcontent = string.sub(text, #sText[1] + #sText[2] + 2, nil)
        net.Start("luctus_funk_broadcast")
            net.WriteEntity(ply)
            net.WriteString(rPlyName)
            net.WriteString(msgcontent)
        net.Broadcast()
        return ""
    end
    if cmd == LUCTUS_FUNK_COMMAND_ANON then
        local amsgcontent = string.sub(text, #sText[1] + #sText[2] + 2, nil)
        net.Start("luctus_funk_anon")
            net.WriteString(" Anonymous: *to " .. rPlyName .. "* " .. amsgcontent)
        net.Broadcast()
        return ""
    end
    
    if not IsValid(rPly) then return end
    if cmd == LUCTUS_FUNK_COMMAND_ENCRYPTED then
        local vmsgcontent = string.sub(text, #sText[1] + #sText[2] + 2, nil)
        net.Start("luctus_funk_anon_enc")
            net.WriteString(" Anonymous: *" .. rPlyName .. "* " .. luctusEncrypt(vmsgcontent))
        net.Broadcast()
        net.Start("luctus_funk_anon_enc")
            net.WriteString(" [DECODED] Anonymous: *" .. rPlyName .. "* " .. vmsgcontent)
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
