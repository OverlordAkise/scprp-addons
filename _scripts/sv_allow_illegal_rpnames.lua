--Luctus No-Name-Restrictions
--Made by OverlordAkise

--You can also add custom restrictions here, current one: Name has to be 3<name<30 long

hook.Add("CanChangeRPName","luctus_allow_all",function(ply, RPname)
    local len = string.len(RPname)
    if len > 30 then return false, DarkRP.getPhrase("too_long") end
    if len < 3 then return false,  DarkRP.getPhrase("too_short") end
    return true
end)

print("[luctus_nonamerestrict] loaded")
