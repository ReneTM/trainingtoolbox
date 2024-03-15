	
//****************************************************************************************
//																						//
//									ttb_distance_tracker.nut							//
//																						//
//****************************************************************************************	

function ValidateDistanceTest(scope){
	if(!("distance_test" in scope)){
		scope["distance_test"] <- false;
	}
	if(!("traveled_distance" in scope)){
		scope["traveled_distance"] <- 0.0;
	}
	if(!("prev_pos" in scope)){
		scope["prev_pos"] <- null;
	}
}

function SetWalkDistanceTest(ent){
	local scope = GetValidatedScriptScope(ent);
	ValidateDistanceTest(scope);
	scope["distance_test"] = !scope["distance_test"];
	ClientPrint(null, 5, WHITE + "Tracking traveled distance " + (scope["distance_test"] ? GREEN + "enabled" : ORANGE + "disabled"));
	if(!scope["distance_test"]){
		scope["traveled_distance"] = 0.0;
		scope["prev_pos"] = null;	
	}
}

function DistanceTracker(){
	local ent = null;
	while(ent = Entities.FindByClassname(ent, "player")){
		if(!IsEntityValid(ent)){
			continue;
		}
		if(IsPlayerABot(ent)){
			return;
		}
		local scope = GetValidatedScriptScope(ent);
		ValidateDistanceTest(scope);
		
		if(!("distance_test" in scope) || !scope["distance_test"]){
			return;
		}
		
		if(!("prev_pos" in scope)){
			scope["prev_pos"] <- ent.GetOrigin();
			return;
		}
		
		if(scope["prev_pos"] == null){
			scope["prev_pos"] = ent.GetOrigin();
		}
		
		local currentPos = ent.GetOrigin();
		local distance = (currentPos - scope["prev_pos"]).Length()
		local units = scope["traveled_distance"];
		local cm = units * 2.54
		local m = cm / 100
		local km = m / 1000
		local walktime = (units / 220.0)
		
		if(distance > 0){
			scope["traveled_distance"] += distance;
			printl(WHITE + "Units: " + units + "  cm: " + cm + "  m: " + m + "  km: " + km + "  Walktime: " + walktime);
		}
		scope["prev_pos"] <- ent.GetOrigin();
	}	
}