--Luctus me chat command
--Made by OverlordAkise

LUCTUS_CHAT_ME_CMD = "/me"
LUCTUS_CHAT_ME_DISTANCE = 512
LUCTUS_CHAT_ME_TAG = "[ME]"
LUCTUS_CHAT_ME_TAG_COLOR = Color(200,100,0)

if SERVER then
    util.AddNetworkString("luctus_chatcmd_me")
    hook.Add("PlayerSay","luctus_chatcmd_me",function(ply,text)
        if string.StartsWith(text,LUCTUS_CHAT_ME_CMD) then
            local msg = string.Split(text,LUCTUS_CHAT_ME_CMD.." ")[2]
            if not msg or msg == "" then return end
            local recvs = {}
            local plyPos = ply:GetPos()
            for k,v in pairs(player.GetAll()) do
                if plyPos:Distance(v:GetPos()) < LUCTUS_CHAT_ME_DISTANCE then
                    table.insert(recvs,v)
                end
            end
            net.Start("luctus_chatcmd_me")
                net.WriteEntity(ply)
                net.WriteString(msg)
            net.Send(recvs)
            return ""
        end
    end,-1)

else

    local color_white = Color(255,255,255,255)
    net.Receive("luctus_chatcmd_me",function()
        local ply = net.ReadEntity()
        local msg = net.ReadString()
        chat.AddText(LUCTUS_CHAT_ME_TAG_COLOR,LUCTUS_CHAT_ME_TAG," ",team.GetColor(ply:Team()),ply:Nick()," ",msg)
    end)

end

print("[luctus_chatcmd_me] sh loaded")
