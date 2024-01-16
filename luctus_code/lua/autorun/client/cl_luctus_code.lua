--Luctus SCP Codes
--Made by OverlordAkise

LUCTUS_CODE_CURRENT_COLOR = Color(0,255,0)
LUCTUS_CODE_CURRENT = "green"
LUCTUS_CODE_CURRENT_TV = ""

surface.CreateFont("luctus_scp_code_hud_font",{
    font = "Arial",
    extended = false,
    size = 30,
    weight = 500,
    antialias = true,
})

local font = "luctus_scp_code_hud_font"
local borderCol = Color(0, 195, 165)
local frameCol = Color(26,26,26)
local color_white = Color(255,255,255,255)

local function DrawBox(x, y, w, h, edgeSize)
    draw.RoundedBox(0, x, y, w, h, borderCol)
    draw.RoundedBox(0, x+1, y+1, w-2, h-2, frameCol)
end

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

hook.Add("InitPostEntity","luctus_code_shud_int",function()
    if LuctusDrawEdgeBox then
        print("[luctus_code] luctus_shud found, loading design")
        DrawBox = LuctusDrawEdgeBox
    end
end)


hook.Add("HUDPaint","luctus_scp_code",function()
    surface.SetFont("luctus_scp_code_hud_font")
    --local wx, wy = surface.GetTextSize("Code: "..LUCTUS_CODE_CURRENT)
    local wx = 160 --box size, now fixed size because of requests
    DrawBox(ScrW()-wx-20, 125, wx+20, 40)
    if LUCTUS_CODE_STYLE_SPLIT then
        draw.DrawText("Code:", font, ScrW()-wx-20+10, 130, color_white, TEXT_ALIGN_LEFT)
        draw.DrawText(LUCTUS_CODE_CURRENT, font, ScrW()-10, 130, LUCTUS_CODE_CURRENT_COLOR, TEXT_ALIGN_RIGHT)
    else
        draw.DrawText("Code: "..LUCTUS_CODE_CURRENT, font, ScrW()-wx-20+(wx/2)+10, 130, LUCTUS_CODE_CURRENT_COLOR, TEXT_ALIGN_CENTER)
    end
end)

hook.Add("InitPostEntity", "luctus_scp_code", function()
    net.Start("luctus_scp_code")
    net.SendToServer()
end)

net.Receive("luctus_scp_code", function()
    local curcode = net.ReadString()
    local changer = net.ReadString()
    if not LUCTUS_SCP_CODES[curcode] then return end
    LUCTUS_CODE_CURRENT_COLOR = LUCTUS_SCP_CODES[curcode][1]
    local oldCode = LUCTUS_CODE_CURRENT
    LUCTUS_CODE_CURRENT = curcode
    
    --chatmessage
    if LUCTUS_SCP_CODES[curcode][2] then
        if LUCTUS_SCP_CODE_SHOW_PLY and changer ~= "" then
            chat.AddText(color_white,changer.." changed the code to: ",LUCTUS_CODE_CURRENT_COLOR,"[",LUCTUS_CODE_CURRENT,"] ",LUCTUS_SCP_CODES[curcode][2])
        else
            chat.AddText(LUCTUS_CODE_CURRENT_COLOR, LUCTUS_SCP_CODES[curcode][2])
        end
    end
    --sound
    if LUCTUS_SCP_CODES[curcode][3] then
        surface.PlaySound(LUCTUS_SCP_CODES[curcode][3])
    end
    --TV subtext
    LUCTUS_CODE_CURRENT_TV = LUCTUS_SCP_CODES[curcode][4] or ""
    hook.Run("LuctusCodeChangedCL",oldCode,curcode)
end)

print("[luctus_code] cl loaded")
