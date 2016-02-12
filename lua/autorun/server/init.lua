util.AddNetworkString( "LawsMenu" )
util.AddNetworkString( "LawsValue" )
util.AddNetworkString( "LawsPublic" )

hook.Add( "PlayerSay", "OpenLawText", function( ply, text, public )
  local text = string.lower( text )
  if ( text == "/laws" ) then
    if ply:Team() ~= TEAM_MAYOR then DarkRP.notify( ply, 1, 3, "Only the mayor can edit the laws.") return '' end
    net.Start( "LawsMenu" )
    net.Send( ply )
    return ''
  end
end)

hook.Add( "PlayerSay", "OpenLawAdmin", function( ply, text, public )
  local text = string.lower( text )
  if ( text == "/forcelaws" ) then
    if not ply:IsSuperAdmin() then DarkRP.notify( ply, 1, 3, "You must be a superadmin to use this command." ) return '' end
    net.Start( "LawsMenu" )
    net.Send( ply )
    return ''
  end
end)

net.Receive( "LawsValue", function()
  local lawvalue = net.ReadString()
  local allPlayers = player.GetAll()
  net.Start( "LawsPublic" )
  net.WriteString( lawvalue )
  net.Broadcast()
  for k, v in pairs(allPlayers) do
    DarkRP.notify( v, 0, 3, "The laws have been updated.")
  end
  print ( lawvalue )
end)
