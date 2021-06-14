--Luctus SCP049 System
--Made by OverlordAkise

SCP049_ZOMBIE_MODEL = "models/player/zombie_classic.mdl"

SCP049_SAVE_PMODELS = {
  ["models/player/monk.mdl"] = true,
  [SCP049_ZOMBIE_MODEL] = true,
}



hook.Add("loadCustomDarkRPItems", "luctus_scp049_drp", function()
  DarkRP.createCategory{
    name = "SCP",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
  }
  TEAM_SCP049 = DarkRP.createJob("SCP 049", {
    color = Color(255, 20, 20, 255),
    model = "models/vinrax/player/Scp049_player.mdl",
    description = [[Euclid
    SCP049 kills everything it touches.]],
    weapons = {"weapon_scp049"},
    command = "scp049",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 5,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "SCP",
    PlayerSpawn = function(ply) 
      ply:SetHealth(1000)
      ply:SetMaxHealth(1000)
    end
  })
end)

print("[SCP049] SH Loaded!")