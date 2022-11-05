--Luctus Backpack
--Made by OverlordAkise

--Info: it automatically detects if its a weapon or an entity

LUCTUS_BACKPACK = {}

hook.Add("postLoadCustomDarkRPItems", "luctus_job_backpack_config", function()

    --Edit here
    --Syntax: [TEAM_NAME] = {
    --  {"weapon_class",price},
    --  {"entity_class",price}
    -- }
    
    LUCTUS_BACKPACK[TEAM_CITIZEN] = {
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
        {"sent_ball",500},
    }
    
    --Edit end
    
end)

print("[luctus_jobbackpack] sh loaded!")
