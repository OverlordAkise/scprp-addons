HandiesConfig = {

  ["EnableCommand"] = true,

  ["HandiesFromCommand"] = {
    ["dab"] = true,
    ["facepunch"] = true,
    ["flip"] = true,
    ["frontflip"] = true,
    ["middlefinger"] = true,
    ["salute"] = true,
    ["surrender"] = true,
  },

}

CreateConVar( "leaf_handies_command", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )

concommand.Add( "leaf_handies", function( ply, cmd, args )
  if HandiesConfig.EnableCommand and args[1] and GetConVar( "leaf_handies_command" ):GetInt() > 0 and HandiesConfig.HandiesFromCommand[args[1]] then
    ply:Give(args[1])
  end
end )