--Luctus Scrapsystem
--Made by OverlordAkise

function LuctusLoadScrapsys()
    for name,tab in pairs(LUCTUS_SCRAPSYS_ENTS) do
        local _ENT = scripted_ents.Get("luctus_scrapsys_base")
        local myname = "luctus_scrapsys_"..string.lower(name)
        ENT = table.Copy(_ENT)
        ENT.Spawnable = true
        ENT.Lootable = true
        
        ENT.Model = tab.model or "models/props_junk/garbage128_composite001a.mdl"
        ENT.scrapmin = tab.scrapmin or 1
        ENT.scrapmax = tab.scrapmax or 1
        ENT.getmin = 1
        ENT.getmax = tab.getmax or 1
        ENT.invis = tab.invis
        ENT.hascollision = tab.collision
        
        ENT.ClassName = myname
        ENT.PrintName = name
        scripted_ents.Register(ENT,myname)
    end
end

hook.Add("PopulatePropMenu", "luctus_load_scrapsys_fallback", LuctusLoadScrapsys)
hook.Add("InitPostEntity", "luctus_load_scrapsys",LuctusLoadScrapsys,-2)

print("[luctus_scrapsys] sh loaded!")
