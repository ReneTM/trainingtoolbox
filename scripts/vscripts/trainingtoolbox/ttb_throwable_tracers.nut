//****************************************************************************************
//																						//
//									ttb_throwable_tracers.nut							//
//																						//
//****************************************************************************************




// ----------------------------------------------------------------------------------------------------------------------------

function throwableTracer(){
	
	if(!Convars.GetFloat("proj_tracer")){
		return
	}
	
	foreach(projectile in GetCurrentProjectiles()){
		drawLine(projectile)
	}
}




// ----------------------------------------------------------------------------------------------------------------------------

function drawLine(ent){
	local scope = GetValidatedScriptScope(ent)
	local ignorez = true
	local debugColor = split(Convars.GetStr("proj_tracer_clr")," ")
	local debugR = debugColor[0].tofloat()
	local debugG = debugColor[1].tofloat()
	local debugB = debugColor[2].tofloat()
	local projectilePos = ent.GetOrigin()
	
	if("lastPos" in scope){
		
		if(Convars.GetFloat("proj_tracer_use_cubes")){
			DebugDrawBox(projectilePos, Vector(0.75,0.75,0.75), Vector(-0.75,-0.75,-0.75), debugR, debugG, debugB, 255, 10)		
		}else{
			DebugDrawLine(scope["lastPos"] + Vector(0.5,0,0), projectilePos + Vector(0.5,0,0), debugR, debugG, debugB, ignorez, 10)
			DebugDrawLine(scope["lastPos"] + Vector(-0.5,0,0), projectilePos + Vector(-0.5,0,0), debugR, debugG, debugB, ignorez, 10)
			DebugDrawLine(scope["lastPos"] + Vector(0,0.5,0), projectilePos + Vector(0,0.5,0), debugR, debugG, debugB, ignorez, 10)
			DebugDrawLine(scope["lastPos"] + Vector(0,-0.5,0), projectilePos + Vector(0,-0.5,0), debugR, debugG, debugB, ignorez, 10)
		}
	
		scope["lastPos"] <- projectilePos
	}else{
		scope["lastPos"] <- projectilePos
	}
}




// ----------------------------------------------------------------------------------------------------------------------------

function GetCurrentProjectiles(){
	local projectiles = []
	local projectile = null;
	while(projectile = Entities.FindByClassname(projectile, "molotov_projectile")){
		projectiles.append(projectile)
	}
	while(projectile = Entities.FindByClassname(projectile, "pipe_bomb_projectile")){
		projectiles.append(projectile)
	}
	while(projectile = Entities.FindByClassname(projectile, "vomitjar_projectile")){
		projectiles.append(projectile)
	}
	return projectiles;
}




// ----------------------------------------------------------------------------------------------------------------------------

function AcceptEntityInput(hEntity, sInput, sValue = "", flDelay = 0.0, hActivator = null){
	if (!hEntity) return printl("[AcceptEntityInput] Entity doesn't exist");
	DoEntFire("!self", sInput.tostring(), sValue.tostring(), flDelay.tofloat(), hActivator, hEntity);
}

function ServerCommand(sCommand = "", flDelay = 0.0){
	local hServerCommand = SpawnEntityFromTable("point_servercommand", {});
	AcceptEntityInput(hServerCommand, "Command", sCommand.tostring(), flDelay.tofloat(), null);
	AcceptEntityInput(hServerCommand, "Kill", "", flDelay.tofloat(), null);
}




// ----------------------------------------------------------------------------------------------------------------------------

ServerCommand("setinfo proj_tracer 0");
ServerCommand("setinfo proj_tracer_use_cubes 0")
ServerCommand("setinfo proj_tracer_clr \"255 255 255\"")

