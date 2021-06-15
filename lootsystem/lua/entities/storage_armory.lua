AddCSLuaFile()

ENT.Base 			= "looting_storage_base"
ENT.PrintName		= "Armory"
ENT.Category        = "Looting system"
ENT.Spawnable		= true

ENT.lootModel = "models/props_c17/Lockers001a.mdl"
ENT.lootPos = { forward = 25, up = 0, right = 0 }
ENT.timeToLoot = 10
ENT.cooldownTime = 480

ENT.lootList = {}
ENT.lootList["m9k_m3"] = 10
ENT.lootList["guthscp_keycard_lvl_2"] = 20
ENT.lootList["m9k_colt1911"] = 15
ENT.lootList["m9k_knife"] = 30
