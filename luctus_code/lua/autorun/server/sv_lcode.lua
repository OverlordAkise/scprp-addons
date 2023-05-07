--Luctus SCP Codes
--Made by OverlordAkise

util.AddNetworkString("luctus_scp_code")

LUCTUS_SCP_CODE_CURRENT = LUCTUS_SCP_CODE_DEFAULT

LuctusLog = LuctusLog or function()end

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
        local oldCode = LUCTUS_SCP_CODE_CURRENT
        LUCTUS_SCP_CODE_CURRENT = code
        net.Start("luctus_scp_code")
            net.WriteString(code)
        net.Broadcast()
        PrintMessage(HUD_PRINTCENTER, "Code "..code)
        DarkRP.notify(player.GetAll(),1,5,"Code "..code.." wurde ausgerufen!")
        LuctusLog("CodeSystem",ply:Nick().."("..ply:SteamID()..") changed the code to "..LUCTUS_SCP_CODE_CURRENT..".")
        if oldCode == LUCTUS_SCP_CODE_LOCKDOWN then
            DarkRP.unLockdown(Entity(0))
        end
        if code == LUCTUS_SCP_CODE_LOCKDOWN then
            DarkRP.lockdown(Entity(0))
        end
        if LUCTUS_SCP_CODE_USES[code] then
            LuctusCodePressThings(LUCTUS_SCP_CODE_USES[code])
        end
        LuctusCodeActivitySupport(code,oldCode)
        return ""
    end
end)

function LuctusCodePressThings(list)
    for k,v in pairs(list) do
        if type(v) == "string" then
            if ents.FindByName(v)[1] and IsValid(ents.FindByName(v)[1]) then
                ents.FindByName(v)[1]:Use(Entity(0)) --entity0=worldspawn
            end
        else
            if IsValid(ents.GetMapCreatedEntity(v)) then
                ents.GetMapCreatedEntity(v):Use(Entity(0))
            end
        end
    end
end

function LuctusCodeActivitySupport(code,oldCode)
    if not LUCTUS_ACTIVITY_ACTIVITIES or not istable(LUCTUS_ACTIVITY_ACTIVITIES) then return end
    if code == LUCTUS_SCP_CODE_ACTIVITYSTOP then
        LuctusActivityPause("CODE "..string.upper(code))
    end
    if oldCode == LUCTUS_SCP_CODE_ACTIVITYSTOP then
        LuctusActivityResume()
    end
end

net.Receive("luctus_scp_code", function(len,ply)
    net.Start("luctus_scp_code")
        net.WriteString(LUCTUS_SCP_CODE_CURRENT)
    net.Send(ply)
end)

print("[luctus_code] sv loaded")
