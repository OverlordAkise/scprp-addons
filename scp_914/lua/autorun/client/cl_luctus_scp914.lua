--Luctus SCP914 System
--Made by OverlordAkise

if (game.GetMap() ~= "rp_liquidrp_ct_site99") then 
  print("[luctus_scp914] THIS ADDON ONLY WORKS ON THE MAP rp_liquidrp_ct_site99 ! Canceling loading!")
  return 
end


local scp914Liste = nil
local scp914CurType = 1
net.Receive("luctus_scp914_get",function()
  local lenge = net.ReadInt(17)
  local data = net.ReadData(lenge)
  local jtext = util.Decompress(data)
  local tab = util.JSONToTable(jtext)
  if tab == nil then return end
  
  if IsValid(scp914Liste) then
    scp914Liste:Clear()
    for k,v in pairs(tab) do
      scp914Liste:AddLine( v.rowid, v.input, v.output )
    end
  end
end)
concommand.Add("scp914_config", function(ply, cmd, args)
  if not ply:IsValid() or not ply:IsAdmin() then return end
  if IsValid(frame) then
    frame:Remove()
  end
  
  frame = vgui.Create("DFrame")
  frame:SetTitle("SCP-914 Settings")
  frame:SetSize(450, 600)
  frame:Center()
  frame:MakePopup()
  frame.btnMaxim:SetVisible(false)
  frame.btnMinim:SetVisible(false)
  
  
  --PANEL TOP
  local top = frame:Add("Panel")
  top:Dock(TOP)
  
  local credit = top:Add("DLabel")
  credit:SetText("SCP914 Config für Liquid's Site99")
  credit:Dock(LEFT)
  credit:SetTextColor(Color(255, 255, 255))
  credit:SetFont("DermaDefaultBold")
  credit:SetWide(300)
  
  local combo = top:Add("DComboBox")
  combo:SetValue("Select a type")
  combo:AddChoice("Rough", 1)
  combo:AddChoice("Coarse", 2)
  combo:AddChoice("1:1", 3)
  combo:AddChoice("Fine", 4)
  combo:AddChoice("Very Fine", 5)
  combo:Dock(RIGHT)
  combo:SetWide(150)
  combo.OnSelect = function(self, index, value, data)
    --data = id
    scp914CurType = tonumber(data)
    net.Start("luctus_scp914_get")
      net.WriteInt(data,8)
    net.SendToServer()
  end
  
  
  --PANEL BOT
  local bot = frame:Add("Panel")
  bot:Dock(BOTTOM)
  
  local inputEntry = bot:Add("DTextEntry")
  inputEntry:SetPlaceholderText("Input class")
  inputEntry:Dock(LEFT)
  
  local arrowLabel = bot:Add("DLabel")
  arrowLabel:SetText("→")
  arrowLabel:Dock(LEFT)
  arrowLabel:SetContentAlignment(5)
  arrowLabel:SetFont("Trebuchet18")
  arrowLabel:SetTextColor(Color(255, 255, 255))
  
  local outputEntry = bot:Add("DTextEntry")
  outputEntry:SetPlaceholderText("Output class")
  outputEntry:Dock(LEFT)
  
  local insertBtn = bot:Add("DButton")
  insertBtn:Dock(RIGHT)
  insertBtn:SetText("Add")
  insertBtn.DoClick = function()
    local input = string.Trim(inputEntry:GetValue())
    local output = string.Trim(outputEntry:GetValue())
    
    if #input == 0 or #output == 0 then return end
    local wType = combo:GetOptionData(combo:GetSelectedID())
    if not wType then return end
    net.Start("luctus_scp914_save")
      net.WriteString(input)
      net.WriteString(output)
      net.WriteInt(combo:GetOptionData(combo:GetSelectedID()), 8)
    net.SendToServer()
    timer.Simple(0.1,function()
      net.Start("luctus_scp914_get")
        net.WriteInt(scp914CurType,8)
      net.SendToServer()
    end)
  end
  
  bot.PerformLayout = function(self, w, h)
    inputEntry:SetWide(154)
    outputEntry:SetWide(154)
    arrowLabel:SetWide(44)
    insertBtn:SetWide(66)
  end
  
  --PANEL LISTE
  scp914Liste = frame:Add("DListView")
  scp914Liste:Dock(FILL)
  scp914Liste:AddColumn("ID"):SetWidth(30)
  scp914Liste:AddColumn("Input"):SetWidth(210)
  scp914Liste:AddColumn("Output")	:SetWidth(210)
  scp914Liste.OnRowRightClick = function(self, lineId, line)
    local menu = DermaMenu() 
    menu:AddOption("Remove", function()
      net.Start("luctus_scp914_delete")
        net.WriteInt(tonumber(line:GetColumnText(1)), 32)
      net.SendToServer()
      timer.Simple(0.1,function()
        net.Start("luctus_scp914_get")
          net.WriteInt(scp914CurType,8)
        net.SendToServer()
      end)
    end):SetIcon( "icon16/delete.png" )
    menu:Open()
  end
end)