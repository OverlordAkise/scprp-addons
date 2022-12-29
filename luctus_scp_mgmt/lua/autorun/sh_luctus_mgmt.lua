--Luctus SCP Management
--Made by OverlordAkise

--The command to open the MGMT menu
LUCTUS_SCP_MGMT_COMMAND = "!mgmt"

--How many seconds until you actually get demoted 
LUCTUS_SCP_MGMT_DEMOTE_DELAY = 60

--The name of the job you get demoted to via the MGMT menu
LUCTUS_SCP_MGMT_DEMOTE_JOB = "Gun Dealer"

--Which jobs are only available in an emergency
LUCTUS_SCP_MGMT_EMERGENCY_JOBS = {
    ["Medic"] = true,
}

--Which jobs are allowed to use the MGMT menu
LUCTUS_SCP_MGMT_ALLOWED_JOBS = {
    ["Hobo"] = true,
}

--After calling an emergency, how many seconds until jobs get available
--Also: After stopping an emergency, how many seconds until jobchange back
LUCTUS_SCP_MGMT_EMERGENCY_JOB_DELAY = 30

print("[SCPMGMT] SH loaded!")

