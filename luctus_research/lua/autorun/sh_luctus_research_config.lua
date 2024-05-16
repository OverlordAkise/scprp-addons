--Luctus Research
--Made by OverlordAkise

--What chat command should open the menu
LUCTUS_RESEARCH_CHAT_COMMAND = "!research"
--Button to open the menu
LUCTUS_RESEARCH_OPEN_BIND = KEY_F7
--Which jobs are allowed to create research papers
LUCTUS_RESEARCH_ALLOWED_JOBS = {
    ["Citizen"] = true,
    ["Researcher"] = true,
    ["Wissenschaftler"] = true,
}
--Which jobs or usergroups are allowed to delete/edit papers
LUCTUS_RESEARCH_ADMINS = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["O5"] = true,
    ["Team on duty"] = true,
}

--The title of the windows
LUCTUS_RESEARCH_TITLE = "Research DB"

--The template when creating new papers
LUCTUS_RESEARCH_PAPER_TEMPLATE = [[
Involved SCP


Involved Facility Staff


Preparation


Execution


Result


]]

print("[luctus_research] loaded config")
