--Luctus Breach (Minimal Version)
--Made by OverlordAkise


--In seconds, after joining job when you are allowed to breach
BREACH_DELAY = 10


--Jobnames and the buttons that the breachsystem will press if a breach is happening for that job

--The button list consists of either a string name or number ID, example:

-- ["SCP173"] = {"button_name",4100},

--Get the name of a button with console command (ingame) 'breach_get_button'

BREACH_ENABLED_JOBS = {
    ["Hobo"] = {4100,"LCZ_door11button"},
}


--CONFIG END

local function NotifyPlayer(ply,text)
    ply:PrintMessage(3,text)
    DarkRP.notify(ply, 1, 5, text)
end

hook.Add("OnPlayerChangedTeam", "BreachLogic", function(ply, beforejob, afterjob)
    ply.canbreach = false
    if BREACH_ENABLED_JOBS[team.GetName(afterjob)] then
        NotifyPlayer(ply,"[breach] You are allowed to breach in "..BREACH_DELAY.." seconds!")
        CreateBreachTimer(ply)
    else
        timer.Remove(ply:SteamID64().."_breachtimer")
    end
end)

hook.Add("PlayerSay", "BreachCommand", function(ply, text)
    if text == "!breach" then
        if BREACH_ENABLED_JOBS[ply:getJobTable().name] then
            if ply.canbreach == true then
                NotifyPlayer(ply,"[breach] Opening doors for you...")
                ply.canbreach = false
                CreateBreachTimer(ply)
                for k,v in pairs(BREACH_ENABLED_JOBS[ply:getJobTable().name]) do
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
            else
                NotifyPlayer(ply,"[breach] You can't breach yet! Time left: "..math.Round(timer.TimeLeft(ply:SteamID64().."_breachtimer")).." seconds.")
            end
        else 
            NotifyPlayer(ply,"[breach] Your job doesn't allow breaching!")
        end
    end
end)

function CreateBreachTimer(ply)
    ply.canbreach = false
    timer.Create(ply:SteamID64().."_breachtimer", BREACH_DELAY, 1, function()
        ply.canbreach = true
        NotifyPlayer(ply,"[breach] You are now allowed to breach! Type '!breach' to open your doors to freedom.")
    end)
end

concommand.Add("breach_get_button",function(ply)
    if not IsValid(ply) then return end
    if not ply:IsAdmin() then return end
    
    print("------------")
    print("Button Name / ID:")
    if ply:GetEyeTrace().Entity:MapCreationID() == Entity(0):MapCreationID() then
        print("ERROR: You are not looking at a 'button'!")
        print("Try to look at the display of the 'button'!")
        return
    end
    print("Name:")
    print(ply:GetEyeTrace().Entity:GetSaveTable(true)["m_iName"])
    print("ID:")
    print(ply:GetEyeTrace().Entity:MapCreationID())
    print("---")
end)

print("[luctus_breach] Loaded SV!")
