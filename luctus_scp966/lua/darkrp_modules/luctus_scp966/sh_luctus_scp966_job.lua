
DarkRP.createCategory{
  name = "SCP",
  categorises = "jobs",
  startExpanded = true,
  color = Color(0, 107, 0, 255),
  canSee = function(ply) return true end,
  sortOrder = 100,
}
TEAM_SCP966 = DarkRP.createJob("SCP 966", {
    color = Color(255, 20, 20, 255),
    model = "models/vasey105/scp/scp966/scp-966.mdl",
    description = [[Euclid
    Invisible, can only be seen by personnel using Nightivision (!nv)
    Looking at people makes them tired (walkingspeed reduced)
    If they are slow enough you can use LMB to put them to sleep
    Use LMB on sleeping players to kill them
    Use RMB to open doors]],
    weapons = {"weapon_luctus_scp966"},
    command = "scp966",
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
      ply:Give("weapon_luctus_scp966")
    end,
})
