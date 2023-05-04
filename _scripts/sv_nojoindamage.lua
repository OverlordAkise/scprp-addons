--Luctus No Join-Job Damage
--Made by OverlordAkise

--Because one SCP server joins players as D-Class

hook.Add("ScalePlayerDamage", "luctus_nojoinjobdamage",function(ply)
    if ply:Team() == TEAM_CONNECTING then return true end
end)

print("[luctus_nojoindamage] loaded")
