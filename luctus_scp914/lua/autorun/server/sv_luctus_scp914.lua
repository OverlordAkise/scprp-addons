--Luctus SCP914 System
--Made by OverlordAkise

--TODO: DARKRP WEAPON SUPPORT (spawned_weapon)
--EDIT BUTTON IN MENU


if (game.GetMap() ~= "rp_liquidrp_ct_site99") then 
  error("[luctus_scp914] THIS ADDON IS ONLY MADE FOR rp_liquidrp_ct_site99 ! Canceling loading!")
end

util.AddNetworkString("luctus_scp914_save")
util.AddNetworkString("luctus_scp914_edit")
util.AddNetworkString("luctus_scp914_delete")
util.AddNetworkString("luctus_scp914_get")

hook.Add("InitPostEntity","luctus_scp914_setup",function()
  local res = sql.Query("CREATE TABLE IF NOT EXISTS luctus_scp914('input' TEXT NOT NULL, 'output' TEXT NOT NULL, 'wheeltype' INTEGER NOT NULL);")
  if res ~= false then
    print("[luctus_scp914] Successfully setup DB!")
  end
end)

net.Receive("luctus_scp914_delete", function(len, ply)
  if not ply:IsValid() or not ply:IsAdmin() then return end
  local rowID = net.ReadInt(32)
  local res = sql.Query("DELETE FROM luctus_scp914 WHERE rowid = "..rowID)
  if res ~= false then
    print("[luctus_scp914] Successfully deleted from list!")
    print("[luctus_scp914] Deleted entry ID: "..rowID)
    ply:PrintMessage(HUD_PRINTTALK, "[scp914] Deleted successfully!")
  else
    ply:PrintMessage(HUD_PRINTTALK, "[scp914] Error during delete, please contact an admin!")
    print("[luctus_scp914] Error during delete from list! :")
    print(sql.LastError())
  end
end)

function getSCP914s(wheeltype)
  if not tonumber(wheeltype) then return {} end
  local ret = sql.Query("SELECT rowid,* FROM luctus_scp914 WHERE wheeltype = "..wheeltype)
  if(ret==false)then
    print("[luctus_scp914] SQL ERROR DURING getSCP914s!")
    print(sql.LastError())
    return {}
  end
  if ret and ret ~= nil then
    --print("Response!")
    --print("Sending:")
    --PrintTable(ret)
    return ret
  end
  return {}
end

net.Receive("luctus_scp914_get", function(len, ply)
  if not ply:IsValid() or not ply:IsAdmin() then return end
  local wheeltype = net.ReadInt(8)
  local liste = getSCP914s(wheeltype)
  net.Start("luctus_scp914_get")
    local t = util.TableToJSON(liste)
    local a = util.Compress(t)
    net.WriteInt(#a,17)
    net.WriteData(a,#a)
  net.Send(ply)
end)

net.Receive("luctus_scp914_edit", function(len, ply)
  if not ply:IsValid() or not ply:IsAdmin() then return end
  local inputEnt = net.ReadString()
  local outputEnt = net.ReadString()
  local wheeltype = net.ReadInt(8)
  local rowID = net.ReadInt(32)
  local res = sql.Query("UPDATE luctus_scp914 SET input = "..sql.SQLStr(inputEnt)..", output = "..sql.SQLStr(outputEnt).." WHERE rowid = "..rowID)

  if res ~= false then
    print("[luctus_scp914] Successfully updated list!")
    print("[luctus_scp914] Changed entry to: "..inputEnt.." / "..outputEnt.." / "..wheeltype)
    ply:PrintMessage(HUD_PRINTTALK, "[scp914] Changed successfully!")
  else
    ply:PrintMessage(HUD_PRINTTALK, "[scp914] Error during change, please contact an admin!")
    print("[luctus_scp914] Error during edit list! :")
    print(sql.LastError())
  end
end)

net.Receive("luctus_scp914_save", function(len, ply)
  if not ply:IsValid() or not ply:IsAdmin() then return end
  local inputEnt = net.ReadString()
  local outputEnt = net.ReadString()
  local wheeltype = net.ReadInt(8)
  local res = sql.Query("INSERT INTO luctus_scp914(input,output,wheeltype) VALUES("..sql.SQLStr(inputEnt)..","..sql.SQLStr(outputEnt)..","..wheeltype..")")
  if res ~= false then
    print("[luctus_scp914] Successfully updated list!")
    print("[luctus_scp914] New entry: "..inputEnt.." / "..outputEnt.." / "..wheeltype)
    ply:PrintMessage(HUD_PRINTTALK, "[scp914] Added successfully!")
  else
    ply:PrintMessage(HUD_PRINTTALK, "[scp914] Error during add, please contact an admin!")
    print("[luctus_scp914] Error during update list! :")
    print(sql.LastError())
  end
end)


scp914WheelCounter = scp914WheelCounter or 1
scp914WheelInitialized = false

local function SetupWheelCounter()
  scp914WheelCounter = 1
  scp914WheelInitialized = false
  
  print("[luctus_scp914] Successfully loaded wheelcounter!")
end

hook.Add( "InitPostEntity", "SCP914_SetupWheelCounter", SetupWheelCounter )
hook.Add( "PostCleanupMap", "SCP914_SetupWheelCounter", SetupWheelCounter )
hook.Add( "SCP914_OnWheelPressed", "TestTeleportHook", function()
  --Stupid wheel doesn't turn on first press
  if scp914WheelInitialized == false then
    scp914WheelInitialized = true
    return
  end
  scp914WheelCounter = (scp914WheelCounter + 1)
  if scp914WheelCounter >= 6 then
    scp914WheelCounter = 1
  end
  print("[luctus_scp914] Wheel has been set to "..scp914WheelCounter)
end)
hook.Add( "SCP914_OnTeleport", "TestTeleportHook", function()
	local activator, caller = ACTIVATOR, CALLER
	--print( activator, caller )--print("[luctus_scp914] Teleporting...")
  if(activator and IsValid(activator) and activator:GetClass())then
    local entClass = activator:GetClass()
    if (activator.GetWeaponClass) then
      entClass = activator:GetWeaponClass()
    end
    --activator:GetClass()
    local res = sql.QueryValue("SELECT output FROM luctus_scp914 WHERE input = "..sql.SQLStr(entClass).." AND wheeltype = "..scp914WheelCounter)
    if res == false then
      print("[luctus_scp914] ERROR DURING TELEPORT SQL SELECT!")
      print(sql.LastError())
      return
    end
    if type(res) ~= "string" then return end
    print("[luctus_scp914] Transforming "..entClass.." to "..res)
    local destPos = activator:GetPos()
    activator:Remove()
    local newEnt = ents.Create(res)
    newEnt:SetPos(destPos)
    newEnt:Spawn()
  end
end)
