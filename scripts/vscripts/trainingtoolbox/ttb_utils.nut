//****************************************************************************************
//																						//
//										ttb_utils.nut									//
//																						//
//****************************************************************************************




// Makes sure entity got a script scope and returns it
// ----------------------------------------------------------------------------------------------------------------------------

::GetValidatedScriptScope <- function(ent){
	ent.ValidateScriptScope()
	return ent.GetScriptScope()
}




// Survivor frag stats
// ----------------------------------------------------------------------------------------------------------------------------

survivorFrags <- {}

function recordSurvivorFrags(params){
	
	if("attackerentid" in params || !("attacker" in params)){
		return;
	}
	
	if(!("victimname" in params) || params.victimname == ""){
		return;
	}
	
	local attacker = GetPlayerFromUserID(params.attacker)

	if(!IsEntityValid(attacker) || attacker.GetZombieType() != 9){
		return;
	}
	
	if(!(attacker in survivorFrags)){
		survivorFrags[attacker] <- { Jockey = 0 Hunter = 0 Smoker = 0 Charger = 0 Boomer = 0 Spitter = 0 Tank = 0 Witch = 0 Infected = 0 Headshots = 0 }	
	}
	
	if("userid" in params || "entityid" in params){
		local infectedName = params.victimname
		survivorFrags[attacker][infectedName]++
	}
	
	if("headshot" in params && params.headshot){
		survivorFrags[attacker]["Headshots"]++
	}
}




// Chat output for frag stats
// ----------------------------------------------------------------------------------------------------------------------------

function fragStatsOutput(player){
	if(!(player in survivorFrags)){
		if(IsEntityValid(player)){
			survivorFrags[player] <- { Jockey = 0 Hunter = 0 Smoker = 0 Charger = 0 Boomer = 0 Spitter = 0 Tank = 0 Witch = 0 Infected = 0 Headshots = 0 }	
		}
	}

	local frags = survivorFrags[player]
	local chatMsg = WHITE +
	"Jockeys: "		+ BLUE + frags.Jockey 	+ WHITE		+ ", " +
	"Hunters: "		+ BLUE + frags.Hunter	+ WHITE		+ ", " +
	"Smokers: "		+ BLUE + frags.Smoker	+ WHITE		+ ", " +
	"Chargers: "	+ BLUE + frags.Charger	+ WHITE		+ ", " +
	"Boomers: "		+ BLUE + frags.Boomer	+ WHITE		+ ", " +
	"Spitters: "	+ BLUE + frags.Spitter	+ WHITE		+ ", " +
	"Tanks: "		+ BLUE + frags.Tank		+ WHITE		+ ", " +
	"Witches: "		+ BLUE + frags.Witch	+ WHITE		+ ", " +
	"Commons: "		+ BLUE + frags.Infected	+ WHITE		+ ", " +
	"Headshots: "	+ BLUE + frags.Headshots + WHITE	+ ""
	
	ClientPrint(player, 5, chatMsg)

}




// Returns arrays of -> Look function name
// ----------------------------------------------------------------------------------------------------------------------------

::GetPlayers <- function(){
	local entities = []
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		if(IsEntityValid(ent)){
			entities.append(ent)
		}
	}
	return entities
}

::GetSurvivors <- function(){
	local entities = []
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		if(IsEntityValid(ent)){
			if(ent.GetZombieType() == 9){
				entities.append(ent)
			}
		}
	}
	return entities
}

::GetHumanSurvivors <- function(){
	local entities = []
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		if(IsEntityValid(ent)){
			if(ent.GetZombieType() == 9 && !IsPlayerABot(ent)){
				entities.append(ent)
			}	
		}
	}
	return entities
}

::GetHumanPlayers <- function(){
	local entities = []
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		if(!IsPlayerABot(ent)){
			if(IsEntityValid(ent)){
				entities.append(ent)
			}
		}
	}
	return entities
}

::GetBotSurvivors <- function(){
	local entities = []
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		if(IsEntityValid(ent)){
			if(IsPlayerABot(ent)){
				if(ent.IsSurvivor()){
					entities.append(ent)
				}
			}
		}
	}
	return entities
}

::GetInfected <- function(){
	local entities = []
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		if(IsEntityValid(ent)){
			if(ent.GetZombieType() != 9 && !ent.IsDying()){
				entities.append(ent)
			}
		}
	}
	return entities
}

::GetHumanInfected <- function(){
	local entities = []
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		if(ent.GetZombieType() != 9 && !ent.IsDying() && !IsPlayerABot(ent)){
			if(IsEntityValid(ent)){
				entities.append(ent)
			}
		}
	}
	return entities
}

::GetWitches <- function(){
	local entities = []
	local ent = null
	while(ent = Entities.FindByClassname(ent, "witch")){
		if(IsEntityValid(ent)){
			entities.append(ent)
		}
	}
	return entities
}

::GetTanks <- function(){
	local entities = []
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		if(IsEntityValid(ent)){
			if(ent.GetZombieType() == 8){
				entities.append(ent)
			}
		}
	}
	return entities
}

::getCommonCount <- function(){
	local common = null;
	local count = 0
	while(common = Entities.FindByClassname(common,"infected")){
		count++
	}
	return count
}




// Precache all survivor models
//-----------------------------------------------------------------------------------------------------------------------------

function precacheAllSurvivorModels(){
	foreach(survivor,table in survivorModelData){
		foreach(key, model in table){
			if(!IsModelPrecached(model)){
				PrecacheModel(model)
			}
		}
	}
}




// Precache all infected models
//-----------------------------------------------------------------------------------------------------------------------------

function precacheAllInfectedModels(){
	foreach(m in InfectedModels){
		local model = ( "models/infected/" + m + ".mdl" )
		if(!IsModelPrecached(model)){
			PrecacheModel(model)
		}
	}
}




// Precache CSS Weapoons so they deal damage
// ----------------------------------------------------------------------------------------------------------------------------

function precacheCSSWeapons(){
	PrecacheEntityFromTable({ classname = "weapon_sniper_awp" });
	PrecacheEntityFromTable({ classname = "weapon_sniper_scout" });
	PrecacheEntityFromTable({ classname = "weapon_smg_mp5" });
	PrecacheEntityFromTable({ classname = "weapon_rifle_sg552" });
}




// Validate survivor number
// ----------------------------------------------------------------------------------------------------------------------------

function ValidateSurvivor(ent){
	local pnum = NetProps.GetPropInt(ent, "m_survivorCharacter")
	if(pnum < 0 || pnum > 4){
		local freeSurvivors = GetAvailableCharacters()
		if(freeSurvivors.len() > 0){
			NetProps.SetPropInt(ent, "m_survivorCharacter", freeSurvivors[0])
		}else{
			NetProps.SetPropInt(ent, "m_survivorCharacter", 0)
		}
	}
}

	/*

	Director.GetSurvivorSet() == 1

	0 - Bill
	1 - Zoey
	2 - Louis
	3 - Francis

	Director.GetSurvivorSet() == 2

	0 - Nick 
	1 - Rochelle
	2 - Coach
	3 - Ellis 
	-----------------
	4 - Bill
	5 - crash Bandicoot
	6 - Francis
	7 - Louis
	 
	5 - will always crash the game

	*/


// Return array with available survivor numbers
// ----------------------------------------------------------------------------------------------------------------------------

function GetAvailableCharacters(){
	local numbers = [ 0, 1, 2, 3 ]
	foreach(ent in GetSurvivors()){
		local pnum = NetProps.GetPropInt(ent, "m_survivorCharacter")
		if(numbers.find(pnum) != null){
			numbers.remove(numbers.find(pnum))
		}
		
	}
	return numbers
}




// Change survivor 
// ----------------------------------------------------------------------------------------------------------------------------

function SwitchSurvivor(ent, name){
	
	local Survivors1 = ["francis","bill","louis","zoey"]
	local Survivors2 = ["ellis","coach","nick","rochelle"]
	
	if(Director.GetSurvivorSet() == 1){
		if(Survivors2.find(name) != null){
			ClientPrint(null, 5, ORANGE + "Please select a L4D1 character")
			return
		}
	}
	if(Director.GetSurvivorSet() == 2){
		if(Survivors1.find(name) != null){
			ClientPrint(null, 5, ORANGE + "Please select a L4D2 character")
			return
		}
	}
	
	if(!ent.IsSurvivor()){
		ClientPrint(null, 5, ORANGE + "You have to be a survivor to switch the character")
		return
	}
	
	NetProps.SetPropInt(ent, "m_survivorCharacter", survivorIndices[name])
	
	SetViewmodel(ent, survivorModelData[name].v_model)
	SetWorldModel(ent, survivorModelData[name].w_model)
	killEntireLoadout(ent)
	GiveWeaponsNextTick()
}




// Return true if the current map is a "night time map"
// ----------------------------------------------------------------------------------------------------------------------------

// 0 - Midnight, 1 - Dawn, 2 - Morning, 3 - Afternoon, 4 - Dusk, 5 - Evening  ( Sitting witch spawn (0,1,5) )

function isNightTime(){
	local worldspawn = Entities.FindByClassname(null, "worldspawn")
	local time = NetProps.GetPropInt(worldspawn, "m_iTimeOfDay")
	// Daytime -> 2,3,4
	if(time == 0 || time == 1 || time == 5){
		return true;
	}
	return false;
}




// Creates the think timer which calls "Think()" every tick
// ----------------------------------------------------------------------------------------------------------------------------

function createThinkTimer(){
	local timer = null;
	while(timer = Entities.FindByName(null, "thinkTimer")){
		timer.Kill()
	}
	timer = SpawnEntityFromTable("logic_timer", { targetname = "thinkTimer", RefireTime = 0.01 })
	timer.ValidateScriptScope()
	timer.GetScriptScope()["scope"] <-	this

	timer.GetScriptScope()["func"]	<-	function(){
		scope.Think()
	}
	timer.ConnectOutput("OnTimer", "func")
	EntFire("!self", "Enable", null, 0, timer)
}




// Toggle between daytimes
// ----------------------------------------------------------------------------------------------------------------------------

function toggleDayTime(){
	if(!trainingActive){
		if(isNightTime()){
			ClientPrint(null, 5, BLUE + "Daytime set to afternoon. Only wandering witches will spawn.")
			witchPoseSwitch("day")
			replaceWitches()
		}else{
			ClientPrint(null, 5, BLUE + "Daytime set to night. Only sitting witches will spawn.")
			witchPoseSwitch("night")
			replaceWitches()
		}
	}else{
		ClientPrint(null, 5, "Switching between day times is only possible in editmode")
	}
}

function replaceWitches(){
	local witch = null;
	local witchPositions = []
	while(witch = Entities.FindByClassname(witch,"Witch")){
		witchPositions.append(witch.GetOrigin())
		witch.Kill()
	}
	foreach(position in witchPositions){
		ZSpawn({ type = 7, pos = position, ang = QAngle(0,0,0)})
	}
}




// // Remove all deathcams e.g on c8m5_rooftop
// ----------------------------------------------------------------------------------------------------------------------------

function removeDeathFallCameras(){
	local deathCam = null;
	while(deathCam = Entities.FindByClassname(deathCam, "point_deathfall_camera")){
		deathCam.Kill()
	}
}




// Removes all trigger_hurt's
// ----------------------------------------------------------------------------------------------------------------------------

function removeOuchees(){
	local ouchee = null;
	while(ouchee = Entities.FindByClassname(ouchee, "trigger_hurt")){
		ouchee.Kill()
	}
}




// Mostly usefull for presentation purposes this will toggle between different orientations of the infected preview models
// ----------------------------------------------------------------------------------------------------------------------------

dummyAngleCounter <- 0

function toggleDummyAngles(){
	if(dummyAngleCounter >= 4){
		dummyAngleCounter = 0;
	}
	if(!trainingActive){
		switch(dummyAngleCounter){
			case 0: dummyAngles = "0 90 0"; ClientPrint(null, 5, BLUE + "Next dummy-angles: " + dummyAngles); break;
			case 1: dummyAngles = "0 180 0"; ClientPrint(null, 5, BLUE + "Next dummy-angles: " + dummyAngles); break;
			case 2: dummyAngles = "0 270 0"; ClientPrint(null, 5, BLUE + "Next dummy-angles: " + dummyAngles); break;
			case 3: dummyAngles = "0 0 0"; ClientPrint(null, 5, BLUE + "Next dummy-angles: " + dummyAngles); break;
		}
		dummyAngleCounter++;
	}else{
		ClientPrint(null, 5, "Changing the dummy-angles is only available in edit mode")
	}
}


// Save survivors position 
// ----------------------------------------------------------------------------------------------------------------------------

function setPlayerStart(){
	if(!trainingActive){
		if(getNoclippingPlayers().len() == 0){
			if(getFloatingPlayers().len() == 0){
				foreach(player in GetPlayers()){
					savedPlayerPositions[player] <- {pos = player.GetOrigin(), ang = player.EyeAngles() }
				}
				ClientPrint(null, 5, BLUE + "Startposition has been set")

			}else{
				ClientPrint(null, 5, "Touch the ground to set spawnpositions")
			}
		}else{
			ClientPrint(null, 5, "Disable noclip to set spawnpositions")
		}
	}
	else{
		ClientPrint(null, 5, "Type !training to enter edit mode")
	}
}

function getNoclippingPlayers(){
	local noClippingPlayers = []
	foreach(player in GetPlayers()){
		if(NetProps.GetPropInt(player, "movetype") == 8){
			noClippingPlayers.append(player)
		}
	}
	return noClippingPlayers
}



function getFloatingPlayers(){
	local playerGroundStates = []
	foreach(player in GetPlayers()){
		if(getLastGroundState(player) == 0){
			playerGroundStates.append(player)
		}
	}
	return playerGroundStates
}




// Save / load player's positions
// ----------------------------------------------------------------------------------------------------------------------------

function savePlayerPosition(player){
	if(!trainingActive){
		if(getNoclippingPlayers().find(player) == null){
			if(getFloatingPlayers().find(player) == null){
				if(!playerIsCapped(player)){
					savedPlayerPositions[player] <- { pos = player.GetOrigin(), ang = player.EyeAngles() }
					ClientPrint(player, 5, BLUE + "Position saved")
				}else{
					ClientPrint(player, 5, "You cannot save your position while being capped")
				}
			}else{
				ClientPrint(player, 5, "Touch the ground to save your position")
			}
		}else{
			ClientPrint(player, 5, "Disable noclip to save your position")
		}
	}else{
		ClientPrint(player, 5, "Saving positions is only available in non-training mode")
	}
}

function loadPlayerPosition(player){
	if(!trainingActive){
		if(player in savedPlayerPositions){
			if(!playerIsCapped(player)){
				player.SetOrigin(savedPlayerPositions[player].pos)
				player.SnapEyeAngles(savedPlayerPositions[player].ang)
			}else{
				ClientPrint(player, 5, "You cannot load a saved position while being capped")
			}
		}else{
			ClientPrint(player, 5, "No saved position yet")
		}
	}else{
		ClientPrint(player, 5, "Saving positions is only available in non-training mode")
	}
}




// Teleport player to infobrush and back to his previous position
// ----------------------------------------------------------------------------------------------------------------------------

::teleportToggleData <- {}

function teleport2InfoToggle(player){
	if(IsValveMap()){
		if(!trainingActive){
			if(getNoclippingPlayers().find(player) == null){
				if(getFloatingPlayers().find(player) == null){
					if(!playerIsCapped(player)){
						if(player in teleportToggleData){
							teleportPlayerBack(player)
							teleportToggleData.rawdelete(player)
						}else{
							teleportToggleData[player] <- { pos = player.GetOrigin(), ang = player.EyeAngles() }
							teleportPlayer2Saveroom(player)	
						}
					}else{
						ClientPrint(player, 5, "Jumping to the saferoom is not possible while being capped")
					}
				}else{
					ClientPrint(player, 5, "Touch the ground to toggle between your current position and the saferoom")
				}
			}
			else{
				ClientPrint(player, 5, "Disable noclip to toggle between your current position and the saferoom")
			}
		}else{
			ClientPrint(player, 5, "This feature is only available in non-training mode")
		}
	}else{
		ClientPrint(player, 5, "This feature is only available on official maps")
	}
}




saveRoomPositions <-
{
	c1m1_hotel		 		= { pos = Vector(280.840668, 5870.486816, 2752.031250), ang = QAngle(2, 90.000000, 0.000000) }
	c1m2_streets 			= { pos = Vector(2517.282227, 5051.012695, 448.031250), ang = QAngle(2, 0.000000, 0.000000) }
	c1m3_mall				= { pos = Vector(6931.743652, -1454.937744, 24.031250), ang = QAngle(1.999512, 0.000000, 0.000000) }
	c1m4_atrium				= { pos = Vector(-2022.845215, -4812.447266, 536.031250), ang = QAngle(1.999512, -90.000000, 0.000000) }
	c2m1_highway			= { pos = Vector(9738.009766, 7752.120605, -514.287537), ang = QAngle(-19.995117, 180.000000, 0.000000) }
	c2m2_fairgrounds		= { pos = Vector(1650.413452, 2623.981689, 4.031250), ang = QAngle(1.999512, 0.000000, 0.000000) }
	c2m3_coaster			= { pos = Vector(4158.702637, 2084.268555, -63.968750), ang = QAngle(-19.995117, 90.000000, 0.000000) }
	c2m4_barns				= { pos = Vector(3048.429443, 3336.136230, -187.968750), ang = QAngle(1.999512, -90.000000, 0.000000) }
	c2m5_concert			= { pos = Vector(-1314.676758, 2162.167480, -255.968781), ang = QAngle(1.999512, 90.000000, 0.000000) }
	c3m1_plankcountry		= { pos = Vector(-11774.369141, 10368.047852, 160.031250), ang = QAngle(2, 0, 0.000000) }
	c3m2_swamp				= { pos = Vector(-8215.742188, 6920.124023, -29.278309), ang = QAngle(-9.997559, 180.000000, 0.000000) }
	c3m3_shantytown			= { pos = Vector(-5668.241699, 2050.451904, 136.031250), ang = QAngle(1.999512, 0.000000, 0.000000) }
	c3m4_plantation			= { pos = Vector(-4968.965820, -1599.401245, -96.811752), ang = QAngle(1.999512, 0.000000, 0.000000) }
	c4m1_milltown_a			= { pos = Vector(-6439.609375, 7636.567871, 96.034790), ang = QAngle(-9.997559, 0.000000, 0.000000) }
	c4m2_sugarmill_a		= { pos = Vector(3888.970703, -1762.402954, 179.441040), ang = QAngle(-14.996338, -90.000000, 0.000000) }
	c4m3_sugarmill_b		= { pos = Vector(-1837.481201, -13669.706055, 130.031250), ang = QAngle(1.999512, 90.000000, 0.000000) }
	c4m4_milltown_b			= { pos = Vector(3837.430908, -1512.233765, 232.281250), ang = QAngle(1.999512, 180.000000, 0.000000) }
	c4m5_milltown_escape	= { pos = Vector(-3208.121582, 7889.920898, 120.031250), ang = QAngle(1.999512, 90.000000, 0.000000) }
	c5m1_waterfront			= { pos = Vector(763.097839, 638.053589, -481.968750), ang = QAngle(1.999512, 180.000000, 0.000000) }
	c5m2_park				= { pos = Vector(-3833.819824, -1326.635254, -343.968750), ang = QAngle(1.999512, -90.000000, 0.000000) }
	c5m3_cemetery			= { pos = Vector(6313.389648, 8526.890625, 0.031250), ang = QAngle(1.999512, 180.000000, 0.000000) }
	c5m4_quarter			= { pos = Vector(-3388.004150, 4845.106445, 68.031250), ang = QAngle(1.999512, -90.000000, 0.000000) }
	c5m5_bridge				= { pos = Vector(-12085.923828, 5917.144043, 512.031250), ang = QAngle(-1.999512, 180.000000, 0.000000) }
	c6m1_riverbank			= { pos = Vector(1055.225220, 3762.806152, 96.031250), ang = QAngle(1.999512, 0.000000, 0.000000) }
	c6m2_bedlam				= { pos = Vector(2941.004395, -927.448547, -299.499084), ang = QAngle(-1.999512, 90.000000, 0.000000) }
	c6m3_port				= { pos = Vector(-2311.376953, -366.284058, -255.968750), ang = QAngle(1.999512, 90.000000, 0.000000) }
	c7m1_docks				= { pos = Vector(13657.449219, 2252.567627, -95.968750), ang = QAngle(1.999512, 180.000000, 0.000000) }
	c7m2_barge				= { pos = Vector(10612.922852, 1768.031250, 176.031250), ang = QAngle(1.999512, -90.000000, 0.000000) }
	c7m1_docks				= { pos = Vector(13657.449219, 2252.567627, -95.968750), ang = QAngle(1.999512, 180.000000, 0.000000) }
	c7m2_barge				= { pos = Vector(10612.922852, 1768.031250, 176.031250), ang = QAngle(1.999512, -90.000000, 0.000000) }
	c7m3_port				= { pos = Vector(1072.639771, 2832.305420, 121.381691), ang = QAngle(-6.998291, -90.000000, 0.000000) }
	c8m1_apartment			= { pos = Vector(1698.065918, 898.535400, 432.031250), ang = QAngle(-9.997559,-90.000000, 0.000000) }
	c8m2_subway				= { pos = Vector(3192.808594, 2870.590576, 11.470423), ang = QAngle(1.999512, 0.000000, 0.000000) }
	c8m3_sewers				= { pos = Vector(11165.782227, 4810.120605, 16.031250), ang = QAngle(-3.999023, 0.000000, 0.000000) }
	c8m4_interior			= { pos = Vector(12228.678711, 12582.234375, 16.031250), ang = QAngle(-1.999512, 180.000000, 0.000000) }
	c8m5_rooftop			= { pos = Vector(5396.156738, 8346.072266, 5536.031250), ang = QAngle(1.999512, -90.000000, 0.000000) }
	c9m1_alleys				= { pos = Vector(-10215.468750, -8637.849609, -0.688648), ang = QAngle(0.000000, 180.000000, 0.000000) }
	c9m2_lots				= { pos = Vector(249.039581, -1385.822144, -175.968750), ang = QAngle(1.999512, -90.000000, 0.000000 ) }
	c10m1_caves				= { pos = Vector(-11814.833984, -14743.941406, -209.635086), ang = QAngle(-14.996338, 180.000000, 0.000000) }
	c10m2_drainage			= { pos = Vector(-11313.030273, -8921.058594, -421.968750), ang = QAngle(24.999390, 90.000000, 0.000000) }
	c10m3_ranchhouse		= { pos = Vector(-8960.831055, -5635.114258, -63.968750), ang = QAngle(-1.999512, -90.000000, 0.000000) }
	c10m4_mainstreet		= { pos = Vector(-3139.802002, -206.748978, 320.031250), ang = QAngle(-1.999512, 180.000000, 0.000000) }
	c10m5_houseboat			= { pos = Vector(1911.789673, 4607.844238, -63.968750), ang = QAngle(0.999756, 180.000000, 0.000000) }
	c11m1_greenhouse		= { pos = Vector(6544.322266, -552.958801, 768.031250), ang = QAngle(1.999512, 180.000000, 0.000000) }
	c11m2_offices			= { pos = Vector(5565.384766, 2782.361328, 48.031250), ang = QAngle(2, 0.000000, 0.000000) }
	c11m3_garage			= { pos = Vector(-5296.158203, -3156.104492, 16.031250), ang = QAngle(2, 0, 0.000000) }
	c11m4_terminal			= { pos = Vector(-190.905106, 3527.132568, 296.031250), ang = QAngle(-9.997559, 0.000000, 0.000000) }
	c11m5_runway			= { pos = Vector(-5490.649902, 11736.214844, 48.075836), ang = QAngle(-1.999512, 0.000000, 0.000000) }
	c12m1_hilltop			= { pos = Vector(-8067.046875, -15007.224609, 296.322327), ang = QAngle(4, -180, 0.000000) }
	c12m2_traintunnel		= { pos = Vector(-6433.481934, -6901.271973, 348.031250), ang = QAngle(3.993530, 0.000000, 0.000000) }
	c12m3_bridge			= { pos = Vector(-963.049500, -10416.855469, -63.968750), ang = QAngle(1.999512, -90.000000, 0.000000) }
	c12m4_barn				= { pos = Vector(7648.781250, -11351.190430, 471.151642), ang = QAngle(1.999512, 90.000000, 0.000000) }
	c12m5_cornfield			= { pos = Vector(10415.913086, -21.257557, -63.968750), ang = QAngle(-10, -180, 0.000000) }
	c13m1_alpinecreek		= { pos = Vector(-3076.474365, -532.883667, 64.031250), ang = QAngle(-9.997559, 180.000000, 0.000000) }
	c13m2_southpinestream	= { pos = Vector(8542.220703, 7295.057617, 496.031250), ang = QAngle(1.999512, 180.000000, 0.000000) }
	c13m3_memorialbridge	= { pos = Vector(-4313.357910, -5206.936523, 96.031250), ang = QAngle(1.999512, -90.000000, 0.000000) }
	c13m4_cutthroatcreek	= { pos = Vector(-3307.884521, -8982.019531, 360.031250), ang = QAngle(1.999512, 90.000000, 0.000000) }
	c14m1_junkyard			= { pos = Vector(-4079.289307, -10618.912109, -296.229492), ang = QAngle(2.499390, 45.000000, 0.000000) }
	c14m2_lighthouse		= { pos = Vector(2162.415527, -1107.708984, 448.031250), ang = QAngle(-9.997559, -90.000000, 0.000000) }
}




function teleportPlayer2Saveroom(player){
	local currentMap = Director.GetMapName().tolower()
	player.SetOrigin(saveRoomPositions[currentMap].pos)
	player.SnapEyeAngles(saveRoomPositions[currentMap].ang)
}

function teleportPlayerBack(player){
	player.SetOrigin(teleportToggleData[player].pos)
	player.SnapEyeAngles(teleportToggleData[player].ang)
}




// Healing players
// ----------------------------------------------------------------------------------------------------------------------------

function healPlayer(player){
	player.ReviveFromIncap()
	player.SetHealth(100)
	player.SetHealthBuffer(0)
	player.SetReviveCount(0)
}

function healEverySurvivor(){
	foreach(survivor in GetSurvivors()){	
		survivor.ReviveFromIncap()
		survivor.SetHealth(100)
		survivor.SetHealthBuffer(0)
		survivor.SetReviveCount(0)
	}
}




// For all special and boss infected we count before and after the spawn to prevent particle drawing without a successful spawn.
// For commons we compare the current common infected count with the limit in the session table.
// Return value of ZSpawn is "true" even if the infected did not spawn due to the director limit.
// ----------------------------------------------------------------------------------------------------------------------------

function customZSpawn(spawner){
	
	local infNum = spawner.type
	local oldInfCount = 0
	local newInfCount = 0
	
	// Witches
	if(infNum == 7){	
		oldInfCount = GetWitches().len()
		ZSpawn(spawner)
		newInfCount = GetWitches().len() 
	}
	// Tanks
	else if(infNum == 8){	
		oldInfCount = GetTanks().len()
		ZSpawn(spawner)
		newInfCount = GetTanks().len() 
	}
	// Specials
	else if(infNum <= 8 && infNum != 0){
		oldInfCount = GetInfected().len()
		ZSpawn(spawner)
		newInfCount = GetInfected().len()
		
	}
	else if(infNum == 0){
		if(getCommonCount() < SessionOptions.CommonLimit){
			ZSpawn(spawner)
			return true
		}
	}

	return (newInfCount > oldInfCount);
}


function getZombieIntFromName(name){
	switch(name){
		case "smoker":						return 1;	break;
		case "boomer":						return 2;	break;
		case "hunter":						return 3;	break;
		case "spitter":						return 4;	break;
		case "jockey":						return 5;	break;
		case "charger":						return 6;	break;
		case "witch":						return 7;	break;
		case "tank":						return 8;	break;
		case "common_male_riot":			return 22;	break;
		case "common_male_ceda":			return 23;	break;
		case "common_male_mud":				return 24;	break;
		case "common_male_roadcrew":		return 25;	break;
		case "common_male_jimmy":			return 26;	break;
		case "common_male_clown":			return 27;	break;
		case "common_male_fallen_survivor": return 28;	break;
	}
}

function getZombieNameFromInt(num){
	switch(num){
		case 1:		return "smoker";						break;
		case 2:		return "boomer";						break;
		case 3:		return "hunter";						break;
		case 4:		return "spitter";						break;
		case 5:		return "jockey";						break;
		case 6: 	return "charger";						break;
		case 7:		return "witch";							break;
		case 8:		return "tank";							break;
		case 22:	return "common_male_riot";				break;
		case 23:	return "common_male_ceda";				break;
		case 24:	return "common_male_mud";				break;
		case 25:	return "common_male_roadcrew";			break;
		case 26:	return "common_male_jimmy";				break;
		case 27:	return "common_male_clown";				break;
		case 28:	return "common_male_fallen_survivor";	break;
	}
}




/*
	Because checking the on ground and charging state after death is not possible (seemingly)
	we store the states every tick so we can get the most recent on player death
	getLastGroundState(player) will return 0 for midair
	getLastChargingState(player) will return 1 while charging
*/


::onGroundStates <-  {}

::getLastGroundState <- function(player){
	local lastPlayersGroundState = null;

	if(player.tostring() in onGroundStates){
		lastPlayersGroundState = onGroundStates[player.tostring()]
		return lastPlayersGroundState
	}
}

::getPlayersOnGroundStates <- function(){
	local ent = null
	while (ent = Entities.FindByClassname(ent, "player")){
		if(IsEntityValid(ent)){
			if(!ent.IsDead() && ent.GetHealth() > 1){
				onGroundStates[ent.tostring()] <- (NetProps.GetPropInt(ent, "m_fFlags") & 1)
			}
		}
	}
}


::chargingStates <-  {}

::getLastChargingState <- function(ent){
	local lastPlayerChargingState = null
	if(ent.tostring() in chargingStates){
		lastPlayerChargingState = chargingStates[ent.tostring()]
		return lastPlayerChargingState
	}
}


::getPlayerChargingStates <- function(){
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		if(IsEntityValid(ent)){
			if(!ent.IsDead() && !ent.IsDying()){
				if(ent.GetZombieType() == 6){
					chargingStates[ent.tostring()] <- NetProps.GetPropInt(NetProps.GetPropEntity(ent, "m_customAbility"), "m_isCharging")
				}
			}
		}
	}
}




// Remove all infected
// ----------------------------------------------------------------------------------------------------------------------------

function removeAllInfected(){
	local player = null
	local witch = null
	local common = null
	while(player=Entities.FindByClassname(player, "player")){
		if(IsPlayerABot(player) && (player.GetZombieType() != 9)){
			player.Kill()
		}
	}
	while(witch=Entities.FindByClassname(witch, "witch")){
		if(IsEntityValid(witch)){
			witch.Kill()
		}
	}
	while(common = Entities.FindByClassname(common, "infected")){
		if(IsEntityValid(common)){
			common.Kill()
		}
	}
}




// Accessable through chat it removes all preview models and clears all spawns
// ----------------------------------------------------------------------------------------------------------------------------

function undoAllSpawnData(){
	if(!trainingActive){
		foreach(infected in InfectedData){
			local spawnModel = null
			while(spawnModel = Entities.FindByModel(spawnModel, infected.modelName)){
				if(IsEntityValid(spawnModel) && spawnModel.GetClassname() != "player"){
					spawnModel.Kill()
				}
			}
		}
		dummySpawnModels.clear()
		spawnPositionData.clear()
		zombieSpawnTypes.clear()
		spawnPositionDataHistory.clear()
		zombieSpawnTypesHistory.clear()
		KillAllDisplays()
		removeAllInfected()
		ClientPrint(null, 5, BLUE + "All present infected spawns have been removed")
	}else{
		ClientPrint(null, 5, "Undoing all positions is only available in non-training mode")
	}
}




// Since we limit the count of carryable items we want to remove default ones
// ----------------------------------------------------------------------------------------------------------------------------

function removeExplosives(){
	local items =
	[
		"models/props_equipment/oxygentank01.mdl",
		"models/props_junk/propanecanister001a.mdl",
		"models/props_junk/gascan001a.mdl"
	]
	foreach(model in items){
		local ent = null;
		while(ent = Entities.FindByModel(ent, model)){
			ent.Kill()
		}
	}
}




// Print a chat message in color x 
// ----------------------------------------------------------------------------------------------------------------------------

function toChat(color, message, sound){
	local player = Entities.FindByClassname(null,"player")
	switch(color)
	{
		case "white"	: color = "\x01" ; break
		case "blue"		: color = "\x03" ; break
		case "orange"	: color = "\x04" ; break
		case "green"	: color = "\x05" ; break
	}
	switch(sound)
	{
		case "reward"	: sound = "ui/littlereward.wav" ; break
		case "error"	: sound = "ui/beep_error01.wav" ; break
		case "click"	: sound = "ui/menu_click01.wav" ; break
	}
	ClientPrint(null, 5, color + message)
	if(sound != null){
		EmitAmbientSoundOn( sound, 1, 100, 100, player)
	}
}




// All needed cvars for mutation
// ----------------------------------------------------------------------------------------------------------------------------

function setNeededCvars(){
	Convars.SetValue("survivor_max_incapacitated_count", 999)
	Convars.SetValue("z_cull_timeout", 30)
	Convars.SetValue("z_spawn_flow_limit", 999999)
	Convars.SetValue("director_no_death_check", 1)
	Convars.SetValue("director_spectate_specials", 1)
	//
	// Tank
	Convars.SetValue("sv_tankpropfade", 0)
	// Uncommon Infected
	Convars.SetValue("z_fallen_kill_suppress_time", 0)
	Convars.SetValue("z_fallen_max_count", 999999)
	// Hunter
	Convars.SetValue("z_hunter_lunge_distance", 2048)
	Convars.SetValue("hunter_pounce_ready_range", 4096)
	Convars.SetValue("hunter_committed_attack_range", 4096)
	// Let´s send hunters flying
	Convars.SetValue("phys_pushscale", 1)
}




// Is the current server a local one...
// ----------------------------------------------------------------------------------------------------------------------------

function OnLocalServer(){
	if(GetListenServerHost() == null){
		return false
	}
	return true
}




// Check if the current map is a valve map
// ----------------------------------------------------------------------------------------------------------------------------

::IsValveMap <- function(){
	local currentMap = Director.GetMapName().tolower()
	local valveMaps =
		[
			// DEAD CENTER
			"c1m1_hotel",
			"c1m2_streets",
			"c1m3_mall",
			"c1m4_atrium",
			// DARK CARNIVAL
			"c2m1_highway",
			"c2m2_fairgrounds",
			"c2m3_coaster",
			"c2m4_barns",
			"c2m5_concert",
			// SWAMP FEVER
			"c3m1_plankcountry",
			"c3m2_swamp",
			"c3m3_shantytown",
			"c3m4_plantation",
			// HARD RAIN
			"c4m1_milltown_a",
			"c4m2_sugarmill_a",
			"c4m3_sugarmill_b",
			"c4m4_milltown_b",
			"c4m5_milltown_escape",
			// THE PARISH
			"c5m1_waterfront",
			"c5m1_waterfront_sndscape",
			"c5m2_park",
			"c5m3_cemetery",
			"c5m4_quarter",
			"c5m5_bridge",
			// THE PASSING
			"c6m1_riverbank",
			"c6m2_bedlam",
			"c6m3_port",
			// THE SACRIFICE
			"c7m1_docks",
			"c7m2_barge",
			"c7m3_port",
			// NO MERCY
			"c8m1_apartment",
			"c8m2_subway",
			"c8m3_sewers",
			"c8m4_interior",
			"c8m5_rooftop",
			// CRASH COURSE
			"c9m1_alleys",
			"c9m2_lots",
			// DEATH TOLL
			"c10m1_caves",
			"c10m2_drainage",
			"c10m3_ranchhouse",
			"c10m4_mainstreet",
			"c10m5_houseboat",
			// DEAD AIR
			"c11m1_greenhouse",
			"c11m2_offices",
			"c11m3_garage",
			"c11m4_terminal",
			"c11m5_runway",
			// BLOOD HARVEST
			"c12m1_hilltop",
			"c12m2_traintunnel",
			"c12m3_bridge",
			"c12m4_barn",
			"c12m5_cornfield",
			// COLD STREAM
			"c13m1_alpinecreek",
			"c13m2_southpinestream",
			"c13m3_memorialbridge",
			"c13m4_cutthroatcreek",
			// THE LAST STAND
			"c14m1_junkyard",
			"c14m2_lighthouse"
		]
	if (valveMaps.find(currentMap) == null){
		return false
	}
	return true
}




// Check if theres an intro scene playing
// ----------------------------------------------------------------------------------------------------------------------------

function introSceneActive(){
	return NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_bInIntro")
}




// Check if player is victim of any special infected
// ----------------------------------------------------------------------------------------------------------------------------

function playerIsCapped(player){
	local infected = null;
	local keys = ["m_pummelVictim","m_carryVictim","m_pounceVictim","m_jockeyVictim","m_tongueVictim"]
	while(infected = Entities.FindByClassname(infected, "player")){
		if(infected.GetZombieType() != 9){
			foreach(key in keys){
				if(NetProps.GetPropEntity(infected, key) == player){
					return true
				}
			}
		}
	}
	return false
}




// When enabled it will change the model of "tank_rock" to a log
// ----------------------------------------------------------------------------------------------------------------------------

tankThrowsLogs <- false

function toggleTankThrowsLogs(){
	if(!trainingActive){
		tankThrowsLogs = !tankThrowsLogs
		ClientPrint(null, 5, BLUE + "Tank throwing logs " + ( tankThrowsLogs ? "Enabled" : "Disabled") )
	}else{
		ClientPrint(null, 5, "Disable the training to change this setting")
	}
	
	// Set present tank rock models to the right one
	
	local rock = null;
	
	if(tankThrowsLogs){
		while(rock = Entities.FindByModel(rock, "models/props_debris/concrete_chunk01a.mdl")){
			if(IsEntityValid(rock)){
				rock.SetModel("models/props_foliage/tree_trunk.mdl")
			}
		}
	}else{
		while(rock = Entities.FindByModel(rock, "models/props_foliage/tree_trunk.mdl")){
			if(IsEntityValid(rock)){
			rock.SetModel("models/props_debris/concrete_chunk01a.mdl")
			}
		}
	}

}

function setTankRockModel(){
	local rock = null;
	if(tankThrowsLogs){
		while(rock = Entities.FindByClassname(rock, "tank_rock")){
			if(IsEntityValid(rock)){
				rock.ValidateScriptScope()
				if(!("usesLog" in rock.GetScriptScope())){
					rock.SetModel("models/props_foliage/tree_trunk.mdl")
					rock.GetScriptScope()["usesLog"] <- true
				}
			}
		}
	}
}




// Create a fuel barrel on players crosshair position
// ----------------------------------------------------------------------------------------------------------------------------

function createFuelBarrel(player){

	if(trainingActive){
		ClientPrint(player, 5, "Disable the training to spawn fuel barrels")
		return
	}
	
	local barrel = null
	local count = 0
	local pointer = getPointerPos(player)
	local piece = null;
	
	// Clean up broken barrels
	local pieces = ["models/props_industrial/barrel_fuel_partb.mdl","models/props_industrial/barrel_fuel_parta.mdl"]
	foreach(model in pieces){
		while(piece = Entities.FindByModel(piece, model)){
			piece.Kill()
		}
	}
	
	// Count present barrels ( we allow 4 )
	while(barrel = Entities.FindByClassname(barrel, "prop_fuel_barrel")){
		count++
	}
	if(isPointerValid(pointer, 32, 96, player)){
		if(count < 4){
			local barrelTable =
			{
				origin = pointer + Vector(0,0,8)
				spawnflags = 0
				angles = "0 0 0"
				skin = 0
				BasePiece = "models/props_industrial/barrel_fuel_partb.mdl"
				model = "models/props_industrial/barrel_fuel.mdl"
				body = 0
				FlyingPiece01 = "models/props_industrial/barrel_fuel_parta.mdl"
				DetonateParticles = "weapon_pipebomb"
				FlyingParticles = "barrel_fly"
				DetonateSound = "BaseGrenade.Explode"
				fadescale = 0
				disableshadows = 0
				fademaxdist = 0
				fademindist = -1
			}
			local barrel = SpawnEntityFromTable("prop_fuel_barrel", barrelTable)
		}else{
			ClientPrint(null, 5, ORANGE + "Limit of explosive barrels has been reached")
		}
	}else{
		sendWarning(player, "Invalid Position!")
	}
}




// Output players lerp settings
// ----------------------------------------------------------------------------------------------------------------------------

function getPlayerRates(player){

	local playerRates =
	{
		cl_interp = Convars.GetClientConvarValue("cl_interp", player.GetEntityIndex()),
		cl_interp_ratio = Convars.GetClientConvarValue("cl_interp_ratio", player.GetEntityIndex()),
		rate = Convars.GetClientConvarValue("rate", player.GetEntityIndex()),
		cl_cmdrate = Convars.GetClientConvarValue("cl_cmdrate", player.GetEntityIndex()),
		cl_updaterate = Convars.GetClientConvarValue("cl_updaterate", player.GetEntityIndex())
	}
	
	foreach(cvar, val in playerRates){
		ClientPrint(player, 5, BLUE + "" + cvar + ": " + val);
	}
}




// Hold space for auto-bhop ( if enabled and player used atleast one mushroom )
// ----------------------------------------------------------------------------------------------------------------------------

::bunnyPlayers <- {}

function toggleBunnyHopForPlayer(player){
	if(player in bunnyPlayers){
		bunnyPlayers.rawdelete(player)
		ClientPrint(null, 5, BLUE + "Auto-BunnyHop has been disabled for " + player.GetPlayerName());
		NetProps.SetPropInt(player, "m_afButtonDisabled", NetProps.GetPropInt(player, "m_afButtonDisabled") & ~2)
	}else{
		bunnyPlayers[player] <- true
		ClientPrint(null, 5, BLUE + "Auto-BunnyHop has been enabled for " + player.GetPlayerName());
	}
}




function autobhop(){
	foreach(player in GetHumanPlayers())
	{
		if(player in bunnyPlayers)
		{
			if(!(NetProps.GetPropInt(player, "m_fFlags") & 1) && NetProps.GetPropInt(player, "movetype") == 2)
			{
				if(player.GetButtonMask() & 2)
				{
					player.OverrideFriction(0.033, 0)
				}
				NetProps.SetPropInt(player, "m_afButtonDisabled", NetProps.GetPropInt(player, "m_afButtonDisabled") | 2)
			} 
			else
			{
				NetProps.SetPropInt(player, "m_afButtonDisabled", NetProps.GetPropInt(player, "m_afButtonDisabled") & ~2)
			}
		}
	}
}




// Infinite Ammo
// ----------------------------------------------------------------------------------------------------------------------------

function infiniteAmmoToggle(player){
	player.ValidateScriptScope()
	local scope = player.GetScriptScope()
	
	if(!("infinite_ammo" in scope)){
		scope["infinite_ammo"] <- true
	}else{
		scope["infinite_ammo"] = !scope["infinite_ammo"]
	}
	ClientPrint(null, 5, WHITE + "Infinite ammo " + ( scope["infinite_ammo"] ? "enabled" : "disabled" ) + " for " + BLUE + player.GetPlayerName())
}




function infiniteAmmo(){
	foreach(player in GetHumanSurvivors()){
		player.ValidateScriptScope()
		local scope = player.GetScriptScope()
		if("infinite_ammo" in scope && scope["infinite_ammo"] == true){
			local wep = player.GetActiveWeapon()
			if(wep.GetClassname() != "weapon_melee"){
				wep.SetClip1(wep.GetMaxClip1())
			}
		}
	}
}




// Godmode
// ----------------------------------------------------------------------------------------------------------------------------

function toggleGodMode(ent){
	local playerscope = GetValidatedScriptScope(ent)
	if(!("godmode" in playerscope)){
		playerscope["godmode"] <- true
	}else{
		playerscope["godmode"] = !playerscope["godmode"]
	}
	ClientPrint(null, 5, WHITE + "Godmode has been " + BLUE + ( playerscope["godmode"] ? "enabled" : "disabled" ) + WHITE + " for " + BLUE + ent.GetPlayerName() )
}

function HasGodModeEnabled(ent){
	local playerscope = GetValidatedScriptScope(ent)
	if(!("godmode" in playerscope)){
		return false
	}else{
		return playerscope["godmode"]
	}
}




// Burning infected
// ----------------------------------------------------------------------------------------------------------------------------

burningInfected <- false

function burningInfectedToggle(){
	burningInfected = !burningInfected
	ClientPrint(null, 5, WHITE + "Burning special infected have been " + BLUE + (burningInfected ? "enabled" : "disabled"))
}




function setInfectedOnFire(){
	if(burningInfected){
		foreach(player in GetInfected()){
			if(!(player.IsOnFire())){
				DoEntFire("!self", "Ignite", "", 0, player, player)
			}
		}
	}
}




// Point at stuff
// ----------------------------------------------------------------------------------------------------------------------------

function makePing(ent){
	
	local playerscope = GetValidatedScriptScope(ent)
	
	if(!("ping_tool_last" in playerscope)){
		playerscope["ping_tool_last"] <- (Time() - 4.0)
	}
	
	if(Time() < playerscope["ping_tool_last"] + 4.0){
		return
	}
	
	playerscope["ping_tool_last"] = Time()
	
	local pointer = getPointerPos(ent)
	
	local sprite = SpawnEntityFromTable("env_sprite",{
			targetname = UniqueString("pingTarget_")
			origin = pointer
			disablereceiveshadows = 0
			disableX360 = 0
			fademaxdist = 0
			fademindist = -1
			spawnflags = 0
			fadescale = 0
			scale = 0.1
			framerate = 0
			rendermode = 9
			GlowProxySize = 0.0
			renderfx = 0
			HDRColorScale = 0.7
			rendercolor = Vector(255,0,0)
			maxcpulevel = 0
			renderamt = 255
			maxgpulevel = 0
			model = "materials/sprites/glow01.spr"
			mincpulevel = 0
			mingpulevel = 0
		})
	


	local laser = SpawnEntityFromTable("env_laser",{
		damage = 0
		dissolvetype = ""
		framestart = 0
		NoiseAmplitude = 0
		renderamt = 255
		rendercolor = Vector(255,255,255)
		width = 1
		renderfx = 0
		TextureScroll = 35
		spawnflags = 1
		texture = "sprites/laserbeam.spr"
		LaserTarget = sprite.GetName()
		origin = ((ent.EyePosition()) + (ent.EyeAngles().Forward()) * 64) 
	})		
	
	if(!IsSoundPrecached("player/laser_on.wav")){
		PrecacheSound("player/laser_on.wav")
	}
	
	EmitAmbientSoundOn("player/laser_on.wav", 1, 100, 180, ent)
	
	DoEntFire("!self", "showsprite", "", 0.03, sprite, sprite)
	DoEntFire("!self", "Kill", "", 7.0, sprite, sprite)
	DoEntFire("!self", "Kill", "", 7.0, laser, laser)
}




// Create a ceiling for orientation (ceiling jump)
// ----------------------------------------------------------------------------------------------------------------------------

ceilingMarkersModels <- []

function makeCeiling(ent){
	
	
	
	local playerscope = GetValidatedScriptScope(ent)
	
	if(!("ping_tool_last" in playerscope)){
		playerscope["ping_tool_last"] <- (Time() - 4.0)
	}
	
	if(Time() < playerscope["ping_tool_last"] + 4.0){
		return
	}
	
	if(trainingActive){
		ClientPrint(null, 5, ORANGE + "Disable the training to create ceiling markers!")
		return
	}
	
	ceilingMarkersModels = RemoveNullInstances(ceilingMarkersModels)
	
	if(ceilingMarkersModels.len() >= 5){
		ClientPrint(null, 5, ORANGE + "There are 5 markers already. Wait for them to disappear!")
		return
	}
	
	playerscope["ping_tool_last"] = Time()
	
	local pointer = getPointerPos(ent)
	
	if(!IsValidCeilingPosition(ent, pointer)){
		ClientPrint(null, 5, "Invalid ceiling position!")
		return
	}
	
	local model = SpawnEntityFromTable("prop_dynamic_override",{ origin = pointer + Vector(0,0,-2), model = "models/trainingtoolbox/signs/sign05.mdl", angles = "90 0 0", skin = 4})

	ceilingMarkersModels.append(model)

	DoEntFire("!self", "Kill", "", 240.0, model, model)
	ClientPrint(null, 5, ORANGE + "Ceiling marker will be killed in 4 Minutes")
	
	if(!IsSoundPrecached("player/laser_on.wav")){
		PrecacheSound("player/laser_on.wav")
	}
	
	EmitAmbientSoundOn("player/laser_on.wav", 1, 100, 180, ent)
}




// Check of pointer position points on a "horizontal ceiling"
// ----------------------------------------------------------------------------------------------------------------------------

function IsValidCeilingPosition(ent, pos){
	
	local startCenter = pos + Vector(0,0,-4)
	local start1 = startCenter + Vector(4,4,0)
	local start2 = startCenter + Vector(-4,-4,0)
	local start3 = startCenter + Vector(4,-4,0)
	local start4 = startCenter + Vector(-4,4,0)
	local end1 = start1 + Vector(0,0,5)
	local end2 = start2 + Vector(0,0,5)
	local end3 = start3 + Vector(0,0,5)
	local end4 = start4 + Vector(0,0,5)
	
	local traceTable1 = { start = start1, end = end1, ignore = ent, mask = TRACE_MASK_PLAYER_SOLID }
	local traceTable2 = { start = start2, end = end2, ignore = ent, mask = TRACE_MASK_PLAYER_SOLID }
	local traceTable3 = { start = start3, end = end3, ignore = ent, mask = TRACE_MASK_PLAYER_SOLID }
	local traceTable4 = { start = start4, end = end4, ignore = ent, mask = TRACE_MASK_PLAYER_SOLID }
	
	TraceLine(traceTable1)
	TraceLine(traceTable2)
	TraceLine(traceTable3)
	TraceLine(traceTable4)
	
	if(!("startsolid" in traceTable1) && !("startsolid" in traceTable2) && !("startsolid" in traceTable3) && !("startsolid" in traceTable4)){
		if("hit" in traceTable1 && traceTable1.hit){
			if("hit" in traceTable2 && traceTable2.hit){
				if("hit" in traceTable3 && traceTable3.hit){
					if("hit" in traceTable4 && traceTable4.hit){
						if(traceTable1.pos.z == traceTable2.pos.z && traceTable3.pos.z == traceTable4.pos.z && traceTable1.pos.z == traceTable4.pos.z){
							if("enthit" in traceTable1 && "enthit" in traceTable4){
								if(traceTable1.enthit.GetClassname() == "worldspawn"){
									if(traceTable4.enthit.GetClassname() == "worldspawn"){
										return true
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return false
}




// Change cvars from chat
// ----------------------------------------------------------------------------------------------------------------------------

function SetConvar(ent, param){
	if(ent != GetListenServerHost()){
		ClientPrint(null, 5, ORANGE + "Only the host is allowed to change cvars!")
		return
	}
	if(GetListenServerHost() == null){
		ClientPrint(null, 5, ORANGE + "It is only allowed to change cvars while playing locally!")
		return
	}
	
	local paramArr = split(param, "=")
	if(paramArr.len() != 2){
		ClientPrint(null, 5, "Correct syntax: !cvar var=val")
		return
	}
	
	local variable = paramArr[0]
	local val = paramArr[1]
	
	Convars.SetValue(variable,val)
	
	if(Convars.GetFloat(variable) == val){
		ClientPrint(null, 5, "Value changed!")
	}else{
		ClientPrint(null, 5, "Variable does not exist or cannot be changed!")
	}
}




// Do newlines in console
// ----------------------------------------------------------------------------------------------------------------------------

function doConNL(num){
	for(local i = 0; i<num;i++){
		print("\n")
	}
}




// Get Text in specified color with precolor
// ----------------------------------------------------------------------------------------------------------------------------

function ColorText(txt, textColor, nextColor){
	return (textColor + txt + nextColor)
}




// Return color as Vector
// ----------------------------------------------------------------------------------------------------------------------------

function ColorStringToVector(str){
	local clr = split(str, " ")
	return Vector(clr[0].tofloat(), clr[1].tofloat(), clr[2].tofloat())
}




// Remove null values in an array
// ----------------------------------------------------------------------------------------------------------------------------

function RemoveNullInstances(arr){
	local validInstances = []
	foreach(item in arr){
		if(IsEntityValid(item)){
			validInstances.append(item)
		}
	}
	return validInstances
}




// Toggle bots 
// ----------------------------------------------------------------------------------------------------------------------------

function SetAllowSurvivorBots(val){
	if(val == "1"){
		WriteToGlobalTable("AllowSurvivorBots", 1)
	}else{
		WriteToGlobalTable("AllowSurvivorBots", 0)
	}
	ClientPrint(null, 5, ORANGE + "Survivor bots have been " + ( (IsSetInGlobal("AllowSurvivorBots") && ttbGlobal["AllowSurvivorBots"] ) ? "enabled" : "disabled"))
}




// Remove AI Survivors (This is a workaround of cm_NoSurvivorBots = 1)
// ----------------------------------------------------------------------------------------------------------------------------

function RemoveBotSurvivors(){
	if(!IsSetInGlobal("AllowSurvivorBots") || (IsSetInGlobal("AllowSurvivorBots") && !ttbGlobal["AllowSurvivorBots"])){
		foreach(ent in GetBotSurvivors()){
			if(IsEntityValid(ent)){
				ent.Kill()
			}
		}
	}
}




// Remove null values in an array
// ----------------------------------------------------------------------------------------------------------------------------

::IsEntityValid <- function(ent){
	if(ent == null){
		return false
	}
	return ent.IsValid()
}




// Enable/Disable Player Damage output to chat
// ----------------------------------------------------------------------------------------------------------------------------

function ToggleShowDamage(){
	if(trainingActive){
		ClientPrint(null, 5, ORANGE + "Disable the training to change this setting!")
		return
	}
	printDamageToChat = !printDamageToChat
	ClientPrint(null, 5, WHITE + "Chat damage printing has been " + (printDamageToChat ? GREEN + "enabled" : ORANGE + "disabled"))
}




// Kick a player
// -----------------------------------------------------------------------------------------------------------------------------

function KickPlayer(ent, message){
	SendToServerConsole("kickid " + ent.GetPlayerUserId() + " " + message)
}




// Remove current weapon
// ----------------------------------------------------------------------------------------------------------------------------

function WeaponStrip(ent, all){
	if(IsEntityValid(ent)){
		if(ent.IsSurvivor() && !ent.IsDead() && !ent.IsDying()){
			if(all){
				local inv = {}
				GetInvTable(ent, inv)
				foreach(wepname, wep in inv){
					if(IsEntityValid(wep)){
						wep.Kill()
					}
				}
			}else{
				local wep = ent.GetActiveWeapon()
				if(IsEntityValid(wep)){
					wep.Kill()
				}
			}
		}
	}
}




// Play a screen effect
// ----------------------------------------------------------------------------------------------------------------------------

scrFx <- {
	classChange = {
		survivor = Vector(0, 50, 0)
		infected = Vector(50, 0, 0)
	},
	events = {
		
	}
}

function PlayScreenEffect(ent, fxColor){
	ScreenFade(ent, fxColor.x, fxColor.y, fxColor.z, 255, 1.0, 0.0, 1)
}




// Are you asciing for trouble?
// ----------------------------------------------------------------------------------------------------------------------------

function printAsci(){
	local asciTXT = ""+
	" ######## ########     ###    #### ##    ## #### ##    ##  ######     \n" +
	"    ##    ##     ##   ## ##    ##  ###   ##  ##  ###   ## ##    ##    \n" +
	"    ##    ##     ##  ##   ##   ##  ####  ##  ##  ####  ## ##          \n" +
	"    ##    ########  ##     ##  ##  ## ## ##  ##  ## ## ## ##   ####   \n" +
	"    ##    ##   ##   #########  ##  ##  ####  ##  ##  #### ##    ##    \n" +
	"    ##    ##    ##  ##     ##  ##  ##   ###  ##  ##   ### ##    ##    \n" +
	"    ##    ##     ## ##     ## #### ##    ## #### ##    ##  ######     \n" +
	"                                                                   ## \n" +
	" ########  #######   #######  ##       ########   #######  ##     ##  \n" +
	"    ##    ##     ## ##     ## ##       ##     ## ##     ##  ##   ##   \n" +
	"    ##    ##     ## ##     ## ##       ##     ## ##     ##   ## ##    \n" +
	"    ##    ##     ## ##     ## ##       ########  ##     ##    ###     \n" +
	"    ##    ##     ## ##     ## ##       ##     ## ##     ##   ## ##    \n" +
	"    ##    ##     ## ##     ## ##       ##     ## ##     ##  ##   ##   \n" +
	"    ##     #######   #######  ######## ########   #######  ##     ##  \n" +
	"                                                          ##          \n" +
	"                           Made by ReneTM"
	doConNL(4)
	print(asciTXT)
	doConNL(4)
}
