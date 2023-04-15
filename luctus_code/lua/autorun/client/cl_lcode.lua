--Luctus SCP Codes
--Made by OverlordAkise

LUCTUS_CODE_CURRENT_COLOR = Color(0,255,0)
LUCTUS_CODE_CURRENT = "green"

surface.CreateFont("luctus_scp_code_hud_font",{
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


local function DrawBox(x, y, w, h, edgeSize)
    draw.RoundedBox(0, x, y, w, h, borderCol)
    draw.RoundedBox(0, x+1, y+1, w-2, h-2, frameCol)
end

local font = "luctus_scp_code_hud_font"
local borderCol = Color(0, 195, 165)
local frameCol = Color(26,26,26)

if EdgeHUD then
    print("[luctus_activity] edgehud found, loading design")
    font = "luctus_scp_code_hud_font"
    DrawBox = function(x,y,width,height,edgeSize,col)
        if not EdgeHUD.Colors or not EdgeHUD.Colors["White_Corners"] then return end
        surface.SetDrawColor(EdgeHUD.Colors["Black_Transparent"])
        surface.DrawRect(x, y, width, height)
        surface.SetDrawColor(EdgeHUD.Colors["White_Outline"])
        surface.DrawOutlinedRect(x, y, width, height)
        surface.SetDrawColor(EdgeHUD.Colors["White_Corners"])
        EdgeHUD.DrawEdges(x,y,width,height,10)
    end
end


hook.Add("HUDPaint","luctus_scp_code",function()
    surface.SetFont("luctus_scp_code_hud_font")
    local wx, wy = surface.GetTextSize("Code: "..LUCTUS_CODE_CURRENT)
    DrawBox(ScrW()-wx-20, 125, wx+20, 40)
    draw.DrawText("Code: "..LUCTUS_CODE_CURRENT, font, ScrW() - 10, 130, LUCTUS_CODE_CURRENT_COLOR, TEXT_ALIGN_RIGHT)
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
