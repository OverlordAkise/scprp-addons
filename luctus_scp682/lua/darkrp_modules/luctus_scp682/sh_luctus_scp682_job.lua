--Luctus SCP682
--Made by OverlordAkise

DarkRP.createCategory{
  name = "SCP",
  categorises = "jobs",
  startExpanded = true,
  color = Color(0, 107, 0, 255),
  canSee = function(ply) return true end,
  sortOrder = 100,
}
TEAM_SCP682 = DarkRP.createJob("SCP 682", {
    color = Color(255, 20, 20, 255),
    model = "models/scp_682/scp_682.mdl",
    description = [[Euclid
    682 is immune to damage after being hit by it once.
    Leftclick attacks, Rightclick opens doors
    Reload screams and launches you forward a bit]],
    weapons = {"weapon_luctus_scp682"},
    command = "scp682",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 5,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "SCP",
    PlayerSpawn = function(ply) 
      ply:StripWeapons()
      ply:Give("weapon_luctus_scp682")
      ply:SetHealth(5000)
      ply:SetMaxHealth(5000)
    end,
})
