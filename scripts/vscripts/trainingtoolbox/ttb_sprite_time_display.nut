//****************************************************************************************
//																						//
//									ttb_sprite_time_display.nut							//
//																						//
//****************************************************************************************


::SpriteTimeDisplays <- []

class SpriteTimeDisplay
{
	sprite = null
	
	constructor(pos, color){
			local ent = SpawnEntityFromTable("env_sprite",{
			origin = pos + Vector(0,0,96)
			disablereceiveshadows = 0
			disableX360 = 0
			fademaxdist = 0
			fademindist = -1
			spawnflags = 0
			fadescale = 0
			scale = 0.1
			framerate = 0
			rendermode = 9
			GlowProxySize = 0.0
			renderfx = 0
			HDRColorScale = 0.7
			rendercolor = color
			maxcpulevel = 0
			renderamt = 227
			maxgpulevel = 0
			model = "materials/sprites/ttb_digits.vmt"
			mincpulevel = 0
			mingpulevel = 0
		})
		
		sprite = ent
		
		DoEntFire("!self", "hidesprite", "", 0.03, ent, ent)
	}
	
	function SetColor(color){
		// NetProps.SetPropInt(sprite, "m_clrRender", GetColorInt(color) )
		DoEntFire("!self", "color", color.x + " " + color.y + " " + color.z, 0.0, sprite, sprite)
	}
	
	function SetFrame(index){
		NetProps.SetPropFloat(sprite, "m_flFrame", index)
	}
	
	function Hide(){
		DoEntFire("!self", "hidesprite", "", 0.03, sprite, sprite)
	}
	
	function Show(){
		DoEntFire("!self", "showsprite", "", 0.03, sprite, sprite)
	}
	
	function KillDisplay(){
		sprite.Kill()
	}

}




// Hide all displays
// ----------------------------------------------------------------------------------------------------------------------------

function HideAllDisplays(){
	foreach(display in SpriteTimeDisplays){
		display.Hide()
		display.SetFrame(0)
	}
}




// Show all displays
// ----------------------------------------------------------------------------------------------------------------------------

function ShowAllDisplays(){
	foreach(display in SpriteTimeDisplays){
		display.Show()
	}
}




// Wipe all displays
// ----------------------------------------------------------------------------------------------------------------------------

function KillAllDisplays(){
	foreach(display in SpriteTimeDisplays){
		display.KillDisplay()
	}
	SpriteTimeDisplays.clear()
}




// Returns vector color as int
// ----------------------------------------------------------------------------------------------------------------------------

::GetColorInt <- function(col){
	if(typeof(col) == "Vector"){
		local color = col.x
		color += 256 * col.y
		color += 65536 * col.z
		return color
	}else if(typeof(col) == "string"){
		local colorArray = split(col, " ")
		local r = colorArray[0].tointeger()
		local g = colorArray[1].tointeger()
		local b = colorArray[2].tointeger()
		local color = r
		color += 256 * g
		color += 65536 * b
		return color
	}
}



