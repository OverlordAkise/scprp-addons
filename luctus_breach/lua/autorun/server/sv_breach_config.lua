--Luctus Breach
--Made by OverlordAkise


--In seconds, after joining job when you are allowed to breach
LUCTUS_BREACH_DELAY = 300
--Allow a breach command
LUCTUS_BREACH_ALLOWCMD = "!allowbreach"
--Deny a breach command
LUCTUS_BREACH_DENYCMD = "!denybreach"
--Custom breach timers for specific jobs
LUCTUS_BREACH_DELAY_CUSTOM = {
    ["Gun Dealer"] = 600,
}
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
LUCTUS_BREACH_JOBS = {
    ["Hobo"] = {4100,"LCZ_door11button"},
    ["Gun Dealer"] = {4100,"LCZ_door11button"},
}

--[[ README

# How to setup the above button list

To let an SCP breach you have to open its doors.  
This is achieved by pressing the "open door" button for the SCP's doors.  

You have to look at the button and use the "breach_get_button" console command in your console.  
This should give you the name and/or the id of the button.  
This is the number/text you have to enter above in the LUCTUS_BREACH_JOBS.  

An example: You look at SCP173's "open door" button, use the "breach_get_button" console command and it prints out in console: ID: 582  
This means you have to enter into the config above:

    ["SCP173"] = {582},

--]]


print("[luctus_breach] config loaded")
