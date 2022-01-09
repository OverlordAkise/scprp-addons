--Luctus SCP457 System
--Made by OverlordAkise

if SERVER then
  resource.AddWorkshop("104607228") -- Extinguisher
  hook.Add( "ExtinguisherDoExtinguish", "luctus_scp457_recontainment", function(prop)
    if prop:IsPlayer() then
      if prop:getJobTable().command == "scp457" then
        prop.lNoBurn = CurTime() + 10
      end
    end
    return true
  end)
end


hook.Add("PlayerShouldTakeDamage", "luctus_scp457_fireno", function(d, e)
  if e and e:GetClass() == "entityflame" and d:GetActiveWeapon():GetClass() == "weapon_scp457" then return false end
end)



print("[SCP457] SH Loaded!")
