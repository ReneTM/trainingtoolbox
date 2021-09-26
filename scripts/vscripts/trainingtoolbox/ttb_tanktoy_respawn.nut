//****************************************************************************************
//																						//
//									ttb_tanktoy_respawn.nut								//
//																						//
//****************************************************************************************




// Returns an array of all entities
// ----------------------------------------------------------------------------------------------------------------------------

function GetAllEntities(){
	local ent = Entities.First();
	local entities = []
	while(ent = Entities.Next(ent)){
		if(ent && ent.IsValid()){
			entities.append(ent)
		}
	}
	return entities
}




// Returns array of all tanktoys
// ----------------------------------------------------------------------------------------------------------------------------

function GetTanktoys(){
	local toys = []
	foreach(ent in GetAllEntities()){
		if(NetProps.GetPropInt(ent, "m_hasTankGlow") == 1){
			toys.append(ent)
		}
	}
	return toys
}




// Let current tanktoys glow
// ----------------------------------------------------------------------------------------------------------------------------
function SetTankToysGlowingStatic(val){
	
	local glowType = 0
	
	if(val){
		glowType = 3
	}
	
	foreach(ent in GetTanktoys()){
		NetProps.SetPropInt(ent, "m_Glow.m_iGlowType", glowType)
		NetProps.SetPropInt(ent, "m_Glow.m_glowColorOverride", GetColorInt( Vector(0,255,0) ))
	}
}




// Saves currently present tanktoys
// ----------------------------------------------------------------------------------------------------------------------------

tanktoys <- []

function SaveTankToys(){
	foreach(ent in GetTanktoys()){
		local model = ent.GetModelName()
		local classname = ent.GetClassname()
		local origin = ent.GetOrigin()
		local ang  = ent.GetAngles()
		tanktoys.append( { classname = classname, model = model, origin = origin, ang = ang } )
	}
}




// Kill all present tanktoys
// ----------------------------------------------------------------------------------------------------------------------------

function KillAllTankToys(){
	foreach(ent in GetTanktoys()){
		if(ent.IsValid()){
			ent.Kill()
		}
	}
}




// Converts QAngle rotation to string angles
// ----------------------------------------------------------------------------------------------------------------------------

function QAngleToString(Q){
	return ("" + Q.x + " " + Q.y + " " + Q.z)
}




// Respawns all saved tanktoys
// ----------------------------------------------------------------------------------------------------------------------------

function RespawnTankToys(){
	
	KillAllTankToys()
	
	foreach(saved in tanktoys){
		SpawnEntityFromTable(saved.classname, {
			model = saved.model
			origin = saved.origin + Vector(0,0,4)
			angles = QAngleToString(saved.ang)
		})
	}
	
	if(alwaysShowToys){
		SetTankToysGlowingStatic(true)
	}
}




// Toggles tanktoys always being visible to the tank
// ----------------------------------------------------------------------------------------------------------------------------

alwaysShowToys <- false

function ToggleAlwaysShowTankToys(){
	alwaysShowToys = !alwaysShowToys
	ClientPrint(null, 5, WHITE + "Tanktoys being always visible is now " + GREEN + ( alwaysShowToys ? "enabled" : "disabled"))
	if(alwaysShowToys){
		SetTankToysGlowingStatic(true)
	}else{
		SetTankToysGlowingStatic(false)
	}
}











