surface.CreateFont("open_sans_25b", {font = "Open Sans Bold", size = 25, weight = 800, antialias = true})
surface.CreateFont("open_sans_19b", {font = "Open Sans Bold", size = 19, weight = 800, antialias = true})

local colour = {
   ["pure_white"] = Color(255, 255, 255),
   ["white"] = Color(220, 220, 220),
   ["grey"] = Color(155, 155, 155),
   ["darkest"] = Color(43, 49, 55),
   ["dark"] = Color(55, 61, 67),
   ["light"] = Color(101, 111, 123),
}

local dst = draw.SimpleText

local x = ScrW()
local y = ScrH()
local pos_x = 0
local pos_y = 0
local offset = 0
local position = 0
local alpha = 0

local function FormatString(str)
   local words = string.Explode(" ", str)
   local upper, lower, str
   local formatted = {}

   for k, v in pairs(words) do
      upper = string.upper(string.sub(v, 1, 1))
      lower = string.lower(string.sub(v, 2))
      table.insert(formatted, upper..lower)
   end

   str = formatted[1]

   if #formatted > 1 then
      for i = 1, #formatted-1 do
         str = str.." "..formatted[i+1]
      end
   end

   return str
end

local function SimpleShadowText(text, font, x, y, colour, min, xalign, yalign)
   dst(text, font, x + 1, y + 1, Color(0, 0, 0, math.min(colour.a, min + 70)), xalign, yalign)
   dst(text, font, x + 2, y + 1, Color(0, 0, 0, math.min(colour.a, min)), xalign, yalign)
   dst(text, font, x, y, colour, xalign, yalign)
end

function OpenLawsEditor()
  local Frame = vgui.Create( "DFrame" )
  Frame:SetSize( 600, 550 )
  Frame:SetTitle( "Laws Editor" )
  Frame:Center()
  Frame:SetVisible( true )
  Frame:SetDraggable( true )
  Frame:ShowCloseButton( true )
  Frame:MakePopup()
  Frame.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200) )
  end

  local TextEntry = vgui.Create( "DTextEntry", Frame )
  local text = laws or "Default laws."
  TextEntry:SetPos( 8, 25 )
  TextEntry:SetSize( 583, 480 )
  TextEntry:SetText( text )
  TextEntry:SetMultiline( true )
  if (text == "") then text = "Default laws." end

  local DermaButton = vgui.Create( "DButton", Frame )
  DermaButton:SetText( "Update Laws" )
  DermaButton:SetPos( 178 , 512  )
  DermaButton:SetSize( 250, 30 )
  DermaButton.DoClick = function()
    net.Start( "LawsValue" )
    local LawValue = TextEntry:GetValue()
    net.WriteString( LawValue )
    net.SendToServer()
 end
end

net.Receive( "LawsMenu", OpenLawsEditor )

net.Receive( "LawsPublic", function()
  laws = net.ReadString()
end)

hook.Add( "HUDPaint", "HUDPaint_LawBox", function()
  local text = laws or "Default laws."
  text = text:gsub("//", "\n"):gsub("\\n", "\n")
  text = DarkRP.textWrap(text, "open_sans_19b", 445)
  if (text == "") then text = "Default laws." end

  local width, height = surface.GetTextSize( text )

  draw.RoundedBox( 0, x * 0.63, y * 0.02, 455, height + 35, Color( 0, 0, 0, 128 ) )
  draw.DrawText( "Laws", "open_sans_25b", x * 0.636, y * 0.02, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

  draw.DrawNonParsedText(text, "open_sans_19b", x * 0.636, y * 0.05, Color(0, 0, 0, 170), 0)
  draw.DrawNonParsedText(text, "open_sans_19b", x * 0.636, y * 0.05, Color(0, 0, 0, 100), 0)
  draw.DrawNonParsedText(text, "open_sans_19b", x * 0.636, y * 0.05, colour.white, 0)
end)
