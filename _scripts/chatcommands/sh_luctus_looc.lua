--Luctus LOOC
--Made by OverlordAkise

LUCTUS_LOOC_CMD = "/looc"
LUCTUS_LOOC_DISTANCE = 512
LUCTUS_LOOC_TAG = "[looc]"
LUCTUS_LOOC_TAG_COLOR = Color(200,200,0)

if SERVER then
    util.AddNetworkString("luctus_looc")
    hook.Add("PlayerSay","luctus_looc",function(ply,text)
        if string.StartsWith(text,LUCTUS_LOOC_CMD) then
            local msg = string.Split(text,LUCTUS_LOOC_CMD.." ")[2]
            if not msg or msg == "" then return end
            local recvs = {}
            local plyPos = ply:GetPos()
            for k,v in pairs(player.GetAll()) do
                if plyPos:Distance(v:GetPos()) < LUCTUS_LOOC_DISTANCE then
                    table.insert(recvs,v)
                end
            end
            net.Start("luctus_looc")
                net.WriteEntity(ply)
                net.WriteString(msg)
            net.Send(recvs)
            return ""
        end
    end)

else

    local color_white = Color(255,255,255,255)
    net.Receive("luctus_looc",function()
        local ply = net.ReadEntity()
        local msg = net.ReadString()
        chat.AddText(LUCTUS_LOOC_TAG_COLOR,LUCTUS_LOOC_TAG," ",team.GetColor(ply:Team()),ply:Nick(),color_white,": ",msg)
    end)

end

print("[luctus_looc] sh loaded")
