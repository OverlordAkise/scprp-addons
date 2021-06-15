AddCSLuaFile()

ENT.Base 			= "looting_storage_base"
ENT.PrintName		= "Trash"
ENT.Category  = "Looting system"
ENT.Spawnable		= true

ENT.lootModel = "models/props_interiors/trashcan01.mdl"
ENT.lootPos = { forward = 25, up = 0, right = 0 }
ENT.timeToLoot = 10
ENT.cooldownTime = 480

ENT.lootList = {}
ENT.lootList["durgz_cigarette"] = 10
ENT.lootList["durgz_water"] = 10
ENT.lootList["bread5b"] = 25
ENT.lootList["meat9"] = 25
ENT.lootList["light kevlar armor"] = 10
ENT.lootList["guthscp_keycard_lvl_2"] = 1
