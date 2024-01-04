--Luctus Scrapsystem
--Made by OverlordAkise

local white = Color(255,255,255,255)
local accent_col = Color(0, 195, 165)
local accent_col_dark = Color(0, 125, 95)
local lightDark = Color(40,40,40)
local dark = Color(10,10,10)
local buttonTextColor = Color(200,200,200)

local ScrapFrame = nil

local function LGetName(ent)
    if not ent or ent == "" then return "<ERR>" end
    local swep = weapons.Get(ent)
    if swep and swep.PrintName then return swep.PrintName end
    local sent = scripted_ents.Get(ent)
    if sent and sent.PrintName then return sent.PrintName end
    return ent
end

local function CreateCloseButton(parent)
    local parent_x, parent_y = parent:GetSize()
    local CloseButton = vgui.Create( "DButton", parent )
    CloseButton:SetPos( parent_x-31, 1 )
    CloseButton:SetSize( 30, 24 )
    CloseButton:SetText("X")
    CloseButton:SetTextColor(Color(255,0,0))
    CloseButton.DoClick = function()
        parent:Close()
    end
    CloseButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, lightDark)
        if self.Hovered then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end
end

net.Receive("luctus_scrapsys_craft",function()
    if IsValid(ScrapFrame) then return end
    local npc = net.ReadEntity()
    
    ScrapFrame = vgui.Create("DFrame")
    ScrapFrame:SetSize(700, 400)
    ScrapFrame:Center()
    ScrapFrame:SetTitle("scrap | craft")
    ScrapFrame:SetDraggable(true)
    ScrapFrame:ShowCloseButton(false)
    ScrapFrame:MakePopup()
    ScrapFrame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, accent_col)
        draw.RoundedBox(0, 1, 1, w-2, h-2, dark)
    end
    CreateCloseButton(ScrapFrame)

    local scrollPanel = vgui.Create("DScrollPanel", ScrapFrame)
    scrollPanel:Dock(FILL)
    scrollPanel:DockMargin(0,10,0,0)
    local iconList = vgui.Create("DIconLayout",scrollPanel)
    iconList:Dock(FILL)
    iconList:SetSpaceY(5)
    iconList:SetSpaceX(5)

    for name,scrapNeeded in pairs(LUCTUS_SCRAPSYS_CRAFTABLES) do
        local but = iconList:Add("DButton")
        but:SetSize(220,90)
        but:SetText("")
        but.entname = name
        but.beautyname = LGetName(name)
        but.scrapNeeded = scrapNeeded
        function but:Paint(w,h)
            if self.Hovered then
                self:SetColor(accent_col)
                draw.RoundedBox(0,0,0,w,h,accent_col)
            else
                self:SetColor(buttonTextColor)
            end
            draw.RoundedBox(0,1,1,w-2,h-2,lightDark)
            draw.DrawText(self.beautyname,"Trebuchet24",w/2,h/4,white,TEXT_ALIGN_CENTER)
            draw.DrawText(self.scrapNeeded.." scrap needed","Trebuchet18",w/2,h/1.5,white,TEXT_ALIGN_CENTER)
        end
        function but:DoClick()
            net.Start("luctus_scrapsys_craft")
                net.WriteString(self.entname)
                net.WriteEntity(npc)
            net.SendToServer()
            ScrapFrame:Close()
        end
    end
end)

print("[luctus_scrapsys] cl loaded")
