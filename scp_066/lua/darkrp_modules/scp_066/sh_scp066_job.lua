--Luctus SCP066
--Made by OverlordAkise

DarkRP.createCategory{
  name = "SCP",
  categorises = "jobs",
  startExpanded = true,
  color = Color(0, 107, 0, 255),
  canSee = function(ply) return true end,
  sortOrder = 100,
}

TEAM_SCP066 = DarkRP.createJob("SCP 066", {
    color = Color(255, 20, 20, 255),
    model = "models/player/mrsilver/scp_066pm/scp_066_pm.mdl",
    description = [[Safe
    Screams your ears out and asks for Eric.]],
    weapons = {"weapon_scp066"},
    command = "scp066",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 5,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "SCP",
    customFootsteps = "066/roll.wav",
})
