--Luctus ulx tools
--Made by OverlordAkise

function ulx.luctustools(ply, code)
    if ply:HasWeapon("weapon_physgun") then
        ulx.fancyLogAdmin(ply, "#A removed his admintools")
        ply:StripWeapon("keys")
        ply:StripWeapon("gmod_tool")
        ply:StripWeapon("weapon_physgun")
        ply:StripWeapon("weapon_physcannon")
    else
        ulx.fancyLogAdmin(ply, "#A gave himself admintools")
        ply:Give("keys")
        ply:Give("gmod_tool")
        ply:Give("weapon_physgun")
        ply:Give("weapon_physcannon")
    end
end
local luctustools = ulx.command("SCP", "ulx tools", ulx.luctustools, "!tools")
luctustools:defaultAccess(ULib.ACCESS_ADMIN)
luctustools:help("Give or Remove your admin weapons (physgun/keys/etc.)")
