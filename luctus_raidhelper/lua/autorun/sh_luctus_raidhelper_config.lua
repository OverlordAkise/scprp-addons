--Luctus Raidhelper
--Made by OverlordAkise

--Command to start the raid
LUCTUS_RAIDHELPER_REQCMD = "!startraid"
--Command to allow the raid
LUCTUS_RAIDHELPER_ALLOWCMD = "!allowraid"
--Command to deny raid request
LUCTUS_RAIDHELPER_DENYCMD = "!denyraid"
--Command to leave the raid as a player
LUCTUS_RAIDHELPER_LEAVECMD = "!leaveraid"
--Command to stop the raid as the leader
LUCTUS_RAIDHELPER_STOPCMD = "!stopraid"

--Cooldown between raids in seconds
LUCTUS_RAIDHELPER_COOLDOWN = 300

--This defines which jobs can start a raid and
--which jobs join the raid too
LUCTUS_RAIDHELPER_JOBS = {
    ["Citizen"] = {
        ["Citizen"] = true,
    },
    ["SH Commander"] = {
        ["SH Medic"] = true,
        ["SH Assault"] = true,
    },
}

--Should the raiders have vision of each other through walls?
LUCTUS_RAIDHELPER_XRAYVISION = true
--Max. distance you can see others with xray through walls
LUCTUS_RAIDHELPER_XRAY_MAXDISTANCE = 2048
--Should the raiders see their teammates health in the HUD?
LUCTUS_RAIDHELPER_HUD_ENABLE = true


print("[luctus_raidhelper] config loaded")
