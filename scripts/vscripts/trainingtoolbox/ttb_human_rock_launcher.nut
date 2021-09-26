//****************************************************************************************
//																						//
//								ttb_human_rock_launcher.nut								//
//																						//
//****************************************************************************************


function toggleHumanRockLauncher(ent){
	local playerscope = GetValidatedScriptScope(ent)
	if(!("rock_launcher_enabled" in playerscope)){
		playerscope["rock_launcher_enabled"] <- true
	}else{
		playerscope["rock_launcher_enabled"] <- !playerscope["rock_launcher_enabled"]
	}
	ClientPrint(null, 5, WHITE + "Human rock launcher mode " + GREEN + ( playerscope["rock_launcher_enabled"] ? "enabled" : "disabled" ) )
}




::playerRockFire <- function(ent){
	
	// Positions
	local player = GetPlayerFromUserID(ent)
	local targetPosition = player.EyePosition() + (player.EyeAngles().Forward() * 512)
	local launcherPosition = player.EyePosition() + (player.EyeAngles().Forward() * 164)
	local playerScope = GetValidatedScriptScope(player)
	
	// Create Entities on first use
	if(!("rockentities" in playerScope)){
		
		// Create Rocklauncher
		local launcherEntity = SpawnEntityFromTable("env_rock_launcher", { origin = launcherPosition } )
		local launcherScope = GetValidatedScriptScope(launcherEntity)
		launcherScope["player_owner"] <- player
		
		// Create target
		local targetName = UniqueString("rockTarget")
		local targetEntity = SpawnEntityFromTable( "info_target", { origin = targetPosition, targetname = targetName } )
		
		// Player scope
		playerScope["rocklauncher"] <- launcherEntity
		playerScope["rocktarget"] <- targetEntity
		
		// Set target
		DoEntFire("!self", "SetTarget", targetName, 0.00, playerScope.rocklauncher, playerScope.rocklauncher)
	}

	// DebugDraw
	// DebugDrawBox(targetPosition, Vector(-1,-1,-1), Vector(1,1,1), 255, 0, 0, 255, 5)
	// DebugDrawBox(launcherPosition, Vector(-1,-1,-1), Vector(1,1,1), 255, 0, 0, 255, 5)

	playerScope.rocklauncher.SetOrigin(launcherPosition)
	playerScope.rocktarget.SetOrigin(targetPosition)
	
	// Fire
	DoEntFire("!self", "LaunchRock", "", 0.00, playerScope.rocklauncher, playerScope.rocklauncher)
}




function OnGameEvent_weapon_fire(params){
    
	local player = GetPlayerFromUserID(params.userid)
	local playerscope = GetValidatedScriptScope(player)
	
	if(!IsPlayerABot(player)){
		if(player.GetButtonMask() & 524288){
			makePing(player)
		}
	}
	
	if("rock_launcher_enabled" in playerscope && playerscope.rock_launcher_enabled){
		if(params.weapon == "melee"){
			if(!IsPlayerABot(player)){
				EntFire("worldspawn", "RunScriptCode", "playerRockFire(" + params.userid + ")", 0.24)	
			}
		}
	}
}