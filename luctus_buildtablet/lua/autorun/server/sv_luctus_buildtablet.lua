--Luctus Buildtablet
--Made by OverlordAkise

util.AddNetworkString("luctus_buildtablet")

LUCTUS_BUILDTABLET_PROPCOUNT = {}

hook.Add("PlayerInitialSpawn","luctus_buildtablet",function(ply)
    LUCTUS_BUILDTABLET_PROPCOUNT[ply] = LUCTUS_BUILDTABLET_PLACEABLE
end)
hook.Add("PlayerDisconnected","luctus_buildtablet",function(ply)
    LUCTUS_BUILDTABLET_PROPCOUNT[ply] = nil
end)

function LuctusBuildtabletPropcountSubtract(ply)
    LUCTUS_BUILDTABLET_PROPCOUNT[ply] = LUCTUS_BUILDTABLET_PROPCOUNT[ply] - 1
end

function LuctusBuildtabletPropcountRecover(ply)
    LUCTUS_BUILDTABLET_PROPCOUNT[ply] = LUCTUS_BUILDTABLET_PROPCOUNT[ply] + 1
end

function LuctusBuildtabletCanSpawn(ply)
    if LUCTUS_BUILDTABLET_PROPCOUNT[ply] > 0 then return true end
    return false
end

print("[luctus_buildtablet] sv loaded")
