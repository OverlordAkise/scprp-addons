--Luctus Jobnumbers
--Made by OverlordAkise

LUCTUS_JOBNUMBERS = {}

--Can users change their own ID?
LUCTUS_JOBNUMBERS_USERS_CAN_CHANGE = true

--[JobName] = {Prefix,MinValue,MaxValue}
--%d gets replaced by the number
LUCTUS_JOBNUMBERS["D-Klasse"] = {"[D-%d]",1000,9999}
LUCTUS_JOBNUMBERS["O5"] = {"[O5-%d]",1,15}
LUCTUS_JOBNUMBERS["Citizen"] = {"[C-%d]",100,999}
LUCTUS_JOBNUMBERS["Medic"] = {"[M-%d]",100,999}
LUCTUS_JOBNUMBERS["Gun Dealer"] = {"[GD-%d]",100,999}
LUCTUS_JOBNUMBERS["Hobo"] = {"[USELESS]",100,999}

--Which jobs share the same numbers
--left side is an id and right are the jobnames who share the number
--Example:
--["mtfid"] = {"MTF E-7", "MTF A-1", "MTF B-2"}
LUCTUS_JOBNUMBERS_SHAREID = {
    ["civilianids"] = {"Medic","Gun Dealer"},
}


print("[luctus_jobnumbers] config loaded!")
