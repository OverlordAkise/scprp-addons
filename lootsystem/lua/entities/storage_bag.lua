AddCSLuaFile()

ENT.Base = "looting_storage_base"
ENT.PrintName = "Loot Bag"
ENT.Category = "Looting system"
ENT.Spawnable = true

ENT.lootModel = "models/props_c17/BriefCase001a.mdl"
ENT.lootPos = { forward = 0, up = 35, right = 0}
ENT.timeToLoot = 10
ENT.cooldownTime = 480

ENT.lootList = {}
ENT.lootList["guthscp_keycard_lvl_3"] = 1
ENT.lootList["guthscp_keycard_lvl_2"] = 5
ENT.lootList["guthscp_keycard_lvl_1"] = 10
ENT.lootList["weapon_vape_medicinal"] = 15
ENT.lootList["m9k_knife"] = 20