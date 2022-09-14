--Luctus Backpack
--Made by OverlordAkise

LBACKMENU = nil

local blur = Material("pp/blurscreen")
local function BlurFunc(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)

    for i = 1, 6 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

function LuctusOpenJobBackpackMenu()
    local availWeapons = LUCTUS_BACKPACK[LocalPlayer():Team()]
    if not availWeapons or table.IsEmpty(LUCTUS_BACKPACK) then return end
    
    LBACKMENU = vgui.Create("DFrame")
    LBACKMENU:SetSize(500, 300)
    LBACKMENU:Center()
    LBACKMENU:SetTitle("Job Rucksack")
    LBACKMENU:SetDraggable(true)
    LBACKMENU:ShowCloseButton(false)
    LBACKMENU:MakePopup()
    --LBACKMENU.startTime = SysTime()
    function LBACKMENU:Paint(w,h)
        BlurFunc(self,5)
        --Derma_DrawBackgroundBlur(self, self.startTime)
        --draw.RoundedBox(0, 0, 0, w, h, Color(32, 34, 37,230))
        --draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62,230))
    end
    

    local parent_x, parent_y = LBACKMENU:GetSize()
    local CloseButton = vgui.Create( "DButton", LBACKMENU )
    CloseButton:SetPos( parent_x-30, 0 )
    CloseButton:SetSize( 30, 30 )
    CloseButton:SetText("X")
    CloseButton:SetTextColor(Color(255,0,0))
    CloseButton.DoClick = function()
        LBACKMENU:Close()
    end
    CloseButton.Paint = function(self, w, h)
        --draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if (self.Hovered) then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77,100))
        end
        --BlurFunc(self,5)
    end
    local weaponList = vgui.Create("DPanelList", LBACKMENU)
    weaponList:Dock(LEFT)
    weaponList:SetWide(100)
    weaponList:EnableVerticalScrollbar(true)
    
    local bottomList = vgui.Create("DPanel",LBACKMENU)
    bottomList:Dock(BOTTOM)
    bottomList:SetHeight(20)
    bottomList:SetPaintBackground(false)
    
    local buyButton = vgui.Create("DButton",bottomList)
    buyButton:Dock(LEFT)
    buyButton:SetWide(400-15)
    buyButton:SetCursor("hand")
    buyButton:SetText("KAUFEN")
    buyButton:SetTextColor(Color(200, 200, 200))
    buyButton.id = nil
    function buyButton:DoClick()
        if not self.id then return end
        net.Start("luctus_jobbackpack_buy")
            net.WriteInt(self.id,32)
        net.SendToServer()
    end
    function buyButton:Paint(w,h)
        --draw.RoundedBox(0, 0, 0, w, h, Color(32, 34, 37,100))
        if (self.Hovered) then
            draw.RoundedBox(0, 0, 0, w, h, Color(195, 0, 0,100))
        end
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62,200))
    end
    
    local icon = vgui.Create("DModelPanel", LBACKMENU)
    icon:Dock(FILL)
    icon:SetModel("")
    icon:SetCursor("pointer")
    function icon:LayoutEntity( Entity ) return end --disables rotation
    
    for k,v in pairs(availWeapons) do
        local item = vgui.Create("DButton",weaponList)
        item:Dock(TOP)
        item:SetSize(CategoryWidth, 30)
        item:SetCursor("hand")
        item:SetText("")
        local wep = weapons.Get(v[1])
        if not wep then --get ent instead
            wep = scripted_ents.Get(v[1])
        end
        if not wep then
            print("[luctus_jobbackpack] ERROR:",v[1],"IS NOT A SCRIPTED_ENT OR WEAPON!")
            continue
        end
        item.wep = wep
        item.id = k
        item.Paint = function(self, w, h)
            if buyButton.id == self.id then
                surface.SetDrawColor(Color(64, 67, 72,100))
            else
                surface.SetDrawColor(Color(44, 47, 52,200))
            end
            surface.DrawRect(0, 0, w, h)
            draw.DrawText(wep and wep.PrintName or v, "Trebuchet18", 10, 7, Color(255,255,255))
        end
        item.DoClick = function(self)
            buyButton.id = self.id
            icon:SetModel((self.wep and self.wep.WorldModel) or (self.wep and self.wep.model) or "")
            
            --fix camera issues
            local class = self.wep and self.wep.ClassName or nil
            if not class then return end
            if string.StartWith(class,"m9k_") then
                icon:SetLookAt(icon.Entity:GetPos()+Vector(10,0,0))
                icon:SetFOV(40)
            end
            --FOV: 70
            --CamPos: 50,50,50
            --LookAng: nil
        end
    end
end

print("[luctus_jobbackpack] cl loaded!")
