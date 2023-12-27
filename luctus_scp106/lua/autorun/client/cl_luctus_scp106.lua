--Luctus SCP106
--Made by OverlordAkise

net.Receive("luctus_scp106_tp",function()
    local wep = LocalPlayer():GetActiveWeapon()
    if not IsValid(wep) then return end
    wep.LastTP = net.ReadVector()
end)

net.Receive("luctus_scp106_tpscreen",function()
    local tickcounter = 0
    local goingDown = true
    hook.Add("Tick","luctus_scp106_tp",function()
        if not LocalPlayer():Alive() then
            hook.Remove("Tick","luctus_scp106_tp")
            return
        end
        if goingDown then
            if tickcounter >= 63 then
                goingDown = false
                return
            end
            tickcounter = tickcounter + LUCTUS_SCP106_TP_SPEED
        else
            tickcounter = tickcounter - LUCTUS_SCP106_TP_SPEED
            if tickcounter <= 0 then
                hook.Remove("Tick","luctus_scp106_tp")
            end
        end
    end)
    hook.Add("HUDPaint","luctus_scp106_tp_blackscreen",function()
        if not LocalPlayer():Alive() then
            hook.Remove("HUDPaint","luctus_scp106_tp_blackscreen")
            return
        end
        draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(0,0,0,4.3*tickcounter))
    end)
end)


local color_accent = Color(0, 195, 165)
local color_button = Color(46,46,46)
local color_button_hover = Color(88, 93, 98)
local color_background = Color(32, 34, 37, 240)

function LuctusSCP106BeautifyButton(button)
    button:SetColor(color_white)
    button.bcolor = color_button
    button.accentWidth = 2
    button.accentTarget = 2
    button.accentSwitch = 0
    function button:Paint(w, h)
        self.accentWidth = Lerp(SysTime()-self.accentSwitch,self.accentWidth,self.accentTarget)
        draw.RoundedBox(0, 0, 0, w, h, color_accent)
        draw.RoundedBox(0, self.accentWidth, 0, w, h, self.bcolor)
    end
    function button:OnCursorEntered()
        self.bcolor = color_button_hover
        surface.PlaySound("UI/buttonrollover.wav")
        self.accentSwitch = SysTime()
        self.accentTarget = 10
    end
    function button:OnCursorExited()
        self.bcolor = color_button
        self.accentSwitch = SysTime()
        self.accentTarget = 2
    end
end

print("[SCP106] cl loaded")
