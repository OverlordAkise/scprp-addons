DarkRP.createCategory{
  name = "SCP",
  categorises = "jobs",
  startExpanded = true,
  color = Color(0, 107, 0, 255),
  canSee = function(ply) return true end,
  sortOrder = 100,
}
TEAM_SCP096 = DarkRP.createJob("SCP 096", {
    color = Color(255, 20, 20, 255),
    model = "models/player/scp096.mdl",
    description = [[Anschauen bedeutet immediate death.]],
    weapons = {"weapon_luctus_scp096"},
    command = "scp096",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 5,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "SCP",
    PlayerSpawn = function(ply)
      ply:SetHealth(4000)
      ply:SetMaxHealth(4000)
      ply:StripWeapons()
      ply:Give("weapon_luctus_scp096")
    end,
})
