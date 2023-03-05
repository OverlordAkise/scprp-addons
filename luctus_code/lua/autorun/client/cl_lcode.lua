--Luctus SCP Codes
--Made by OverlordAkise

LUCTUS_CODE_CURRENT_COLOR = Color(0,255,0)
LUCTUS_CODE_CURRENT = "green"

surface.CreateFont( "luctus_scp_code_hud_font", {
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
})

hook.Add("LuctusLogAddCategory","luctus_scpcodesys",function()
    table.insert(lucid_log_quickfilters,"CodeSystem")
end)

hook.Add("HUDPaint","luctus_scp_code",function()
    surface.SetFont("luctus_scp_code_hud_font")
    local wx, wy = surface.GetTextSize("Code: "..LUCTUS_CODE_CURRENT)
    draw.RoundedBox(10, ScrW()-wx-10, 125, wx+10, 40, Color(0, 195, 165))
    draw.RoundedBox(10, ScrW()-wx-10+1, 125+1, wx+10-2, 40-2, Color(26,26,26))
    draw.DrawText("Code: "..LUCTUS_CODE_CURRENT, "luctus_scp_code_hud_font", ScrW() - 5, 130, LUCTUS_CODE_CURRENT_COLOR, TEXT_ALIGN_RIGHT)
end)

hook.Add("InitPostEntity", "luctus_scp_code", function()
    net.Start("luctus_scp_code")
    net.SendToServer()
end)

net.Receive("luctus_scp_code", function()
    local curcode = net.ReadString()
    if not LUCTUS_SCP_CODES[curcode] then return end
    LUCTUS_CODE_CURRENT_COLOR = LUCTUS_SCP_CODES[curcode][1]
    LUCTUS_CODE_CURRENT = curcode
    chat.AddText(LUCTUS_CODE_CURRENT_COLOR, LUCTUS_SCP_CODES[curcode][2])
    --sound
    if LUCTUS_SCP_CODES[curcode][3] then
        surface.PlaySound(LUCTUS_SCP_CODES[curcode][3])
    end
end)
