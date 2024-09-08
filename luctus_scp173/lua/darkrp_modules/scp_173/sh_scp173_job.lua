--Luctus SCP173 System
--Made by OverlordAkise

DarkRP.createCategory{
  name = "SCP",
  categorises = "jobs",
  startExpanded = true,
  color = Color(0, 107, 0, 255),
  canSee = function(ply) return true end,
  sortOrder = 100,
}
TEAM_SCP173 = DarkRP.createJob("SCP 173", {
    color = Color(255, 20, 20, 255),
    model = "models/breach173.mdl",
    description = [[Euclid
    173 is a statue that only moves if nobody is looking at it.
    Left-Mouse: Snap people's neck or open doors
    Right-Mouse: Force everyone near you to blink]],
    weapons = {"weapon_scp173"},
    command = "scp173",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 5,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "SCP",
    PlayerSpawn = function(ply) 
      ply:SetRunSpeed(240*3)
      ply:SetWalkSpeed(240*3)
      ply:StripWeapons()
      ply:Give("weapon_scp173")
      ply:SetHealth(10000)
      ply:SetMaxHealth(10000)
    end,
})
