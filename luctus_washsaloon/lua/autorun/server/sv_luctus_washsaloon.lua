--Luctus Washsaloon
--Made by OverlordAkise

--Cleanup clothes if a player disconnects
function LuctusWashsaloonCleanup(ply)
    for k,ent in ipairs(ents.FindByClass("luctus_washsaloon_clothes")) do
        if ent.wshowner == ply then
            ent:Remove()
        end
    end
end

hook.Add("PlayerDisconnected","luctus_washsaloon_cleanup",function(ply)
    LuctusWashsaloonCleanup(ply)
end)

hook.Add("OnPlayerChangedTeam","luctus_washsaloon_cleanup",function(ply,before,after)
    if LUCTUS_WASHSALOON_JOB_WHITELIST and LUCTUS_WASHSALOON_JOBS[team.GetName(before)] 
        and not LUCTUS_WASHSALOON_JOBS[team.GetName(after)] then
        LuctusWashsaloonCleanup(ply)
    end
end)

print("[luctus_washsaloon] sv loaded")
