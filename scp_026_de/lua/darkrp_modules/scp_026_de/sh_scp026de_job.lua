DarkRP.createCategory{
  name = "SCP",
  categorises = "jobs",
  startExpanded = true,
  color = Color(0, 107, 0, 255),
  canSee = function(ply) return true end,
  sortOrder = 100,
}
TEAM_SCP096 = DarkRP.createJob("SCP 026 DE", {
    color = Color(255, 20, 20, 255),
    model = "models/player/skeleton.mdl",
    description = [[Ask infected questions in rhyme, if they cant answer they will have a tough time.]],
    weapons = {"scp_026_de"},
    command = "scp026de",
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
      ply:StripWeapons()
      ply:Give("scp_026_de")
    end,
})
