//****************************************************************************************
//																						//
//								ttb_dummy_spawner.nut									//
//																						//
//****************************************************************************************

::DummySurvivors <-
{
	bill = 4
	zoey = 5
	francis = 6
	louis = 7
}

::SpawnDummy <- function(ent, survivor){
	
	if(Director.GetSurvivorSet() == 1){
		ClientPrint(null, 5, "Dummy players (result of info_l4d1_survivor_spawn) are only available on L4D2 maps!")
		return
	}
	
	if(trainingActive){
		ClientPrint(null, 5, "Disable the training to spawn a dummy!")
		return
	}
	
	if(IsSetInGlobal("AllowSurvivorBots") && !ttbGlobal["AllowSurvivorBots"]){
		ClientPrint(null, 5, "Survivor bots are currently disabled. Type !bots 1 to enable them")
		return
	}
	
	if(!(survivor in DummySurvivors)){
		ClientPrint(null, 5, "Please select a valid survivor")
		return
	}
	
	
	local DummySpawner = null
	if(Entities.FindByName(null, "ttb_dummy_spawner") == null){
		DummySpawner = SpawnEntityFromTable("info_l4d1_survivor_spawn", { targetname = "myspawner" })
	}
	
	if(GetDummyPlayers().len() == 4){
		ClientPrint(null, 5, "There are already 4 bots!")
		return
	}
	
	local b = null
	while(b = Entities.FindByClassname(b, "player")){
		if(NetProps.GetPropInt(b, "m_iTeamNum") == 4){
			ClientPrint(null, 5, "" + NetProps.GetPropInt(b, "m_survivorCharacter"))
			if(NetProps.GetPropInt(b, "m_survivorCharacter") == DummySurvivors[survivor]){
				ClientPrint(null, 5, "This survivor is already spawned!")
				return
			}
		}
	}
	
	local pointer = getPointerPos(ent)
	
	if(!isPointerValid(pointer, 32, 96, ent)){
		ClientPrint(null, 5, "Aim on a valid position to spawn a dummy!")
		return
	}
	
	
	DummySpawner.SetOrigin(pointer + Vector(0,0,16))
	NetProps.SetPropInt(DummySpawner, "m_character", DummySurvivors[survivor])
	
	DoEntFire("!self", "spawnsurvivor", "", 0.03, DummySpawner, DummySpawner)
}


::RemoveSurvivorBots <- function(){
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		if(IsEntityValid(ent)){
			if(IsPlayerABot(ent) && ent.IsSurvivor()){
				ent.Kill()
			}
		}
	}
	while(ent = Entities.FindByClassname(ent, "player")){
		if(IsEntityValid(ent)){
			if(IsPlayerABot(ent) && ent.IsSurvivor()){
				KickPlayer(ent, "")
			}
		}
	}
	removeDeathModels()
}




::AddBot <- function(){
	if(trainingActive){
		ClientPrint(null, 5, "Disable the training to add bots!")
		return
	}
	if(IsSetInGlobal("AllowSurvivorBots") && !ttbGlobal["AllowSurvivorBots"]){
		ClientPrint(null, 5, "Survivor bots are currently disabled. Type !bots 1 to enable them")
		return
	}
	SendToServerConsole("sb_add")
}




::GetDummyPlayers <- function(){
	local ent = null
	local ents = []
	while(ent = Entities.FindByClassname(ent, "player")){
		if(ent.IsValid()){
			if(NetProps.GetPropInt(ent, "m_iTeamNum") == 4){
				ents.append(ent)
			}
		}
	}
	return ents
}