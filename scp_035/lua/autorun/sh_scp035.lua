--Luctus SCP035 System
--Made by OverlordAkise

if SERVER then
  resource.AddWorkshop("268195264")
end

hook.Add("loadCustomDarkRPItems", "luctus_scp035_drp", function()
  DarkRP.createCategory{
    name = "SCP",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
  }
  TEAM_SCP035 = DarkRP.createJob("SCP 035", {
    color = Color(255, 20, 20, 255),
    model = "models/vinrax/player/035_player.mdl",
    description = [[Euclid
    SCP035 kills everything it touches.]],
    weapons = {},
    command = "scp035",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "SCP",
    PlayerSpawn = function(ply) 
      ply:SetHealth(1000)
      ply:SetMaxHealth(1000)
    end,
    customCheck = function(ply) return false end,
  })
end)

hook.Add("PlayerSpawn","scp035_spawn_at_pickup",function(ply)
  if ply.scp035_spawnpos and ply.isSCP035 then
    timer.Simple(0.1,function()
      ply:SetPos(ply.scp035_spawnpos)
      ply.scp035_spawnpos = nil
    end)
  end
end)

hook.Add("PostPlayerDeath","scp035_spawn_mask",function(ply)
  if ply.isSCP035 then
    ply.isSCP035 = nil
    local maskent = ents.Create("scp035_mask")
    maskent:SetPos(ply:GetPos())
    maskent:Spawn()
    maskent:Activate()
    if ply:Team() == TEAM_SCP035 then
      ply:changeTeam(GAMEMODE.DefaultTeam, true, false)
    end
  end
end)

print("[SCP035] SH Loaded!")