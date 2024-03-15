//****************************************************************************************
//																						//
//								ttb_nadeprediction.nut									//
//																						//
//****************************************************************************************


// Settings
// ----------------------------------------------------------------------------------------------------------------------------

local gravity = Convars.GetFloat("sv_gravity");		// default 800
local tickrate = 30									// default local servers are always 30 tick
local projectile_init_speed = 750					// can be found by reading NetProps.getPropVector(projectile,m_vInitialVelocity).Length()




// Spawn camera
// ----------------------------------------------------------------------------------------------------------------------------

function ValidateNadePredictionCameras(){

	
	// Remove cameras from disconnected players
	local cam = null;
	while(cam = Entities.FindByClassname(cam, "point_viewcontrol_multiplayer")){
		local camscope = GetValidatedScriptScope(cam);
		if("cam_owner" in camscope && !IsEntityValid(camscope["cam_owner"])){
			cam.Kill();
		}
	}
	
	local camTable = 
	{ 
		origin = Vector(0,0,0)
		angles = "90 0 0"
		targetname = "nade_cam"
	}
	
	local pointerTable = 
	{
		origin = Vector(0,0,0)
		model = "models/w_models/weapons/w_eq_molotov.mdl"
		angles = "0 0 0"
		targetname = "nade_cam_model"
	}
	
	foreach(player in GetSurvivors()){
		local playerscope = GetValidatedScriptScope(player);
		if(!("nade_prediction_camera" in playerscope) || !IsEntityValid(playerscope["nade_prediction_camera"])){
			local cam = SpawnEntityFromTable("point_viewcontrol_multiplayer", camTable);
			local pointer = SpawnEntityFromTable("prop_dynamic_override", pointerTable);
			local scope = GetValidatedScriptScope(cam);
			scope["cam_owner"] <- player;
			playerscope["nade_prediction_camera"] <- cam;
			playerscope["nade_prediction_pointer"] <- pointer
		}
	}
}




// Set camera position
// ----------------------------------------------------------------------------------------------------------------------------

function SetCamera(pos, angle, player){
	local scope = GetValidatedScriptScope(player);
	if(!("nade_prediction_camera" in scope)){
		return;
	}
	local cam = scope["nade_prediction_camera"];
	local pointer = scope["nade_prediction_pointer"];
	if(cam){
		cam.SetOrigin(pos + Vector(0,0,128));
		cam.SetAngles(angle);
	}
	if(pointer){
		pointer.SetOrigin(pos + Vector(0,0,8));
	}
}


function ToggleNadePrediction(ent){
	local scope = GetValidatedScriptScope(ent);
	if(!("nade_prediction" in scope)){
		scope["nade_prediction"] <- false
	}
	
	if(NetProps.GetPropEntity(ent, "m_hViewEntity")){
		ClientPrint(null, 5, "Leave the camera before disabling the nade prediction!")
		return;
	}
	
	scope["nade_prediction"] = !scope["nade_prediction"]
	ValidateNadePredictionCameras();
	ClientPrint(null, 5, WHITE + "Nadeprediction " + GREEN + (scope["nade_prediction"] ? "enabled" : "disabled") + WHITE + " for " + GREEN + ent.GetPlayerName())
}

function NadePrediction(){
	foreach(player in GetSurvivors()){
		

		local scope = GetValidatedScriptScope(player)
		if(!("nade_prediction" in scope) || !scope["nade_prediction"]){
			continue;
		}
		
		RemoveFlag(player, 32)
		RemoveFlag(player, 64)
		
		local activeWeapon = player.GetActiveWeapon()
		if(activeWeapon){
			activeWeapon = activeWeapon.GetClassname();
			if(activeWeapon != "weapon_molotov" && activeWeapon != "weapon_pipe_bomb" && activeWeapon != "weapon_vomitjar"){
				continue;
			}
		}

		local camangle = QAngle(90,0,0)
		local startpos = player.EyePosition() + player.EyeAngles().Forward() * 16;												// Start position of the throw
		local velocity = (player.GetVelocity() + player.EyeAngles().Forward() * projectile_init_speed) * ( 1.0 / tickrate );	// Player speed + grenade initial speed
		local gravity_vector = Vector(0, 0, (-gravity / 75) / tickrate);
		local prev_pos = startpos;
		local next_pos = prev_pos;
		
		for(local i = 0; i < 128; i++) {
			if(Collision(next_pos, player)){
				SetCamera(next_pos, camangle, player);
				DebugDrawBoxAngles(next_pos, Vector(-1,-1,-1), Vector(1,1,1), QAngle(0,0,0), Vector(0,255,0), 200, 0.1)
				continue;
			}
			velocity += gravity_vector
			next_pos += velocity
			DebugDrawBoxAngles(next_pos, Vector(-1,-1,-1), Vector(1,1,1), QAngle(0,0,0), Vector(255,255,0), 200, 0.1)
			DebugDrawLine(prev_pos, next_pos, 255, 0, 0, false, 0.1);
			prev_pos = next_pos;
		}			
	}
}

// models\w_models\weapons\w_eq_molotov.mdl
// models\w_models\weapons\w_eq_bile_flask.mdl
// models\w_models\weapons\w_eq_pipebomb.mdl

/*

AddPlayer
   Makes the !activator view from this entity.
RemovePlayer
   Removes !activator view from this entity.
*/


// Checks if theres ground beneath the passed position (z-1)
// ----------------------------------------------------------------------------------------------------------------------------

function Collision(pos,player){
	local traceTableDown	= { start = pos, end = pos + Vector(0,0,-2), mask = TRACE_MASK_GRENADES, ignore = player}
	local traceTableRight	= { start = pos, end = pos + Vector(2,0,0), mask = TRACE_MASK_GRENADES, ignore = player}
	local traceTableLeft	= { start = pos, end = pos + Vector(-2,0,0), mask = TRACE_MASK_GRENADES, ignore = player}
	local traceTableBack	= { start = pos, end = pos + Vector(0,-2,0), mask = TRACE_MASK_GRENADES, ignore = player}
	local traceTableFoward	= { start = pos, end = pos + Vector(0,2,0), mask = TRACE_MASK_GRENADES, ignore = player}
	
	if(TraceLine(traceTableDown) && ( traceTableDown.hit || "startsolid" in traceTableDown)){
		return true
	}
	if(TraceLine(traceTableRight) && ( traceTableRight.hit || "startsolid" in traceTableRight)){
		return true
	}
	if(TraceLine(traceTableLeft) && ( traceTableLeft.hit || "startsolid" in traceTableLeft)){
		return true
	}
	if(TraceLine(traceTableBack) && ( traceTableBack.hit || "startsolid" in traceTableBack)){
		return true
	}
	if(TraceLine(traceTableFoward) && ( traceTableFoward.hit || "startsolid" in traceTableFoward)){
		return true
	}
	return false;
}




// Enable the grenade camera (on Showscores)
// ----------------------------------------------------------------------------------------------------------------------------

function ToggleNadeCameraState(player){
	
	local playerscope = GetValidatedScriptScope(player);
	
	if(!("nade_prediction" in playerscope) || !playerscope["nade_prediction"]){
		return;
	}
	
	local cam = playerscope["nade_prediction_camera"]
	local cameraOn = NetProps.GetPropEntity(player, "m_hViewEntity")
	if(!cam){
		return;
	}
	DoEntFire("!self", cameraOn == null ? "enable" : "disable" , "", 0, cam, cam)
}