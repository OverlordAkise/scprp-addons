--SCP Code System
--Reworked by OverlordAkise

scpcode_current_code = "red"

util.AddNetworkString("SCPCodes")
resource.AddFile("materials/code-green.png")
resource.AddFile("materials/code-yellow.png")
resource.AddFile("materials/code-orange.png")
resource.AddFile("materials/code-red.png")
resource.AddFile("materials/code-black.png")
resource.AddFile("materials/code-brown.png")
resource.AddFile("materials/code-purple.png")
resource.AddFile("materials/code-blue.png")
resource.AddFile("materials/code-white.png")
print("[scp_codes] Resources added!")
print("[scp_codes] Resource download doesn't work if you use FastDL and didn't include these materials in it!")
print("[scp_codes] aka. This auto download only works if sv_downloadurl is set to \"\" !")

LuctusLog = LuctusLog or function()end

hook.Add("PlayerSay","luctus_scp_codes_pngs",function(ply,text,team)
    local cmds = string.Split(text," ")
    if cmds[1] == scp_code_command then
      if not scp_code_materials[cmds[2]] then return end
      if not scp_code_allowedJobs[ply:getJobTable().name] then return end
      scpcode_current_code = cmds[2]
      LuctusLog("CodeSystem",ply:Nick().."("..ply:SteamID()..") changed the code to "..scpcode_current_code..".")
      net.Start("SCPCodes")
      net.WriteString(cmds[2])
      net.Broadcast()
      PrintMessage(HUD_PRINTTALK, scp_code_messages[cmds[2]])
      if not scp_code_echo_in_chat then
        return ""
      end
    end
end)

net.Receive("SCPCodes",function(len,ply)
  net.Start("SCPCodes")
  net.WriteString(scpcode_current_code)
  net.Send(ply)
end)
