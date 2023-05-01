--Luctus Disguise
--Made by OverlordAkise

--The jobs who can disguise themselves
LUCTUS_DISGUISE_ALLOWED_JOBS = {
    ["O5 Rat"] = true,
    ["Citizen"] = true,
}

--CONFIG END

--Fix for tbfy
hook.Add("InitPostEntity","luctus_disguise_tbfy_overwrite",function()
    if JobRanksConfig then
        local PLAYER = FindMetaTable("Player")
        function PLAYER:GetJobRankTableID()
            if self:GetNWInt("disguiseTeam",-1) != -1 then
                return JobRanksConfig.JobsRankTables[self:GetNWInt("disguiseTeam",-1)]
            end
            return JobRanksConfig.JobsRankTables[self:Team()]
        end
    end
end)

print("[luctus_disguise] config loaded")
