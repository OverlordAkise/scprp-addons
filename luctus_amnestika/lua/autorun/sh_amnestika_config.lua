--Luctus Amnestika
--Made by OverlordAkise

--YOU NEED THE FOLLOWING WORKSHOP ADDON IN YOUR SERVER'S WORKSHOP COLLECTION FOR THIS TO WORK:

--https://steamcommunity.com/sharedfiles/filedetails/?id=2595071184


--STRENGTH should always be between 1 and 10, didn't test it for higher!
AMNESTIKA_LEVELS = {
  --[LEVEL] = {STRENGTH, TIME, TEXT FOR PLAYER}
    ["A"] = {1, 3, "You forget everything that happened in the last 2 hours!"},
    ["B"] = {5, 5, "You forget everything that happened in the last 12 hours!"},
}

-- CONFIG end

function LoadAmnestikas()
    for k,v in pairs(AMNESTIKA_LEVELS) do
        local SWEP = weapons.Get("weapon_amnestika")
        SWEP.Spawnable = true
        SWEP.myclass = "weapon_amnestika_"..string.lower(k)
        SWEP.mytype = k
        SWEP.PrintName = "Amnestika "..k
        weapons.Register(SWEP,"weapon_amnestika_"..string.lower(k))
    end
end

hook.Add("PopulatePropMenu", "luctus_load_amnestikas", LoadAmnestikas)

hook.Add("InitPostEntity", "luctus_load_amnestikas_fully",LoadAmnestikas)



print("amnestika loaded!")
