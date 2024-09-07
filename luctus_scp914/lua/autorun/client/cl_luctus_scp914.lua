--Luctus SCP914 System
--Made by OverlordAkise

net.Receive("luctus_scp914_nomap",function()
    Derma_Message("This current map is not supported! SCP914 will NOT work with this addon!", "luctus scp914 | unsupported map", "OK")
end)

local frame
local scp914Liste = nil
net.Receive("luctus_scp914_get",function()
    local lenge = net.ReadInt(17)
    local data = net.ReadData(lenge)
    local jtext = util.Decompress(data)
    local tab = util.JSONToTable(jtext)
    if tab == nil then return end

    if not IsValid(scp914Liste) then return end
    scp914Liste:Clear()
    for k,row in ipairs(tab) do
        scp914Liste:AddLine(row.rowid, row.input, row.output, row.wheelnum)
    end
end)

local function createLabel(text,parent)
    local arrowLabel = parent:Add("DLabel")
    arrowLabel:SetText(text)
    arrowLabel:Dock(LEFT)
    arrowLabel:SetFont("Trebuchet18")
    arrowLabel:SetTextColor(Color(255, 255, 255))
    arrowLabel:SetWide(30)
    if string.len(text) > 4 then
        arrowLabel:SetWide(70)
    end
end

concommand.Add("scp914_config", function(ply, cmd, args)
    if not ply:IsValid() or not ply:IsAdmin() then return end
    if IsValid(frame) then
        frame:Remove()
    end
  
    frame = vgui.Create("DFrame")
    frame:SetTitle("Luctus' SCP914 Config")
    frame:SetSize(450, 600)
    frame:Center()
    frame:MakePopup()
    frame.btnMaxim:SetVisible(false)
    frame.btnMinim:SetVisible(false)
  
  
    --PANEL TOP
    local top = frame:Add("Panel")
    top:Dock(TOP)

    local hint = top:Add("DLabel")
    hint:SetText("HINT: Wheel position starts at 0, if there are 5 positions => 0,1,2,3,4")
    hint:Dock(LEFT)
    hint:SetTextColor(Color(255, 255, 255))
    hint:SetFont("Trebuchet18")
    hint:SetWide(450)
  
  
    --PANEL BOT
    local bot = frame:Add("Panel")
    bot:Dock(BOTTOM)
    
    createLabel("wheel pos:",bot)
    local wheelEntry = bot:Add("DTextEntry")
    wheelEntry:SetPlaceholderText("1")
    wheelEntry:Dock(LEFT)
    wheelEntry:SetDrawLanguageID(false)
    
    createLabel("//",bot)
    local inputEntry = bot:Add("DTextEntry")
    inputEntry:SetPlaceholderText("Input")
    inputEntry:Dock(LEFT)
    inputEntry:SetDrawLanguageID(false)

    createLabel("→",bot)
    local outputEntry = bot:Add("DTextEntry")
    outputEntry:SetPlaceholderText("Output")
    outputEntry:Dock(LEFT)
    outputEntry:SetDrawLanguageID(false)

  
    local insertBtn = bot:Add("DButton")
    insertBtn:Dock(RIGHT)
    insertBtn:SetText("Add")
    insertBtn.DoClick = function()
        local input = string.Trim(inputEntry:GetValue())
        local output = string.Trim(outputEntry:GetValue())
        local wheelStr = wheelEntry:GetValue()
        local wheelnum = tonumber(wheelStr)
        if not wheelnum then return end
        
        if #input == 0 or #output == 0 then return end
        net.Start("luctus_scp914_save")
            net.WriteString(input)
            net.WriteString(output)
            net.WriteInt(wheelnum, 8)
        net.SendToServer()
        timer.Simple(0.1,function()
            net.Start("luctus_scp914_get")
            net.SendToServer()
        end)
    end
  
    --PANEL LISTE
    scp914Liste = frame:Add("DListView")
    scp914Liste:Dock(FILL)
    scp914Liste:AddColumn("ID"):SetWidth(30)
    scp914Liste:AddColumn("Input"):SetWidth(210)
    scp914Liste:AddColumn("Output"):SetWidth(210)
    scp914Liste:AddColumn("Wheel"):SetWidth(50)
    function scp914Liste:OnRowRightClick(lineId, line)
        local menu = DermaMenu() 
        menu:AddOption("Remove", function()
            net.Start("luctus_scp914_delete")
                net.WriteInt(tonumber(line:GetColumnText(1)), 32)
            net.SendToServer()
            timer.Simple(0.1,function()
                net.Start("luctus_scp914_get")
                net.SendToServer()
            end)
        end):SetIcon( "icon16/delete.png" )
        menu:AddOption("Edit", function()
            local inputEnt = line:GetColumnText(2) or ""
            local outputEnt = line:GetColumnText(3) or ""
            local wheelStr = line:GetColumnText(4) or ""
            Derma_StringRequest("Input Entity", "input...", inputEnt, function(text) 
                inputEnt = text 
                Derma_StringRequest("Output Entity", "...output...", outputEnt, function(text) 
                    outputEnt = text
                    Derma_StringRequest("Wheel position","...wheel position", wheelStr, function(text)
                        wheelStr = text
                        local wheelNum = tonumber(wheelStr)
                        if not wheelNum then return end
                        net.Start("luctus_scp914_edit")
                            net.WriteString(inputEnt)
                            net.WriteString(outputEnt)
                            net.WriteInt(wheelNum, 8)
                            net.WriteInt(tonumber(line:GetColumnText(1)), 32)
                        net.SendToServer()
                        timer.Simple(0.1,function()
                            net.Start("luctus_scp914_get")
                            net.SendToServer()
                        end)
                    end, function()end)
                end, function()end)
            end, function()end)
        end):SetIcon("icon16/arrow_rotate_clockwise.png")
        menu:Open()
    end
    net.Start("luctus_scp914_get")
    net.SendToServer()
end)

print("[luctus_scp914] cl loaded")
