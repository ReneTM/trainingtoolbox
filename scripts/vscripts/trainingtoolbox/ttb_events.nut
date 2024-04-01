//****************************************************************************************
//																						//
//										ttb_events.nut									//
//																						//
//****************************************************************************************




// Handling of chat commands
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_player_say(params){

	local text = strip(params["text"].tolower())
	local ent = GetPlayerFromUserID(params["userid"])
	local textData = getCommandData(text)
	local command = textData.command
	local parameter = textData.parameter
	
	if(ent != null && command != null){
		
		if(!introSceneActive()){
			
			if(command != null && parameter == null){
				
				switch(command){
					case "training":		toggleTraining(ent);							break
					case "undo":			undo();											break
					case "redo":			redo();											break
					case "undoall":			undoAllSpawnData();								break
					case "toggledaytime":	toggleDayTime();								break
					case "tankthrowslogs":	toggleTankThrowsLogs();							break
					case "rocklauncher":	toggleHumanRockLauncher(ent);					break

					case "commands":		showCommands(ent, "commands");					break
					case "melees":			showCommands(ent, "melees");					break
					case "weapons":			showCommands(ent, "weapons");					break
					case "spawns":			showCommands(ent, "spawns");					break
					case "misc":			showCommands(ent, "misc");						break
					case "debug":			showCommands(ent, "debug");						break
					case "guides":			showCommands(ent, "guides");					break
					case "infected":		showCommands(ent, "infected");					break
					case "version":			toChat("green", trainingtoolbox_version, null);	break

					case "startposition":	setPlayerStart();								break
					case "ammo":			GivePrimaryAndSecondaryAmmo(ent);				break
					case "health":			healPlayer(ent);								break
					case "healthall":		healEverySurvivor();							break
					case "noclip":			noclipMe(ent);									break
					case "fastclear":		infectedFastClearMode();						break
					case "savepos":			savePlayerPosition(ent);						break
					case "loadpos":			loadPlayerPosition(ent);						break
					case "saferoomtoggle":	teleport2InfoToggle(ent);						break

					case "hunter":			spawnSingleInfected(ent, 3);					break
					case "jockey":			spawnSingleInfected(ent, 5);					break
					case "charger":			spawnSingleInfected(ent, 6);					break
					case "smoker":			spawnSingleInfected(ent, 1);					break
					case "boomer":			spawnSingleInfected(ent, 2);					break
					case "spitter":			spawnSingleInfected(ent, 4);					break
					case "tank":			spawnSingleInfected(ent, 8);					break
					case "witch":			spawnSingleInfected(ent, 7);					break
					case "common":			spawnSingleInfected(ent, 0);					break

					case "riot":			spawnSingleInfected(ent, 22);					break
					case "ceda":			spawnSingleInfected(ent, 23);					break
					case "mud":				spawnSingleInfected(ent, 24);					break
					case "roadcrew":		spawnSingleInfected(ent, 25);					break
					case "jimmy":			spawnSingleInfected(ent, 26);					break
					case "clown":			spawnSingleInfected(ent, 27);					break
					case "fallen":			spawnSingleInfected(ent, 28);					break

					case "huntingrifle":	ent.GiveItem("weapon_hunting_rifle");			break
					case "autosniper":		ent.GiveItem("weapon_sniper_military");			break

					case "deagle":			ent.GiveItem("weapon_pistol_magnum");			break
					case "pistol":			ent.GiveItem("weapon_pistol");					break

					case "ak":				ent.GiveItem("weapon_rifle_ak47");				break
					case "scar":			ent.GiveItem("weapon_rifle_desert");			break
					case "rifle":			ent.GiveItem("weapon_rifle");					break
					case "chrome":			ent.GiveItem("weapon_shotgun_chrome");			break
					case "pump":			ent.GiveItem("weapon_pumpshotgun");				break
					case "autoshotty":		ent.GiveItem("weapon_autoshotgun");				break
					case "spas":			ent.GiveItem("weapon_shotgun_spas");			break

					case "smg":				ent.GiveItem("weapon_smg");						break
					case "silenced":		ent.GiveItem("weapon_smg_silenced");			break

					case "scout":			ent.GiveItem("weapon_sniper_scout");			break
					case "awp":				ent.GiveItem("weapon_sniper_awp");				break
					case "sg":				ent.GiveItem("weapon_rifle_sg552");				break
					case "mp5":				ent.GiveItem("weapon_smg_mp5");					break

					case "m60":				ent.GiveItem("weapon_rifle_m60");				break
					case "grenadelauncher":	ent.GiveItem("weapon_grenade_launcher");		break
					case "chainsaw":		ent.GiveItem("weapon_chainsaw");				break

					case "cola":			giveSlot5Item(ent, "weapon_cola_bottles");		break
					case "gnome":			giveSlot5Item(ent, "weapon_gnome");				break

					case "adrenaline":		ent.GiveItem("weapon_adrenaline");				break
					case "pills":			ent.GiveItem("weapon_pain_pills");				break
					case "defib":			ent.GiveItem("weapon_defibrillator");			break
					case "medkit":			ent.GiveItem("weapon_first_aid_kit");			break

					case "bile":			ent.GiveItem("weapon_vomitjar");				break
					case "pipe":			ent.GiveItem("weapon_pipe_bomb");				break
					case "molo":			ent.GiveItem("weapon_molotov");					break

					case "fireworks":		giveSlot5Item(ent,"weapon_fireworkcrate");		break
					case "propane":			giveSlot5Item(ent,"weapon_propanetank");		break
					case "gascan":			giveSlot5Item(ent,"weapon_gascan");				break
					case "oxygen":			giveSlot5Item(ent,"weapon_oxygentank");			break
					case "fuelbarrel":		createFuelBarrel(ent);							break

					case "explosive":		EntFire("upgrade_ammo_explosive", "kill"); ent.GiveItem("weapon_upgradepack_explosive");	break
					case "incendiary":		EntFire("upgrade_ammo_incendiary", "kill"); ent.GiveItem("weapon_upgradepack_incendiary");	break
					case "incendiaries":	ent.GiveUpgrade(0);								break
					case "explosives":		ent.GiveUpgrade(1);								break
					case "laser":			ent.GiveUpgrade(2);								break

					case "golfclub":		GiveMelee(ent,"golfclub");						break
					case "pan":				GiveMelee(ent,"frying_pan");					break
					case "bat":				GiveMelee(ent,"baseball_bat");					break
					case "cricket":			GiveMelee(ent,"cricket_bat");					break
					case "tonfa":			GiveMelee(ent,"tonfa");							break
					case "guitar":			GiveMelee(ent,"electric_guitar");				break
					case "riotshield":		GiveMelee(ent,"riot_shield");					break
					case "shovel":			GiveMelee(ent,"shovel");						break

					case "machete":			GiveMelee(ent,"machete");						break
					case "fireaxe":			GiveMelee(ent,"fireaxe");						break
					case "katana":			GiveMelee(ent,"katana");						break
					case "crowbar":			GiveMelee(ent,"crowbar");						break
					case "knife":			GiveMelee(ent,"knife");							break
					case "pitchfork":		GiveMelee(ent,"pitchfork");						break

					case "strip":			WeaponStrip(ent, false);				break
					case "stripall":		WeaponStrip(ent, true);					break
					
					case "intro":			playInvisibleCommentary("#commentary/trainingtoolbox/com-TTB-intro.wav", "ReneTM");			break
					case "skeeting":		playInvisibleCommentary("#commentary/trainingtoolbox/com-TTB-skeeting.wav", "ReneTM");		break
					case "leveling":		playInvisibleCommentary("#commentary/trainingtoolbox/com-TTB-leveling.wav", "ReneTM");		break
					case "crowning":		playInvisibleCommentary("#commentary/trainingtoolbox/com-TTB-crowning.wav", "ReneTM");		break
					case "tonguecutting":	playInvisibleCommentary("#commentary/trainingtoolbox/com-TTB-tonguecutting.wav", "ReneTM");	break
					case "deadstopping":	playInvisibleCommentary("#commentary/trainingtoolbox/com-TTB-deadstopping.wav", "ReneTM");	break
					case "stopcommentary":	killAllNodes();																break
					case "weaponstats":		outputWeaponStats(ent, GetPlayersActiveWeapon(ent));						break
					case "skinswitch":		SkinSwitch(ent);								break
					case "frags":			fragStatsOutput(ent);							break
					case "lerp":			getPlayerRates(ent);							break
					case "autobhop":		toggleBunnyHopForPlayer(ent);					break
					case "checkbhops":		toggleBhopCheck(ent);							break

					case "falldamagedebug":		fallDamageDebug(ent);						break
					case "penetrationtest":		penetrationTest(ent);						break
					case "boomerdebug":			boomerDebug(ent);							break
					case "smokerdebug":			smokerDebug(ent);							break
					case "tankdebug":			tankDebug(ent);								break
					case "infernodebug":		infernoDebug(ent);							break
					case "meleedebug":			meleeDebug(ent);							break
					case "hitboxdebug":			infectedHitboxDebug(ent);					break
					case "escaperoute":			showEscapeRoute(ent);						break
					case "toggleparticles":		toggleParticles();							break
					case "toggledummyangles":	toggleDummyAngles();						break
					case "eventdebug":			EventDebugPrintToggle(ent);					break
					case "examplerock":			spawnExampleRock(ent);						break
					case "distancetoexamplerock": getDistanceToExampleRock(ent);			break
					case "togglenadeprediction"	: ToggleNadePrediction(ent);				break
					case "distancetest":		SetWalkDistanceTest(ent);					break
					
					case "undorocklaunchers":	removeRockLaunchers();						break
					case "burninginfected":		burningInfectedToggle();					break
					case "god":					toggleGodMode(ent);							break
					case "infammo":				infiniteAmmoToggle(ent);					break
					
					// Tankplay
					case "respawntanktoys":			RespawnTankToys();						break
					case "showtanktoys":			SetTankToysGlowingStatic(true);			break
					case "tanktoysalwaysvisible":	ToggleAlwaysShowTankToys();				break

					case "kill":				killHumanPlayer(ent);						break	
					case "becomehunter":		becomeZombie(ent, ZOMBIETYPES.HUNTER);		break
					case "becomejockey":		becomeZombie(ent, ZOMBIETYPES.JOCKEY);		break
					case "becomecharger":		becomeZombie(ent, ZOMBIETYPES.CHARGER);		break
					case "becomesmoker":		becomeZombie(ent, ZOMBIETYPES.SMOKER);		break
					case "becomespitter":		becomeZombie(ent, ZOMBIETYPES.SPITTER);		break
					case "becomeboomer":		becomeZombie(ent, ZOMBIETYPES.BOOMER);		break
					case "becometank":			becomeZombie(ent, ZOMBIETYPES.TANK);		break
					case "tankrockselector":	toggletankrockselector();					break
					case "toggleghostmode":		ToggleGhostMode(ent);						break
					case "becomesurvivor":		switchToSurvivors(ent);	PlayScreenEffect(ent, scrFx.classChange.survivor);					break
					case "spectate":			spectate(ent);								break
				
					case "thirdperson":			SetThirdperson(ent, 1);						break
					case "firstperson":			SetThirdperson(ent, 0);						break
				
					case "fogoff":				setFogVisibility(ent, false);				break
					case "fogon":				setFogVisibility(ent, true);				break
					case "sky":					toggleBrushElement(ent, "sky");				break
					case "clips":				toggleBrushElement(ent, "clip");			break
					case "playerclips":			toggleBrushElement(ent, "playerclip");		break
					case "infectedclips":		toggleBrushElement(ent, "infectedclip");	break
					case "showsaferoom":		MarkSaferoom();								break
					case "ceilingspots":		SpawnCeilingMarkers();						break
					case "ceiling":				makeCeiling(ent);							break
					case "showmykeys":			ShowMyKeys(ent);							break
					case "removebots":			RemoveSurvivorBots();						break
					case "addbot":				AddBot();									break
					case "showdamage":			ToggleShowDamage();							break
					case "movebots":			botmover(ent, null);						break
					case "botsholdpositions":	BotsHoldSavedPositions();					break
					case "stattrack":			TrackStatsToggle(ent);						break
					case "unlockview":			UnlockViewAngles(ent);						break
				}
			}
			
			if(command != null && parameter != null){
				switch(command){
					
					case "listenclass":	ToggleClassListener(parameter);							break
					case "script":		executeScript(parameter,ent);							break
					case "camera":		CameraToggle(parameter,ent);							break
					case "hunter" :		createSpawnSet(InfectedData.hunter, parameter, ent);	break
					case "jockey" :		createSpawnSet(InfectedData.jockey, parameter, ent);	break
					case "charger" :	createSpawnSet(InfectedData.charger, parameter, ent);	break
					case "smoker" :		createSpawnSet(InfectedData.smoker, parameter, ent);	break
					case "boomer" :		createSpawnSet(InfectedData.boomer, parameter, ent);	break
					case "spitter" :	createSpawnSet(InfectedData.spitter, parameter, ent);	break
					case "tank" :		createSpawnSet(InfectedData.tank, parameter, ent);		break
					case "witch" :		createSpawnSet(InfectedData.witch, parameter, ent);		break
					case "common" :		createSpawnSet(InfectedData.common, parameter, ent);	break
					// uncommon
					case "riot" :		createSpawnSet(InfectedData.riot, parameter, ent);		break
					case "ceda" :		createSpawnSet(InfectedData.ceda, parameter, ent);		break
					case "mud" :		createSpawnSet(InfectedData.mud, parameter, ent);		break
					case "roadcrew" :	createSpawnSet(InfectedData.roadcrew, parameter, ent);	break
					case "jimmy" :		createSpawnSet(InfectedData.jimmy, parameter, ent);		break
					case "clown" :		createSpawnSet(InfectedData.clown, parameter, ent);		break
					case "fallen" :		createSpawnSet(InfectedData.fallen, parameter, ent);	break
					// rock launcher
					case "rocklauncher":		createTankRockLauncher(ent, parameter);		break
					case "rocklauncherdir":		rockLauncherDirToggle(parameter);			break
					// infected variant switch
					case "witchvariant":		SetInfectedVariant("witch", parameter);		break
					case "tankvariant":			SetInfectedVariant("tank", parameter);		break
					case "huntervariant":		SetInfectedVariant("hunter", parameter);	break
					case "smokervariant":		SetInfectedVariant("smoker", parameter);	break
					case "boomervariant":		SetInfectedVariant("boomer", parameter);	break
					//
					case "becomesurvivor":		SwitchSurvivor(ent, parameter);		PlayScreenEffect(ent, scrFx.classChange.survivor);	break
					//
					case "map":					MapChange(ent, parameter);					break
					case "cvar":				SetConvar(ent, parameter);					break
					case "dummy":				SpawnDummy(ent, parameter);					break
					case "bots":				SetAllowSurvivorBots(parameter);			break
					case "timescale":			setTimeScale(ent, parameter);				break
					case "movebot":				botmover(ent, parameter);					break
					case "savebotposition":		SaveBotPosition(ent, parameter);			break
					case "lockview":			LockViewAngles(ent, parameter);				break
				}
			}
			if(command != null){
				switch(command){
					// presets
					case "savepreset":		savePreset(ent, parameter);						break
					case "loadpreset":		loadPreset(ent, parameter);						break
				}	
			}
		}else{
			ClientPrint(null, 5, ORANGE + "Chat commands are disabled during intro scenes")
		}
	}
}

function OnGameEvent_gameinstructor_nodraw(params){
	if(!Director.IsFirstMapInScenario()){
		return;
	}	
	SkipIntro();
}


function GivePrimaryAndSecondaryAmmo(player){
	player.GiveAmmo(999)
	local weaponTable = {}
	GetInvTable(player, weaponTable)
	
	if("slot0" in weaponTable){
		local weapon = weaponTable["slot0"]
		weapon.SetClip1(weapon.GetMaxClip1())
	}
	
	if("slot1" in weaponTable){
		local weapon = weaponTable["slot1"]
		if(weapon.GetClassname() != "weapon_melee"){
			weapon.SetClip1(weapon.GetMaxClip1())
		}
	}
}

function giveSlot5Item(player,itemname){
	local currentItemCount = 0
	local propane	= null;	local propaneCount		= 0
	local oxygen	= null;	local oxygenCount		= 0
	local gascan	= null;	local gascanCount		= 0
	local gnome		= null;	local gnomeCount		= 0
	local cola		= null;	local colaCount			= 0
	local fireworks = null; local fireworksCount 	= 0
	
	switch(itemname){
		case "weapon_fireworkcrate":
		while(oxygen = Entities.FindByModel(oxygen, "models/props_equipment/oxygentank01.mdl")){ oxygenCount++;}
		if(oxygenCount < 4){ player.GiveItem(itemname)} else { sendWarning(player, "Limit of " + itemname + " reached") }
		break
		
		case "weapon_cola_bottles":
		while(cola = Entities.FindByClassname(cola, "weapon_cola_bottles")){ colaCount++; }
		if(colaCount < 4){ player.GiveItem(itemname)} else { sendWarning(player, "Limit of " + itemname + " reached") }
		break
		
		case "weapon_gnome":
		while(gnome = Entities.FindByModel(gnome, "models/props_junk/gnome.mdl")) { gnomeCount++; }
		if(gnomeCount < 4){ player.GiveItem(itemname)} else { sendWarning(player, "Limit of " + itemname + " reached") }
		break
		
		case "weapon_propanetank":
		while(propane = Entities.FindByModel(propane, "models/props_junk/propanecanister001a.mdl")){ propaneCount++; }
		if(propaneCount < 4){ player.GiveItem(itemname)} else { sendWarning(player, "Limit of " + itemname + " reached") }
		break
		
		case "weapon_gascan":
		while(gascan = Entities.FindByClassname(gascan, "weapon_gascan")){ gascanCount++; }
		if(gascanCount < 4){ player.GiveItem(itemname)} else { sendWarning(player, "Limit of " + itemname + " reached") }
		break
		
		case "weapon_oxygentank":
		while(oxygen = Entities.FindByModel(oxygen, "models/props_equipment/oxygentank01.mdl")){ oxygenCount++;}
		if(oxygenCount < 4){ player.GiveItem(itemname)} else { sendWarning(player, "Limit of " + itemname + " reached") }
		break
	}
}




function OnGameEvent_player_left_checkpoint(params){
	EntFire("worldspawn", "RunScriptCode", "setSpawnForEveryPlayer()", 0.5)
}




function OnGameEvent_player_hurt(params){
	local victim = GetPlayerFromUserID(params.userid)
	local attacker = GetPlayerFromUserID(params.attacker)
	local healthRemaining = params.health

	if(PlayerWantsToDie(victim)){
		return
	}

	if (!IsPlayerABot(victim)){
		if(healthRemaining < 40){
			if(IsPlayerABot(attacker) && attacker.GetZombieType() != 9){
				attacker.Kill()
			}
			stopTraining()
		}
	}
}




function OnGameEvent_player_incapacitated(params){
	local victim = GetPlayerFromUserID(params.userid)
	local attacker = null
	
	if(PlayerWantsToDie(victim)){
		return
	}
	
	if("attacker" in params){
		attacker = GetPlayerFromUserID(params.attacker)	
	}else{
		attacker = EntIndexToHScript(params.attackerentid)
	}
	if(attacker != null){
		if((attacker.IsPlayer() && attacker.GetZombieType() != 9 && IsPlayerABot(attacker)) || attacker.GetClassname() == "witch"){
			attacker.Kill()
		}
	}
	if(victim.GetZombieType() == 9){
		stopTraining()
	}
}




// Kills dropped weapons / items with exceptions
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_weapon_drop(params){
	local ent = GetPlayerFromUserID(params["userid"])
	local itemsToPreserve = [ "weapon_gascan", "weapon_upgradepack_explosive", "weapon_upgradepack_incendiary", "weapon_cola_bottles" ]
	if("propid" in params){
		local itemtype = EntIndexToHScript(params.propid).GetClassname()
		if(itemsToPreserve.find(itemtype) == null){
			EntIndexToHScript(params.propid).Kill()	
		}
	}
}




// Update worldmodels and viewmodels dependent on the current variant set
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_player_spawn(params){
	UpdateInfectedModels()
}

function OnGameEvent_witch_spawn(params){
	UpdateInfectedModels()
}




// Print data of unlocked achievement for testing purposes
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_achievement_earned(param){
	PrintEventDebug(param)
}




// We save data over map transitions - clear it when the server shuts down or the mission is ended
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_finale_win(params){
	ClearSavedTables()
}

function OnGameEvent_server_pre_shutdown(params){
	ClearSavedTables()
}




// Since we got playercontrolledzombies in trainingtoolbox.txt we save the first saferoom spawn position
// which the player gets teleported back to in player_first_spawn
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_player_entered_checkpoint(params){
	local ent = GetPlayerFromUserID(params["userid"])
	local scope = GetValidatedScriptScope(ent)
	if(!("entered_checkpoint_position" in scope)){
		scope["entered_checkpoint_position"] <- ent.GetOrigin();
	}
}

// Since we got playercontrolledzombies in trainingtoolbox.txt we have to ensure the player
// gets turned into a survivor when he spawns as infected ghost
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_player_first_spawn(params){
	local ent = GetPlayerFromUserID(params["userid"])
	
	if(!IsEntityValid(ent)){
		return;
	}
	
	if(IsPlayerABot(ent)){
		return;
	}
	
	if(trainingActive){
		spectate(ent)
		ClientPrint(null, 5, "" + ent.GetPlayerName() + " got switched to spectators. Disable training and join survivors via !becomesurvivor")
	}else{
		if(ent.GetZombieType() != ZOMBIETYPES.SURVIVOR){
			switchToSurvivors(ent)
			
			local scope = GetValidatedScriptScope(ent)
			if(("entered_checkpoint_position" in scope)){
				ent.SetOrigin(scope["entered_checkpoint_position"]);
			}else{
				ent.SetOrigin(Entities.FindByClassname(null, "info_player_start").GetOrigin())
			}
			printl("Moved " + ent.GetPlayerName() + " to survivors for initial spawn!")
		}	
	}
}




//
//
// ----------------------------------------------------------------------------------------------------------------------------
function OnGameEvent_player_connect(tParams){
	if (tParams["networkid"] != "BOT")
	{
		printl(format("[%s] SteamID - %s UserID - %d", tParams["name"], tParams["networkid"], tParams["userid"]));
		ClientPrint(null, 3, format("Player %s has joined the game", tParams["name"]))
	}
}



function OnGameEvent_player_disconnect(params){

	//g_ModeScript.DeepPrintTable(params);
	if(!("userid" in params)){
		return;
	}
	
	local player = GetPlayerFromUserID(params["userid"]);

	if(!IsEntityValid(player)){
		return;
	}
	
	local initialTeam = NetProps.GetPropInt(player, "m_iInitialTeamNum");
	
	if (initialTeam == 0){
		return;
	}
		
	local currentTeam = NetProps.GetPropInt(player, "m_iTeamNum");
	if (currentTeam != initialTeam){
		NetProps.SetPropInt(player, "m_iTeamNum", initialTeam);
		printl("Initial team has been set");
	}
}


function OnGameEvent_player_team(params){
	
	if (!("userid" in params)){
		return;
	}
	local player = GetPlayerFromUserID(params["userid"]);
	
	if(!IsEntityValid(player)){
		return;
	}

	if("team" in params){
		NetProps.SetPropInt(player, "m_iInitialTeamNum", params.team);	
	}
	
	local initialTeam = NetProps.GetPropInt(player, "m_iInitialTeamNum");
	if (initialTeam == 0){
		return;	
	}
	
	
	local curTeam = NetProps.GetPropInt(player, "m_iTeamNum");
	if ("team" in params && params.team != 0){
		NetProps.SetPropInt(player, "m_iInitialTeamNum", params.team);

	}
	
	// Causes a crash
	if (curTeam != initialTeam){
		//NetProps.SetPropInt(player, "m_iTeamNum", initialTeam);
		printl(player + " current: " + curTeam + "  init: " + initialTeam)
	}
}
