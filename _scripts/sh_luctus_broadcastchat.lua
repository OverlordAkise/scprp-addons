--Luctus Broadcastchat
--Made by OverlordAkise

-- A simple script that enables /broadcast <text> to be a red chat message for everyone

--Chat command
local broadcastCmd = "!broadcast"
--Prefix in chat
local broadcastChat = "Broadcast: "
--Color of the chat message, default = red
local broadcastColor = Color(255,0,0)
--Which teams can use this chat command
local allowedTeams = {
    ["Citizen"] = true,
    ["Site Director"] = true,
}
--Which ranks can use this chat command
local allowedGroups = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["operator"] = true,
    ["moderator"] = true,
}


if SERVER then
    util.AddNetworkString("luctus_broadcastchat")
    hook.Add("PlayerSay","luctus_broadcastchat",function(ply,text,isTeam)
        if not string.StartsWith(text,broadcastCmd.." ") then return end
        if not allowedTeams[team.GetName(ply:Team())] and not allowedGroups[ply:GetUserGroup()] then return end
        local text = string.Split(text,broadcastCmd.." ")
        net.Start("luctus_broadcastchat")
            net.WriteString(text[2])
        net.Broadcast()
        return ""
    end)
else
    net.Receive("luctus_broadcastchat",function()
        local text = net.ReadString()
        chat.AddText(broadcastColor,broadcastChat,text)
        chat.PlaySound()
    end)
end

print("[luctus_broadcastchat] sh loaded")
