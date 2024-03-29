--Luctus Breach
--Made by OverlordAkise

local function NotifyPlayer(ply,text)
    ply:PrintMessage(3,text)
    DarkRP.notify(ply, 1, 5, text)
end

hook.Add("OnPlayerChangedTeam", "BreachLogic", function(ply, beforejob, afterjob)
    ply.canbreach = false
    ply.breachid = nil
    if LUCTUS_BREACH_JOBS[team.GetName(afterjob)] then
        NotifyPlayer(ply,"[breach] You are allowed to breach in "..string.NiceTime(LUCTUS_BREACH_DELAY_CUSTOM[team.GetName(ply:Team())] or LUCTUS_BREACH_DELAY))
        CreateBreachTimer(ply)
    else
        timer.Remove(ply:SteamID64().."_breachtimer")
    end
end)

function LuctusBreachDo(ply)
    NotifyPlayer(ply,"[breach] Opening doors for you...")
    hook.Run("LuctusBreachOpen",ply)
    ply.canbreach = false
    CreateBreachTimer(ply)
    for k,v in ipairs(LUCTUS_BREACH_JOBS[ply:getJobTable().name]) do
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

function LuctusBreachOpenAllDoors(ply)
    hook.Run("LuctusBreachContainment",ply)
    for jobname,doors in pairs(LUCTUS_BREACH_JOBS) do
        for k,v in ipairs(doors) do
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
end

function LuctusBreachSeekApproval(breacher)
    hook.Run("LuctusBreachRequested",breacher)
    LuctusBreachTellAdmins("[breach] '"..breacher:Nick().."' wants to breach! Type '"..LUCTUS_BREACH_ALLOWCMD.." "..breacher.breachid.."' to approve this breach (or "..LUCTUS_BREACH_DENYCMD..")")
end

function LuctusBreachTellAdmins(text)
    for k,v in ipairs(player.GetHumans()) do
        if not LUCTUS_BREACH_APPROVER[v:GetUserGroup()] then continue end
        NotifyPlayer(v,text)
    end
end

hook.Add("PlayerSay", "BreachCommand", function(ply, text)
    if text == LUCTUS_BREACH_COMMAND then
        if LUCTUS_BREACH_JOBS[ply:getJobTable().name] then
            if ply.canbreach == true then
                if LUCTUS_BREACH_NEEDS_APPROVAL then
                    if ply.breachid then
                        NotifyPlayer(ply,"[breach] You already requested a breach! Your ID: "..ply.breachid)
                        return
                    end
                    ply.breachid = ""..math.random(1,9999)
                    LuctusBreachSeekApproval(ply)
                    NotifyPlayer(ply,"[breach] Your request to breach has been created! Your ID: "..ply.breachid)
                else
                    LuctusBreachDo(ply)
                end
            else
                NotifyPlayer(ply,"[breach] You can't breach yet! Time left: "..math.Round(timer.TimeLeft(ply:SteamID64().."_breachtimer")).." seconds.")
            end
        else 
            NotifyPlayer(ply,"[breach] Your job doesn't allow breaching!")
        end
    end
    if text == LUCTUS_BREACH_CONTAINMENT_COMMAND then
        if not LUCTUS_BREACH_APPROVER[ply:GetUserGroup()] then return end
        LuctusBreachOpenAllDoors(ply)
        LuctusBreachTellAdmins("[breach] A containment breach has been started by "..ply:Nick().."/"..ply:SteamID())
    end
    if LUCTUS_BREACH_APPROVER[ply:GetUserGroup()] and string.StartWith(text,LUCTUS_BREACH_ALLOWCMD) then
        local name = string.Split(text,LUCTUS_BREACH_ALLOWCMD.." ")
        if not name[2] then return end
        for k,v in ipairs(player.GetHumans()) do
            if v.breachid and v.breachid == name[2] then
                LuctusBreachDo(v)
                NotifyPlayer(ply,"[breach] Successfully approved!")
                hook.Run("LuctusBreachApproved",ply,v)
                return
            end
        end
        NotifyPlayer(ply,"[breach] Error, ID not found!")
    end
    if LUCTUS_BREACH_APPROVER[ply:GetUserGroup()] and string.StartWith(text,LUCTUS_BREACH_DENYCMD) then
        local name = string.Split(text,LUCTUS_BREACH_DENYCMD.." ")
        if not name[2] then return end
        for k,v in ipairs(player.GetHumans()) do
            if v.breachid and v.breachid == name[2] then
                CreateBreachTimer(v)
                NotifyPlayer(v,"[breach] Your breach has been denied! Timer reset.")
                NotifyPlayer(ply,"[breach] Successfully denied!")
                hook.Run("LuctusBreachDenied",ply,v)
                return
            end
        end
        NotifyPlayer(ply,"[breach] Error, ID not found!")
    end
end)

function CreateBreachTimer(ply)
    ply.canbreach = false
    ply.breachid = nil
    timer.Create(ply:SteamID64().."_breachtimer", LUCTUS_BREACH_DELAY_CUSTOM[team.GetName(ply:Team())] or LUCTUS_BREACH_DELAY, 1, function()
        ply.canbreach = true
        NotifyPlayer(ply,"[breach] You are now allowed to breach! Type '!breach' to open your doors to freedom.")
    end)
end

concommand.Add("breach_get_button",function(ply)
    if not IsValid(ply) then return end
    if not ply:IsAdmin() then return end
    
    ply:PrintMessage(2,"Getting name and id of the entity you are looking at")
    if ply:GetEyeTrace().Entity:MapCreationID() == Entity(0):MapCreationID() then
        ply:PrintMessage(2,"ERROR: You are not looking at a 'button'!")
        ply:PrintMessage(2,"Try to look at the display of the 'button'!")
        return
    end
    ply:PrintMessage(2,"---")
    ply:PrintMessage(2,"Name:")
    ply:PrintMessage(2,ply:GetEyeTrace().Entity:GetSaveTable(true)["m_iName"] or "<nothing>")
    ply:PrintMessage(2,"ID:")
    ply:PrintMessage(2,ply:GetEyeTrace().Entity:MapCreationID() or "<nothing>")
    ply:PrintMessage(2,"---")
end)

print("[luctus_breach] sv loaded")
