--Luctus Backpack
--Made by OverlordAkise

--This is basically just a buymenu, you can decide what job can buy what entity/weapon
--Info: it automatically detects if its a weapon or an entity

LUCTUS_BACKPACK = {}

hook.Add("postLoadCustomDarkRPItems", "luctus_job_backpack_config", function()

    --Edit here
    --Syntax: [TEAM_NAME] = {
    --  {"weapon_class",price},
    --  {"entity_class",price}
    -- }
    
    LUCTUS_BACKPACK[TEAM_CITIZEN] = {
        {"m9k_acr",950},
        {"sent_ball",500},
    }
    
    --Edit end
    
end)

print("[luctus_jobbackpack] sh loaded!")
