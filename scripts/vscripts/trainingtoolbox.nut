//****************************************************************************************
//																						//
//							trainingtoolbox.nut (mainfile)								//
//																						//
//****************************************************************************************


::trainingtoolbox_version <- 1.77

scriptDebug <- Convars.GetFloat("developer")

IncludeScript("trainingtoolbox/ttb_global")
IncludeScript("trainingtoolbox/ttb_sprite_time_display")
IncludeScript("trainingtoolbox/ttb_utils")
IncludeScript("trainingtoolbox/ttb_model_controller")
IncludeScript("trainingtoolbox/ttb_chat_analysis")
IncludeScript("trainingtoolbox/ttb_survivorfailevents")
IncludeScript("trainingtoolbox/ttb_item_pickup")
IncludeScript("trainingtoolbox/ttb_classchanger")
IncludeScript("trainingtoolbox/ttb_events")
IncludeScript("trainingtoolbox/ttb_human_rock_launcher")
IncludeScript("trainingtoolbox/ttb_particledrawing")
IncludeScript("trainingtoolbox/ttb_melee_getter")
IncludeScript("trainingtoolbox/ttb_director")
IncludeScript("trainingtoolbox/ttb_commentarynodes")
IncludeScript("trainingtoolbox/ttb_commentarydata")
IncludeScript("trainingtoolbox/ttb_signplacement")
IncludeScript("trainingtoolbox/ttb_weaponstats")
IncludeScript("trainingtoolbox/ttb_ai_dmg_fix")
IncludeScript("trainingtoolbox/ttb_damage_controll")
IncludeScript("trainingtoolbox/ttb_debug_local")
IncludeScript("trainingtoolbox/ttb_commentary_shine")
IncludeScript("trainingtoolbox/ttb_rocklauncher")
IncludeScript("trainingtoolbox/ttb_preset_controller")
IncludeScript("trainingtoolbox/ttb_skin_switch")
IncludeScript("trainingtoolbox/ttb_throwable_tracers")
IncludeScript("trainingtoolbox/ttb_infected_model_toggle")
IncludeScript("trainingtoolbox/ttb_tankthrowselector")
IncludeScript("trainingtoolbox/ttb_map_switcher")
IncludeScript("trainingtoolbox/ttb_key_listener")
IncludeScript("trainingtoolbox/ttb_dummy_spawner")
IncludeScript("trainingtoolbox/ttb_execute_script")
IncludeScript("trainingtoolbox/ttb_tanktoy_respawn")
IncludeScript("trainingtoolbox/ttb_ceiling_markers")
IncludeScript("trainingtoolbox/ttb_perfect_bhop_check")
::TimeScaler <- {}
IncludeScript("trainingtoolbox/ttb_time_scaler", TimeScaler)
IncludeScript("trainingtoolbox/ttb_bot_commands")
IncludeScript("trainingtoolbox/ttb_nadeprediction")
IncludeScript("trainingtoolbox/ttb_nav_functions")
IncludeScript("trainingtoolbox/ttb_brush_element_toggle")
IncludeScript("trainingtoolbox/ttb_alarmcar")
IncludeScript("trainingtoolbox/ttb_doorfix")
IncludeScript("trainingtoolbox/ttb_playercamera")
IncludeScript("trainingtoolbox/ttb_lockers")
IncludeScript("trainingtoolbox/ttb_motd")
IncludeScript("trainingtoolbox/ttb_distance_tracker")
IncludeScript("trainingtoolbox/ttb_jumplistener")
IncludeScript("trainingtoolbox/ttb_hud_controller")
IncludeScript("trainingtoolbox/ttb_sequence_controller")
IncludeScript("trainingtoolbox/ttb_entity_listener")
// IncludeScript("trainingtoolbox/ttb_tediore")
IncludeScript("trainingtoolbox/ttb_weapon_spawn_debug")
::EventDebugger <- {}
IncludeScript("trainingtoolbox/ttb_event_debug", EventDebugger)
::TankrockCamera <- {}
IncludeScript("trainingtoolbox/ttb_tank_rock_camera", TankrockCamera);




precacheAllSurvivorModels()
precacheAllInfectedModels()
precacheCSSWeapons()


// Get's fired 'OnGameplayStart' ( usually after every single loadingscreen )
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameplayStart(){
	setNeededCvars()
	createInformationalEnts()
	createBubbleShine()
	updateNodeData()
	removeDeathFallCameras()
	removeOuchees()
	removeExplosives()
	createThinkTimer()
	SaveTankToys()
	TimeScaler.createBulletTimerEntity()
	DoorFix()
	Start()
}


getroottable()["TRACE_MASK_ALL"] <- -1
getroottable()["TRACE_MASK_VISION"] <- 33579073
getroottable()["TRACE_MASK_VISIBLE_AND_NPCS"] <- 33579137
getroottable()["TRACE_MASK_PLAYER_SOLID"] <- 33636363
getroottable()["TRACE_MASK_NPC_SOLID"] <- 33701899
getroottable()["TRACE_MASK_SHOT"] <- 1174421507
getroottable()["TRACE_MASK_GRENADES"] <- 33570827


getroottable()["WHITE"]		<- "\x01"
getroottable()["BLUE"]		<- "\x03"
getroottable()["ORANGE"]	<- "\x04"
getroottable()["GREEN"]		<- "\x05"


survivorIndices <- {}

/*
if(Director.GetSurvivorSet() == 1){
	survivorIndices["0"] <- "bill"
	survivorIndices["1"] <- "zoey"
	survivorIndices["2"] <- "louis"
	survivorIndices["3"] <- "francis"
}else{
	survivorIndices["0"] <- "nick"
	survivorIndices["1"] <- "rochelle"
	survivorIndices["2"] <- "coach"
	survivorIndices["3"] <- "ellis"
}
*/

if(Director.GetSurvivorSet() == 1){
	survivorIndices["bill"] <- 0
	survivorIndices["zoey"] <- 1
	survivorIndices["louis"] <- 2
	survivorIndices["francis"] <- 3
}else{
	survivorIndices["nick"] <- 0
	survivorIndices["rochelle"] <- 1
	survivorIndices["coach"] <- 2
	survivorIndices["ellis"] <- 3
}



// General colors
colors <- 
{
	red		= "255 0 0"
	green	= "0 255 0"
	blue	= "0 0 255"
	cyan	= "0 255 255"
	magenta	= "255 0 255"
	yellow	= "255 255 15"
	orange	= "255 90 0"
	white	= "255 255 255"
}




// Glow colors of infected preview by class
modelGlowColors <-
{
	common = colors.white
	uncommon = colors.yellow
	boss = colors.red
	capper = colors.orange
	support = colors.green
}




// Arrays and variables to handle the training and spawn data
trainingActive				<- false
dummySpawnModels 			<- []
spawnPositionData			<- []
zombieSpawnTypes			<- []




// Arrays to redo and undo
spawnPositionDataHistory	<- []
zombieSpawnTypesHistory		<- []




// Player Spawn Positions
::savedPlayerPositions 		<- {}




InfectedData <-
{
	// BOSS
	tank = { infectedName = "tank", modelName = "models/infected/hulk.mdl", spawnNumber = 8, modelGlowColor = modelGlowColors.boss, DefaultAnim = "ACT_IDLE" }
	witch = { infectedName = "witch", modelName = "models/infected/witch.mdl", spawnNumber = 7, modelGlowColor = modelGlowColors.boss, DefaultAnim = "ACT_IDLE" }
	// CAPPER
	hunter = { infectedName = "hunter", modelName = "models/infected/hunter.mdl", spawnNumber = 3, modelGlowColor = modelGlowColors.capper, DefaultAnim = "ACT_IDLE" }
	smoker = { infectedName = "smoker", modelName = "models/infected/smoker.mdl", spawnNumber = 1, modelGlowColor = modelGlowColors.capper, DefaultAnim = "ACT_IDLE" }
	jockey = { infectedName = "jockey", modelName = "models/infected/jockey.mdl", spawnNumber = 5, modelGlowColor = modelGlowColors.capper, DefaultAnim = "ACT_IDLE" }
	charger = { infectedName = "charger", modelName = "models/infected/charger.mdl", spawnNumber = 6, modelGlowColor = modelGlowColors.capper, DefaultAnim = "ACT_IDLE" }
	// SUPPORT
	boomer = { infectedName = "boomer", modelName = "models/infected/boomer.mdl", spawnNumber = 2, modelGlowColor = modelGlowColors.support, DefaultAnim = "ACT_IDLE" }
	spitter = { infectedName = "spitter", modelName = "models/infected/spitter.mdl", spawnNumber = 4, modelGlowColor = modelGlowColors.support, DefaultAnim = "ACT_IDLE" }
	// COMMON
	common = { infectedName = "common", modelName = "models/infected/common_male01.mdl", spawnNumber = 0, modelGlowColor = modelGlowColors.common, DefaultAnim = "Idle_Neutral_01" }
	// UNCOMMON
	riot = { infectedName = "common_male_riot", modelName = "models/infected/common_male_riot.mdl", spawnNumber = 22, modelGlowColor = modelGlowColors.uncommon, DefaultAnim = "Idle_Neutral_01" }
	ceda = { infectedName = "common_male_ceda", modelName = "models/infected/common_male_ceda.mdl", spawnNumber = 23, modelGlowColor = modelGlowColors.uncommon, DefaultAnim = "Idle_Neutral_01" }
	mud = { infectedName = "common_male_mud", modelName = "models/infected/common_male_mud.mdl", spawnNumber = 24, modelGlowColor = modelGlowColors.uncommon, DefaultAnim = "Idle_Neutral_01" }
	roadcrew = { infectedName = "common_male_roadcrew", modelName = "models/infected/common_male_roadcrew.mdl", spawnNumber = 25, modelGlowColor = modelGlowColors.uncommon, DefaultAnim = "Idle_Neutral_01" }
	jimmy = { infectedName = "common_male_jimmy", modelName = "models/infected/common_male_jimmy.mdl", spawnNumber = 26, modelGlowColor = modelGlowColors.uncommon, DefaultAnim = "Idle_Neutral_01" }
	clown = { infectedName = "common_male_clown", modelName = "models/infected/common_male_clown.mdl", spawnNumber = 27, modelGlowColor = modelGlowColors.uncommon, DefaultAnim = "Idle_Neutral_01" }
	fallen = { infectedName = "common_male_fallen_survivor", modelName = "models/infected/common_male_fallen_survivor.mdl", spawnNumber = 28, modelGlowColor = modelGlowColors.uncommon, DefaultAnim = "Idle_Neutral_01" }
}




// When the daytime is set to night we want to use sitting witch models
// ----------------------------------------------------------------------------------------------------------------------------

function witchPoseSwitch(daytime){
	local worldspawn = Entities.FindByClassname(null, "worldspawn")
	local anim = 0
	switch(daytime){
		case "night":	{ anim = 4; NetProps.SetPropInt(worldspawn, "m_iTimeOfDay", 5); break; }
		case "day":		{ anim = 1; NetProps.SetPropInt(worldspawn, "m_iTimeOfDay", 2); break; }
	}
	
	foreach(model in dummySpawnModels){
		if(model.GetModelName() == "models/infected/witch.mdl"){
			model.SetSequence(anim)
		}
	}
}




// Send a text message to the player with an additional sound
// ----------------------------------------------------------------------------------------------------------------------------

function sendWarning(player, message){
	ClientPrint(player, 5, message)
	EmitAmbientSoundOn("level/bell_impact.wav", 0.4, 100, 128, player)
}




// Fade effect
// ----------------------------------------------------------------------------------------------------------------------------

function blackScreen(){
	foreach(player in GetHumanSurvivors()){
		ScreenFade(player, 0, 0, 0, 255, 1, 0.5, 1)
	}
}




// Toggle Trainingmode / Editmode
// ----------------------------------------------------------------------------------------------------------------------------

function toggleTraining(ent){
	
	local humanInfectedCount = 0
	foreach(ent in GetPlayers()){
		if(!IsPlayerABot(ent)){
			if(NetProps.GetPropInt(ent, "m_iTeamNum") == TEAMS.INFECTED){
				humanInfectedCount++
			}
		}
	}
	
	if(humanInfectedCount > 0){
		ClientPrint(null, 5, "Human infected are restricted in training mode. Type !becomesurvivor to use the training mode.")
		return
	}
	
	if(GetBotSurvivors().len() > 0){
		ClientPrint(null, 5, "Remove all bot controlled survivors before starting the training!")
		return
	}
	
	if(spawnPositionData.len() > 0)
	{
		if(!anyCommentaryNodeActive()){
			killAllNodes()
			killBubbleShine()
			trainingActive = !trainingActive
			ClientPrint(null, 5, WHITE + "Training " + GREEN + (trainingActive ? "Enabled" : "Disabled"))
			trainingActive ? hideAllSpawns() : showAllSpawns();
			removeAllInfected();
			resetSpawnTimeStamps();
			if(trainingActive){
				blackScreen()
			}
			
			trainingActive ? ShowAllDisplays() : HideAllDisplays();
			
			disableNoclipAndTeleportToStart()
		}else{
			sendWarning(ent, "Wait for the guide to end or type !stopcommentary")
		}
	}else{
		sendWarning(ent, "Place atleast one spawn to start")
	}
}


function resetSpawnTimeStamps(){
	//local randomTimeFactor = RandomInt(0.25, 5)
	foreach(spawner in spawnPositionData){
		//spawner["lastSpawnedTimeStamp"] = Time() + randomTimeFactor
		spawner["lastSpawnedTimeStamp"] = Time()
	}
}




// Create a set of preview model and a spawnpos given by players crosshair position
// !hunter 5 with a valid position will create a hunter spawn with a spawntime of 5 + ( 0.1 - 1.0 ) seconds
// ----------------------------------------------------------------------------------------------------------------------------

function createSpawnSet(inf, spawntime, player){
	
	if(!isNumeric(spawntime)){
		ClientPrint(null, 5, "Invalid parameter: >" + spawntime + "<");
		return;
	}
	
	spawntime = spawntime.tointeger()
	
	if(trainingActive){
		sendWarning(player, "Type !training to enter edit mode");
		return;
	}

	if(spawnPositionData.len() >= 32){
		sendWarning(player, "Limit of 32 spawns has been reached.");
		return;
	}

	if(spawntime < 5 || spawntime > 60){
		sendWarning(player, "Spawntime has to be between 5 and 60");
		return;
	}

	// local randomSpawnTimeFactor = RandomFloat(0.1, 1)
	// spawntime += randomSpawnTimeFactor;

	local pointer = getPointerPos(player)
	
	if(!isPointerValid(pointer, 32, 96, player)){
		sendWarning(player, "Invalid Position!");
		return;
	}

	if(!distanceToOtherSpawnsValid(pointer)){
		sendWarning(player, "Distance to next infected spawn is too small");
		return;
	}

	local spawnModel = createStatue(inf)
	DoEntFire("!self", "Alpha", dummyAlpha, 0, spawnModel, spawnModel)
	createZombieSpawn(inf, pointer, spawntime, ColorStringToVector(inf.modelGlowColor))
	spawnModel.SetOrigin(pointer)
	dummySpawnModels.append(spawnModel)
	zombieSpawnTypes.append(inf)
	UpdateInfectedModels()
}
	

	






// We dont want to create infected spawns too close to others
// ----------------------------------------------------------------------------------------------------------------------------

function distanceToOtherSpawnsValid(pointer){
	if(spawnPositionData.len() == 0){
		return true
	}else{
		foreach(dataset in spawnPositionData){
			if((dataset.pos - pointer).Length() < 96 ){
				return false
			}
		}
		return true;
	}
}




// Return players pointer pos
// ----------------------------------------------------------------------------------------------------------------------------

function getPointerPos(player){
	local startPt = player.EyePosition()
	local endPt = startPt + player.EyeAngles().Forward().Scale(999999)
	local m_trace = { start = startPt, end = endPt, ignore = player, mask = TRACE_MASK_SHOT }
	TraceLine(m_trace)
	return m_trace.pos
}




// This function validates the pointer position to spawn an infected OR the position to disable noclip
// ----------------------------------------------------------------------------------------------------------------------------

function isPointerValid(pointer, radius, height, player){
	local xTable = null
	local yTable = null
	local diagonalTable1 = null
	local diagonalTable2 = null

	for(local i=-radius; i <= radius; i += 2){
		xTable = {start = pointer + Vector(i,0,height), end = pointer + Vector(i,0,16), ignore = player, mask = TRACE_MASK_PLAYER_SOLID },
		yTable = {start = pointer + Vector(0,i,height), end = pointer + Vector(0,i,16), ignore = player, mask = TRACE_MASK_PLAYER_SOLID },
		diagonalTable1 = {start = pointer+Vector(i,i,height), end = pointer + Vector(i,i,16), ignore = player, mask = TRACE_MASK_PLAYER_SOLID },
		diagonalTable2 = {start = pointer+Vector(i,-i,height), end = pointer + Vector(i,-i,16), ignore = player, mask = TRACE_MASK_PLAYER_SOLID },

		TraceLine(xTable)
		TraceLine(yTable)
		TraceLine(diagonalTable1)
		TraceLine(diagonalTable2)
		
		if(scriptDebug){
			DebugDrawLine(xTable.start, xTable.end, 255, 255, 255, false, 4)
			DebugDrawLine(yTable.start, yTable.end, 255, 255, 255, false, 4)
			DebugDrawLine(diagonalTable1.start, diagonalTable1.end, 255, 255, 255, false, 4)
			DebugDrawLine(diagonalTable2.start, diagonalTable2.end, 255, 255, 255, false, 4)
		}
		if("startsolid" in xTable || "startsolid" in yTable){
			return false;
		}else if("hit" in xTable && xTable.hit == true || "hit" in yTable && yTable.hit == true){
			return false;
		}
	}
	return true;
}




// Create a spawntable with given infected and position
// ----------------------------------------------------------------------------------------------------------------------------

function createZombieSpawn(inf, pointer, spawntime, dispColor){
	local disp =  SpriteTimeDisplay(pointer, dispColor)
	SpriteTimeDisplays.append(disp)
	local spawnTable = { type = inf.spawnNumber, pos = pointer + Vector(0,0,16), ang = QAngle(0,90,0), spawntime = spawntime, lastSpawnedTimeStamp = 0, display = disp, displayColor = dispColor }
	spawnPositionData.append(spawnTable)
}




// Create a special infected model and return its handle
// ----------------------------------------------------------------------------------------------------------------------------

dummyAngles	<- "0 0 0"
dummyAlpha	<- "192"

function createStatue(inf){
	
	local modelTable = 	
	{
		angles = dummyAngles, body = "0", DefaultAnim = inf.DefaultAnim,DisableBoneFollowers = "1", disablereceiveshadows = "1", disableshadows = "1", disableX360 = "0",
		ExplodeDamage = "0", ExplodeRadius = "0", fademaxdist = "0", fademindist = "-1", fadescale = "1", glowbackfacemult = "1.0", glowcolor = inf.modelGlowColor,
		glowrange = "0", glowrangemin = "0", glowstate = "3", health = "0", LagCompensate = "0", MaxAnimTime = "10", maxcpulevel = "0", maxgpulevel = "0", MinAnimTime = "5",
		mincpulevel = "0", mingpulevel = "0", model = inf.modelName, PerformanceMode = "0", pressuredelay = "0",
		RandomAnimation = "0", renderamt = "255", rendercolor = "255 255 255", renderfx = "0", rendermode = "1", SetBodyGroup = "0", skin = "0",
		solid = "0", spawnflags = "0", updatechildren = "0"
	}
	
	if(inf.infectedName == "witch"){
		if(isNightTime()){
			modelTable.DefaultAnim = "ACT_TERROR_WITCH_IDLE"
		}else{
			modelTable.DefaultAnim = "ACT_IDLE"
		}
	}
	
	return SpawnEntityFromTable("prop_dynamic_override", modelTable)
}




// Attach the infected model to func_rotating
// ----------------------------------------------------------------------------------------------------------------------------

function AttachRotatorTo(ent){
	local pos = ent.GetOrigin()
	local rotName = UniqueString("_ttb_rot")
	local rotator = SpawnEntityFromTable("func_rotating", { targetname = rotName, origin = pos, maxspeed = 18, spawnflags = 67 })
	NetProps.SetPropVector(rotator, "m_Collision.m_vecMins", Vector(1,1,1))
	NetProps.SetPropVector(rotator, "m_Collision.m_vecMaxs", Vector(-1,-1,-1))
	DoEntFire("!self", "SetParent", "!activator", 0.03, rotator, ent);

}




// Undo and redo spawnpositions
// ----------------------------------------------------------------------------------------------------------------------------

function undo(){
	if(!trainingActive){
		if(spawnPositionData.len() > 0){
			local previous = dummySpawnModels.pop()
			NetProps.SetPropInt(previous, "m_Glow.m_iGlowType", -1)
			previous.Kill()
			
			// Undo display
			local prevTable = spawnPositionData.pop()
			prevTable.display.KillDisplay()
			SpriteTimeDisplays.remove(SpriteTimeDisplays.len()-1)
			
			spawnPositionDataHistory.append(prevTable)
			zombieSpawnTypesHistory.append(zombieSpawnTypes.pop())
			ClientPrint(null, 5, BLUE + "Spawn undone")
		}else{
			ClientPrint(null, 5, "There are no spawns to undo!")
		}
	}else{
		ClientPrint(null, 5, "Type !training to enter edit mode")
	}
}

function redo(){
	if(!trainingActive){
		if(spawnPositionDataHistory.len() > 0){
			local restoredSpawnTable = spawnPositionDataHistory.pop()
			
			// Restore Display
			restoredSpawnTable.display = SpriteTimeDisplay(restoredSpawnTable.pos, restoredSpawnTable.displayColor)
			SpriteTimeDisplays.append(restoredSpawnTable.display)
			
			spawnPositionData.append(restoredSpawnTable)
			zombieSpawnTypes.append(zombieSpawnTypesHistory.pop())
			local restoredModel = createStatue(zombieSpawnTypes.top())
			DoEntFire("!self", "Alpha", dummyAlpha, 0, restoredModel, restoredModel)
			restoredModel.SetOrigin(restoredSpawnTable.pos - Vector(0,0,16))
			dummySpawnModels.append(restoredModel)
			ClientPrint(null, 5, BLUE + "Spawn redone")
			UpdateInfectedModels()
			showAllSpawns()
		}else{
			ClientPrint(null, 5, "There are no spawns to redo!")
		}
	}else{
		ClientPrint(null, 5, "Type !training to enter edit mode")
	}
}




// Show/hide infected props
// ----------------------------------------------------------------------------------------------------------------------------

function hideAllSpawns(){
	foreach(model in dummySpawnModels){
		NetProps.SetPropInt(model, "m_Glow.m_iGlowType", -1)
		NetProps.SetPropInt(model, "m_fEffects", NetProps.GetPropInt(model, "m_fEffects") | (1 << 5))
	}
}

function showAllSpawns(){
	foreach(model in dummySpawnModels){
		NetProps.SetPropInt(model, "m_fEffects", 0)
		NetProps.SetPropInt(model, "m_Glow.m_iGlowType", 3)
	}
}


::moveSurvivorsToStartPos <- function(){
	foreach(player in GetHumanSurvivors()){
		if(player.GetZombieType() == 9){
			if(player in savedPlayerPositions){
				player.SetOrigin(savedPlayerPositions[player].pos)
				player.SnapEyeAngles(savedPlayerPositions[player].ang)
			}
		}
	}
}

function stopTraining(){
	if(trainingActive){
		removeAllInfected()
		showAllSpawns()
		HideAllDisplays()
		ClientPrint(null, 5, "Training stopped")
		trainingActive = false
		EntFire("worldspawn", "RunScriptCode", "moveSurvivorsToStartPos()", 0.5)
	}
	healEverySurvivor()
}




// Spawn infected on player's crossshair position
// ----------------------------------------------------------------------------------------------------------------------------

function spawnSingleInfected(player, infected){
	
	if(infected == 8 && GetGhostPlayers().len() > 0){
		sendWarning(player, "No tank spawn allowed when there are ghost players out there.")
		return;
	}
	
	if(!trainingActive){
		local pointer = getPointerPos(player)
		local spawnTable = { type = infected, pos = pointer + Vector(0,0,16), ang = QAngle(0,90,0) }
	
		if(isPointerValid(pointer, 32, 96, player)){
			if(infected >= 22){
				spawnUncommonInfected(infected, pointer + Vector(0,0,16))
			}else{
				ZSpawn(spawnTable);		
			}
			createInfectedSpawnCircle(pointer + Vector(1,1,1))
		}else{
			sendWarning(player, "Invalid Position!")
		}
	}else{
		sendWarning(player, "Spawning single infected is only available with training disabled")
	}
}




// Check if there are any ghosting players
// ----------------------------------------------------------------------------------------------------------------------------

function GetGhostPlayers(){
	local ents = [];
	local ent = null;
	while(ent = Entities.FindByClassname(ent, "player")){
		if(!IsEntityValid(ent)) continue;
		if(!IsGhost(ent)) continue;
		ents.append(ent);
	}
	return ents;
}

// Timed infected spawning
// ----------------------------------------------------------------------------------------------------------------------------

function timedInfectedSpawning(){
	if(trainingActive){
		foreach(spawner in spawnPositionData){

			local lastSpawned = spawner["lastSpawnedTimeStamp"];
			local spawnTime = spawner["spawntime"]
			local pos = spawner["pos"]
			local display = spawner["display"]
			
			local displayTime = abs( (spawnTime - (Time() - lastSpawned) ) + 1 ) 
			display.SetFrame(displayTime)
			
			if( Time() >= ( lastSpawned + spawnTime ) )
			{
				// Uncommon infected
				if(spawner["type"] >= 22)
				{
					if(spawnUncommonInfected(spawner["type"], pos))
					{
						createInfectedSpawnCircle(pos - Vector(0,0,15))
					}
					spawner["lastSpawnedTimeStamp"] = Time()

				}
				// Special infected and commons
				else
				{
					if(customZSpawn(spawner))
					{
						createInfectedSpawnCircle(pos - Vector(0,0,15))
					}
					spawner["lastSpawnedTimeStamp"] = Time()

				}
			}
		}
	}
}




// +Use on dummy in point_commentary_node 
// ----------------------------------------------------------------------------------------------------------------------------

function playerIsHittingUSE(){
	foreach(player,buttonArray in getHeldPlayerButtons()){
		if(buttonArray.find("USE") != null){
			foreach(node,dummy in commentaryNodes){
				if(getPointerEnt(player) == dummy){
					toggleNode(node)
				}
			}
		}
	}
}

lastNodeStemp <- 0
function toggleNode(node){
	if(Time() > lastNodeStemp + 0.5){
		if(!(NetProps.GetPropInt(node, "m_bActive") & 1)){
			DoEntFire("!self", "StartCommentary", "", 0, null, node)
		}else{
			NetProps.SetPropInt(node, "m_bActive", 0)
		}
		lastNodeStemp <- Time()
	}
}




// Think
// ----------------------------------------------------------------------------------------------------------------------------

function Think(){
	skeetFix()
	hurtChargers()
	drawInfectedHitbox()	
	getPlayersOnGroundStates()
	getPlayerChargingStates()
	playerIsHittingUSE()
	timedInfectedSpawning()
	setTankRockModel()
	autobhop()
	rockLauncherTimer()
	setInfectedOnFire()
	infiniteAmmo()
	throwableTracer()
	TankThrowSelector()
	KeyListener()
	RemoveBotSurvivors()
	perfectBhopCheck()
	BotWalkController()
	NadePrediction()
	SetSavedViewAngles()
	DistanceTracker()
	JumpListener()
	EntityListener()
}




// Noclip & Playerspawns
// ----------------------------------------------------------------------------------------------------------------------------

function noclipMe(ent){
	if(trainingActive){
		ClientPrint(null, 5, "Noclip is only allowed in edit mode")
		return
	}
	
	if(ent.IsDying() || ent.IsDead()){
		ClientPrint(null, 5, "Noclip cannot be enabled while dying / while being dead!")
		return	
	}
	
	if(!IsNoclipping(ent)){
		SetIsNoclipping(ent, true)
		ClientPrint(null, 5, BLUE + "Noclip enabled for " + ent.GetPlayerName())
	}else{
		if(isPointerValid(ent.GetOrigin(), 16, 96, ent)){
			SetIsNoclipping(ent, false)
			ClientPrint(null, 5, BLUE + "Noclip disabled for " + ent.GetPlayerName())
		}else{
			ClientPrint(null, 5, "Disabling noclip in solids/clip brushes is forbidden")
		}
	}
}

function IsNoclipping(ent){
	return (NetProps.GetPropInt(ent, "movetype") == 8)
}

function SetIsNoclipping(ent, val){
	NetProps.SetPropInt(ent, "movetype", (val ? 8 : 2))	
}




function disableNoclipAndTeleportToStart(){
	foreach(ent in GetSurvivors()){
		if(NetProps.GetPropInt(ent, "movetype") == 8){
			NetProps.SetPropInt(ent, "movetype", 2)
			if(ent in savedPlayerPositions){
				ent.SetOrigin(savedPlayerPositions[ent].pos);	
				ent.SnapEyeAngles(savedPlayerPositions[ent].ang);
			}
		}
	}
}


::setSpawnForEveryPlayer <- function(){
	foreach(ent in GetHumanSurvivors()){
		if(!(ent in savedPlayerPositions)){
			savedPlayerPositions[ent] <- { pos = ent.GetOrigin(), ang = ent.EyeAngles() }
		}
	}
}




// Spawn an infected on demand when training is disabled
// ----------------------------------------------------------------------------------------------------------------------------

function spawnUncommonInfected(num, pos){
	local zombieName = getZombieNameFromInt(num)
	local uncommonSpawner = Entities.FindByName(null, "uncommonSpawner");
	if(uncommonSpawner == null){
		uncommonSpawner = SpawnEntityFromTable("commentary_zombie_spawner", { origin = pos, angles = "0 0 0", targetname = "uncommonSpawner" })
	}else{
		uncommonSpawner.SetOrigin(pos)
	}

	EntFire("uncommonSpawner", "spawnzombie", zombieName, 0);

	if(getCommonCount() < SessionOptions.CommonLimit){
		return true
	}
	return false;
}




// Print the selected set of chatcommands to the chat
// ----------------------------------------------------------------------------------------------------------------------------

function showCommands(player,selection){
	local selected = ""
	//
	local categoryTXT = "" +
	"!weapons, !melees, !spawns, !misc, !guides, !debug, !infected"
	local weaponTXT = "" +
	"!huntingrifle,!autosniper,!deagle,!pistol,!ak,!scar,!rifle,!chrome,!pump," +
	"!autoshotty,!spas,!silenced,!smg,!scout,!awp,!sg,!mp5,!m60"
	local meleeTXT = "" +
	"!golfclub,!pan,!bat,!cricket,!tonfa,!guitar,!machete,!fireaxe," +
	"!katana,!crowbar,!shovel,!pitchfork"
	local spawnTXT = "" +
	"!hunter,!smoker,!jockey,!charger,!boomer,!spitter,!tank,!witch," +
	"!riot,!mud,!clown,!ceda,!jimmy,!fallen,!roadcrew,!redo,!undo,!undoall"
	local miscTXT = "" +
	"!training,!noclip,!savepos,!loadpos,!saferoomtoggle,!toggleparticles,!toggledummyangles,!autobhop," +
	"!huntervariant <num> e.g. !huntervariant 2"
	local debugTXT = "" +
	"!falldamagedebug,!penetrationtest,!boomerdebug,!smokerdebug,!tankdebug," +
	"!infernodebug,!meleedebug,!hitboxdebug,!fastclear,!escaperoute"
	local guidesTXT = "" + 
	"!skeeting,!leveling,!crowning,!tonguecutting,!deadstopping,!intro,!stopcommentary"
	local infectedTXT = "!become<infectedname> e.g. !becomehunter,!tankrockselector"
	
	switch(selection){
		case "commands"	:	selected = categoryTXT;	break
		case "melees"	:	selected = meleeTXT;	break
		case "weapons"	:	selected = weaponTXT;	break
		case "spawns"	:	selected = spawnTXT;	break
		case "misc"		:	selected = miscTXT;		break
		case "debug"	:	selected = debugTXT;	break
		case "guides"	:	selected = guidesTXT;	break
		case "infected"	:	selected = infectedTXT;	break
	}
	ClientPrint(player, 5, BLUE + selected)
}






printAsci();

__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)






