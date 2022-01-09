DarkRP.createCategory{
  name = "SCP",
  categorises = "jobs",
  startExpanded = true,
  color = Color(0, 107, 0, 255),
  canSee = function(ply) return true end,
  sortOrder = 100,
}
TEAM_SCP999 = DarkRP.createJob("SCP 999", {
    color = Color(255, 20, 20, 255),
    model = "models/scp/999/jq/scp_999_pmjq.mdl",
    description = [[Sicher
    999 ist ein großes amorphes Wesen aus orangener, transparenter Masse die sich wie Erdnussbutter anfühlt und so riecht. Es will jedem Menschen Liebhaben, dies tut es mit kuscheln oder kitzeln. 999 liebt süßes und kann sich damit locken lassen.]],
    weapons = {"weapon_scp999"},
    command = "scp999",
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
      ply:Give("weapon_scp999")
    end,
})
