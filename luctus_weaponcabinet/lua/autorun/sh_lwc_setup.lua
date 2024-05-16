--Luctus Weaponcabinet
--Made by OverlordAkise

LUCTUS_WEAPONCABINET_S = {} --create beautified lookup table here
for cat,info in pairs(LUCTUS_WEAPONCABINET) do
    LUCTUS_WEAPONCABINET_S[cat] = {}
    LUCTUS_WEAPONCABINET_S[cat]["jobs"] = {}
    LUCTUS_WEAPONCABINET_S[cat]["weps"] = {}
    for _,job in pairs(info[1]) do
        LUCTUS_WEAPONCABINET_S[cat]["jobs"][job] = true
    end
    for _,wep in pairs(info[2]) do
        LUCTUS_WEAPONCABINET_S[cat]["weps"][wep] = true
    end
end

print("[luctus_weaponcabinet] sh loaded")
