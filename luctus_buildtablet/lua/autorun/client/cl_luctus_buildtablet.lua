--Luctus Buildtablet
--Made by OverlordAkise

local matBallGlow = Material("models/props_combine/tpballglow")
local matColr,matColg,matColb = 0, 0.695, 0.565

hook.Add("NetworkEntityCreated", "luctus_buildtablet", function(ent)
    if not IsValid(ent) or ent:GetClass() ~= "luctus_bprop" then return end
    local model = ent:GetModel()
    local spawnTime = nil
    local heightOffset = nil
    for k,v in ipairs(LUCTUS_BUILDTABLET_PROPS) do
        if v[1] == model then
            spawnTime = v[3]
            heightOffset = v[5]
            break
        end
    end
    if not spawnTime then return end
    ent.height = 0
    ent.StartTime = CurTime()
    ent.obbMax = ent:OBBMaxs().z
    if heightOffset then
        ent.obbMax = ent.obbMax+heightOffset
    end
    function ent:Draw()
        if self.height < self.obbMax then
            self:drawSpawning()
        else
            self:DrawModel()
        end
    end

    function ent:drawSpawning()
        render.MaterialOverride(matBallGlow)

        render.SetColorModulation(matColr,matColg,matColb)

        self:DrawModel()

        render.MaterialOverride()

        render.SetColorModulation(1, 1, 1)

        render.MaterialOverride()

        local normal = - self:GetAngles():Up()
        local pos = self:LocalToWorld(Vector(0, 0, self:OBBMins().z + self.height))
        local distance = normal:Dot(pos)
        self.height = self.obbMax * ((CurTime() - self.StartTime) / spawnTime)
        render.EnableClipping(true)
        render.PushCustomClipPlane(normal, distance)

        self:DrawModel()

        render.PopCustomClipPlane()
    end
end)

print("[luctus_buildtablet] cl loaded")
