--Luctus Scrapsystem
--Made by OverlordAkise

--Should crafted entities be put into your DarkRP "pocket"
LUCTUS_SCRAPSYS_USE_POCKET = false
--Should scrap be saved between play sessions?
--If false then a player looses all scrap after leaving the server
LUCTUS_SCRAPSYS_SAVE = true
--How long after emptying a scrap-spot until it is recharged? in seconds
LUCTUS_SCRAPSYS_RECHARGE_DELAY = 3
--Limit which job can loot scrap?
LUCTUS_SCRAPSYS_JOBWHITELIST = false
--Which jobs can loot scrap
LUCTUS_SCRAPSYS_JOBNAMES = {
    ["D-Class"] = true,
}

--Scrap entities config
--Entity name will be  luctus_scrapsys_<name>
LUCTUS_SCRAPSYS_ENTS = {
    ["trash"] = { --name for entity
        model = "models/props_junk/garbage128_composite001a.mdl", --model of entity
        scrapmin = 1, --how many scraps you min. get
        scrapmax = 3, --how many scraps you max. get
        getmax = 3, --how many times you can press E to get scrap from this entity, random between 1 and this
        invis = true, --should get invisible after looted
        collision = false, --should have collision
    },
    --this also works, 1 scrap 1 time with no collision and invis after loot:
    ["noodlebox"] = {
        model = "models/props_junk/garbage_takeoutcarton001a.mdl",
    }
}

--Crafting config,  entity = scrapneeded
LUCTUS_SCRAPSYS_CRAFTABLES = {
    ["m9k_knife"] = 5,
    ["guthscp_keycard_lvl_1"] = 10,
    ["guthscp_keycard_lvl_2"] = 10,
    ["guthscp_keycard_lvl_3"] = 10,
    ["guthscp_keycard_lvl_4"] = 10,
} 

print("[luctus_scrapsys] config loaded")
