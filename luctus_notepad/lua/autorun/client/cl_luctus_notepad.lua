--Luctus Notepad
--Made by OverlordAkise

LUCTUS_NOTEPAD_TEXT = LUCTUS_NOTEPAD_TEXT or ""

surface.CreateFont("luctus_np",{
    font = "Verdana",
    size = 13,
    weight = 500,
    antialias = false,
    shadow = true,
    outline = false,
})

hook.Add("PostDrawTranslucentRenderables","luctus_notepad_text",function()
    local lplypos = LocalPlayer():GetPos()
    for k,ply in pairs(player.GetAll()) do
        local wep = ply:GetActiveWeapon()
        if IsValid(wep) and wep:GetClass() == "weapon_luctus_np" and wep:GetIsShowing() and lplypos:Distance(ply:GetPos()) < 500 then
            local rHand = ply:LookupBone("ValveBiped.Bip01_R_Hand")
            if not rHand then return end
            local handPos, handAng = ply:GetBonePosition(rHand)
            handAng:RotateAroundAxis(handAng:Up(), -90)
            handAng:RotateAroundAxis(handAng:Forward(),270)
            handPos = handPos + (handAng:Up()*10) + handAng:Right()*-5
            cam.Start3D2D(handPos, handAng, 0.1)
                draw.DrawText(ply:GetNW2String("luctus_notepad",""), "luctus_np", 0, 0, color_white,TEXT_ALIGN_CENTER)
            cam.End3D2D()
        end
    end
end)

function LuctusNotepadSet(text)
    LUCTUS_NOTEPAD_TEXT = text
    net.Start("luctus_notepad")
        net.WriteString(text)
    net.SendToServer()
end

function LuctusNotepadOpen()
    if IsValid(frame) then return end
    
    if not file.Exists("luctus_notepad","DATA") then
        file.CreateDir("luctus_notepad")
    end
    
    local frame = vgui.Create("DFrame")
    frame:SetTitle("luctus | notepad")
    frame:SetSize(200,300)
    frame:ShowCloseButton(false)
    frame:Center()
    frame:MakePopup()
    function frame:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(32, 34, 37))
        draw.RoundedBox(0, 1, 1, w-2, h-2, Color(54, 57, 62))
    end
    
    local closeButton = vgui.Create("DButton",frame)
    closeButton:SetPos(200-32,2)
    closeButton:SetSize(30,20)
    closeButton:SetText("X")
    closeButton:SetTextColor(Color(255,0,0))
    function closeButton:DoClick()
        frame:Close()
    end
    function closeButton:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if self.Hovered then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end
    
    local topPanel = vgui.Create("DPanel",frame)
    topPanel:Dock(TOP)
    
    local textEntry = vgui.Create("DTextEntry",frame)
    textEntry:Dock(FILL)
    textEntry:SetMultiline(true)
    textEntry:SetDrawLanguageID(false)
    textEntry:SetPlaceholderText("This text will be displayed on your notepad")
    if LUCTUS_NOTEPAD_TEXT then
        textEntry:SetValue(LUCTUS_NOTEPAD_TEXT)
    end
    
    local fileSelect = vgui.Create("DComboBox",topPanel)
    fileSelect:Dock(LEFT)
    fileSelect:SetValue("Load")
    function fileSelect:OnSelect(index, value)
        local text = file.Read("luctus_notepad/"..value,"DATA")
        if not text then return end
        textEntry:SetText(text)
        LuctusNotepadSet(text)
    end
    local files, directories = file.Find("luctus_notepad/*", "DATA")
    for k,v in pairs(files) do
        fileSelect:AddChoice(v)
    end

    local saveBut = vgui.Create("DButton",frame)
    saveBut:Dock(BOTTOM)
    saveBut:SetText("Set Text")
    function saveBut:DoClick()
        local text = textEntry:GetValue()
        LuctusNotepadSet(text)
    end
    
    local fileSave = vgui.Create("DTextEntry",topPanel)
    fileSave:SetPlaceholderText("Save as...")
    fileSave:Dock(FILL)
    fileSave:SetDrawLanguageID(false)
    function fileSave:OnEnter()
        local fname = self:GetValue()
        local text = textEntry:GetValue()
        if not text then return end
        if not fname then return end
        file.Write("luctus_notepad/"..fname..".txt",text)
        notification.AddLegacy("[notepad] saved!",0,5)
        textEntry:SetText(text)
        LuctusNotepadSet(text)
    end
    
    return frame
end

print("[luctus_notepad] cl loaded")
