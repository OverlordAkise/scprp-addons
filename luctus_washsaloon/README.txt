# luctus_washsaloon

A minimalistic "washing machine" addon for d-class in SCPRP

 - Take out dirty clothes from the Basket (brown)  
 - Put the brown clothes into the washing machine to make them wet (blue)  
 - Put the blue clothes into the dryer to make them clean (white)  
 - Put the clean clothes into the collector to get money

There exists one hook: When a player submits clean clothes

```lua
hook.Run("LuctusWashsaloonHandinClean",ply)
```

You can use this hook to give the player extra rewards like EXP for a leveling system
