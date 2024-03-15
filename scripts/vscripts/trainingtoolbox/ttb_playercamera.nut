//****************************************************************************************
//																						//
//									ttb_playercamera.nut								//
//																						//
//****************************************************************************************

function CameraToggle(param,ent){
	
	local params = split(param, ",");
	
	if(params.len() != 6){
		ClienPrint(null, 5, "Invalid Parameters passed!")
		return;
	}
	
	local offsetx = params[0].tointeger();
	local offsety = params[1].tointeger();
	local offsetz = params[2].tointeger();
	local angx = params[3].tointeger();
	local angy = params[4].tointeger();
	local angz = params[5].tointeger();
	
	
	if(!IsEntityValid(ent)) return;
	local scope = GetValidatedScriptScope(ent)
	

	
	//ent.SetOrigin(Vector(0,0,0));
	ent.SnapEyeAngles(QAngle(0,0,0))
	
	if("player_cam" in scope && IsEntityValid(scope["player_cam"])){
		scope["player_cam"].Kill();
	}
	
	if(!("player_cam" in scope) || !IsEntityValid(scope["player_cam"])){
		scope["player_cam"] <- SpawnEntityFromTable("point_viewcontrol_multiplayer",
		{
			targetname = "player_cam_" + UniqueString(),
			origin = ent.GetOrigin() + Vector(offsetx,offsety,offsetz) // right side
			angles = angx + " " + angy + " " + angz
		});
	}
	EntFire(scope["player_cam"].GetName(), "Enable", "", 0.0);



	local id = ent.GetPlayerUserId();
	
	EntFire("worldspawn", "RunScriptCode", "UnlockPlayer(" + id + ")", 0.03)
	EntFire("worldspawn", "RunScriptCode", "CameraParent(" + id + ")", 0.06)
}

::UnlockPlayer <- function(id){
	local ent = GetPlayerFromUserID(id)
	if(!ent) return;
	RemoveFlag(ent, 32)
	RemoveFlag(ent, 64)
}

::CameraParent <- function(id){
	local ent = GetPlayerFromUserID(id)
	if(!ent) return;
	local scope = GetValidatedScriptScope(ent);
	local cam = scope["player_cam"];
	DoEntFire("!self", "SetParent", "!activator", 0.00, ent, cam)
}


		
		