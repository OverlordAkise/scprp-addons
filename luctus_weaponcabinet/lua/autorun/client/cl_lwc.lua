--Luctus Weaponcabinet
--Made by OverlordAkise

local accent_col = Color(0, 195, 165)
local wcFrame = nil

local wcLastTime = {}

local ncd = 0
local function NotifyIfNoCooldown()
    if ncd > CurTime() then return end
    ncd = CurTime() + 5
    notification.AddLegacy("You are not allowed to pickup a weapon!", 1, 5)
    surface.PlaySound("buttons/button15.wav")
end


local function LuctusPrettifyScrollbar(el)
  function el:Paint() return end
	function el.btnGrip:Paint(w, h)
        draw.RoundedBox(0,0,0,w,h,accent_col)
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(32, 34, 37))

	end
	function el.btnUp:Paint(w, h)
		draw.RoundedBox(0,0,0,w,h,accent_col)
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(32, 34, 37))
	end
	function el.btnDown:Paint(w, h)
		draw.RoundedBox(0,0,0,w,h,accent_col)
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(32, 34, 37))
	end
end

net.Receive("luctus_weaponcabinet",function()
    if IsValid(wcFrame) then return end
    local wcEnt = net.ReadEntity()
    
    if LocalPlayer():KeyDown(IN_WALK) and not table.IsEmpty(wcLastTime) then
        for _,ClassWeapons in pairs(wcLastTime) do
            net.Start("luctus_weaponcabinet")
                net.WriteString(ClassWeapons[1])
                net.WriteEntity(wcEnt)
                net.WriteString(ClassWeapons[2])
            net.SendToServer()
        end
        return
    end
    
    wcLastTime = {}
    currentCat = ""
    
    local availableCategories = {}
    local job = LocalPlayer():getDarkRPVar("job")
    for cat,tab in pairs(LUCTUS_WEAPONCABINET_S) do
        if tab["jobs"][job] then
            table.insert(availableCategories,cat)
        end
    end
    if table.IsEmpty(availableCategories) then
        NotifyIfNoCooldown()
        return
    end
    wcFrame = vgui.Create("DFrame")
    wcFrame:SetSize(700, 500)
    wcFrame:Center()
    wcFrame:SetTitle("Luctus' Weapon Cabinet")
    wcFrame:SetDraggable(true)
    wcFrame:ShowCloseButton(false)
    wcFrame:MakePopup()
    function wcFrame:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(32, 34, 37))
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62))
    end

    local parent_x, parent_y = wcFrame:GetSize()
    local CloseButton = vgui.Create( "DButton", wcFrame )
    CloseButton:SetPos( parent_x-30, 0 )
    CloseButton:SetSize( 30, 30 )
    CloseButton:SetText("X")
    CloseButton:SetTextColor(Color(255,0,0))
    CloseButton.DoClick = function()
        wcFrame:Close()
    end
    CloseButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if (self.Hovered) then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end
    
    local categoryButtons = vgui.Create("DScrollPanel", wcFrame)
    categoryButtons:Dock(LEFT)
    categoryButtons:SetWide(150)
    categoryButtons:DockMargin(5,5,5,5)
    LuctusPrettifyScrollbar(categoryButtons:GetVBar())
    
    local iconScroller = vgui.Create("DScrollPanel", wcFrame)
    iconScroller:Dock(FILL)
    LuctusPrettifyScrollbar(iconScroller:GetVBar())
    
    local iconList = vgui.Create("DIconLayout", iconScroller)
    iconList:Dock(FILL)
    iconList:SetSpaceY(5)
    iconList:SetSpaceX(5)
    
    LuctusWCAddWeaponIcons(iconList, LUCTUS_WEAPONCABINET_S[availableCategories[1]]["weps"],availableCategories[1],wcEnt)
    --^ This needs to stay or the DIconLayout doesn't work
    --aka. without initially having icons it wont work
    currentCat = availableCategories[1]
    
    for _,catName in pairs(availableCategories) do
        local weps = LUCTUS_WEAPONCABINET_S[catName]["weps"]
        local catBut = vgui.Create("DButton",categoryButtons)
        catBut.weps = weps
        catBut.catName = catName
        catBut.cabinEnt = wcEnt
        catBut:Dock(TOP)
        catBut:SetSize(CategoryWidth, 30)
        catBut:SetCursor("hand")
        catBut:SetText("")
        catBut.Paint = function(self, w, h)
            --if k % 2 == 0 then
            draw.RoundedBox(0, 0, 0, w, h, Color(44, 47, 52))
            if (self.Hovered) then
                draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
            end
            if currentCat == self.catName then
                DrawHighlightBorder(self,w,h)
            end
            draw.DrawText(catName, "Trebuchet18", 10, 7, Color(255,255,255))
        end
        catBut.DoClick = function(self)
            currentCat = self.catName
            iconList:Clear()
            LuctusWCAddWeaponIcons(iconList, self.weps, self.catName, self.cabinEnt)
        end
    end--]]
end)

function DrawHighlightBorder(el,w,h)
    surface.SetDrawColor(accent_col)
    surface.DrawLine(0,0,w,0)
    surface.DrawLine(w-1,0,w-1,h-1)
    surface.DrawLine(w-1,h-1,0,h-1)
    surface.DrawLine(0,h-1,0,0)
end

function LuctusWCAddWeaponIcons(iconList, weplist, catName, cabinEnt)
    for wepClass,_ in pairs(weplist) do
        local wep = weapons.Get(wepClass)
        if not wep then return end
        
        local icon = iconList:Add("DModelPanel")
        icon:SetModel(wep.WorldModel)
        icon:SetSize(120, 120)
        icon:SetLookAt(icon.Entity:GetPos()+Vector(10,0,0))
        icon:SetFOV(30)
        function icon:LayoutEntity(Entity) return end --disables rotation
        
        
        local bg = vgui.Create("DButton",icon)
        bg:SetSize(120, 120)
        bg:SetText("")
        bg.wep = wepClass
        bg.catName = catName
        bg.cabinEnt = cabinEnt
        bg:SetTextColor(accent_col)
        bg.wepname = wep.PrintName
        bg.Paint = function(self,w,h)
            if (self.Hovered) then
                self:SetText(self.wepname)
                draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
            else
                DrawHighlightBorder(self,w,h)
                self:SetText("")
            end
        end
        bg.DoClick = function(self)
            if not LocalPlayer():HasWeapon(self.wep) then
                table.insert(wcLastTime,{self.catName,self.wep})
                net.Start("luctus_weaponcabinet")
                    net.WriteString(self.catName)
                    net.WriteEntity(self.cabinEnt)
                    net.WriteString(self.wep)
                net.SendToServer()
            else
                net.Start("luctus_weaponcabinet_r")
                    net.WriteEntity(self.cabinEnt)
                    net.WriteString(self.wep)
                net.SendToServer()
            end
        end
    end
end

print("[luctus_weaponcabinet] cl loaded")
