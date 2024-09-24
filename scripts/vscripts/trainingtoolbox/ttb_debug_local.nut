//****************************************************************************************
//																						//
//									ttb_local_debug.nut									//
//																						//
//****************************************************************************************




// Debug options which will be only avalable for the local hosting player
// ----------------------------------------------------------------------------------------------------------------------------

penetrationTestActive <- false

function penetrationTest(ent){
	if(OnLocalServer() && ent == GetListenServerHost()){
		if(!trainingActive){
			penetrationTestActive = !penetrationTestActive
			Convars.SetValue("sv_showdebugtracers", (penetrationTestActive ? 1:0))
			Convars.SetValue("sv_showdamage", (penetrationTestActive ? 2:0))
			Convars.SetValue("sv_showimpacts", (penetrationTestActive ? 3:0))
			ClientPrint(ent, 5, BLUE + "Penetrationtest " + (penetrationTestActive ? "enabled" : "disabled"))
		}else{
			ClientPrint(ent, 5, "Disable the training to toggle this debug mode")
		}
	}else{
		ClientPrint(ent, 5, "This debug function is only accessable for the local hosting player")
	}
}




boomerDebugModeActive <- false

function boomerDebug(ent){
	if(OnLocalServer() && ent == GetListenServerHost()){
		if(!trainingActive){
			boomerDebugModeActive = !boomerDebugModeActive
			Convars.SetValue("z_vomit_debug", (boomerDebugModeActive ? 1:0))
			ClientPrint(ent, 5, BLUE + "Boomer debug mode " + (boomerDebugModeActive ? "enabled" : "disabled"))
		}else{
			ClientPrint(ent, 5, "Disable the training to toggle this debug mode")
		}
	}else{
		ClientPrint(ent, 5, "This debug function is only accessable for the local hosting player")
	}
}




smokerDebugModeActive <- false

function smokerDebug(ent){
	if(OnLocalServer() && ent == GetListenServerHost()){
		if(!trainingActive){
			smokerDebugModeActive = !smokerDebugModeActive
			Convars.SetValue("tongue_debug", (smokerDebugModeActive ? 1:0))
			ClientPrint(ent, 5, BLUE + "Smoker debug mode " + (smokerDebugModeActive ? "enabled" : "disabled"))
		}else{
			ClientPrint(ent, 5, "Disable the training to toggle this debug mode")
		}
	}else{
		ClientPrint(ent, 5, "This debug function is only accessable for the local hosting player")
	}
}




fallDamageDebugActive <- false

function fallDamageDebug(ent){
	if(OnLocalServer() && ent == GetListenServerHost()){
		if(!trainingActive){
			fallDamageDebugActive = !fallDamageDebugActive
			Convars.SetValue("z_debug_falling_damage", (fallDamageDebugActive ? 1:0))
			ClientPrint(ent, 5, BLUE + "Fall damage debug mode " + (fallDamageDebugActive ? "enabled" : "disabled"))	
		}else{
			ClientPrint(ent, 5, "Disable the training to toggle this debug mode")
		}
	}else{
		ClientPrint(ent, 5, "This debug function is only accessable for the local hosting player")
	}
}




tankDebugModeActive <- false

function tankDebug(ent){
	if(OnLocalServer() && ent == GetListenServerHost()){
		if(!trainingActive){
			tankDebugModeActive = !tankDebugModeActive
			Convars.SetValue("z_tank_rock_debug", (tankDebugModeActive ? 1 : 0))
			ClientPrint(ent, 5, BLUE + "Tank debug mode " + (tankDebugModeActive ? "enabled" : "disabled"))
		}else{
			ClientPrint(ent, 5, "Disable the training to toggle this debug mode")
		}
	}else{
		ClientPrint(ent, 5, "This debug function is only accessable for the local hosting player")
	}
}




infernoDebugActive <- false

function infernoDebug(ent){
	if(OnLocalServer() && ent == GetListenServerHost()){
		if(!trainingActive){
			infernoDebugActive = !infernoDebugActive
			Convars.SetValue("inferno_debug", (infernoDebugActive ? 1:0))
			ClientPrint(ent, 5, BLUE + "Fire/Spit debug mode " + (infernoDebugActive ? "enabled" : "disabled"))
		}else{
			ClientPrint(ent, 5, "Disable the training to toggle this debug mode")
		}
	}else{
		ClientPrint(ent, 5, "This debug function is only accessable for the local hosting player")
	}
}




meleeDebugModeActive <- false

function meleeDebug(ent){
	if(OnLocalServer() && ent == GetListenServerHost()){
		if(!trainingActive){
			meleeDebugModeActive = !meleeDebugModeActive
			Convars.SetValue("melee_show_swing", (meleeDebugModeActive ? 1 : 0))
			Convars.SetValue("z_show_swings", (meleeDebugModeActive ? 1 : 0))
			ClientPrint(ent, 5, BLUE + "Melee debug mode " + (meleeDebugModeActive ? "enabled" : "disabled"))
		}else{
			ClientPrint(ent, 5, "Disable the training to toggle this debug mode")
		}
	}else{
		ClientPrint(ent, 5, "This debug function is only accessable for the local hosting player")
	}
}




function drawInfectedHitbox(){
	if(infectedHitboxModeActive){
		local player = null
		while (player = Entities.FindByClassname(player, "player")){
			if(player.GetZombieType() != 9){
				if(player.IsValid()){
					if(!player.IsDead()){
						Convars.SetValue("sv_showhitboxes", player.GetEntityIndex())
					}
				}
			}
		}
	}
}




infectedHitboxModeActive <- false
function infectedHitboxDebug(ent){
	if(OnLocalServer() && ent == GetListenServerHost()){
		if(!trainingActive){
			infectedHitboxModeActive = !infectedHitboxModeActive
			ClientPrint(ent, 5, BLUE + "Infected hitbox " + (infectedHitboxModeActive ? "enabled" : "disabled"))
			Convars.SetValue("sv_showhitboxes", 0)
		}else{
			ClientPrint(ent, 5, "Disable the training to toggle this debug mode")
		}
	}else{
		ClientPrint(ent, 5, "This debug function is only accessable for the local hosting player")
	}
}




showEscapeRouteActive <- false

function showEscapeRoute(ent){
	if(OnLocalServer() && ent == GetListenServerHost()){
		if(!trainingActive){
			showEscapeRouteActive = !showEscapeRouteActive
			ClientPrint(ent, 5, BLUE + "Showing escape route " + (showEscapeRouteActive ? "enabled" : "disabled"))
			Convars.SetValue("cl_drawescaperoute", (showEscapeRouteActive ? 1:0))
			Convars.SetValue("z_show_escape_route", (showEscapeRouteActive ? 1:0))
		}else{
			ClientPrint(ent, 5, "Disable the training to toggle this debug mode")
		}
	}else{
		ClientPrint(ent, 5, "This debug function is only accessable for the local hosting player")
	}
}
