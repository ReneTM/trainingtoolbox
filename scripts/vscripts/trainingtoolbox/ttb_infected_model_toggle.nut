//****************************************************************************************
//																						//
//								ttb_infected_model_toggle.nut							//
//																						//
//****************************************************************************************




// Contains all worldmodels and viewmodels from relevant infected
// ----------------------------------------------------------------------------------------------------------------------------

::infectedVariants <-
{
	smoker =
	{
		modelData =
		[
			{ worldmodel = "models/infected/smoker.mdl", viewmodel = "models/v_models/weapons/v_claw_smoker.mdl" },
			{ worldmodel = "models/infected/smoker_l4d1.mdl", viewmodel = "models/v_models/weapons/v_claw_smoker_l4d1.mdl" }
		],
		current = 0, min = 0, max = 1
	},
	
	boomer =
	{
		modelData =
		[
			{ worldmodel = "models/infected/boomer.mdl", viewmodel = "models/v_models/weapons/v_claw_boomer.mdl" },
			{ worldmodel = "models/infected/boomer_l4d1.mdl", viewmodel = "models/v_models/weapons/v_claw_boomer_l4d1.mdl" },
		],
		current = 0, min = 0, max = 1
	},
	
	hunter =
	{
		modelData =
		[
			{ worldmodel = "models/infected/hunter.mdl", viewmodel = "models/v_models/weapons/v_claw_hunter.mdl" },
			{ worldmodel = "models/infected/hunter_l4d1.mdl", viewmodel = "models/v_models/weapons/v_claw_hunter_l4d1.mdl" },
		],
		current = 0, min = 0, max = 1
	},
	
	tank =
	{
		modelData =
		[
			{ worldmodel = "models/infected/hulk.mdl", viewmodel = "models/v_models/weapons/v_claw_hulk.mdl" },
			{ worldmodel = "models/infected/hulk_l4d1.mdl", viewmodel = "models/v_models/weapons/v_claw_hulk_l4d1.mdl" },
			{ worldmodel = "models/infected/hulk_dlc3.mdl", viewmodel = "models/v_models/weapons/v_claw_hulk_dlc3.mdl" }
		],
		current = 0, min = 0, max = 2
	},
	
	witch =
	{
		modelData = 
		[
			{ worldmodel = "models/infected/witch.mdl" },
			{ worldmodel = "models/infected/witch_bride.mdl" }
		],
		current = 0, min = 0, max = 1
	}
}




// Ensure precached models
// ----------------------------------------------------------------------------------------------------------------------------

foreach(infectedTable in infectedVariants){
	foreach(ds in infectedTable.modelData){
		foreach(key, model in ds){
			PrecacheModel(model)
		}
	}
}




// Set models dependent on map
// ----------------------------------------------------------------------------------------------------------------------------

if(Director.GetSurvivorSet() == 1){
	infectedVariants.hunter.current = 1
	infectedVariants.smoker.current = 1
	infectedVariants.tank.current = 1
	infectedVariants.boomer.current = 1
}else{
	infectedVariants.hunter.current = 0
	infectedVariants.smoker.current = 0
	infectedVariants.tank.current = 0
	infectedVariants.boomer.current = 0
}




// Instead of getting players we find by models
// ----------------------------------------------------------------------------------------------------------------------------

function GetInfectedModels(inf){
	local ent = null
	local ents = []
	local models =
	{
		witch = [ "models/infected/witch.mdl", "models/infected/witch_bride.mdl"],
		tank = [ "models/infected/hulk.mdl", "models/infected/hulk_l4d1.mdl", "models/infected/hulk_dlc3.mdl" ],
		smoker = [ "models/infected/smoker.mdl", "models/infected/smoker_l4d1.mdl"],
		hunter = [ "models/infected/hunter.mdl", "models/infected/hunter_l4d1.mdl"],
		boomer = [ "models/infected/boomer.mdl", "models/infected/boomer_l4d1.mdl"],
	}
	
	foreach(modelname in models[inf]){
		ent = null
		while(ent = Entities.FindByModel(ent, modelname)){
			if(ent.IsValid()){
				ents.append(ent)
			}
		}
	}
	return ents
}




// Change all models from present infected players/models ( called at player_spawn and witch_spawn ) CALL IT ALSO ON SPAWNCREATION
// ----------------------------------------------------------------------------------------------------------------------------

function UpdateInfectedModels(){
	foreach(ent in GetInfectedModels("witch")){
		local shouldBeModel = infectedVariants.witch.modelData[infectedVariants.witch.current].worldmodel
		if(ent.GetModelName() != shouldBeModel){
			SetWorldModel(ent, shouldBeModel)
			InfectedData["witch"].modelName = shouldBeModel
		}
	}
	foreach(ent in GetInfectedModels("tank")){
		local shouldBeModel = infectedVariants.tank.modelData[infectedVariants.tank.current].worldmodel
		if(ent.GetModelName() != shouldBeModel){
			SetWorldModel(ent, shouldBeModel)
			InfectedData["tank"].modelName = shouldBeModel
			if(ent.GetClassname() == "player" && !IsPlayerABot(ent)){
				SetViewmodel(ent, infectedVariants.tank.modelData[infectedVariants.tank.current].viewmodel)
			}
		}
	}
	foreach(ent in GetInfectedModels("hunter")){
		if(ent.GetClassname() == "player" && playerGotAVictim(ent)){return}
		local shouldBeModel = infectedVariants.hunter.modelData[infectedVariants.hunter.current].worldmodel
		if(ent.GetModelName() != shouldBeModel){
			SetWorldModel(ent, shouldBeModel)
			InfectedData["hunter"].modelName = shouldBeModel
			if(ent.GetClassname() == "player" && !IsPlayerABot(ent)){
				SetViewmodel(ent, infectedVariants.hunter.modelData[infectedVariants.hunter.current].viewmodel)
			}
		}
	}
	foreach(ent in GetInfectedModels("smoker")){
		if(ent.GetClassname() == "player" && playerGotAVictim(ent)){return}
		local shouldBeModel = infectedVariants.smoker.modelData[infectedVariants.smoker.current].worldmodel
		if(ent.GetModelName() != shouldBeModel){
			SetWorldModel(ent, shouldBeModel)
			InfectedData["smoker"].modelName = shouldBeModel
			if(ent.GetClassname() == "player" && !IsPlayerABot(ent)){
				SetViewmodel(ent, infectedVariants.smoker.modelData[infectedVariants.smoker.current].viewmodel)
			}
		}
	}
	foreach(ent in GetInfectedModels("boomer")){
		local shouldBeModel = infectedVariants.boomer.modelData[infectedVariants.boomer.current].worldmodel
		if(ent.GetModelName() != shouldBeModel){
			SetWorldModel(ent, shouldBeModel)
			InfectedData["boomer"].modelName = shouldBeModel
			if(ent.GetClassname() == "player" && !IsPlayerABot(ent)){
				SetViewmodel(ent, infectedVariants.boomer[infectedVariants.boomer.current].viewmodel)
			}
		}
	}
}




function SetInfectedVariant(inf, val){
	
	if(trainingActive){
		ClientPrint(null, 5, "Disable the training to switch infected variants")
		return
	}
	
	if(!(inf in infectedVariants)){
		ClientPrint(null, 5, ORANGE + "There are no other variants for this infected")
	}
	
	val = val.tointeger()
	
	val -= 1
	
	if( ( val >= infectedVariants[inf].min ) && ( val <= infectedVariants[inf].max ) ){
		
		if(infectedVariants[inf].current == val){
			ClientPrint(null, 5, WHITE + "Yeah change Model variant for " + ColorText(inf, ORANGE, WHITE) + " from " + ColorText((infectedVariants[inf].current) + 1, ORANGE, WHITE) + " to " + ColorText((val + 1), ORANGE, WHITE) )
			ClientPrint(null, 5, ORANGE + "Very clever...")
			return
		}
		
		ClientPrint(null, 5, WHITE + "Changed Model variant for " + ColorText(inf, GREEN, WHITE) + " from " + ColorText((infectedVariants[inf].current + 1), GREEN, WHITE) + " to " + ColorText((val + 1), GREEN, WHITE) )
		
		if(inf == "witch"){
			infectedVariants.witch.current = val
		}
		else if(inf == "tank"){
			infectedVariants.tank.current = val
		}
		else if(inf == "hunter"){
			infectedVariants.hunter.current = val
		}
		else if(inf == "smoker"){
			infectedVariants.smoker.current = val
		}
		else if(inf == "boomer"){
			infectedVariants.boomer.current = val
		}
		
		UpdateInfectedModels()
	
	}else{
		ClientPrint(null, 5, ORANGE + "Parameter for " + inf + " variants ranges from " + (infectedVariants[inf].min + 1) + " to " + ( infectedVariants[inf].max + 1) + "!")
	}
}





function SetViewmodel(player, model){
	local viewmodelEnt = NetProps.GetPropEntity(player, "m_hViewModel")
	if(viewmodelEnt){
		local vmSequence = viewmodelEnt.GetSequence()
		viewmodelEnt.SetModel(model)
		viewmodelEnt.SetSequence(vmSequence)
	}
}




function SetWorldModel(ent, model){
	local wmSequence = ent.GetSequence()
	ent.SetModel(model)
	ent.SetSequence(wmSequence)
}





