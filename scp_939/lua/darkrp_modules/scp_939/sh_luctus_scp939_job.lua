--Luctus SCP939
--Made by OverlordAkise

DarkRP.createCategory{
  name = "SCP",
  categorises = "jobs",
  startExpanded = true,
  color = Color(0, 107, 0, 255),
  canSee = function(ply) return true end,
  sortOrder = 100,
}
TEAM_SCP173 = DarkRP.createJob("SCP 939", {
    color = Color(255, 20, 20, 255),
    model = "models/scpbreach/scp939redone/scp_939_redone_pm.mdl",
    description = [[Euclid
    939 can barely see but hearing and smelling are improved greatly.
    Left-Mouse: Bite
    Right-Mouse: Sniff out nearby players
    Reload: Scream to see better for a short time]],
    weapons = {"weapon_luctus_scp939"},
    command = "scp939",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 5,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "SCP",
    PlayerSpawn = function(ply) 
      ply:SetRunSpeed(340)
      ply:SetWalkSpeed(200)
      ply:StripWeapons()
      ply:Give("weapon_luctus_scp939")
      ply:SetHealth(5000)
      ply:SetMaxHealth(5000)
    end,
})
