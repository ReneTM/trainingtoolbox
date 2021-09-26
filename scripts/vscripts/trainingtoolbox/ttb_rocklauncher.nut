//****************************************************************************************
//																						//
//								ttb_rocketlauncher.nut									//
//																						//
//****************************************************************************************

local rockLaunchers = {}	
local targetSpawned = false

// Create a rock launcher with an interval of x
// ----------------------------------------------------------------------------------------------------------------------------

function createTankRockLauncher(player, time){
	local pointer = getPointerPos(player)
	if(!(isNumeric(time))){
		ClientPrint(null, 5, "Invalid parameter: >" + time + "<")
		return
	}
	
	time = time.tointeger()
	
	if(!(time >= 4) || !(time <= 16)){
		ClientPrint(null, 5, "Tank rock launcher interval has to be between 4 and 16 seconds!" )
		return
	}
	
	
	if(isPointerValid(pointer, 32, 256, player)){
		
		if(!distanceToOtherRockSpawnsValid(pointer + Vector(0,0,256))){
			sendWarning(player, "Distance to next tank rock spawner is too small")
			return
		}
		
		if(!trainingActive){
			if(rockLaunchers.len() < 4){
				
				local model = "";
				if(tankThrowsLogs){
					model = "models/props_foliage/tree_trunk.mdl"
				}else{
					model = "models/props_debris/concrete_chunk01a.mdl"
				}
				
				local rockLauncherTable = 	
				{
					origin = pointer + Vector(0,0,256), angles = "-90 90 0", body = 0, DefaultAnim = "idle",DisableBoneFollowers = 1, disablereceiveshadows = 1, disableshadows = 1, disableX360 = 0,
					ExplodeDamage = 0, ExplodeRadius = 0, fademaxdist = 0, fademindist = -1, fadescale = 1, glowbackfacemult = 1.0, // glowcolor = "0 255 0",
					glowrange = 0, glowrangemin = 0, glowstate = 3, health = 0, LagCompensate = 0, MaxAnimTime = 10, maxcpulevel = 0, maxgpulevel = 0, MinAnimTime = 5,
					mincpulevel = 0, mingpulevel = 0, model = model, PerformanceMode = 0, pressuredelay = 0,
					RandomAnimation = 0, renderamt = 255, rendercolor = "255 255 255", renderfx = 0, rendermode = 1, SetBodyGroup = 0, skin = 0,
					solid = 0, spawnflags = 0, updatechildren = 0
				}
			
				local launcherModel = SpawnEntityFromTable("prop_dynamic_override", rockLauncherTable)
				
				if(!targetSpawned){
					SpawnEntityFromTable("env_rock_launcher", { targetname = "ttb_rock_launcher_target", angles = "0 0 0", origin = Vector(0,0,0) } )
				}
				local Rocklauncher = SpawnEntityFromTable("env_rock_launcher", { targetname = "ttb_rock_launcher", angles = "0 0 0", origin = pointer + Vector(0,0,256) } )
				targetSpawned = true
				rockLaunchers[Rocklauncher] <- { launcher = Rocklauncher, dummy = launcherModel, launchTime = Time(), interval = time }
			}else{
				ClientPrint(null, 5, "Maximum of 4 rock launchers reached" )
			}
		}else{
			ClientPrint(null, 5, "Disable training to create a rock launcher" )
		}
	}else{
		ClientPrint(null, 5, "Launching rocks requires space. Try it somewhere with more spaaaace!" )
	}
}




// Timer for the rock spawners
// ----------------------------------------------------------------------------------------------------------------------------

rockLauncherTimeStamp <- Time()

function rockLauncherTimer(){
	if(!trainingActive){

		foreach(rocklauncher in rockLaunchers){
			if(Time() >= rocklauncher.launchTime + rocklauncher.interval){
				Entities.FindByName(null, "ttb_rock_launcher_target").SetOrigin(rocklauncher.dummy.GetOrigin() + getRockSpawnerDirection() )
				DoEntFire("!self", "SetTarget", "ttb_rock_launcher_target", 0, rocklauncher.launcher, rocklauncher.launcher)
				DoEntFire("!self", "LaunchRock", "", 0 ,rocklauncher.launcher, rocklauncher.launcher)
				rockLauncherTimeStamp = Time()
				rocklauncher.launchTime = Time() + RandomFloat(0.25, 0.75)
			}
		}
	}
}




// Undo all rock launchers
// ----------------------------------------------------------------------------------------------------------------------------

function removeRockLaunchers(){
	if(rockLaunchers.len() > 0){
		foreach(rockLauncher in rockLaunchers){
			rockLauncher.dummy.Kill()
			rockLauncher.launcher.Kill()
		}
		rockLaunchers.clear()
		ClientPrint(null, 5, BLUE + "All rock launchers have been removed!" )
	}else{
		ClientPrint(null, 5, "There are no rock launchers to remove!" )
	}
}




// Returns one of the four cardinal points or a random direction with Z being positive
// ----------------------------------------------------------------------------------------------------------------------------

local rockLauncherDirection = 0

function getRockSpawnerDirection(){
	switch(rockLauncherDirection){
		case 0:	return Vector(RandomInt(-32, 32),RandomInt(-32, 32),RandomInt(0, 8)); break;
		case 1: return Vector(-16,0,2);		break;
		case 2: return Vector(0,16,2);		break;
		case 3: return Vector(16,0,2);		break;
		case 4: return Vector(0,-16,2);		break;
	}
}




// Change direction of the spawning rocks
// ----------------------------------------------------------------------------------------------------------------------------

function rockLauncherDirToggle(num){
	
	if(!(isNumeric(num))){
		ClientPrint(null, 5, "Invalid parameter: >" + num + "<")
		return;
	}
	
	num = num.tointeger()
	
	if(num < 0 || num > 4){
		ClientPrint(null, 5, "Invalid rock direction! -> 1-4 for directions and 0 for random! <- ")
		return;
	}
	if(num == rockLauncherDirection){
		ClientPrint(null, 5, "The current direction is already " + num )
		return;
	}
	ClientPrint(null, 5, WHITE + "Direction of rocks set from " + BLUE + rockLauncherDirection + WHITE + " to " + BLUE + num )
	rockLauncherDirection = num
}




// We dont want to create rock spawners too close to others
// ----------------------------------------------------------------------------------------------------------------------------

function distanceToOtherRockSpawnsValid(pointer){
	if(rockLaunchers.len() == 0){
		return true
	}else{
		foreach(dataset in rockLaunchers){
			if((dataset.launcher.GetOrigin() - pointer).Length() < 96 ){
				return false
			}
		}
		return true
	}
}

