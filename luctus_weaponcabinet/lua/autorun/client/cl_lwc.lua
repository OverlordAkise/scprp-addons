--Luctus Weaponcabinet
--Made by OverlordAkise

local accent_col = Color(0, 195, 165)
local wcFrame = nil

surface.CreateFont("luctus_weaponcabinet", {
	font = "Arial",
	size = 24,
	weight = 5000,
	-- antialias = true,
} )

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

function luctusWCcreateFrameAndLeftPanel()
    local frame = vgui.Create("DFrame")
    frame:SetSize(700, 500)
    frame:Center()
    frame:SetTitle("Luctus' Weapon Cabinet")
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

net.Receive("luctus_weaponcabinet_buy",function()
    if IsValid(wcFrame) then return end
    local wcEnt = net.ReadEntity()
    
    local currentCategory = ""
    wcFrame = luctusWCcreateFrameAndLeftPanel()
    
    local categoryButtons = vgui.Create("DScrollPanel", wcFrame)
    categoryButtons:Dock(LEFT)
    categoryButtons:SetWide(150)
    categoryButtons:DockMargin(5,5,5,5)
    LuctusPrettifyScrollbar(categoryButtons:GetVBar())
    
    local iconScroller = vgui.Create("DScrollPanel", wcFrame)
    iconScroller:Dock(FILL)
    LuctusPrettifyScrollbar(iconScroller:GetVBar())
    
    for catName,tab in pairs(LUCTUS_WEAPONNPC_WEAPONS) do
        --tab.AllowedJobs, tab.Weapons
        if not table.HasValue(tab.AllowedJobs,team.GetName(LocalPlayer():Team())) then continue end
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
            luctusWCNAddWeapons(iconScroller, self.weps, self.catName, self.cabinEnt)
        end
    end
end)

function luctusWCNAddWeapons(scrollPanel,weaponList,catName,ent)
    for wep,price in pairs(weaponList) do
        local ewep = weapons.Get(wep)
        if not ewep then
            print("[luctus_weaponcabinet] ERROR: ",wepClass,"not found!")
            continue
        end
        local panel = scrollPanel:Add("DPanel")
        panel:SetHeight(64)
        panel:DockMargin(5,5,5,5)
        panel:Dock(TOP)
        panel.Paint = function()end
        
        local icon = vgui.Create("DModelPanel",panel)
        icon:SetSize(64,64)
        icon:Dock(LEFT)
        
        model, optOffset, optFov = LuctusWCGetWeaponWorldModel(wep,ewep)
        icon:SetModel(model)
        icon:SetLookAt(icon.Entity:GetPos()+(optOffset or Vector(0,-10,0)))
        icon:SetFOV(optFov or 10)
        function icon:LayoutEntity(Entity) return end --disables rotation
        
        local button = vgui.Create("DButton",panel)
        button:SetText("")
        button.wtext = (ewep and ewep.PrintName or wep)
        button.ptext = "$"..price
        button:Dock(RIGHT)
        button:SetSize(scrollPanel:GetWide()-96,64)
        button.ent = ent
        button.cat = catName
        button.wep = wep
        button.DoClick = function(self)
            net.Start("luctus_weaponcabinet_buy")
                net.WriteEntity(self.ent)
                net.WriteString(self.cat)
                net.WriteString(self.wep)
            net.SendToServer()
            if IsValid(wcFrame) then wcFrame:Close() end
        end
        function button:Paint(w,h)
            if self.Hovered then
                draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
                -- self:SetText(self.wepname)
            else
                DrawHighlightBorder(self,w,h)
                -- self:SetText("")
            end
            draw.SimpleText(self.wtext, "luctus_weaponcabinet", 10, 32, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            draw.SimpleText(self.ptext, "luctus_weaponcabinet", self:GetWide()-10, 32, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        end
    end
end

net.Receive("luctus_weaponcabinet",function()
    if IsValid(wcFrame) then return end
    local wcEnt = net.ReadEntity()
    
    if LocalPlayer():KeyDown(IN_WALK) and not table.IsEmpty(wcLastTime) then
        for _,ClassWeapons in pairs(wcLastTime) do
            net.Start("luctus_weaponcabinet")
                net.WriteEntity(wcEnt)
                net.WriteString(ClassWeapons[1])
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
    
    wcFrame = luctusWCcreateFrameAndLeftPanel()
    
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
        if not wep then
            print("[luctus_weaponcabinet] ERROR: ",wepClass,"not found!")
            continue
        end
        
        local icon = iconList:Add("DModelPanel")
        icon:SetSize(120, 120)
        model, optOffset, optFov = LuctusWCGetWeaponWorldModel(wepClass,wep)
        icon:SetModel(model)
        icon:SetLookAt(icon.Entity:GetPos()+(optOffset or Vector(10,0,0)))
        icon:SetFOV(optFov or 30)
        function icon:LayoutEntity(Entity) return end --disables rotation
        
        
        local bg = vgui.Create("DButton",icon)
        bg:SetSize(120, 120)
        bg:SetText("")
        bg.wep = wepClass
        bg.wepvalid = wep and true or false --disable buying if nil
        bg.catName = catName
        bg.cabinEnt = cabinEnt
        bg:SetTextColor(accent_col)
        bg.wepname = wep and wep.PrintName or "ERROR\n"..wepClass
        bg.Paint = function(self,w,h)
            if (self.Hovered) then
                if LocalPlayer():HasWeapon(self.wep) then
                    self:SetText("Return:\n"..self.wepname)
                    draw.RoundedBox(0, 0, 0, w, h, Color(166, 70, 77))
                else
                    self:SetText(self.wepname)
                    draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
                end
            else
                DrawHighlightBorder(self,w,h)
                self:SetText("")
            end
        end
        bg.DoClick = function(self)
            if not self.wepvalid then return end
            if not LocalPlayer():HasWeapon(self.wep) then
                table.insert(wcLastTime,{self.catName,self.wep})
                net.Start("luctus_weaponcabinet")
                    net.WriteEntity(self.cabinEnt)
                    net.WriteString(self.catName)
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

function LuctusWCGetWeaponWorldModel(wepClass,wep)
    if string.StartsWith(wepClass, "rw_sw_") and wep.WElements then
        for k,wepEl in pairs(wep.WElements) do
            if wepEl.type == "Model" and wepEl.model and wepEl.model != "" then
                return wepEl.model, Vector(-2,0,4), 12
            end
        end
    end
    
    if wep.WorldModel then
        return wep.WorldModel
    end
    
    return "models/error.mdl"
end

print("[luctus_weaponcabinet] cl loaded")
