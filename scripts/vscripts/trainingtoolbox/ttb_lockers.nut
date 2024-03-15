//****************************************************************************************
//																						//
//									ttb_lockers.nut										//
//																						//
//****************************************************************************************

function LockViewAngles(ent,params){
	if(!IsEntityValid(ent)) return;
	
	local params = split(params, ",");
	
	if(params.len() != 3){
		ClientPrint(null, 5, "Invalid Parameters passed!");
		return;
	}
	
	local parsed_x = 0;
	local parsed_y = 0;
	local parsed_z = 0;
	local errorOccured = false;
	try{
		parsed_x = params[0].tofloat();
		parsed_y = params[1].tofloat();
		parsed_z = params[2].tofloat();
	}catch(exception){
		error(exception);
		errorOccured = true;
	}
	
	if(errorOccured){
		ClientPrint(null, 5, "Parsing Error!");
		return;
	}
	
	local scope = GetValidatedScriptScope(ent)
	if(!("lock_player_angles_to" in scope)){
		scope["lock_player_angles_to"] <- QAngle(parsed_x,parsed_y,parsed_z);
	}else{
		scope["lock_player_angles_to"] = QAngle(parsed_x,parsed_y,parsed_z);
	}
}

function UnlockViewAngles(ent){
	if(!IsEntityValid(ent)) return;
	local scope = GetValidatedScriptScope(ent)
	if(!("lock_player_angles_to" in scope)){
		ClientPrint(null, 5, "No saved player angles to lock to anyways!");
		return;
	}
	scope.rawdelete("lock_player_angles_to");
	ClientPrint(null, 5, "Locking disabled");
}

function SetSavedViewAngles(){
	foreach(ent in GetHumanPlayers()){
		local scope = GetValidatedScriptScope(ent)
		if(!("lock_player_angles_to" in scope)){
			continue;
		}
		local ang = scope["lock_player_angles_to"];
		ent.SnapEyeAngles(QAngle(ang.x, ang.y, ang.z));
	}
}

