--Luctus Activityplan
--Made by OverlordAkise

luctusCurrentActivityID = 0

util.AddNetworkString("luctus_activity_sync")

hook.Add( "PlayerInitialSpawn", "luctus_activity_initply", function(ply)
	hook.Add( "SetupMove", ply, function( self, ply, _, cmd )
		if self == ply and not cmd:IsForced() then
			net.Start("luctus_activity_sync")
        net.WriteString(LUCTUS_ACTIVITY_ACTIVITIES[luctusCurrentActivityID][1])
        net.WriteInt(luctusActivityTimeLeft(),16)
      net.Send(ply)
			hook.Remove( "SetupMove", self )
		end
	end)
end)

hook.Add("PlayerInitialSpawn", "luctus_activity_start", function(ply)
  luctusStartNextActivity()
  hook.Remove("PlayerInitialSpawn", "luctus_activity_start")
end)

function luctusActivityTimeLeft()
  return timer.TimeLeft("luctus_activity_timer")
end

function luctusStartNextActivity()
  if timer.Exists("luctus_activity_timer") then
    timer.Remove("luctus_activity_timer")
  end
  luctusCurrentActivityID = (luctusCurrentActivityID % 4)+1
  timer.Create("luctus_activity_timer",LUCTUS_ACTIVITY_ACTIVITIES[luctusCurrentActivityID][2], 1, function()
    luctusStartNextActivity()
  end)
  net.Start("luctus_activity_sync")
    net.WriteString(LUCTUS_ACTIVITY_ACTIVITIES[luctusCurrentActivityID][1])
    net.WriteInt(luctusActivityTimeLeft(),16)
  net.Broadcast()
end

hook.Add("PlayerSay","luctus_activity_resync",function(ply,text,team)
  if text == "!activity_resync" then
    net.Start("luctus_activity_sync")
      net.WriteString(LUCTUS_ACTIVITY_ACTIVITIES[luctusCurrentActivityID][1])
      net.WriteInt(luctusActivityTimeLeft(),16)
    net.Broadcast()
  end
  if text == "!activity_skip" then
    if not ply:IsAdmin() then return end
    luctusStartNextActivity()
  end
end)

print("[luctus_activity] SV loaded!")
