
DarkRP.createCategory{
  name = "SCP",
  categorises = "jobs",
  startExpanded = true,
  color = Color(0, 107, 0, 255),
  canSee = function(ply) return true end,
  sortOrder = 100,
}
TEAM_SCP457 = DarkRP.createJob("SCP 457", {
    color = Color(255, 20, 20, 255),
    model = "models/player/charple.mdl",
    description = [[Euclid
    457 ist ein wesen aus Flammen was oft Humanoid geformt ist sofern genug brennbare masse gegeben ist, die masse von 457 ist unbekannt.]],
    weapons = {"weapon_scp457"},
    command = "scp457",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 5,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "SCP",
    PlayerSpawn = function(ply) 
      ply:StripWeapons()
      ply:Give("weapon_scp457")
      ply:SetHealth(3000)
      ply:SetMaxHealth(3000)
    end,
})
