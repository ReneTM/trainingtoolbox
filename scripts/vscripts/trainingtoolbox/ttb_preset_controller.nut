//****************************************************************************************
//																						//
//								ttb_preset_controller.nut								//
//																						//
//****************************************************************************************

local mapName = Director.GetMapName().tolower()
local presetPath = "trainingtoolbox/presets/" + mapName + "/"





// Save preset for every map
// ----------------------------------------------------------------------------------------------------------------------------

function savePreset(ent, filename_user){
	
	if(!presetsAllowed(ent)){
		return;
	}
	
	if(spawnPositionData.len() == 0){
		ClientPrint(null, 5, "Saving a preset requires atleast one spawn!")
		return;
	}
	
	if(filename_user == null){
		ClientPrint(null, 5, "Correct usage -> !savepreset <presetname>")
		return;
	}
	
	if(!fileNameOkay(filename_user)){
		ClientPrint(null, 5, "Allowed characters: < 0-9 >, < a-z >, < _ >")
		return
	}
	
	if(filename_user.len() > 16 || filename_user.len() < 1){
		ClientPrint(null, 5, "Allowed length of preset name is 1-16 characters!")
	}
	
	local text =
	
	"::presetFromFile <-" + "\n" +
	"[" + "\n"
	
	foreach(dataSet in spawnPositionData){
		text = text +
		"{ type = " + dataSet.type + ", pos = " + GetVectorAsString(dataSet.pos) + ", spawntime = " + dataSet.spawntime + "}" + "\n"
	}
	
	text += "]"

	StringToFile(presetPath + filename_user + ".txt", text)
	ClientPrint(null, 5, WHITE + "Preset has been saved:" + "\n" + BLUE + "Left_4_Dead_2/left4dead2/ems/trainingtoolbox/presets/" + mapName +"/" + filename_user + ".txt")
}




// Save preset for every map
// ----------------------------------------------------------------------------------------------------------------------------

function loadPreset(ent, filename_user){

	if(!presetsAllowed(ent)){
		return;
	}

	if(spawnPositionData.len() > 0){
		ClientPrint(null, 5, "Remove all spawns with !undoall before loading a preset file!")
		return;
	}
	
	if(filename_user == null){
		ClientPrint(null, 5, "Correct usage -> !loadpreset <presetname>")
		return;
	}
	
	if(!fileNameOkay(filename_user)){
		ClientPrint(null, 5, "Allowed characters: < 0-9 >, < a-z >, < _ >")
		return
	}
	
	if(filename_user.len() > 16 || filename_user.len() < 1){
		ClientPrint(null, 5, "Allowed length of preset name is 1-16 characters!")
	}
	
	if(FileToString(presetPath + filename_user + ".txt") != null){
		
		try
		{
			local compiledscript = compilestring(FileToString(presetPath + filename_user + ".txt"))
			compiledscript();
		}
		catch(exception){
			ClientPrint(null, 5, "The preset file seems to be invalid!")
			return;
		}

		
		if(presetFromFile.len() > 32){
			ClientPrint(null, 5, "Found " + presetFromFile.len() + "infected spawns in preset file.")
			ClientPrint(null, 5, "The limit for infected spawns is 32!")
			return;
		}
		
		foreach(dataSet in presetFromFile){
			local infectedData = getInfectedData(dataSet.type)
			local spawnModel = createStatue(infectedData)
			local displayColor = infectedData.modelGlowColor
			DoEntFire("!self", "Alpha", dummyAlpha, 0, spawnModel, spawnModel)
			createZombieSpawn(infectedData, dataSet.pos, dataSet.spawntime, displayColor)
			spawnModel.SetOrigin(dataSet.pos)
			dummySpawnModels.append(spawnModel)
			zombieSpawnTypes.append(infectedData)
		}
	}else{
		ClientPrint(null, 5, "Theres no preset file called \"" + filename_user + ".txt\" for the current map!")
	}
}




// Only allow saving / loading presets on local servers for the host with training being disabled
// ----------------------------------------------------------------------------------------------------------------------------

function presetsAllowed(ent){
	if(!trainingActive){
		if(OnLocalServer()){
			if(ent == GetListenServerHost()){
				return true;
			}else{
				ClientPrint(null, 5, "Saving and loading preset files is only avalable for the local hosting player!")
				return false;
			}
		}else{
			ClientPrint(null, 5, "Saving and loading preset files is only avalable for the local hosting player!")
			return false;
		}
	}else{
		ClientPrint(null, 5, "Disable the training to save / load any presets!")
		return false;
	}
}




// Returns required infected data
// ----------------------------------------------------------------------------------------------------------------------------

function getInfectedData(num){
	foreach(dataSet in InfectedData){
		if(dataSet.spawnNumber == num){
			return dataSet
		}
	}
}




// Returns the given vector with the z-offset reverted to zero
// ----------------------------------------------------------------------------------------------------------------------------

function GetVectorAsString(vec){
	vec += Vector(0,0,-16)
	return "Vector(" + vec.x + "," + vec.y + "," + vec.z + ")"
}




// We dont want to allow anything else than letters, numbers or underscores
// ----------------------------------------------------------------------------------------------------------------------------

function fileNameOkay(fileName){
	
	fileName = fileName.tolower()
	
	local allowedChars =
	[
		"0","1","2","3","4","5","6","7","8","9",
		"a","b","c","d","e","f","g","h","i","j",
		"k","l","m","n","o","p","q","r","s","t",
		"u","v","w","x","y","z",
		"_"
	]
	for(local i = 0; i < fileName.len(); i++){
		local letter = fileName.slice(i, i + 1)
		if(!(allowedChars.find(letter))){
			return false
		}
	}
	return true;
}


