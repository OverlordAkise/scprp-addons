--Luctus SCP Codes
--Made by OverlordAkise

LUCTUS_SCP_CODES = {
    ["green"] = {
        Color(0,255,0),
        "Es herrscht nun Code Green! Es kann ohne verschärfte Sicherheitsmassnahmen gearbeitet werden.",
    },
    ["yellow"] = {
        Color(255,255,0),
        "Es herrscht nun Code Yellow! Bitte achten sie auf auffälligkeiten und melden diese sofort!",
    },
    ["red"] = {
        Color(255,0,0),
        "Es herrscht nun Code Red! Bitte bleiben sie in ihren Räumen und versperren sie die Türen!",
    },
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

print("[luctus_scp_code] sh config loaded!")
