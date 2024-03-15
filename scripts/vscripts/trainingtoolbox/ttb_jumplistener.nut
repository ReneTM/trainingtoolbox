//****************************************************************************************
//																						//
//								ttb_jumplistener.nut									//
//																						//
//****************************************************************************************

function JumpListener(){
	foreach(ent in GetHumanPlayers()){
		if(!IsEntityValid(ent)){
			continue;
		}
		local scope = GetValidatedScriptScope(ent);
		if(!("previous_on_ground_state" in scope)){
			scope["previous_on_ground_state"] <- false;
		}
		if(!("previous_on_ground_pos" in scope)){
			scope["previous_on_ground_pos"] <- ent.GetOrigin();
		}

		if(!("player_jump_height_max" in scope)){
			scope["player_jump_height_max"] <- 0;
		}
		
		if(!("last_on_ground_pos" in scope)){
			scope["last_on_ground_pos"] <- ent.GetOrigin();
		}
		
		if(!("player_left_surface_pos" in scope)){
			scope["player_left_surface_pos"] <- ent.GetOrigin();
		}
		if(!("jump_initiated_at" in scope)){
			scope["jump_initiated_at"] <- ent.GetOrigin();
		}
	

		if(!PlayerIsOnGround(ent)){
			local maxHeight = scope["player_jump_height_max"];
			local currentHeight = ent.GetOrigin().z - scope["last_on_ground_pos"].z;
			if(currentHeight > maxHeight){
				scope["player_jump_height_max"] = currentHeight;
			}
		}
		

		if(PlayerIsOnGround(ent)){
			scope["last_on_ground_pos"] = ent.GetOrigin()
		}
		
		if(PlayerIsOnGround(ent) && !scope["previous_on_ground_state"]){
			PlayerLandedOnSurface(ent)
			scope["previous_on_ground_state"] = true;
			return;
		}

		if(!PlayerIsOnGround(ent) && scope["previous_on_ground_state"]){
			PlayerLeftSurface(ent, scope["last_on_ground_pos"]);
			scope["previous_on_ground_state"] = false;
			return;
		}
	}
}

function PlayerLeftSurface(ent, lastGroundPos){
	if(!IsEntityValid(ent)){
		return;
	}
	local scope = GetValidatedScriptScope(ent);
	scope["player_left_surface_pos"] = ent.GetOrigin();
	scope["jump_initiated_at"] = lastGroundPos
}

function PlayerLandedOnSurface(ent){
	if(!IsEntityValid(ent)){
		return;
	}
	local scope = GetValidatedScriptScope(ent);

	local distance = (scope["jump_initiated_at"] - ent.GetOrigin()).Length()
	if(distance <= 0.01){
		distance = 0;
	}
	jmpstr = "Jumpwidth: " + distance + "  Height: " + scope["player_jump_height_max"]
	scope["player_jump_height_max"] = 0;
}

::jmpstr <- "";
::jump <- false;