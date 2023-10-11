--Luctus SCP Management
--Made by OverlordAkise

--The command to open the MGMT menu
LUCTUS_SCP_MGMT_COMMAND = "!mgmt"

--Keybind for opening the menu
LUCTUS_SCP_MGMT_BINDKEY = KEY_F6

--How many seconds until you actually get demoted 
LUCTUS_SCP_MGMT_DEMOTE_DELAY = 3

--The name of the job you get demoted to via the MGMT menu
LUCTUS_SCP_MGMT_DEMOTE_JOB = "Gun Dealer"

--Which jobs are only available in an emergency
LUCTUS_SCP_MGMT_EMERGENCY_JOBS = {
    ["Medics"] = {
        ["Medic"] = true,
    },
    ["Gangsters"] = {
        ["Mob boss"] = true,
    },
}

--What error message should a player get if they try to join these jobs
LUCTUS_SCP_MGMT_JOBERROR = "This job is only available in an emergency!"

--Which jobs are allowed to use the MGMT menu
LUCTUS_SCP_MGMT_ALLOWED_JOBS = {
    ["Hobo"] = true,
}

--After calling an emergency, how many seconds until jobs get available
--Also: After stopping an emergency, how many seconds until jobchange back
LUCTUS_SCP_MGMT_EMERGENCY_JOB_DELAY = 30

print("[luctus_scp_mgmt] config loaded")
