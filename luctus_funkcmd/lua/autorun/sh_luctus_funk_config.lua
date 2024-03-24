--Luctus Funk
--Made by OverlordAkise

--Every chat command words with ! and /
LUCTUS_FUNK_COMMAND = "funk"
LUCTUS_FUNK_COMMAND_ANON = "funka"
LUCTUS_FUNK_COMMAND_ENCRYPTED = "funke"
LUCTUS_FUNK_PREFIX = "[FUNK BROADCAST]"
LUCTUS_FUNKA_PREFIX = "[FUNK ANON]"
LUCTUS_FUNKE_PREFIX = "[FUNK ENCRYPTED]"

--Restrict access to funk chat commands
--Only if you have the weapon you can use them
LUCTUS_FUNK_WEAPONRESTRICT = false
LUCTUS_FUNK_WEAPON_CLASS = "luctus_radio"

--Restrict access to funk chat commands
--Only if your job is in the whitelist you can use them
LUCTUS_FUNK_JOB_WHITELIST_ENABLED = false
LUCTUS_FUNK_JOB_WHITELIST = {
    ["Medic"] = true,
    ["MTF"] = true,
}

LUCTUS_FUNK_CUSTOM_CHANNELS = {
    ["cifunk"] = { --the chat command
        prefix = "[CI FUNK]",
        color = Color(50,100,50),
        isAnonymous = false, --if playernames should be hidden
        jobs = {"CI Commander", "CI Assault", "Citizen"}, --if this is empty every job can use it
        needsRadioToFunk = false, --If you need to have the radio weapon to use this
    },
    ["anonfunk"] = { --the chat command
        prefix = "[ANON FUNK]",
        color = Color(200,150,250),
        isAnonymous = true, --if playernames should be hidden
        jobs = {}, --if this is empty every job can use it
        needsRadioToFunk = false, --If you need to have the radio weapon to use this
    },
}

--Users could decrypt messages automatically
--if you don't change the encryption table often
--set this to true to make the encryption random
LUCTUS_FUNK_RANDOM_ENCRYPTION = false

LUCTUS_FUNK_ENCTABLE = {
    ["a"] = "i",
    ["b"] = "q",
    ["c"] = "m",
    ["d"] = "z",
    ["e"] = "f",
    ["f"] = "j",
    ["g"] = "o",
    ["h"] = "v",
    ["i"] = "s",
    ["j"] = "p",
    ["k"] = "y",
    ["l"] = "x",
    ["m"] = "d",
    ["n"] = "a",
    ["o"] = "h",
    ["p"] = "c",
    ["q"] = "e",
    ["r"] = "k",
    ["s"] = "t",
    ["t"] = "w",
    ["u"] = "r",
    ["v"] = "n",
    ["w"] = "g",
    ["x"] = "b",
    ["y"] = "l",
    ["z"] = "u"
}

--Config End

if LUCTUS_FUNK_RANDOM_ENCRYPTION then
    local alpha = "abcdefghijklmnopqrstuvwxyz"
    for k,v in pairs(LUCTUS_FUNK_ENCTABLE) do
        local randomCharNum = math.random(1,#alpha)
        local randomChar = string.sub(alpha,randomCharNum,randomCharNum)
        LUCTUS_FUNK_ENCTABLE[k] = randomChar
        alpha = string.gsub(alpha,randomChar,"")
    end
end

print("[luctus_funkcmd] config loaded")
