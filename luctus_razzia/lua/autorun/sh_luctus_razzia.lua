--Luctus Razzia
--Made by OverlordAkise

--CONFIG START

--Which jobs can call a razzia?
LUCTUS_RAZZIA_JOBS_SEND = {
    ["Citizen"] = true,
    ["O5-Rat"] = true,
}
--Which jobs get the message about it?
LUCTUS_RAZZIA_JOBS_RECV = {
    ["Citizen"] = true,
    ["D-Klasse"] = true,
}
--Chat command to begin
LUCTUS_RAZZIA_STARTCMD = "!razziastart"
--Chat command to end
LUCTUS_RAZZIA_ENDCMD = "!razziaend"
--Text in chat if it begins
LUCTUS_RAZZIA_STARTTEXT = "A razzia is about to begin, please step up to the line"
--Text in chat if it ends
LUCTUS_RAZZIA_ENDTEXT = "The razzia ended, please head to your cells"

--CONFIG END


if SERVER then
    
    util.AddNetworkString("luctus_razzia")
    hook.Add("PlayerSay", "luctus_razzia", function(ply,text)
        if LUCTUS_RAZZIA_JOBS_SEND[team.GetName(ply:Team())] then
            local toSend = nil
            if text == LUCTUS_RAZZIA_STARTCMD then toSend = true end
            if text == LUCTUS_RAZZIA_ENDCMD then toSend = false end
            if toSend == nil then return end
            for k,v in pairs(player.GetAll()) do
                if not LUCTUS_RAZZIA_JOBS_RECV[team.GetName(v:Team())] then continue end
                net.Start("luctus_razzia")
                    net.WriteBool(toSend)
                net.Send(v)
            end
        end
    end)

else

    local color_white = Color(255,255,255)
    local accent = Color(255,0,0)
    net.Receive("luctus_razzia",function()
        local isStarting = net.ReadBool()
        chat.AddText(accent,"[razzia] ",color_white,isStarting and LUCTUS_RAZZIA_STARTTEXT or LUCTUS_RAZZIA_ENDTEXT)
    end)

end

print("[luctus_razzia] sh loaded!")
