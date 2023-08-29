--Luctus Clearence Chat
--Made by OverlordAkise

LUCTUS_CLEARENCE_CHAT = {
    ["/cl1"] = {
        color = Color(100,250,100),
        tag = "[CL1]",
        allowed = {
            ["Citizen"] = true,
            ["Hobo"] = true,
        },
    },
    ["/cl4"] = {
        color = Color(250,100,100),
        tag = "[CL4]",
        allowed = {
            ["Hobo"] = true,
        },
    },
    ["/cl5"] = {
        color = Color(255,0,0),
        tag = "[CL5]",
        allowed = {
            ["Medic"] = true,
        },
    },
}

--config end

if SERVER then
    util.AddNetworkString("luctus_clearencechat")
end

local function getPlayersToSendTo(tab)
    local sendTo = {}
    for k,v in pairs(player.GetHumans()) do
        if tab.allowed[team.GetName(v:Team())] then
            table.insert(sendTo,v)
        end
    end
    return sendTo
end

hook.Add("PlayerSay","luctus_clearencechat",function(ply,text,isteam)
    if isteam then return end
    local cmd = string.Split(text," ")[1]
    local tab = LUCTUS_CLEARENCE_CHAT[string.lower(cmd)]
    if tab then
        if not tab.allowed[team.GetName(ply:Team())] then
            ply:PrintMessage(HUD_PRINTTALK, "You are not allowed to use this chat!")
            return ""
        end
        net.Start("luctus_clearencechat")
            net.WriteEntity(ply)
            net.WriteString(cmd)
            net.WriteString(string.Split(text,cmd.." ")[2])
        net.Send(getPlayersToSendTo(tab))
        return ""
    end
end)

if CLIENT then
    local color_white = Color(255,255,255,255)
    net.Receive("luctus_clearencechat",function()
        local sentPly = net.ReadEntity()
        local cmd = net.ReadString()
        local text = net.ReadString()
        local tab = LUCTUS_CLEARENCE_CHAT[string.lower(cmd)]
        if not tab then return end
        chat.AddText(tab.color,tab.tag," ",team.GetColor(sentPly:Team()),sentPly:Nick(),": ",color_white," ",text)
    end)
end

print("[luctus_clearencechat] sh loaded")
