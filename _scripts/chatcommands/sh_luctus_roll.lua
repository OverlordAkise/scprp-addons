--Luctus Roll
--Made by OverlordAkise

LUCTUS_ROLL_CMD = "/roll"
LUCTUS_ROLL_DISTANCE = 512
LUCTUS_ROLL_TAG = "[ROLL]"
LUCTUS_ROLL_TAG_COLOR = Color(200,100,0)
LUCTUS_ROLL_NUMBER_COLOR = Color(0, 195, 165)

if SERVER then
    util.AddNetworkString("luctus_roll")
    hook.Add("PlayerSay","luctus_roll",function(ply,text)
        if text == LUCTUS_ROLL_CMD then
            local msg = math.random(1,100)
            local recvs = {}
            local plyPos = ply:GetPos()
            for k,v in pairs(player.GetAll()) do
                if plyPos:Distance(v:GetPos()) < LUCTUS_ROLL_DISTANCE then
                    table.insert(recvs,v)
                end
            end
            net.Start("luctus_roll")
                net.WriteEntity(ply)
                net.WriteString(msg)
            net.Send(recvs)
            return ""
        end
    end)

else

    local color_white = Color(255,255,255,255)
    net.Receive("luctus_roll",function()
        local ply = net.ReadEntity()
        local msg = net.ReadString()
        chat.AddText(LUCTUS_ROLL_TAG_COLOR,LUCTUS_ROLL_TAG," ",team.GetColor(ply:Team()),ply:Nick(),color_white," rolled a ",LUCTUS_ROLL_NUMBER_COLOR,msg)
    end)

end

print("[luctus_roll] sh loaded")
