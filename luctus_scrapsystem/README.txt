# luctus_scrapsystem

A very simple and minimalistic scrap system for SCPRP servers to replace an older, badly written one from the gmodstore.

This addon has 2 hooks:

`hook.Run("LuctusScrapsysMultiplier",ent,ply)`  

which lets you add a multiplier when a player gets scrap. The resulting number will always be rounded up. Example:  

```
hook.Add("LuctusScrapsysMultiplier","donator",function(ent,ply)
    if ply:GetUserGroup() == "Donator" then return 1.1 end
end)
```

The above example gives a player 10% more scrap if they are the "Donator" usergroup. This will, if you get one scrap, give you 2 scrap, because the 1.1 scrap get rounded up to 2.

`hook.Run("LuctusScrapsysCrafted",ply,itemClass)`  

which lets you log what a player crafted via the npc.
