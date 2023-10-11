--Luctus Researchrequest
--Made by OverlordAkise

--Command to request dclass personnel, used in '<cmd> <number>'
LUCTUS_RESEARCHREQUEST_CMD = "!reqdclass"

-- %d will be replaced with the number of dclass personnel requested
LUCTUS_RESEARCHREQUEST_TEXT = "[escort] Researchers have requested %d D-Class personnel."

--Which jobs can request for personnel
LUCTUS_RESEARCHREQUEST_REQUESTORS = {
    ["Citizen"] = true,
    ["Researcher"] = true,
}

--Which jobs should see the request?
LUCTUS_RESEARCHREQUEST_ESCORTERS = {
    ["Citizen"] = true,
    ["MTF"] = true,
}

--Config end

local function GetAllPlayersByJobs(jobnames)
    local plys = {}
    for k,ply in ipairs(player.GetAll()) do
        if jobnames[team.GetName(ply:Team())] then
            table.insert(plys,ply)
        end
    end
    return plys
end

local function notifyReq(text)
    local plys = GetAllPlayersByJobs(LUCTUS_RESEARCHREQUEST_REQUESTORS)
    DarkRP.notify(plys,0,5,text)
    for k,ply in ipairs(plys) do
        ply:PrintMessage(HUD_PRINTTALK, text)
    end
end

local function notifyEsc(text)
    local plys = GetAllPlayersByJobs(LUCTUS_RESEARCHREQUEST_ESCORTERS)
    DarkRP.notify(plys,0,5,text)
    for k,ply in ipairs(plys) do
        ply:PrintMessage(HUD_PRINTTALK, text)
    end
end

hook.Add("PlayerSay","luctus_researchrequest",function(ply,text)
    if string.StartWith(text,LUCTUS_RESEARCHREQUEST_CMD) then
        local dNum = string.Split(text," ")[2]
        if not dNum or not tonumber(dNum) then return end
        notifyEsc(string.format(LUCTUS_RESEARCHREQUEST_TEXT,dNum))
    end
end)

print("[luctus_researchrequest] sv loaded")
