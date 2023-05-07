--Luctus AKT
--Made by OverlordAkise

LUCTUS_AKT_CMD = "/akt"
LUCTUS_AKT_DISTANCE = 512
LUCTUS_AKT_TAG = "[AKT]"
LUCTUS_AKT_TAG_COLOR = Color(200,100,0)

if SERVER then
    util.AddNetworkString("luctus_akt")
    hook.Add("PlayerSay","luctus_akt",function(ply,text)
        if string.StartsWith(text,LUCTUS_AKT_CMD) then
            local msg = string.Split(text,LUCTUS_AKT_CMD.." ")[2]
            if not msg or msg == "" then return end
            local recvs = {}
            local plyPos = ply:GetPos()
            for k,v in pairs(player.GetAll()) do
                if plyPos:Distance(v:GetPos()) < LUCTUS_AKT_DISTANCE then
                    table.insert(recvs,v)
                end
            end
            net.Start("luctus_akt")
                net.WriteEntity(ply)
                net.WriteString(msg)
            net.Send(recvs)
            return ""
        end
    end)

else

    local color_white = Color(255,255,255,255)
    net.Receive("luctus_akt",function()
        local ply = net.ReadEntity()
        local msg = net.ReadString()
        chat.AddText(LUCTUS_AKT_TAG_COLOR,LUCTUS_AKT_TAG," ",team.GetColor(ply:Team()),ply:Nick()," ",msg)
    end)

end

print("[luctus_akt] sh loaded")
