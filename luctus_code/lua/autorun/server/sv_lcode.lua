--Luctus SCP Codes
--Made by OverlordAkise

util.AddNetworkString("luctus_scp_code")

LUCTUS_SCP_CODE_CURRENT = LUCTUS_SCP_CODE_DEFAULT

hook.Add("PlayerSay", "luctus_scp_code", function(ply,text,team) 
    if string.Split(text," ")[1] == "!code" then
        if not LUCTUS_SCP_CODE_ALLOWEDJOBS[ply:getJobTable().name] 
            and not LUCTUS_SCP_CODE_ALLOWEDRANKS[ply:GetUserGroup()] then
            DarkRP.notify(ply,1,5,"Du besitzt nicht die Berechtigung den Code zu ändern!")
            return ""
        end
        local code = string.Split(text,"!code ")[2]
        if not LUCTUS_SCP_CODES[code] then
            DarkRP.notify(ply,1,5,"Dieser Code existiert nicht!")
            return
        end
        LUCTUS_SCP_CODE_CURRENT = code
        net.Start("luctus_scp_code")
            net.WriteString(code)
        net.Broadcast()
        DarkRP.notify(player.GetAll(),1,5,"Code "..code.." wurde ausgerufen!")
        return ""
    end
    --[[
    --This was code for a map to activate lockdown
    if (code == "lockdown") then
      if(ents.FindByName("lockdown_lever_roomccont")[1]:GetSaveTable(true)["m_toggle_state"] == 1) then
        ents.FindByName("lockdown_lever_roomccont")[1]:Use(ply)
      end
    else
      if(ents.FindByName("lockdown_lever_roomccont")[1]:GetSaveTable(true)["m_toggle_state"] == 0) then
        ents.FindByName("lockdown_lever_roomccont")[1]:Use(ply)
      end
    end
    --]]
end)

net.Receive("luctus_scp_code", function(len,ply)
    net.Start("luctus_scp_code")
        net.WriteString(LUCTUS_SCP_CODE_CURRENT)
    net.Send(ply)
end)
