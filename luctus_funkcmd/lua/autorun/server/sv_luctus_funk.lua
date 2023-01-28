--Luctus Funk
--Made by OverlordAkise

function luctusEncrypt(text)
    textArray = string.Explode("", string.lower(text))
    for k, v in pairs(textArray) do
        if LUCTUS_FUNK_ENCTABLE[v] then
            textArray[k] = LUCTUS_FUNK_ENCTABLE[v]
        end
    end
    return string.Implode("", textArray)
end

function luctusDecrypt(text)
    textArray = string.Explode("", string.lower(text))
    for k, v in pairs(textArray) do
        for kk,vv in pairs(LUCTUS_FUNK_ENCTABLE) do
            if vv == v then
                textArray[k] = kk
            break
            end
        end
    end
    return string.Implode("", textArray)
end

util.AddNetworkString("luctus_funk_broadcast")
util.AddNetworkString("luctus_funk_anon")
util.AddNetworkString("luctus_funk_anon_enc")
util.AddNetworkString("luctus_funk_opendec")
util.AddNetworkString("luctus_funk_decrypt")

hook.Add("PlayerSay", "comms.cmdplysay", function( ply, text )
    if string.StartWith(string.lower(text), LUCTUS_FUNK_COMMAND) then
        local contents = string.Explode(" ", text)
        local receivent = contents[2]
        local msgcontent = string.sub(text, #contents[1] + #contents[2] + 2, nil)
        net.Start( "luctus_funk_broadcast" )
            net.WriteEntity(ply)
            net.WriteString(receivent)
            net.WriteString(msgcontent)
        net.Broadcast()
        return ""
    end
    if string.StartWith(string.lower(text), LUCTUS_FUNK_COMMAND_ANON) then
        local acontents = string.Explode(" ", text)
        local areceivent = acontents[2]
        local amsgcontent = string.sub(text, #acontents[1] + #acontents[2] + 2, nil)
        net.Start("luctus_funk_anon")
            net.WriteString(" Anonymous: *" .. areceivent .. "* " .. amsgcontent)
        net.Broadcast()
        return ""
    end
    if string.StartWith(string.lower(text), LUCTUS_FUNK_COMMAND_ENCRYPTED) then
        local vcontents = string.Explode(" ", text)
        local vreceivent = vcontents[2]
        local vmsgcontent = string.sub(text, #vcontents[1] + #vcontents[2] + 2, nil)
        net.Start( "luctus_funk_anon_enc" )
            net.WriteString(" Anonymous: *" .. vreceivent .. "* " .. luctusEncrypt(vmsgcontent))
        net.Broadcast()
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
