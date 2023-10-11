--Luctus Raidhelper
--Made by OverlordAkise

local raid_members = {}

timer.Create("luctus_raidmembers_sync",1,0,function()
    if not LocalPlayer() then return end
    raid_members = {}
    if not LUCTUS_RAIDHELPER_HUD_ENABLE then return end
    local raid = LocalPlayer():GetNW2String("IsRaiding","")
    if raid == "" then return end
    for k,v in pairs(player.GetAll()) do
        if v:GetNW2String("IsRaiding","") == raid then
            table.insert(raid_members,v)
        end
    end
end)

hook.Add("HUDPaint","luctus_raid_hud",function()
    if #raid_members == 0 then return end
    surface.SetDrawColor(0, 195, 165, 255)
    surface.DrawOutlinedRect(5,ScrH()/2-200+20,210,(#raid_members*20)+10,2)
    draw.RoundedBox(0,7,ScrH()/2-200+22,206,(#raid_members*20)+6,Color(0,0,0,180))
    for k,ply in ipairs(raid_members) do
        draw.DrawText(ply:Nick(),"Trebuchet18",10,ScrH()/2-200+(k*20))
        draw.RoundedBox(0,10,ScrH()/2-200+(k*20)+17,200,5,Color(200,200,200,220))
        draw.RoundedBox(0,10,ScrH()/2-200+(k*20)+17,(ply:Health()*200)/ply:GetMaxHealth(),5,Color(255,0,0))
        draw.RoundedBox(0,10,ScrH()/2-200+(k*20)+17+3,(ply:Armor()*200)/ply:GetMaxArmor(),2,Color(255,0,0))
    end
end)

if LUCTUS_RAIDHELPER_XRAYVISION then
    hook.Add("PreDrawHalos", "luctus_raid_halos", function()
        halo.Add(raid_members, color_white, 1, 1, 5, true, true)
    end)
end

print("[luctus_raidhelper] cl loaded")
