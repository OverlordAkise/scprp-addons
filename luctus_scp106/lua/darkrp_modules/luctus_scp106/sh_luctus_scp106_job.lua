
DarkRP.createCategory{
  name = "SCP",
  categorises = "jobs",
  startExpanded = true,
  color = Color(0, 107, 0, 255),
  canSee = function(ply) return true end,
  sortOrder = 100,
}
TEAM_SCP106 = DarkRP.createJob("SCP 106", {
    color = Color(255, 20, 20, 255),
    model = "models/player/charple.mdl",
    description = [[Euclid
    SCP106 is a black man who teleports others into his shadow realm where they will most likely die of non-natural causes.]],
    weapons = {"weapon_luctus_scp106"},
    command = "scp106",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 5,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "SCP",
    PlayerSpawn = function(ply) 
      ply:StripWeapons()
      ply:Give("weapon_luctus_scp106")
      ply:SetHealth(3000)
      ply:SetMaxHealth(3000)
    end,
})
