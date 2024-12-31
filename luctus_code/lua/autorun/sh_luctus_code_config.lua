--Luctus SCP Codes
--Made by OverlordAkise

--Only the color is mandatory, the other 3 can be left out if desired
LUCTUS_SCP_CODES = {
  --["codename"] = {
    --Color for TV and HUD display
    --Text to be shown in chat
    --Sound to be played
    --TV Description beneath codename
  --}
    ["green"] = {
        Color(0,255,0),
        "Es herrscht nun Code Green! Es kann ohne verschärfte Sicherheitsmassnahmen gearbeitet werden.",
        "HL1/fvox/deactivated.wav",
        "All OK",
    },
    ["yellow"] = {
        Color(255,255,0),
        "Es herrscht nun Code Yellow! Bitte achten sie auf Auffälligkeiten und melden diese sofort!",
        "HL1/fvox/warning.wav",
        "Please alert suspect\nactivities immediately!",
    },
    ["red"] = {
        Color(255,0,0),
        "Es herrscht nun Code Red! Bitte bleiben sie in ihren Räumen und versperren sie die Türen!",
        "HL1/fvox/evacuate_area.wav",
        "Evacuate immediately!\nContainment Breach",
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

--Should the HUD element be enabled?
LUCTUS_SCP_CODE_HUD_ENABLED = true

--The code after a server restart, has to exist in the config above!
LUCTUS_SCP_CODE_DEFAULT = "green"

--If you use luctus_activityplan, which code should halt it?
LUCTUS_SCP_CODE_ACTIVITYSTOP = "red"

--Which code should also start a DarkRP lockdown? (Set to non existing code to disable)
--If you use this please set the DarkRP "GAMEMODE.Config.lockdowndelay" very low or else the lockdown wont start everytime
LUCTUS_SCP_CODE_LOCKDOWN = "red"

--Should the name of the ply who changed the code be shown in chat?
LUCTUS_SCP_CODE_SHOW_PLY = true

--Should the code HUD display be split and the "Code:" be white?
--If this is false the whole text will be colored in the same way as the current code
LUCTUS_CODE_STYLE_SPLIT = false

print("[luctus_code] config loaded!")
