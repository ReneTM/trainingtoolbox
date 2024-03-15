//****************************************************************************************
//																						//
//									ttb_bot_commands.nut								//
//																						//
//****************************************************************************************

function getBotInstanceFromName(botname){
	local Survivors1 = ["francis","bill","louis","zoey"]
	local Survivors2 = ["ellis","coach","nick","rochelle"]
	local bots = GetBotSurvivors();
	if(bots.len() == 0){
		return null;
	}
	if(Survivors1.find(botname) == null && Survivors2.find(botname) == null){
		error("Invalid botname passed to 'getBotInstanceFromName'");
		return null;
	}
	foreach(bot in bots){
		if(bot.GetModelName() == survivorModelData[botname].w_model){
			return bot;
		}
	}
	return null;
}

function botmover(ent, botname){
	
	local Survivors1 = ["francis","bill","louis","zoey"]
	local Survivors2 = ["ellis","coach","nick","rochelle"]
	local bots = GetBotSurvivors();
	
	if(bots.len() == 0){
		ClientPrint(null, 5, "No bots have been found!");
		return;
	}
	
	local pointer = getPointerPos(ent)
	if(!isPointerValid(pointer, 32, 96, ent)){
		ClientPrint(null, 5, "Invalid position to move to!");
		return;
	}
	
	// Move all bots
	if(botname == null){
		CommandABot( { cmd = DirectorScript.BOT_CMD_MOVE, pos = pointer})
		ClientPrint(null, 5, "The " + ( bots.len() > 1 ? "bots" : "bot" ) + " will move to your crosshair position now!");
		return;
	}

	
	// Command a specific bot found by Survivor Name
	local bot = getBotInstanceFromName(botname)
	if(!bot){
		ClientPrint(null, 5, "Bot " + botname + " has not been found!");
		return;
	}
	CommandABot( { cmd = DirectorScript.BOT_CMD_MOVE, pos = pointer, bot = bot})
	ClientPrint(null, 5, "Bot " + botname + " will move to your crosshair position now!");
}

function SaveBotPosition(ent, botname){
	local bot = getBotInstanceFromName(botname);
	if(!bot){
		ClientPrint(null, 5, "Bot " + botname + " has not been found!");
		return;
	}
	if(trainingActive){
		ClientPrint(ent, 5, "Saving positions is only available in non-training mode");
		return;
	}
	if(getNoclippingPlayers().find(bot) != null){
		ClientPrint(ent, 5, "It is not allowed to save positions of noclipping bots");
		return;
	}
	if(getFloatingPlayers().find(bot) != null){
		ClientPrint(ent, 5, "It is not allowed to save positions of mid air bots")
		return;
	}
	if(playerIsCapped(bot)){
		ClientPrint(ent, 5, "You cannot save positions of capped bots");
		return;
	}
	savedPlayerPositions[bot] <- { pos = bot.GetOrigin(), ang = bot.EyeAngles() }
	ClientPrint(ent, 5, BLUE + "Position saved");
}

function BotWalkController(){
	if(!botHoldPosition){
		return;
	}
	if(Time() < botLastWalkCommandTime + 2){
		return;
	}
	local bots = GetBotSurvivors();
	
	foreach(bot in bots){
		if(bot in savedPlayerPositions){
			bot.SetOrigin(savedPlayerPositions[bot].pos)
			bot.SnapEyeAngles(savedPlayerPositions[bot].ang)
			CommandABot( { cmd = DirectorScript.BOT_CMD_MOVE, pos = savedPlayerPositions[bot].pos, bot = bot})
		}
		botLastWalkCommandTime = Time();
	}
}

botHoldPosition <- false
botLastWalkCommandTime <- Time()

function BotsHoldSavedPositions(){
	botHoldPosition = !botHoldPosition;
	ClientPrint(null,5, WHITE + "Bots holding positions " + (botHoldPosition ? "enabled" : "disabled"))
}
 
 
 
 
/*

m_survivorCharacter 
 
0 models/survivors/survivor_mechanic.mdl
1 models/survivors/survivor_producer.mdl
2 models/survivors/survivor_coach.mdl
3 models/survivors/survivor_mechanic.mdl
4 models/survivors/survivor_namvet.mdl
5 models/survivors/survivor_teenangst.mdl
6 models/survivors/survivor_biker.mdl
7 models/survivors/survivor_manager.mdl

*/ 

