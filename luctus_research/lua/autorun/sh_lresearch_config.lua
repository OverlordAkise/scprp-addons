--Luctus Research
--Made by OverlordAkise

--What chat command should open the menu
lucidResearchChatCommand = "!research"
--Button to open the menu
lucidResearchOpenBind = KEY_F7
--Which jobs are allowed to create research papers
lucidResearchAllowedJobs = {
    ["Citizen"] = true,
    ["Researcher"] = true,
    ["Wissenschaftler"] = true,
}
--Which jobs or usergroups are allowed to delete/edit papers
lucidResearchAdmins = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["O5"] = true,
    ["Team on duty"] = true,
}

print("[luctus_research] loaded config")
