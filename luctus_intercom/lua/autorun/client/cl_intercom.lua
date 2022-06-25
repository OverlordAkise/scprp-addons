--Luctus Intercom
--Made by OverlordAkise

INTERCOM_IS_TALKING = false

net.Receive("luctus_intercom_sync",function()
    INTERCOM_IS_TALKING = net.ReadBool()
end)

print("[luctus_intercom] cl loaded!")
