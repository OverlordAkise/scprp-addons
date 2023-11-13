--Luctus Buildtablet
--Made by OverlordAkise

--How many props can each player spawn?
LUCTUS_BUILDTABLET_PLACEABLE = 5
--Spawnable props
LUCTUS_BUILDTABLET_PROPS = {
  --{"prop.mdl",Health,SpawnTime,AngleOffset,heightOffset},
    {"models/props_c17/concrete_barrier001a.mdl",500,5},
    {"models/props_phx/construct/glass/glass_curve90x1.mdl",100,2,Angle(0,135,0)},
    {"models/props_phx/construct/glass/glass_curve90x2.mdl",150,3,Angle(0,135,0)},
    {"models/props_lab/blastdoor001b.mdl",200,4},
    {"models/props_junk/wood_crate001a_damaged.mdl",200,4,nil,20},
}

print("[luctus_buildtablet] config loaded")
