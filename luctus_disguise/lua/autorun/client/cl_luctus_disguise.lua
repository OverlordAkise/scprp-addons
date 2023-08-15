--Luctus Disguise
--Made by OverlordAkise

local accent_col = Color(0, 195, 165)
local wcFrame = nil
local wcLastTime = {}

local curJob = nil
local curModel = nil
local curRank = nil


local backgroundColLight = Color(26,26,26,180)
local color_black = Color(0,0,0)
local color_white = Color(255,255,255)

local function lLuctusDrawEdgeBox(x, y, w, h, s, b)
    if not s then s = 10 end
    if not b then b = 2 end
    surface.SetDrawColor(backgroundColLight)
    surface.DrawRect(x,y,w,h)
    surface.SetDrawColor(color_white)
    surface.DrawRect(x,y,s,b)
    surface.DrawRect(x,y+b,b,s-b)
    local xr = x+w
    surface.DrawRect(xr-s,y,s,b)
    surface.DrawRect(xr-b,y+b,b,s-b)
    local yb = y+h
    surface.DrawRect(xr-s,yb-b,s,b)
    surface.DrawRect(xr-b,yb-s,b,s-b)
    surface.DrawRect(x,yb-b,s,b)
    surface.DrawRect(x,yb-s,b,s-b)
end

local function LuctusPrettifyScrollbar(el)
  function el:Paint() return end
	function el.btnGrip:Paint(w, h)
        lLuctusDrawEdgeBox(0,0,w,h,5,1)
	end
	function el.btnUp:Paint(w, h)
		lLuctusDrawEdgeBox(0,0,w,h,5,1)
	end
	function el.btnDown:Paint(w, h)
		lLuctusDrawEdgeBox(0,0,w,h,5,1)
	end
end

net.Receive("luctus_disguise",function()
    if IsValid(wcFrame) then return end
    local cabEnt = net.ReadEntity()
    if not LUCTUS_DISGUISE_ALLOWED_JOBS[team.GetName(LocalPlayer():Team())] then
        notification.AddLegacy("You can't use this!",1,3)
        return
    end
    local wcEnt = net.ReadEntity()
    curJob = nil
    curModel = nil
    curRank = nil

    wcFrame = vgui.Create("DFrame")
    wcFrame:SetSize(800, 600)
    wcFrame:Center()
    wcFrame:SetTitle("Luctus' Disguise Cabinet")
    wcFrame:SetDraggable(true)
    wcFrame:ShowCloseButton(false)
    wcFrame:MakePopup()
    function wcFrame:Paint(w,h)
        lLuctusDrawEdgeBox(0,0,w,h)
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
        lLuctusDrawEdgeBox(0,0,w,h,5,1)
        if self.Hovered then
            lLuctusDrawEdgeBox(0,0,w,h,8,2)
        end
    end
    
    local unSubmitButton = vgui.Create("DButton", wcFrame)
    unSubmitButton:Dock(BOTTOM)
    unSubmitButton:SetText("")
    unSubmitButton.Paint = function(self,w,h)
        if self.Hovered then
            lLuctusDrawEdgeBox(0, 0, w, h, 15, 3)
        else
            lLuctusDrawEdgeBox(0, 0, w, h, 7, 1)
        end
        draw.DrawText("UnDisguise!", "Trebuchet18", 10, 2, Color(255,255,255))
    end
    unSubmitButton:DockMargin(0,0,0,20)
    
    local submitButton = vgui.Create("DButton", wcFrame)
    submitButton:Dock(BOTTOM)
    submitButton:SetText("")
    submitButton.Paint = function(self,w,h)
        if self.Hovered then
            lLuctusDrawEdgeBox(0, 0, w, h, 15, 3)
        else
            lLuctusDrawEdgeBox(0, 0, w, h, 7, 1)
        end
        draw.DrawText("Disguise!", "Trebuchet18", 10, 2, Color(255,255,255))
    end
    submitButton:DockMargin(0,0,0,5)
    
    local jobList = vgui.Create("DScrollPanel", wcFrame)
    jobList:Dock(LEFT)
    jobList:SetWide(180)
    jobList:DockMargin(0,0,0,20)
    LuctusPrettifyScrollbar(jobList:GetVBar())
    
    local modelList = vgui.Create("DScrollPanel", wcFrame)
    modelList:Dock(LEFT)
    modelList:SetWide(350)
    modelList:DockMargin(0,0,0,20)
    LuctusPrettifyScrollbar(modelList:GetVBar())
    
    local rankList = vgui.Create("DScrollPanel", wcFrame)
    rankList:Dock(LEFT)
    rankList:SetWide(150)
    rankList:DockMargin(0,0,0,20)
    LuctusPrettifyScrollbar(rankList:GetVBar())
    
    function unSubmitButton:DoClick()
        net.Start("luctus_disguise_off")
        net.SendToServer()
        wcFrame:Close()
    end
    
    function submitButton:DoClick()
        if not curJob or not curModel then
            notification.AddLegacy("You need to select a job and model!",1,3)
            return
        end
        if LUCTUS_DISGUISE_JOB_BLACKLIST[curJob] then
            notification.AddLegacy("You cant disguise to this job!",1,3)
            return
        end
        net.Start("luctus_disguise")
            net.WriteEntity(cabEnt)
            net.WriteString(curJob)
            net.WriteString(curModel)
            net.WriteString(curRank and tostring(curRank) or "")
        net.SendToServer()
        wcFrame:Close()
    end
    
    for k,curTeam in pairs(RPExtraTeams) do
        local catBut = vgui.Create("DButton",jobList)
        catBut.jobname = curTeam.name
        catBut.job = k
        catBut:Dock(TOP)
        catBut:DockMargin(5,5,5,5)
        catBut:SetCursor("hand")
        catBut:SetText("")
        catBut.Paint = function(self,w,h)
            if self.Hovered or curJob == self.jobname then
                lLuctusDrawEdgeBox(0, 0, w, h, 15, 3)
            else
                lLuctusDrawEdgeBox(0, 0, w, h, 7, 1)
            end
            draw.DrawText(self.jobname, "Trebuchet18", 10, 2, Color(255,255,255))
        end
        catBut.DoClick = function(self)
            curJob = self.jobname
            modelList:Clear()
            rankList:Clear()
            LuctusAddToModelList(self.job,modelList)
            LuctusAddToRankList(self.job,rankList)
        end
    end
end)

function LuctusAddToRankList(curTeam,rankList)
    local jobname = team.GetName(curTeam)
    local list = LuctusDisguiseGetRankTable(curTeam,jobname)
    for id,rankname in ipairs(list) do
        local but = rankList:Add("DButton")
        but:SetText("")
        but:Dock(TOP)
        but.rankid = id
        but.rankname = rankname
        but:DockMargin(5,5,5,5)
        but.Paint = function(self,w,h)
            if self.Hovered or curRank == self.rankid then
                lLuctusDrawEdgeBox(0, 0, w, h, 15, 3)
            else
                lLuctusDrawEdgeBox(0, 0, w, h, 7, 1)
            end
            draw.DrawText(self.rankname, "Trebuchet18", 10, 2, Color(255,255,255))
        end
        but.DoClick = function(self)
            curRank = self.rankid
        end
    end
end

--CHANGEME This function has to be customized for your jobrank system
--key = rankid, value = rankname
function LuctusDisguiseGetRankTable(cteam,jobname)
    if luctus_jobranks and luctus_jobranks[jobname] then
        local list = {}
        for k,v in ipairs(luctus_jobranks[jobname]) do
            table.insert(list,v[2])
        end
        return list
    --TBFY Jobranks support
    elseif JobRanksConfig then
        local list = {}
        local tbfyID = JobRanksConfig.JobsRankTables[cteam]
        if not tbfyID then return list end
        local subTables = JobRanks[tbfyID]
        if not subTables then return list end
        if not subTables.NameRanks or not istable(subTables.NameRanks) then return list end
        for k,v in ipairs(subTables.NameRanks) do
            table.insert(list,v)
        end
        return list
    end
    return {}
end

function LuctusAddToModelList(curTeam,modelList)
    local models = RPExtraTeams[curTeam].model
    if isstring(models) then
        local but = modelList:Add("DButton")
        but:SetText("")
        but:Dock(TOP)
        but:DockMargin(5,5,5,5)
        but.model = models
        but.Paint = function(self,w,h)
            if self.Hovered or curModel == self.model then
                lLuctusDrawEdgeBox(0, 0, w, h, 15, 3)
            else
                lLuctusDrawEdgeBox(0, 0, w, h, 7, 1)
            end
            draw.DrawText(self.model, "Trebuchet18", 10, 2, Color(255,255,255))
        end
        but.DoClick = function(self)
            curModel = self.model
        end
        return
    end
    
    for k,model in pairs(models) do
        
        local but = modelList:Add("DButton")
        but:SetText("")
        but:Dock(TOP)
        but.model = model
        but:DockMargin(5,5,5,5)
        but.Paint = function(self,w,h)
            if self.Hovered or curModel == self.model then
                lLuctusDrawEdgeBox(0, 0, w, h, 15, 3)
            else
                lLuctusDrawEdgeBox(0, 0, w, h, 7, 1)
            end
            draw.DrawText(self.model, "Trebuchet18", 10, 2, Color(255,255,255))
        end
        but.DoClick = function(self)
            curModel = self.model
        end
    end
end

print("[luctus_disguise] cl loaded")
