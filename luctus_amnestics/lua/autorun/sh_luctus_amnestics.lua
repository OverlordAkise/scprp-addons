--Luctus Amnestics
--Made by OverlordAkise

function LuctusLoadAmnestics()
    for k,v in pairs(LUCTUS_AMNESTICS_LEVELS) do
        local _SWEP = weapons.Get("weapon_amnestic")
        SWEP = table.Copy(_SWEP)
        SWEP.Spawnable = true
        SWEP.myclass = "weapon_amnestic_"..string.lower(k)
        SWEP.ClassName = "weapon_amnestic_"..string.lower(k)
        SWEP.mytype = k
        SWEP.PrintName = LUCTUS_AMNESTICS_WEAPONNAME..k
        weapons.Register(SWEP,"weapon_amnestic_"..string.lower(k))
    end
end

hook.Add("PopulatePropMenu", "luctus_load_amnestics_fallback", LuctusLoadAmnestics)
hook.Add("InitPostEntity", "luctus_load_amnestics",LuctusLoadAmnestics)

print("[luctus_amnestics] sh loaded!")
