DarkRP.createCategory{
  name = "SCP",
  categorises = "jobs",
  startExpanded = true,
  color = Color(0, 107, 0, 255),
  canSee = function(ply) return true end,
  sortOrder = 100,
}

TEAM_SCP131A = DarkRP.createJob("SCP 131-A", {
    color = Color(255, 20, 20, 255),
    model = "models/scprp/scp131a2.mdl",
    description = [[Sicher
    131-A ist eines von zwei Augen.]],
    weapons = {"weapon_scp131"},
    command = "scp131a",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 5,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "SCP",
})

TEAM_SCP131B = DarkRP.createJob("SCP 131-B", {
    color = Color(255, 20, 20, 255),
    model = "models/scprp/scp131a2.mdl",
    description = [[Sicher
    131-B ist eines von zwei Augen.]],
    weapons = {"weapon_scp131"},
    command = "scp131b",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 5,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "SCP",
})
