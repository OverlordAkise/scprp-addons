--Luctus Jobnumbers
--Made by OverlordAkise

hook.Add("loadCustomDarkRPItems", "z_luctus_jn_nick_overwrite", function()
    local PLAYER = FindMetaTable("Player")
    PLAYER.SteamName = PLAYER.SteamName or PLAYER.Name
    PLAYER.OldName = PLAYER.Name
    function PLAYER:Name()
        if not self:IsValid() then DarkRP.error("Attempt to call Name/Nick/GetName on a non-existing player!", SERVER and 1 or 2) end
        local Nick = self:OldName()
        if self:GetNWString("l_numtag","") ~= "" then
            Nick = self:GetNWString("l_numtag","") .. " " .. Nick
        end

        return Nick
    end
    PLAYER.GetName = PLAYER.Name
    PLAYER.Nick = PLAYER.Name
end)

print("[luctus_jobnumbers] sh loaded!")
