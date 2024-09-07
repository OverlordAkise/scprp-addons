# luctus_scp008

## HOW IT WORKS

If the hatch is opened everyone who has line of sight with a "scp008_spreader" entity will be infected.  
You know if you got infected if you cough ingame.  
You can infect others only if you turn into a zombie. You turn into a zombie after being infected for a longer time.  

There is no cure after becoming a zombie.


## SETUP

To setup SCP-008 you need to do 2 things:

1. Set your hatch correctly  

Go singleplayer on your SCP map and look at the hatch.  
Run the following command in your console:  

    lua_run print(Entity(1):GetEyeTrace().Entity:MapCreationID())

It should print out an ID that is bigger than 0. Copy it and paste it into the config at line 9 (LUCTUS_SCP008_HATCH_ENTMAPID = XXXX)


2. Spawn SCP008 spreader entities

These entities control who gets infected if the hatch opens.  
You can spawn them and permaprop them on walls.  
Everyone who was line of sight with these entities will be infected if the hatch is open.

---

When you are done with the setup set the DEBUG variable to false in the config. The spreader entities will be invisible then and it won't show your infection details on screen.




Hooks:

    hook.Run("LuctusSCP008HatchOpened",ply)
    hook.Run("LuctusSCP008HatchClosed")
    hook.Run("LuctusSCP008PlayerInfected",ply,amount)
    hook.Run("LuctusSCP008PlayerZombified",ply)
    hook.Run("LuctusSCP008PlayerInfectionStopped",ply)
    hook.Run("LuctusSCP008PlayerHealed",ply)
