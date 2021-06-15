

local search_starttime = 0
local search_progress = 0
local SmoothedProgress = 0

net.Receive("lootsystem_enable_hud", function()
	local enabled = net.ReadBool()
	if enabled then 
		search_starttime = CurTime() 
	else 
		search_starttime = 0 
		search_progress = 0 
		SmoothedProgress = 0
	end
end)



hook.Add( "HUDPaint", "lootsystem_hud", function()
	local ent = LocalPlayer():GetEyeTraceNoCursor().Entity
	local SW, SH = ScrW(), ScrH()

	if not ent:GetNWBool("isLoot") or LocalPlayer():GetPos():Distance(ent:GetPos()) > 110 then return end
  if ent:GetNWInt("nextSearch") > CurTime() then
    draw.SimpleTextOutlined("You have to wait "..math.Round(ent:GetNWInt("nextSearch") - CurTime()).."s before you can search again!", "Trebuchet24", SW/2, SH/2+60, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
    return
  end
	
	if search_starttime ~= 0 then
		search_progress = ((CurTime() - search_starttime) / ent:GetNWInt("timeToLoot")) * 100
		if search_progress > 100 then search_progress = 100 end
		SmoothedProgress = math.Approach(SmoothedProgress, search_progress, (search_progress - SmoothedProgress) / 2)

		surface.SetDrawColor(0,0,0,255)
    surface.DrawOutlinedRect( SW*0.3-2, SH/2+18, SW*0.4+4, 20+4, 2 )
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawRect( SW*0.3, SH/2+20, (SW*0.4)*(SmoothedProgress*0.01), 20 )
		surface.SetDrawColor( 255, 255, 255, 5 )
		surface.DrawRect( SW*0.3, SH/2+20, SW*0.4, 20 )
    draw.SimpleTextOutlined( "Searching...", "Trebuchet24", SW/2, SH/2+60, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	else
    draw.SimpleTextOutlined("Press [E] to search", "Trebuchet24", SW/2, SH/2+70, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
  end
end )
