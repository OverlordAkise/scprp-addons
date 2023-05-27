--Luctus Razzia
--Made by OverlordAkise

--CONFIG START

--Which jobs can call a razzia?
LUCTUS_RAZZIA_JOBS_SEND = {
    ["Citizen"] = true,
    ["O5-Rat"] = true,
}
--Which jobs get the message about it?
LUCTUS_RAZZIA_JOBS_RECV = {
    ["Citizen"] = true,
    ["D-Klasse"] = true,
}

--Max time a razzia can take before it auto stops, in seconds
LUCTUS_RAZZIA_MAX_TIME = 300

LUCTUS_RAZZIA_STARTCMD = "!razziastart"
LUCTUS_RAZZIA_STARTTEXT = "A razzia is about to begin, please step up to the line"

LUCTUS_RAZZIA_STARTSOUND = {
    "npc/overwatch/radiovoice/attention.wav",
    "npc/overwatch/radiovoice/subject.wav",
    "npc/overwatch/radiovoice/_comma.wav",
    "npc/overwatch/radiovoice/apply.wav",
    "npc/overwatch/radiovoice/two.wav",
    "npc/overwatch/radiovoice/patrol.wav",
    "npc/overwatch/radiovoice/line.wav",
}
--"npc/attack_helicopter/aheli_damaged_alarm1.wav"

LUCTUS_RAZZIA_ENDCMD = "!razziaend"
LUCTUS_RAZZIA_ENDTEXT = "The razzia ended, please head to your cells"
LUCTUS_RAZZIA_ENDSOUND = {
    "npc/overwatch/radiovoice/attention.wav",
    "npc/overwatch/radiovoice/_comma.wav",
    "npc/overwatch/radiovoice/allunitsat.wav",
    "npc/overwatch/radiovoice/residentialblock.wav",
    "npc/overwatch/radiovoice/suspend.wav",
    "npc/overwatch/radiovoice/inprogress.wav",
    "npc/overwatch/radiovoice/search.wav",
}

--CONFIG END

print("[luctus_razzia] config loaded!")
