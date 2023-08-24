--Luctus Exam
--Made by OverlordAkise

AddCSLuaFile()

ENT.Base = "luctus_exam_base"
ENT.Type = "ai"
ENT.Author= "OverlordAkise"
ENT.Contact= ""
ENT.Purpose= ""
ENT.Instructions= ""
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Exam NPCs"

ENT.PrintName = "Example Exam NPC"
ENT.Model = "models/odessa.mdl"
--Allowed mistakes to make (<= this means you pass)
ENT.AllowedMistakes = 1
--Delay between exams in seconds
ENT.TimeBetweenExams = 60

--Function run after passing this exam
function ENT:SuccessFunction(ply)
    if not ply or not IsValid(ply) then return end
    --GAS.JobWhitelist:AddToWhitelist( 2, GAS.JobWhitelist.LIST_TYPE_STEAMID, ply:AccountID())
    print("[luctus_exam]",ply:Nick(),ply:SteamID(),"got whitelisted for ~Nothing~")
end

ENT.Questions = {
  --[x] = {Correct_Answer, Question, Ans#1, Ans#2, Ans#3, Image_Link},
    [0] = {1,"Answer these questions correctly to be whitelisted for\n\n~Nothing~","Start Exam","","",nil},
    [1] = {1,"Where is this banner from?","luctus_istina", "luctus_logs", "luctus_miner", "https://luctus.at/images/istina_banner.png"},
    [2] = {3,"On what continent is switzerland?","Asia","Africa","Europe", nil},
}
