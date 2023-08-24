--Luctus Exam
--Made by OverlordAkise

util.AddNetworkString("luctus_exam")

net.Receive("luctus_exam", function(len, ply)
    local testEnt = net.ReadEntity()
    if not testEnt or not IsValid(testEnt) or not string.StartsWith(testEnt:GetClass(),"luctus_exam_") then return end
    if testEnt:GetPos():Distance(ply:GetPos()) > 256 then return end
    local entClass = testEnt:GetClass()
    
    --Cooldown / Delay
    if ply[entClass] and ply[entClass] > CurTime() then
        return
    end
    ply[entClass] = CurTime()+testEnt.TimeBetweenExams
    
    local wrongAnswers = net.ReadUInt(8)
    local success = wrongAnswers <= testEnt.AllowedMistakes
    if success then
        print("[luctus_exam]",ply:Nick(),ply:SteamID(),"passed the exam!")
        ply:PrintMessage(HUD_PRINTTALK, "Congratulations, you have passed your exam!")
        testEnt:SuccessFunction(ply)
        testEnt:EmitSound("vo/npc/male01/nice.wav")
    else
        print("[luctus_exam]",ply:Nick(),ply:SteamID(),"failed the exam")
        ply:PrintMessage(HUD_PRINTTALK, "Sorry, You have failed your exam.")
        testEnt:EmitSound("vo/npc/male01/ohno.wav")
    end
    hook.Run("LuctusExamFinished",ply,testEnt,success,wrongAnswers)
    if not ply.examTimeStart then
        ErrorNoHaltWithStack(ply:Nick()," ",ply:SteamID()," finished the exam without starting one")
        return
    end
    --if CurTime()-ply.examTimeStart < 5 then
        --ErrorNoHaltWithStack(ply:Nick()," ",ply:SteamID()," finished the exam within 5 seconds")
    --end
end)

print("[luctus_exam] sv loaded")
