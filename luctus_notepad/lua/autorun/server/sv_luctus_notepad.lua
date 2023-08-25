--Luctus Notepad
--Made by OverlordAkise

util.AddNetworkString("luctus_notepad")

net.Receive("luctus_notepad",function(len,ply)
    local text = net.ReadString()
    if string.len(text) > LUCTUS_NOTEPAD_MAX_CHARS then return end
    ply:SetNW2String("luctus_notepad",text)
    DarkRP.notify(ply,0,5,"[notepad] Text set!")
end)
 
print("[luctus_notepad] sv loaded")
