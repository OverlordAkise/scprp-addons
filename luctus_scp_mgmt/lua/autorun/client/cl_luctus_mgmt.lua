--Luctus SCP Management
--Made by OverlordAkise

luctus_scpmgmt_frame = nil
luctus_scpmgmt_bgblur = nil

net.Receive("luctus_scp_mgmt",function()
    LuctusOpenSCPMGMT()
end)

luctus_scpmgmt_buttons = {
    {"HR Management",function() LuctusOpenSCPMGMTDegrade() end},
}

--Create Emergency Buttons
hook.Add("InitPostEntity","luctus_scp_mgmt_load",function()
    if LUCTUS_SCP_CODES then
        table.insert(luctus_scpmgmt_buttons,{"Change Code",function() LuctusOpenSCPMGMTCode() end})
    end
    if LUCTUS_RAZZIA_JOBS_SEND then
        table.insert(luctus_scpmgmt_buttons,{"Razzia Start",function() RunConsoleCommand("say","!razziastart") end})
        table.insert(luctus_scpmgmt_buttons,{"Razzia End",function() RunConsoleCommand("say","!razziaend") end})
    end
    for cat,jobs in pairs(LUCTUS_SCP_MGMT_EMERGENCY_JOBS) do
        table.insert(luctus_scpmgmt_buttons,{"Start "..cat.."-Emergency",function()
            net.Start("luctus_scp_mgmt")
                net.WriteString("emergencyon "..cat)
            net.SendToServer()
        end})
        table.insert(luctus_scpmgmt_buttons,{"Stop "..cat.."-Emergency",function()
            net.Start("luctus_scp_mgmt")
                net.WriteString("emergencyoff "..cat)
            net.SendToServer()
        end})
    end
    for name,func in pairs(LUCTUS_SCP_MGMT_EXTRABUTTONS) do
        table.insert(luctus_scpmgmt_buttons,{name,func})
    end
end)

local function AskPlayerInput(text,func)
    local window = vgui.Create("DFrame")
    window:SetTitle("Luctus | Enter Text")
    window:SetSize(350, 150)
    window:Center()
    window:MakePopup()
    window:ShowCloseButton(false)
    function window.Paint(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(32, 34, 37))
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62))
    end
            
    local title = vgui.Create("DLabel", window)
    title:SetText(text)
    title:SetFont("Trebuchet18")
    title:SetPos( 25, 40 )
    title:SetSize( 300, 20)
    title:SetTextColor(color_white)
    
    local reasonText = vgui.Create("DTextEntry", window)
    reasonText:SetPos( 40, 80 )
    reasonText:SetSize( 270, 20)
    reasonText:SetText("input here")
    reasonText.OnEnter = function(self)
		func(self:GetValue())
        window:Close()
	end
        
    local btn_yes = vgui.Create("DButton", window)
    btn_yes:SetText("OK")
    btn_yes:SetFont("DermaDefault")
    btn_yes:SetTextColor(color_white)
    btn_yes:SetWide(100,50)
    btn_yes:SetPos(50,120)
    function btn_yes.Paint(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if (s.Hovered) then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end
    btn_yes.DoClick = function()
        func(reasonText:GetValue())
        window:Close()
    end

    local btn_no = vgui.Create("DButton", window)
    btn_no:SetText("Cancel")
    btn_no:SetFont("DermaDefault")
    btn_no:SetTextColor(color_white)
    btn_no:SetWide(100,50)
    btn_no:SetPos(200,120)
    function btn_no.Paint(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if (s.Hovered) then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end
    
    btn_no.DoClick = function()
        window:Close()
    end
end

local function closeFrame(el)
    gui.EnableScreenClicker( false )
    el:SetMouseInputEnabled( false )
    el:SetKeyboardInputEnabled( false )
    el:MoveTo(-1*ScrW(), el:GetY(),0.5,0)
    timer.Simple(0.5,function()
        el:Close()
    end)
end

local function createCloseButton(el)
    local CloseButton = vgui.Create("DButton", el)
    CloseButton:SetText("X")
    CloseButton:SetPos(el:GetWide()-22,2)
    CloseButton:SetSize(20,20)
    CloseButton:SetTextColor(Color(0,195,165))
    CloseButton.DoClick = function()
        closeFrame(el)
    end
    CloseButton.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if (self.Hovered) then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end
end

local function beautifyButton(el)
    el.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(247, 249, 254))
        if (self.Hovered) then
            draw.RoundedBox(0, 0, 0, w, h, Color(0,195,165))
            draw.RoundedBox(0, 1, 1, w-2, h-2, Color(66, 70, 77))
        end
    end
end

function LuctusOpenSCPMGMTCode()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Luctus' Code")
    frame:SetSize( 300, 300 )
    frame:SetPos(ScrW()/2-150, ScrH()/2-250)
    frame:MakePopup()
    frame:ShowCloseButton(false)
    function frame:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0,195,165))--32,34,37
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62))
    end
    createCloseButton(frame)
    local lliste = vgui.Create("DListLayout", frame)
    lliste:Dock(FILL)
    for k,v in pairs(LUCTUS_SCP_CODES) do
        local item = lliste:Add("DButton")
        item:Dock(TOP)
        item:DockMargin(10,10,10,0)
        item:SetText(k)
        item.k = k
        item.col = v[1]
        function item:DoClick()
            RunConsoleCommand("say","!code "..self.k)
            frame:Close()
        end
        item.Paint = function(self,w,h)
            draw.RoundedBox(0, 0, 0, w, h, self.col)
            draw.RoundedBox(0, 1, 1, w-2, h-2, Color(217, 219, 214))
            if (self.Hovered) then
                --draw.RoundedBox(0, 0, 0, w, h, Color(0,195,165))
                draw.RoundedBox(0, 1, 1, w-2, h-2, Color(66, 70, 77))
            end
        end
    end
    --frame:SizeTo(300, 500, 0.2, 0)
end

function LuctusOpenSCPMGMTDegrade()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Luctus' Degrader")
    frame:SetSize( 300, 500 )
    frame:SetPos(ScrW()/2-150, ScrH()/2-250)
    frame:MakePopup()
    frame:ShowCloseButton(false)
    function frame:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0,195,165))--32,34,37
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62))
    end
    createCloseButton(frame)
    --local DScrollPanel = vgui.Create( "DScrollPanel", frame )
    --DScrollPanel:Dock(FILL)
    --DScrollPanel:SetHeight(400)
    local plist = vgui.Create("DListView", frame)
	plist:Dock(FILL)
	plist:AddColumn("Name")
	plist:AddColumn("Beruf")
	plist:AddColumn("SteamID")
	for k, v in pairs(player.GetAll()) do
		--if not ManagementSystem.MenuJobs[v:Team()] and not ManagementSystem.DisallowDemoteJobs[v:Team()] then
            plist:AddLine(v:Nick(), team.GetName(v:Team()), v:SteamID())
        --end
	end
    function plist:OnRowRightClick(lineID, line)
        local Menu = DermaMenu()
        local demote = Menu:AddOption("Demote")
        demote:SetIcon("icon16/delete.png")
        local stopdemote = Menu:AddOption("Stop Demote")
        stopdemote:SetIcon("icon16/add.png")
        
        function Menu:OptionSelected(selPanel, panelText)
            if panelText == "Demote" then
                local plyID = line:GetColumnText(3)
                AskPlayerInput("Please enter a reason to demote '"..line:GetColumnText(1).."'",function(text)
                    net.Start("luctus_scp_mgmt")
                        net.WriteString("demote")
                        net.WriteString(plyID)
                        net.WriteString(text)
                    net.SendToServer()
                end)
                return 
            end
            if panelText == "Stop Demote" then
                local plyID = line:GetColumnText(3)
                AskPlayerInput("Please enter a reason to stop demote for '"..line:GetColumnText(1).."'",function(text)
                    net.Start("luctus_scp_mgmt")
                        net.WriteString("stopdemote")
                        net.WriteString(plyID)
                        net.WriteString(text)
                    net.SendToServer()
                end)
                return 
            end
        end
      Menu:Open()
    end
end

function LuctusOpenSCPMGMT()
    if IsValid(luctus_scpmgmt_frame) then return end
    luctus_scpmgmt_frame = vgui.Create("DFrame")
    luctus_scpmgmt_frame:SetTitle("Luctus' SCP Management")
    luctus_scpmgmt_frame:SetSize(340, 300)
    if #luctus_scpmgmt_buttons > 8 then
        luctus_scpmgmt_frame:SetSize(360, 300)
    end
    luctus_scpmgmt_frame:Center()
    luctus_scpmgmt_frame:SetX(ScrW()+300)
    luctus_scpmgmt_frame:MakePopup()
    luctus_scpmgmt_frame:ShowCloseButton(false)
    luctus_scpmgmt_frame:MoveTo(ScrW()/2-luctus_scpmgmt_frame:GetWide()/2, luctus_scpmgmt_frame:GetY(),0.5,0)
    function luctus_scpmgmt_frame:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0,195,165))--32,34,37
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62))
    end
    function luctus_scpmgmt_frame:OnKeyCodePressed(button) 
        if not self.closing and button == LUCTUS_SCP_MGMT_BINDKEY then
            self.closing = true
            closeFrame(self)
        end
	end
    createCloseButton(luctus_scpmgmt_frame)
    local Scroll = vgui.Create("DScrollPanel", luctus_scpmgmt_frame)
    Scroll:Dock(FILL)
    local plist = vgui.Create("DIconLayout", Scroll)
    plist:Dock(FILL)
    plist:SetSpaceY(10)
    plist:SetSpaceX(10)
    plist:DockMargin(10,10,0,0)
    for k,v in pairs(luctus_scpmgmt_buttons) do
        local item = plist:Add("DButton")
        item:SetSize(150,50)
        item:SetText(v[1])
        item.v = v[2]
        function item:DoClick()
            self.v()
        end
        beautifyButton(item)
    end
end

function LuctusOpenSCPMGMTWebsite(url)
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Site ## | Intranet")
    frame:SetSize( 700, 500 )
    frame:SetPos(ScrW()/2-150, ScrH()/2-250)
    frame:MakePopup()
    frame:ShowCloseButton(false)
    function frame:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0,195,165))--32,34,37
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62))
    end
    createCloseButton(frame)
    local MainPanel = vgui.Create("DHTML",frame)
    MainPanel:Dock(FILL)
    MainPanel:OpenURL(url)
end

hook.Add("PlayerButtonDown","luctus_scp_mgmt_open",function(ply,button)
    if ply != LocalPlayer() then return end
    if not LUCTUS_SCP_MGMT_ALLOWED_JOBS[team.GetName(LocalPlayer():Team())] then return end
    if button == LUCTUS_SCP_MGMT_BINDKEY then
        RunConsoleCommand("say",LUCTUS_SCP_MGMT_COMMAND)
    end
end)

print("[luctus_scp_mgmt] cl loaded")
