--Luctus Lootsystem
--Made by OverlordAkise

--CONFIG START

--Set to true to blacklist jobs from looting
luctus_loot_blacklist_jobs = {
    ["Citizen"] = true,
    ["Medic"] = true,
}

luctus_loot_entities = {
    ["Armory"] = {
        model = "models/props_c17/Lockers001a.mdl",
        customPos = { forward = 25, up = 0, right = 0 },
        lootTime = 10,
        lootCooldown = 480,
        lootList = {
            ["m9k_m3"] = 10,
            ["m9k_knife"] = 30,
            ["guthscp_keycard_lvl_2"] = 20,
        }
    },
}

--CONFIG END

function LoadLootEntities()
    for name,enttable in pairs(luctus_loot_entities) do
        local newname = "looting_storage_base"..string.lower(name)
        local _SENT =  scripted_ents.Get("looting_storage_base")
        SENT = table.Copy(_SENT)
        SENT.Base = "looting_storage_base"
        SENT.PrintName = "Loot "..name
        SENT.Category = "Looting System"
        SENT.Spawnable = true
        SENT.lootModel = enttable.model
        SENT.lootPos = enttable.customPos
        SENT.timeToLoot = enttable.lootTime
        SENT.cooldownTime = enttable.lootCooldown
        SENT.lootList = enttable.lootList
        SENT.ClassName = newname
        scripted_ents.Register(SENT,newname)
    end
end

hook.Add("PopulatePropMenu", "luctus_load_lootents", LoadLootEntities)

hook.Add("InitPostEntity", "luctus_load_lootents",LoadLootEntities)


if SERVER then
    util.AddNetworkString("luctus_lootsystem_hud")
end
