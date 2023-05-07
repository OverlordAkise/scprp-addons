--Luctus Amnestics
--Made by OverlordAkise

--YOU NEED THE FOLLOWING WORKSHOP ADDON IN YOUR SERVER'S WORKSHOP COLLECTION FOR THIS TO WORK:
--https://steamcommunity.com/sharedfiles/filedetails/?id=2595071184


LUCTUS_AMNESTICS_WEAPONNAME = "Amnestic " -- +level


LUCTUS_AMNESTICS_LEVELS = {
  --[LEVEL] = {duration in seconds, TEXT FOR PLAYER, function to render in HUDPaint}
    ["A"] = {
        ["duration"] = 3,
        ["text"] = "You forget everything that happened in the last 2 hours!",
        ["display"] = function()
            DrawMotionBlur( 0.05, 0.95, 0.01 )
        end,
    },
    ["B"] = {
        ["duration"] = 5,
        ["text"] = "You forget everything that happened in the last 12 hours!",
        ["display"] = function()
            DrawMotionBlur( 0.05, 0.95, 0.01 )
            DrawBloom( 0, 0.35, 3, 3, 2, 3, 1, 0, 0 )
        end,
    },
    ["C"] = {
        ["duration"] = 5,
        ["text"] = "You forget everything that happened in the last 24 hours!",
        ["display"] = function()
            DrawMotionBlur( 0.05, 0.95, 0.01 )
            DrawBloom( 0, 0.55, 3, 3, 2, 3, 1, 0, 0 )
        end,
    },
    ["D"] = {
        ["duration"] = 10,
        ["text"] = "You forget everything that happened in the last 48 hours!",
        ["display"] = function()
            DrawMotionBlur( 0.05, 0.95, 0.01 )
            DrawBloom( 0, 0.75, 3, 3, 2, 3, 1, 0, 0 )
        end,
    },
    ["E"] = {
        ["duration"] = 15,
        ["text"] = "You forget everything that happened in the last 96 hours!",
        ["display"] = function()
            DrawMotionBlur( 0.05, 0.95, 0.01 )
            DrawBloom( 0, 0.75, 3, 3, 2, 3, 200, 0, 0 )
        end,
    },
    ["F"] = {
        ["duration"] = 30,
        ["text"] = "You forget everything!",
        ["display"] = function()
            DrawMotionBlur( 0.05, 0.95, 0.01 )
            DrawBloom( 0, 0.75, 3, 3, 2, 3, 200, 0, 0 )
        end,
    },
}

print("[luctus_amnestics] config loaded!")
