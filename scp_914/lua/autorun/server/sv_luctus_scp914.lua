--Luctus SCP914 System
--Made by OverlordAkise

if (game.GetMap() ~= "rp_liquidrp_ct_site99") then 
  print("[luctus_scp914] THIS ADDON IS ONLY MADE FOR rp_liquidrp_ct_site99 ! Canceling loading!")
  return 
end

util.AddNetworkString("luctus_scp914_save")
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
    print("Response!")
    print("Sending:")
    PrintTable(ret)
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

local function SetupMapLua()
  scp914WheelCounter = 1
  scp914WheelInitialized = false
	MapLua = ents.Create( "lua_run" )
	MapLua:SetName( "triggerhook" )
	MapLua:Spawn()

	for k, v in pairs( ents.FindByClass( "trigger_teleport" ) ) do
		--print( v )
    --print("Adding")
		v:Fire( "AddOutput", "OnStartTouch triggerhook:RunPassedCode:hook.Run( 'OnTeleport' ):0:-1" )
	end
  local wheelEnt = ents.GetMapCreatedEntity(4281)
  wheelEnt:Fire( "AddOutput", "OnPressed triggerhook:RunPassedCode:hook.Run( 'OnWheelPressed' ):0:-1" )
  print("[luctus_scp914] Successfully setup map!")
end

hook.Add( "InitPostEntity", "SetupMapLua", SetupMapLua )
hook.Add( "PostCleanupMap", "SetupMapLua", SetupMapLua )
hook.Add( "OnWheelPressed", "TestTeleportHook", function()
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
hook.Add( "OnTeleport", "TestTeleportHook", function()
	local activator, caller = ACTIVATOR, CALLER
	--print( activator, caller )
  if(caller == ents.GetMapCreatedEntity(4242))then
    --print("[luctus_scp914] Teleporting...")
    if(activator and IsValid(activator) and activator:GetClass())then
      --activator:GetClass()
      local res = sql.QueryValue("SELECT output FROM luctus_scp914 WHERE input = "..sql.SQLStr(activator:GetClass()).." AND wheeltype = "..scp914WheelCounter)
      if res == false then
        print("[luctus_scp914] ERROR DURING TELEPORT SQL SELECT!")
        print(sql.LastError())
        return
      end
      if type(res) ~= "string" then return end
      print("[luctus_scp914] Transforming "..activator:GetClass().." to "..res)
      local destPos = activator:GetPos()
      activator:Remove()
      local newEnt = ents.Create(res)
      newEnt:SetPos(destPos)
      newEnt:Spawn()
    end
  end
end)
