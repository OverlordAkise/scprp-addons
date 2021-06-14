--Luctus SCP Codes
--Made by OverlordAkise

util.AddNetworkString("luctus_scp_code")

local lallowedCodes = {
  ["green"] = true,
  ["red"] = true,
  ["yellow"] = true,
  ["lockdown"] = true,
}

local lallowedJobs = {
  ["Security"] = true,
  ["O5 Rat"] = true,
  ["MTF"] = true,
  ["MTF Commander"] = true,
}

local lcurcode = "green"

hook.Add("PlayerSay", "luctus_scp_code", function(ply,text,team) 
	if string.Split(text," ")[1] == "!code" then
    if not lallowedJobs[ply:getJobTable().name] then
      DarkRP.notify(ply,1,5,"You don't have the permission to change the active code!")
      return ""
    end
    local code = string.Split(text," ")[2]
    if not lallowedCodes[code] then
      DarkRP.notify(ply,1,5,"This code doesn't exist!")
      return
    end
    lcurcode = code
    net.Start("luctus_scp_code")
      net.WriteString(code)
    net.Broadcast()
    DarkRP.notify(player.GetAll(),1,5,"Code changed to "..code.."!")
    return ""
  end
end)

net.Receive("luctus_scp_code", function(len,ply)
  net.Start("luctus_scp_code")
      net.WriteString(lcurcode)
    net.Send(ply)
end)
