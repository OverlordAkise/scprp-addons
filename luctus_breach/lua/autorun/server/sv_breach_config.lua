--Luctus Breach
--Made by OverlordAkise


--In seconds, after joining job when you are allowed to breach
LUCTUS_BREACH_DELAY = 300
--If a teammember has to approve your breach
LUCTUS_BREACH_NEEDS_APPROVAL = true
--Usergroups who can approve a breach
LUCTUS_BREACH_APPROVER = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["operator"] = true,
    ["moderator"] = true,
    ["supporter"] = true,
}

--Jobnames and the buttons that the breachsystem will press if a breach is happening for that job
--The button list consists of either a string name or number ID, example:
-- ["SCP173"] = {"button_name",4100},
--Get the name of a button with console command (ingame) 'breach_get_button'
LUCTUS_BREACH_JOBS = {
    ["Hobo"] = {4100,"LCZ_door11button"},
}


print("[luctus_breach] config loaded")
