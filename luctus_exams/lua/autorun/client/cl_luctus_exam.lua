--Luctus Exam
--Made by OverlordAkise

local WelcomeText = "Welcome to the exam!"
local SuccessText = "Congratulations!\nYou passed the exam!"
local FailedText = "Exam failed!\nPlease try again."
local SuccessSound = "buttons/button5.wav"
local FailedSound = "buttons/button8.wav"


surface.CreateFont("luctus_exam", {
    font = "Verdana", 
    size = 23,
    weight = 900,
    outline = true,
    shadow = false,
    antialias = true,
})


local fehler = 0
local curQuestion = 0
local quizFrame = nil
local questions = {}
local npcEnt = nil

local color_accent = Color(0, 195, 165)
local color_button = Color(20,20,20,255)
local color_hovered = Color(40,40,40,255)

local color_white = Color(255,255,255,255)
local color_black = Color(0,0,0,255)

function DrawTextQuestion(s, w, h)
    local textHeight = 60
    if curQuestion < #questions+1 and questions[curQuestion][6] then
        textHeight = 20
        surface.SetMaterial(LuctusExamLoadImage(questions[curQuestion][6]))
        surface.SetDrawColor(255,255,255,255)
        surface.DrawTexturedRect(0,0,w,h)
    end
    if curQuestion < 1 then --before the quiz
        draw.DrawText(WelcomeText, "luctus_exam", w/2, textHeight, color_white, TEXT_ALIGN_CENTER)
    elseif curQuestion > #questions then --done with quiz
        draw.DrawText("Mistakes: "..fehler, "luctus_exam", w * .1, 15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if fehler < 4 then
            draw.DrawText(SuccessText, "luctus_exam", w/2, 60, color_white, TEXT_ALIGN_CENTER)
        else
            draw.DrawText(FailedText, "luctus_exam", w/2, 60, color_white, TEXT_ALIGN_CENTER)
        end
    else
        draw.DrawText(questions[curQuestion][2], "luctus_exam", w/2, textHeight, color_white, TEXT_ALIGN_CENTER)
    end
end

function DrawAnswerButton(self, w, h)
    local col = self:IsHovered() and color_hovered or color_white

    if curQuestion > #questions then
        if self.bid == 3 then
            self:SetText("close")
            surface.SetDrawColor(col)
            surface.DrawRect(0, 0, w, h)
        else
            self:SetText("")
        end
        return
    end

    local tabIndex = self.bid + 2
    if questions[curQuestion] and questions[curQuestion][tabIndex] == "" then
        self:SetText("")
        return
    end
    
    surface.SetDrawColor(col)
    surface.DrawRect(0, 0, w, h)
    self:SetText(questions[curQuestion][tabIndex])
end

function ButtonDoClick(self)
    if self:GetText() == "" then return end
    if questions[curQuestion] and questions[curQuestion][1] ~= self.bid then
        fehler = fehler + 1
    end
    curQuestion = curQuestion + 1
    if curQuestion > #questions+1 then
        quizFrame:Close()
        return
    end
    if curQuestion == #questions+1 then
        
        net.Start("luctus_exam")
            net.WriteEntity(npcEnt)
            net.WriteUInt(fehler,8)
        net.SendToServer()
        
        local allowedMistakes = IsValid(npcEnt) and npcEnt.AllowedMistakes or 4
        if fehler <= allowedMistakes then
            surface.PlaySound(SuccessSound)
        else
            surface.PlaySound(FailedSound)
        end
    end
end

net.Receive("luctus_exam", function(len, ply)
    if IsValid(quizFrame) then return end
    npcEnt = net.ReadEntity()
    questions = npcEnt.Questions
    fehler = 0
    curQuestion = 0

    quizFrame = vgui.Create("DFrame")
    quizFrame:SetSize(700, 500)
    quizFrame:Center()
    quizFrame:MakePopup()
    quizFrame:SetDraggable(true)
    quizFrame:ShowCloseButton(false)
    quizFrame:SetTitle("")
    function quizFrame:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,color_accent)
        draw.RoundedBox(0,1,1,w-2,h-2,color_black)
    end
    
    local CloseButton = vgui.Create("DButton", quizFrame)
    CloseButton:SetPos(quizFrame:GetWide()-25, 1)
    CloseButton:SetSize(24, 24)
    CloseButton:SetFont("Trebuchet18")
    CloseButton:SetText("X")
    function CloseButton:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(220,0,0))
    end
    function CloseButton:DoClick()
        quizFrame:Close()
    end

    local QuestionPanel = vgui.Create("DPanel", quizFrame)
    QuestionPanel:Dock(FILL)
    QuestionPanel.Paint = DrawTextQuestion
    
    for i=1,3 do
        local but = vgui.Create("DButton",quizFrame)
        but:Dock(BOTTOM)
        but:DockMargin(115, 5, 105, 5)
        but:SetHeight(35)
        but:SetText(i)
        but:SetFont("Trebuchet24")
        but.bid = i
        but.Paint = DrawAnswerButton
        but.DoClick = ButtonDoClick
    end
end)



LUCTUS_EXAM_IMGCACHE = {}
function LuctusExamLoadImage(url)
    file.CreateDir("luctus_exam")
    if LUCTUS_EXAM_IMGCACHE[url] then
        return LUCTUS_EXAM_IMGCACHE[url]
    end
    
    LUCTUS_EXAM_IMGCACHE[url] = Material("phoenix_storms/stripes")
    local fname = string.GetFileFromFilename(url)

    if file.Exists("luctus_exam/"..fname,"DATA") then
        print("[luctus_exam] Loading image from cache")
        LUCTUS_EXAM_IMGCACHE[url] = Material("../data/luctus_exam/"..fname)
        return LUCTUS_EXAM_IMGCACHE[url]
    end
    print("[luctus_exam] Download image from web")
    http.Fetch(url,function(body,size,headers,code)
        if code != 200 then
            ErrorNoHaltWithStack(body)
            return
        end
        file.Write("luctus_exam/"..fname,body)
        print("[luctus_exam] Download successfully cached")
        LUCTUS_EXAM_IMGCACHE[url] = Material("../data/luctus_exam/"..fname)
        return LUCTUS_EXAM_IMGCACHE[url]
    end,
    function(err)
        ErrorNoHaltWithStack(err)
    end)
    return LUCTUS_EXAM_IMGCACHE[url]
end


print("[luctus_exam] cl loaded")
