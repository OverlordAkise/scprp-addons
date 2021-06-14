--Luctus SCP049 System
--Made by OverlordAkise

util.AddNetworkString("luctus_scp049_mixing")
resource.AddWorkshop("183901628") -- SCP049 Playermodel

scp049_ply = scp049_ply or false
scp049_col_one = 1
scp049_col_two = 1
scp049_random = tonumber(os.date("%W")) --unused


scp049_effects = {
  ["Nothing"] = 60, 
  ["Jumpheight"] = 20,
  ["Health"] = 15,
  ["Damage"] = 10,
  ["Speed"] = 10,
  ["Godly"] = 5,
}

scp049_effect_functions = {
  ["Nothing"] = function(ply) end, 
  ["Jumpheight"] = function(ply)
    local spawnPos = ply:GetPos()
    ply:Spawn()
    ply.scp049_oldJob = ply:getDarkRPVar("job")
    ply:setDarkRPVar("job","SCP049-2")
    ply:SetPos(spawnPos)
    ply:StripWeapons()
    ply:Give("weapon_scp049_2")
    ply:SetJumpPower(400)
    ply:SetModel(SCP049_ZOMBIE_MODEL)
  end,
  ["Health"] = function(ply)
    local spawnPos = ply:GetPos()
    ply:Spawn()
    ply.scp049_oldJob = ply:getDarkRPVar("job")
    ply:setDarkRPVar("job","SCP049-2")
    ply:SetPos(spawnPos)
    ply:StripWeapons()
    ply:Give("weapon_scp049_2")
    ply:SetHealth(1000)
    ply:SetMaxHealth(1000)
    ply:SetModel(SCP049_ZOMBIE_MODEL)
  end,
  ["Damage"] = function(ply)
    local spawnPos = ply:GetPos()
    ply:Spawn()
    ply.scp049_oldJob = ply:getDarkRPVar("job")
    ply:setDarkRPVar("job","SCP049-2")
    ply:SetPos(spawnPos)
    ply:StripWeapons()
    ply:Give("weapon_scp049_2")
    ply:GetWeapons()[1].Primary.Damage = 60
    ply:SetModel(SCP049_ZOMBIE_MODEL)
  end,
  ["Speed"] = function(ply)
    local spawnPos = ply:GetPos()
    ply:Spawn()
    ply.scp049_oldJob = ply:getDarkRPVar("job")
    ply:setDarkRPVar("job","SCP049-2")
    ply:SetPos(spawnPos)
    ply:StripWeapons()
    ply:Give("weapon_scp049_2")
    ply:SetRunSpeed(ply:GetRunSpeed()*2)
    ply:SetWalkSpeed(ply:GetWalkSpeed()*2)
    ply:SetDuckSpeed(ply:GetWalkSpeed()*2)
    ply:SetModel(SCP049_ZOMBIE_MODEL)
  end,
  ["Godly"] = function(ply)
    local spawnPos = ply:GetPos()
    ply:Spawn()
    ply:SetPos(spawnPos)
  end,
}

scp049_mixtable = scp049_mixtable or {}


function luctusMixTable()
  scp049_mixtable = {}
  local chc = 0
	local lootChc = {}
	local lootClass = ""
    	local loot
	for k, v in pairs ( scp049_effects ) do
		lootChc[k] = { min = chc+1, max = chc + v }
		chc = chc + v
	end
  print("[SCP049] The Mixtable is:")
  for i=1,7 do
    scp049_mixtable[i] = {}
    for j=1,7 do
      local rNumber = math.random( 1, chc )
      for k, v in pairs ( lootChc ) do
        if ( rNumber >= v.min and rNumber <= v.max ) then
          lootClass = k
          print("["..i.."]["..j.."] = "..k)
          scp049_mixtable[i][j] = k
        end
      end
    end
  end
  print("[SCP049] End of mixtable")
end
  
hook.Add("OnPlayerChangedTeam", "luctus_scp049_killaura", function(ply, beforeNum, afterNum)

  --switch to scp173
  if RPExtraTeams[afterNum].name == "SCP 049" then
    luctusMixTable()
    scp049_ply = ply
    --PrintMessage(HUD_PRINTTALK, "Someone switched to SCP 049!")
    timer.Create("scp049_killaura", 0.1, 0, function()
      for k,v in pairs(ents.FindInSphere( scp049_ply:GetPos(), 100 )) do
        if v ~= scp049_ply and v:IsPlayer() and not v.scp049_killed and not SCP049_SAVE_PMODELS[v:GetModel()] then
          v.scp049_killed = true
          v:Kill()
        end
      end
    end)
  end

  --switch from scp173
  if RPExtraTeams[beforeNum].name == "SCP 049" then
    scp049_ply = nil
    --PrintMessage(HUD_PRINTTALK, "Someone switched from SCP 049!")
    timer.Remove("scp049_killaura")
  end
end)

hook.Add("PlayerSpawn", "luctus_scp049_antispawnkill", function(ply)
  ply.scp049_killed = false
  if ply.scp049_oldJob then
    ply:setDarkRPVar("job",ply.scp049_oldJob)
    ply.scp049_oldJob = nil
  end
end)

net.Receive("luctus_scp049_mixing",function(len,ply)
  scp049_col_one = math.Clamp(net.ReadInt(17),1,7)
  scp049_col_two = math.Clamp(net.ReadInt(17),1,7)
  ply:PrintMessage(HUD_PRINTTALK, "Your mixed ID is "..scp049_col_one..scp049_col_two)
end)

print("[SCP049] SV Loaded!")
