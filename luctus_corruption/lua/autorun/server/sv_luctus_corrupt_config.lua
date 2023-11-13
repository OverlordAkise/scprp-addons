--Luctus Corrupt
--Made by OverlordAkise

--Which jobs can become corrupt
LUCTUS_CORRUPT_JOBS = {
    ["Citizen"] = true,
    ["Hobo"] = true,
}
--In seconds, after joining job when are you allowed to become corrupt
LUCTUS_CORRUPT_DELAY = 3
--Chat command for becoming corrupt
LUCTUS_CORRUPT_COMMAND = "!corrupt"
--Chat command to stop being corrupt
LUCTUS_CORRUPT_STOPCMD = "!uncorrupt"
--Admin chat command to allow corruption
LUCTUS_CORRUPT_ALLOWCMD = "!allowcorrupt"
--Admin chat command to deny corruption
LUCTUS_CORRUPT_DENYCMD = "!denycorrupt"
--If a teammember has to approve your corruption
LUCTUS_CORRUPT_NEEDS_APPROVAL = true
--Usergroups who can approve corruptions if enabled
LUCTUS_CORRUPT_APPROVER = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["operator"] = true,
    ["moderator"] = true,
    ["supporter"] = true,
}

print("[luctus_corrupt] config loaded")
