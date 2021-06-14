--Luctus SCP Codes
--Made by OverlordAkise

local codecol = Color(0,255,0)
local codecode = "Code: green"

surface.CreateFont( "LSCPCodeFont", {
	font = "Arial",
	extended = false,
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

hook.Add("HUDPaint","luctus_scp_code",function()
  surface.SetFont("LSCPCodeFont")
  local wx, wy = surface.GetTextSize(codecode)
  draw.RoundedBox(0, ScrW()-wx-10, 125, wx+10, 40, Color(0,0,0,240))
  draw.DrawText(codecode, "LSCPCodeFont", ScrW() - 5, 130, codecol, TEXT_ALIGN_RIGHT)
end)

hook.Add("InitPostEntity", "luctus_scp_code", function()
	net.Start("luctus_scp_code")
	net.SendToServer()
end )

net.Receive("luctus_scp_code", function()
  local codetext = net.ReadString()
  codecode = "Code: "..codetext
  if (codetext == "green") then
    codecol = Color(0,255,0)
    chat.AddText(codecol, "The current code is now Code Green!")
  elseif (codetext == "yellow") then
    codecol = Color(255,255,0)
    chat.AddText(codecol, "The current code is now Code Yellow!")
  else
    codecol = Color(255,50,50)
    chat.AddText(codecol, "The current code is now Code Red!")
  end
end)

