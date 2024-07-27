--Luctus Weaponarmory
--Made by OverlordAkise

local wcFrame = nil

surface.CreateFont("luctus_weaponarmory", {
	font = "Arial",
	size = 24,
	weight = 5000,
} )

local function LuctusPrettifyScrollbar(el)
  function el:Paint() return end
	function el.btnGrip:Paint(w, h)
        draw.RoundedBox(0,0,0,w,h,LUCTUS_WEAPONARMORY_ACCENT_COLOR)
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(32, 34, 37))

	end
	function el.btnUp:Paint(w, h)
		draw.RoundedBox(0,0,0,w,h,LUCTUS_WEAPONARMORY_ACCENT_COLOR)
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(32, 34, 37))
	end
	function el.btnDown:Paint(w, h)
		draw.RoundedBox(0,0,0,w,h,LUCTUS_WEAPONARMORY_ACCENT_COLOR)
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(32, 34, 37))
	end
end

function DrawHighlightBorder(el,w,h)
    surface.SetDrawColor(LUCTUS_WEAPONARMORY_ACCENT_COLOR)
    surface.DrawLine(0,0,w,0)
    surface.DrawLine(w-1,0,w-1,h-1)
    surface.DrawLine(w-1,h-1,0,h-1)
    surface.DrawLine(0,h-1,0,0)
end

local function createFrame()
    local frame = vgui.Create("DFrame")
    frame:SetSize(700, 500)
    frame:Center()
    frame:SetTitle("Armory")
    frame:SetDraggable(true)
    frame:ShowCloseButton(false)
    frame:MakePopup()
    function frame:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(32, 34, 37))
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62))
    end

    local parent_x, parent_y = frame:GetSize()
    local CloseButton = vgui.Create( "DButton", frame )
    CloseButton:SetPos( parent_x-30, 0 )
    CloseButton:SetSize( 30, 30 )
    CloseButton:SetText("X")
    CloseButton:SetTextColor(Color(255,0,0))
    CloseButton.DoClick = function()
        frame:Close()
    end
    CloseButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if (self.Hovered) then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end
    
    return frame
end

local function addToWeaponsList(scrollPanel,weaponList,unlockedList,catName,ent)
    for wep,price in pairs(weaponList) do
        local ewep = weapons.Get(wep)
        local panel = scrollPanel:Add("DPanel")
        panel:SetHeight(64)
        panel:DockMargin(5,5,5,5)
        panel:Dock(TOP)
        local isUnlocked = unlockedList and unlockedList[wep]
        function panel:Paint(w,h)
            if self.chover then
                draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
            else
                DrawHighlightBorder(self,w,h)
            end
            if not isUnlocked then
                draw.RoundedBox(0,0,0,w,h,Color(155,20,20,220))
            end
        end
        
        local icon = vgui.Create("DModelPanel",panel)
        icon:SetModel(ewep and ewep.WorldModel or "models/error.mdl")
        icon:Dock(LEFT)
        icon:SetSize(64,64)
        icon:SetLookAt(icon.Entity:GetPos()+Vector(0,-10,0))
        icon:SetFOV(10)
        function icon:LayoutEntity(Entity) return end --disables rotation
        
        local button = vgui.Create("DButton",panel)
        button:SetText("")
        button.wtext = (ewep and ewep.PrintName or wep)
        button.ptext = (LocalPlayer():HasWeapon(wep) and "return") or (unlockedList and unlockedList[wep] and "free") or "unlock for $"..price
        button:Dock(RIGHT)
        button:SetSize(scrollPanel:GetWide()-96,64)
        button.ent = ent
        button.cat = catName
        button.wep = wep
        button.DoClick = function(self)
            if LocalPlayer():HasWeapon(wep) then
                net.Start("luctus_weaponarmory_r")
                    net.WriteEntity(self.ent)
                    net.WriteString(self.cat)
                    net.WriteString(self.wep)
                net.SendToServer()
                self.ptext = "free"
                return
            end
            net.Start("luctus_weaponarmory")
                net.WriteEntity(self.ent)
                net.WriteString(self.cat)
                net.WriteString(self.wep)
            net.SendToServer()
            if unlockedList and unlockedList[wep] then
                self.ptext = "return"
            end
            if LocalPlayer():canAfford(price) and (not unlockedList or not unlockedList[wep]) then
                self.ptext = "free"
                isUnlocked = true
                unlockedList[wep] = true
            end
            
            -- if IsValid(wcFrame) then wcFrame:Close() end
        end
        function button:Paint(w,h)
            panel.chover = self.Hovered
            draw.SimpleText(self.wtext, "luctus_weaponarmory", 10, 32, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            draw.SimpleText(self.ptext, "luctus_weaponarmory", self:GetWide()-10, 32, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        end
    end
end

net.Receive("luctus_weaponarmory",function()
    if IsValid(wcFrame) then return end
    local wcEnt = net.ReadEntity()
    local a = net.ReadUInt(17)
    local d = net.ReadData(a)
    local unlocks = util.JSONToTable(util.Decompress(d))
    
    
    local currentCategory = ""
    wcFrame = createFrame()
    
    local categoryButtons = vgui.Create("DScrollPanel", wcFrame)
    categoryButtons:Dock(LEFT)
    categoryButtons:SetWide(150)
    categoryButtons:DockMargin(5,5,5,5)
    LuctusPrettifyScrollbar(categoryButtons:GetVBar())
    
    local iconScroller = vgui.Create("DScrollPanel", wcFrame)
    iconScroller:Dock(FILL)
    LuctusPrettifyScrollbar(iconScroller:GetVBar())
    
    for catName,tab in pairs(LUCTUS_WEAPONARMORY) do
        --tab.AllowedJobs, tab.Weapons
        if not tab.AllowedJobs[LocalPlayer():getDarkRPVar("job")] then continue end
        local catBut = vgui.Create("DButton",categoryButtons)
        catBut.catName = catName
        catBut.cabinEnt = wcEnt
        catBut.weps = tab.Weapons
        catBut:Dock(TOP)
        catBut:SetHeight(30)
        catBut:SetCursor("hand")
        catBut:SetText("")
        catBut.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(44, 47, 52))
            if (self.Hovered) then
                draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
            end
            if currentCategory == self.catName then
                DrawHighlightBorder(self,w,h)
            end
            draw.DrawText(catName, "Trebuchet18", 10, 7, Color(255,255,255))
        end
        catBut.DoClick = function(self)
            currentCategory = self.catName
            iconScroller:Clear()
            addToWeaponsList(iconScroller, self.weps, unlocks[catName], self.catName, self.cabinEnt)
        end
    end
end)

print("[luctus_weaponarmory] cl loaded")
