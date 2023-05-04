--Luctus SCP Codes
--Made by OverlordAkise

LUCTUS_SCP_CODES = {
    ["green"] = {
        Color(0,255,0),
        "Es herrscht nun Code Green! Es kann ohne verschärfte Sicherheitsmassnahmen gearbeitet werden.",
        "HL1/fvox/deactivated.wav",
    },
    ["yellow"] = {
        Color(255,255,0),
        "Es herrscht nun Code Yellow! Bitte achten sie auf Auffälligkeiten und melden diese sofort!",
        "HL1/fvox/warning.wav",
    },
    ["red"] = {
        Color(255,0,0),
        "Es herrscht nun Code Red! Bitte bleiben sie in ihren Räumen und versperren sie die Türen!",
        "HL1/fvox/evacuate_area.wav",
    },
}

--You can define a button to be pressed/used if a new code is set
--Key = codename
--Value = MapCreationID or entity name
LUCTUS_SCP_CODE_USES = {
    ["red"] = {1371},
    ["green"] = {1371},
}

--Printname of allowed jobs to change the code
LUCTUS_SCP_CODE_ALLOWEDJOBS = {
    ["Ziffer Agent"] = true,
    ["O5"] = true,
    ["Ethikkommission"] = true,
    ["Side Director"] = true,
    ["Staff on Duty"] = true,
    ["Citizen"] = true,
}

--Allowed team ranks who can change code
LUCTUS_SCP_CODE_ALLOWEDRANKS = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["moderator"] = true,
}

--The code after a server restart, has to exist in the config above!
LUCTUS_SCP_CODE_DEFAULT = "green"

--Which code should also start a DarkRP lockdown? (Set to non existing code to disable)
--If you use this please set the DarkRP "GAMEMODE.Config.lockdowndelay" very low or else the lockdown wont start everytime
LUCTUS_SCP_CODE_LOCKDOWN = "red"

print("[luctus_code] config loaded!")
