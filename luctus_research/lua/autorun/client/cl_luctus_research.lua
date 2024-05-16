--Luctus Research
--Made by OverlordAkise

lresearch = nil
lresearch_list = nil
lresearch_page = 0
lresearch_searchid = 0
lresearch_searchtext = ""


luctus_research_windows = luctus_research_windows or {}

net.Receive("luctus_research_getall",function()
    local lenge = net.ReadInt(17)
    local data = net.ReadData(lenge)
    local jtext = util.Decompress(data)
    local tab = util.JSONToTable(jtext)
    if tab == nil then return end
    if not IsValid(lresearch) then luctusOpenMainResearchWindow() end
    if not IsValid(lresearch_list) then return end
    lresearch_list:Clear()
    for k,v in ipairs(tab) do
        lresearch_list:AddLine(v.rowid, v.date, v.researcher, v.summary)
    end
end)

net.Receive("luctus_research_getid",function(len,ply)
    local lenge = net.ReadInt(17)
    local data = net.ReadData(lenge)
    local jtext = util.Decompress(data)
    local tab = util.JSONToTable(jtext)
    if tab == nil then return end
    luctusOpenPaperWindow(tab)
end)

function luctusOpenMainResearchWindow()
    --if lresearch then return end
    lresearch = vgui.Create("DFrame")
    lresearch:SetTitle(LUCTUS_RESEARCH_TITLE.." | v1.3")
    lresearch:SetSize(800,600)
    lresearch:Center()
    lresearch:MakePopup()
    function lresearch:OnClose()
        lresearch_list = nil
        lresearch_page = 0
        lresearch_searchid = 0
        lresearch_searchtext = ""
        luctus_research_windows[self] = nil
    end
    function lresearch:OnKeyCodePressed(button)
        if not self.closing and button == LUCTUS_RESEARCH_OPEN_BIND then
            self.closing = true
            timer.Simple(0.05,function() lresearch:Close() end)
        end
	end
    luctus_research_windows[lresearch] = true

    local MenuBar = vgui.Create( "DMenuBar", lresearch )
    MenuBar:DockMargin( 0, 0, 0, 0 )

    local M1 = MenuBar:AddMenu( "Paper" )
    M1:AddOption("New", function()
        luctusOpenPaperWindow(nil,true)
        lresearch:Close()
    end):SetIcon("icon16/page_add.png")
  
    M1:AddOption("Open by ID", function()
        Derma_StringRequest(
        LUCTUS_RESEARCH_TITLE.." | Request by ID", 
        "Please enter the paper ID, numbers only!",
        "1",
        function(text)
            if not tonumber(text) then return end
            net.Start("luctus_research_getid")
                net.WriteInt(tonumber(text),32)
                net.WriteBool(false)
            net.SendToServer()
        end,
        function(text) end
        )
    end):SetIcon("icon16/folder.png")
  
    M1:AddOption("Edit by ID", function()
        if not LocalPlayer():IsAdmin() then
            Derma_Message("Only Admins can edit papers!", LUCTUS_RESEARCH_TITLE.." | error", "OK")
            return
        end
        Derma_StringRequest(
        LUCTUS_RESEARCH_TITLE.." | Edit by ID", 
        "Please enter the ID of the paper you want to edit, numbers only!",
        "1",
        function(text)
            if not tonumber(text) then return end
            net.Start("luctus_research_getid")
                net.WriteInt(tonumber(text),32)
                net.WriteBool(true)
            net.SendToServer()
        end,
        function(text) end
        )
    end):SetIcon("icon16/folder_edit.png")
  
    M1:AddOption("Delete by ID", function()
        if not LocalPlayer():IsAdmin() then
            Derma_Message("Only Admins can delete papers!", LUCTUS_RESEARCH_TITLE.." | error", "OK")
            return
        end
        Derma_StringRequest(
        LUCTUS_RESEARCH_TITLE.." | Delete by ID", 
        "Please enter the ID of the paper you want to delete, numbers only!",
        "1",
        function(text)
            if not tonumber(text) then return end
            net.Start("luctus_research_deleteid")
                net.WriteInt(tonumber(text),32)
            net.SendToServer()
            timer.Simple(0.1,function()
                net.Start("luctus_research_getall")
                    net.WriteInt(lresearch_page,32)
                net.SendToServer()
            end)
        end,
        function(text) end
        )
    end):SetIcon("icon16/folder_delete.png")
  
    local M2 = MenuBar:AddMenu("Search")
    M2:AddOption("Creator", function()
        Derma_StringRequest(
        LUCTUS_RESEARCH_TITLE.." | Search by Creator", 
        "Please enter the name of the Creator!",
        "Dr. Hustensaft",
        function(text)
            lresearch_searchid = 2
            lresearch_searchtext = text
            net.Start("luctus_research_getall")
                net.WriteInt(lresearch_page,32)
                net.WriteInt(lresearch_searchid,4)
                net.WriteString(lresearch_searchtext)
            net.SendToServer()
        end,
        function(text) end
        )
    end):SetIcon("icon16/user.png")
  
    M2:AddOption("Summary", function()
        Derma_StringRequest(
        LUCTUS_RESEARCH_TITLE.." | Search by Summary", 
        "Please enter the text that the summary should contain!",
        "death",
        function(text)
            lresearch_searchid = 1
            lresearch_searchtext = text
            net.Start("luctus_research_getall")
                net.WriteInt(lresearch_page,32)
                net.WriteInt(lresearch_searchid,4)
                net.WriteString(lresearch_searchtext)
            net.SendToServer()
        end,
        function(text) end
        )
    end):SetIcon("icon16/text_allcaps.png")
  
    M2:AddOption("Reset Search Filters", function()
        lresearch_searchid = 0
        lresearch_searchtext = ""
        net.Start("luctus_research_getall")
            net.WriteInt(lresearch_page,32)
            net.WriteInt(lresearch_searchid,4)
            net.WriteString(lresearch_searchtext)
        net.SendToServer()
    end):SetIcon("icon16/arrow_rotate_anticlockwise.png")
  
    local M3 = MenuBar:AddMenu("Settings")
    M3:AddOption("Refresh List", function()
        net.Start("luctus_research_getall")
            net.WriteInt(lresearch_page,32)
        net.SendToServer()
    end):SetIcon("icon16/arrow_rotate_clockwise.png")
  
    lresearch_list = lresearch:Add("DListView")
    lresearch_list:Dock(FILL)
    lresearch_list:SetMultiSelect( false )
    lresearch_list:AddColumn("ID"):SetWidth(20)
    lresearch_list:AddColumn("Date"):SetWidth(120)
    lresearch_list:AddColumn("Creator"):SetWidth(150)
    lresearch_list:AddColumn("Summary"):SetWidth(500)
    function lresearch_list:DoDoubleClick( lineID, line )
        if not tonumber(line:GetColumnText(1)) then return end
        net.Start("luctus_research_getid")
            net.WriteInt(tonumber(line:GetColumnText(1)),32)
            net.WriteBool(false)
        net.SendToServer()
    end
  
    local bottomPanel = vgui.Create("DPanel",lresearch)
    bottomPanel:Dock(BOTTOM)
    bottomPanel:SetPaintBackground(false)
    
    local button = vgui.Create("DButton",bottomPanel)
    button:Dock(RIGHT)
    button:SetText(">")
    function button:DoClick()
        lresearch_page = lresearch_page + 1
        net.Start("luctus_research_getall")
            net.WriteInt(lresearch_page,32)
            net.WriteInt(lresearch_searchid,4)
            net.WriteString(lresearch_searchtext)
        net.SendToServer()
    end
  
    local button = vgui.Create("DButton",bottomPanel)
    button:Dock(RIGHT)
    button:SetText("<")
    function button:DoClick()
        lresearch_page = lresearch_page - 1
        if lresearch_page < 0 then lresearch_page = 0 end
        net.Start("luctus_research_getall")
            net.WriteInt(lresearch_page,32)
            net.WriteInt(lresearch_searchid,4)
            net.WriteString(lresearch_searchtext)
        net.SendToServer()
    end

end


--rowid,date,researcher,summary,fulltext
function luctusOpenPaperWindow(tab,ShouldCache)
    if not tab and ShouldCache then --load last edited paper
        local fileContent = file.Read("luctus_research_cache.txt","DATA")
        if fileContent and fileContent ~= "" then 
            tab = util.JSONToTable(fileContent)
        end
    end
    local mainFrame = vgui.Create("DFrame")
    mainFrame:SetTitle(LUCTUS_RESEARCH_TITLE.." | Paper #"..(tab and tab.rowid or "X"))
    mainFrame:SetSize(400,600)
    mainFrame:Center()
    mainFrame:MakePopup()
    mainFrame.rowid = tab and tab.rowid or nil
    mainFrame.ShouldCache = ShouldCache
    luctus_research_windows[mainFrame] = true
    function mainFrame:OnKeyCodePressed(button)
        if button == KEY_LALT then
            LuctusResearchUnfocusAllWindows()
        end
    end
    
    local summaryLabel = vgui.Create("DLabel",mainFrame)
    summaryLabel:Dock(TOP)
    summaryLabel:SetText("Summary / Headline")
    local summaryText = vgui.Create("DTextEntry",mainFrame)
    summaryText:Dock(TOP)
    summaryText:SetDrawLanguageID(false)
    summaryText:SetPlaceholderText("Put your short summary here")
    summaryText:SetText(tab and tab.summary or "")
    function summaryText:OnKeyCode(button)
        if button == KEY_LALT then
            LuctusResearchUnfocusAllWindows()
        end
    end

    local nameLabel = vgui.Create("DLabel",mainFrame)
    nameLabel:Dock(TOP)
    nameLabel:SetText("Creator")
    local nameText = vgui.Create("DTextEntry",mainFrame)
    nameText:Dock(TOP)
    nameText:SetDrawLanguageID(false)
    nameText:SetPlaceholderText("Put your own name here")
    nameText:SetText(tab and tab.researcher or "")
    function nameText:OnKeyCode(button)
        if button == KEY_LALT then
            LuctusResearchUnfocusAllWindows()
        end
    end

    local descLabel = vgui.Create("DLabel",mainFrame)
    descLabel:Dock(TOP)
    descLabel:SetText("Content")
    local descText = vgui.Create("DTextEntry",mainFrame)
    descText:Dock(FILL)
    descText:SetDrawLanguageID(false)
    descText:SetMultiline(true)
    descText:SetPlaceholderText("")
    descText:SetText(tab and tab.fulltext or LUCTUS_RESEARCH_PAPER_TEMPLATE)
    function descText:OnKeyCode(button)
        if button == KEY_LALT then
            LuctusResearchUnfocusAllWindows()
        end
    end

    if tab and tab.rowid and not tab.edit then return end
    local saveButton = vgui.Create("DButton",mainFrame)
    saveButton:SetText("SAVE PAPER")
    saveButton:Dock(BOTTOM)
    function saveButton:DoClick()
        local psummary = summaryText:GetText()
        local pname = nameText:GetText()
        local pcontent = descText:GetText()
        if psummary == "" or pname == "" or pcontent == "" then
            Derma_Message("Please fill in every field!", LUCTUS_RESEARCH_TITLE.." | error", "OK")
            return
        end
        if tab and tab.edit then
            net.Start("luctus_research_editid")
            net.WriteInt(tab.rowid,32)
        else
            net.Start("luctus_research_save")
        end
        net.WriteString(psummary)
        net.WriteString(pname)
        local a = util.Compress(pcontent)
        net.WriteInt(#a,17)
        net.WriteData(a,#a)
        net.SendToServer()
        
        LuctusResearchSaveLocal(psummary,pname,pcontent)
        mainFrame.ShouldCache = false
        
        mainFrame:Close()
        timer.Simple(0.1,function()
            net.Start("luctus_research_getall")
                net.WriteInt(lresearch_page,32)
            net.SendToServer()
        end)
    end
    
    local OnVanish = function(self)
        if not self.ShouldCache then return end
        luctus_research_windows[self] = nil
        file.Write("luctus_research_cache.txt",util.TableToJSON({
            ["summary"] = summaryText:GetText(),
            ["researcher"] = nameText:GetText(),
            ["fulltext"] = descText:GetText(),
        }))
    end
    mainFrame.OnClose = OnVanish
    mainFrame.OnRemove = OnVanish
end

function LuctusResearchSaveLocal(summary,name,content)
    file.Delete("luctus_research_cache.txt")
    file.Write("luctus_research_"..os.date("%Y_%m_%d_%H_%M_%S")..".txt",util.TableToJSON({
        ["summary"] = summary,
        ["researcher"] = name,
        ["fulltext"] = content,
    }))
end

function LuctusResearchUnfocusAllWindows()
    --gui.EnableScreenClicker(false)
    for pnl,n in pairs(luctus_research_windows) do
        if not IsValid(pnl) then
            luctus_research_windows[pnl] = nil
            continue
        end
        pnl:SetMouseInputEnabled(false)
        pnl:SetKeyboardInputEnabled(false)
    end
    hook.Add("KeyPress","luctus_research_focusagain",function(ply,key)
        if key == IN_WALK then
            --gui.EnableScreenClicker(true)
            for pnl,n in pairs(luctus_research_windows) do
                if not IsValid(pnl) then
                    luctus_research_windows[pnl] = nil
                    continue
                end
                pnl:SetMouseInputEnabled(true)
                pnl:SetKeyboardInputEnabled(true)
                pnl:RequestFocus()
            end
            hook.Remove("KeyPress","luctus_research_focusagain")
        end
    end)
end

hook.Add("PlayerButtonDown","luctus_research_open",function(ply,button)
    if ply ~= LocalPlayer() then return end
    if not LUCTUS_RESEARCH_ALLOWED_JOBS[team.GetName(LocalPlayer():Team())] and not LUCTUS_RESEARCH_ADMINS[LocalPlayer():GetUserGroup()] then return end
    if button ~= LUCTUS_RESEARCH_OPEN_BIND then return end
    RunConsoleCommand("say",LUCTUS_RESEARCH_CHAT_COMMAND)
end)

print("[luctus_research] cl loaded")
