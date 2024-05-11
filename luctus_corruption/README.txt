# luctus corruption

This is a simple addon to track corupt jobs ingame.

Players can use !corrupt to set / query to become corrupt ingame.  

Hooks:

hook.Run("LuctusCorruptStart", ply Player, reason String)

hook.Run("LuctusCorruptStop", ply Player)

hook.Run("LuctusCorruptRequested", ply Player, reason String)

hook.Run("LuctusCorruptApproved", wantsToCorrupt Player, approver Player)

hook.Run("LuctusCorruptDenied", wantsToCorrupt Player, denier Player)