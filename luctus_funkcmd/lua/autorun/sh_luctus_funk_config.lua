--Luctus Funk
--Made by OverlordAkise

LUCTUS_FUNK_COMMAND = "!funk"
LUCTUS_FUNK_COMMAND_ANON = "!funka"
LUCTUS_FUNK_COMMAND_ENCRYPTED = "!funke"
LUCTUS_FUNK_PREFIX = "[FUNK BROADCAST]"
LUCTUS_FUNKA_PREFIX = "[FUNK ANON]"
LUCTUS_FUNKE_PREFIX = "[FUNK ENCRYPTED]"

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
