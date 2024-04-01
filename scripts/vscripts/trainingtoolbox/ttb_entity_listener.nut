//****************************************************************************************
//																						//
//									ttb_entity_listener.nut								//
//																						//
//****************************************************************************************

classes <- {};

classes["vomitjar_projectile"] <- false
classes["pipe_bomb_projectile"] <- false
classes["molotov_projectile"] <- false
classes["spitter_projectile"] <- false
classes["tank_rock"] <- false

function ToggleClassListener(classname){
	if(!(classname in classes)){
		ClientPrint(null, 5, "Unallowed class!");
		return;
	}
	classes[classname] = !classes[classname]
	ClientPrint(null, 5, WHITE + "Listening on " + GREEN + classname + WHITE + " has been " + GREEN + (classes[classname] ? "enabled" : "disabled" ) );
}

function EntityListener(){
	foreach(classname, val in classes){
		if(!val) continue;
		local ent = null;
		while(ent = Entities.FindByClassname(ent, classname)){
			local scope = GetValidatedScriptScope(ent)
			if(!("prev_pos" in scope)){
				scope["prev_pos"] <- ent.GetOrigin();
				continue;
			}
			local currentPos = ent.GetOrigin();
			local distance = (currentPos - scope["prev_pos"]).Length()
			local tickrate = 30.0
			local speed = distance / ( 1.0 / tickrate)
			scope["prev_pos"] <- ent.GetOrigin();
			ClientPrint(null, 5, "" + speed)
		}
	}
}