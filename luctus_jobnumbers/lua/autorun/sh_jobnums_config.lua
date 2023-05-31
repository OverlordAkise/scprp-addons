--Luctus Jobnumbers
--Made by OverlordAkise

luctus_jobnumbers = {}

--Can users change their own ID?
luctus_jobnumbers_USERS_CAN_CHANGE = true

--[JobName] = {Prefix,MinValue,MaxValue}
--%d gets replaced by the number
luctus_jobnumbers["D-Klasse"] = {"[D-%d]",1000,9999}
luctus_jobnumbers["O5"] = {"[O5-%d]",1,15}
luctus_jobnumbers["Citizen"] = {"[C-%d]",100,999}
luctus_jobnumbers["Hobo"] = {"[USELESS]",100,999}


print("[luctus_jobnumbers] config loaded!")
