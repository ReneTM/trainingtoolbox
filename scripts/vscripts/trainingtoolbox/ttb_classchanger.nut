//****************************************************************************************
//																						//
//								ttb_classchanger.nut									//
//																						//
//										Credits:										//
//																						//
//			Icy Inferno:	http://steamcommunity.com/profiles/76561197998419248		//
//			ReneTM:			http://steamcommunity.com/profiles/76561198012983942		//
//																						//
//****************************************************************************************




::TEAMS <-
{
    SPECTATOR	= 1
    SURVIVOR	= 2
    INFECTED	= 3
}

::ZOMBIETYPES <-
{
    COMMON		= 0
    SMOKER		= 1
    BOOMER		= 2
    HUNTER		= 3
    SPITTER		= 4
    JOCKEY		= 5
    CHARGER		= 6
    WITCH		= 7
    TANK		= 8
    SURVIVOR	= 9
    MOB			= 10
    WITCHBRIDE	= 11
    MUDMEN		= 12
}

::MAXHEALTH <-
{
	COMMON		= 50
	SMOKER		= 250
	BOOMER		= 50
	HUNTER		= 250
	SPITTER		= 100
	JOCKEY		= 325
	CHARGER		= 600
	WITCH		= 1000
	TANK		= 6000
	WITCHBRIDE	= 1000
	MUDMEN		= 150
}

Convars.SetValue("z_tank_incapacitated_health", 0.0)

::AbilityNames <-
[
	"weapon_smoker_claw",
	"weapon_hunter_claw",
	"weapon_charger_claw",
	"weapon_jockey_claw",
	"weapon_boomer_claw",
	"weapon_spitter_claw",
	"weapon_tank_claw"
]

::victimKeys <-
[
	"m_pummelVictim",
	"m_carryVictim",
	"m_pounceVictim",
	"m_jockeyVictim",
	"m_tongueVictim"
]

::abilityStates <-
[
	"m_isCharging",
	"m_isLeaping",
	"m_tongueState",
	"m_isSpraying"
]

::worldspawn <- Entities.FindByClassname(null, "worldspawn")




// Change players infected class or spawn him as infected
// ----------------------------------------------------------------------------------------------------------------------------

::becomeZombie <- function(player, infectedNumber){

	if(trainingActive){
		ClientPrint(null, 5, "Disable the training to become an infected")
		return
	}
	
	if(IsGhost(player) && infectedNumber == ZOMBIETYPES.TANK){
		ClientPrint(null, 5, "Technicly it is possible but in normal gameplay there are no tank ghosts!")
		return;
	}
	
	removeAllParents(player)
	RemoveInfectedEntities(player)
	ResetAbilityStates(player)
	killEntireLoadout(player)
	
	if(playerGotAVictim(player)){
		killHumanPlayer(player)
	}
	
	
	resetVictimAndAttackerFlags(player)
	

	
	if(!IsInfected(player)){
		NetProps.SetPropInt(player, "m_iTeamNum", TEAMS.INFECTED)
	}
	
	NetProps.SetPropInt(player, "m_iVersusTeam", 2) // Might fix crashes?
	
	if(player.IsDead() || player.IsDying()){
		local survDummyTable = { type = ZOMBIETYPES.HUNTER, pos = player.GetOrigin(), ang = QAngle(0,90,0) }
		ZSpawn(survDummyTable);
		becomeZombie(player, infectedNumber) //<- experimental recall
	}

	switch(infectedNumber){
		case ZOMBIETYPES.SMOKER:
			NetProps.SetPropInt(player, "m_zombieClass", ZOMBIETYPES.SMOKER)
			NetProps.SetPropInt(player, "m_iMaxHealth", MAXHEALTH.SMOKER)
			player.SetHealth(MAXHEALTH.SMOKER)
			player.SetModel("models/infected/smoker.mdl")
			player.GiveItem("weapon_smoker_claw")
			local ability_tongue = SpawnEntityFromTable("ability_tongue", { targetname = UniqueString("newTongue") })
			NetProps.SetPropEntity(ability_tongue, "m_owner", player)
			NetProps.SetPropEntity(player, "m_customAbility", ability_tongue)
			break
		case ZOMBIETYPES.BOOMER:
			NetProps.SetPropInt(player, "m_zombieClass", ZOMBIETYPES.BOOMER)
			NetProps.SetPropInt(player, "m_iMaxHealth", MAXHEALTH.BOOMER)
			player.SetHealth(MAXHEALTH.BOOMER)
			player.SetModel("models/infected/boomer.mdl")
			player.GiveItem("weapon_boomer_claw")
			local ability_vomit = SpawnEntityFromTable("ability_vomit", { targetname = UniqueString("newVomit") })
			NetProps.SetPropEntity(ability_vomit, "m_owner", player)
			NetProps.SetPropEntity(player, "m_customAbility", ability_vomit)
			break
		case ZOMBIETYPES.HUNTER:
			NetProps.SetPropInt(player, "m_zombieClass", ZOMBIETYPES.HUNTER)
			NetProps.SetPropInt(player, "m_iMaxHealth", MAXHEALTH.HUNTER)
			player.SetHealth(MAXHEALTH.HUNTER)
			player.SetModel("models/infected/hunter.mdl")
			player.GiveItem("weapon_hunter_claw")
			local ability_lunge = SpawnEntityFromTable("ability_lunge", { targetname = UniqueString("newLunge") })
			NetProps.SetPropEntity(ability_lunge, "m_owner", player)
			NetProps.SetPropEntity(player, "m_customAbility", ability_lunge)
			break
		case ZOMBIETYPES.SPITTER:
			NetProps.SetPropInt(player, "m_zombieClass", ZOMBIETYPES.SPITTER)
			NetProps.SetPropInt(player, "m_iMaxHealth", MAXHEALTH.SPITTER)
			player.SetHealth(MAXHEALTH.SPITTER)
			player.SetModel("models/infected/spitter.mdl")
			player.GiveItem("weapon_spitter_claw")
			local ability_spit = SpawnEntityFromTable("ability_spit", { targetname = UniqueString("newSpit") })
			NetProps.SetPropEntity(ability_spit, "m_owner", player)
			NetProps.SetPropEntity(player, "m_customAbility", ability_spit)
			break
		case ZOMBIETYPES.JOCKEY:
			NetProps.SetPropInt(player, "m_zombieClass", ZOMBIETYPES.JOCKEY)
			NetProps.SetPropInt(player, "m_iMaxHealth", MAXHEALTH.JOCKEY)
			player.SetHealth(MAXHEALTH.JOCKEY)
			player.SetModel("models/infected/jockey.mdl")
			player.GiveItem("weapon_jockey_claw")
			local ability_leap = SpawnEntityFromTable("ability_leap", { targetname = UniqueString("newLeap") })
			NetProps.SetPropEntity(ability_leap, "m_owner", player)
			NetProps.SetPropEntity(player, "m_customAbility", ability_leap)
			break
		case ZOMBIETYPES.CHARGER:
			NetProps.SetPropInt(player, "m_zombieClass", ZOMBIETYPES.CHARGER)
			NetProps.SetPropInt(player, "m_iMaxHealth", MAXHEALTH.CHARGER)
			player.SetHealth(MAXHEALTH.CHARGER);
			player.SetModel("models/infected/charger.mdl")
			player.GiveItem("weapon_charger_claw")
			local ability_charger = SpawnEntityFromTable("ability_charge", { targetname = UniqueString("newCharge") })
			NetProps.SetPropEntity(ability_charger, "m_owner", player)
			NetProps.SetPropEntity(player, "m_customAbility", ability_charger)
			break
		case ZOMBIETYPES.TANK:
			NetProps.SetPropInt(player, "m_zombieClass", ZOMBIETYPES.TANK)
			NetProps.SetPropInt(player, "m_iMaxHealth", MAXHEALTH.TANK)
			player.SetHealth(MAXHEALTH.TANK)
			player.SetModel("models/infected/hulk.mdl")
			player.GiveItem("weapon_tank_claw")
			local ability_throw = SpawnEntityFromTable("ability_throw", { targetname = UniqueString("newThrow") });
			NetProps.SetPropEntity(ability_throw, "m_owner", player)
			NetProps.SetPropEntity(player, "m_customAbility", ability_throw)
			break
		default:
			printl("Invalid Zombie Type!")
			return 0
	}

	removeDeathModels()
	movementFix(player)
	UpdateInfectedModels()
	SetPlayerFlashlightState(player, true)
	/*
	local ability = NetProps.GetPropEntity(player, "m_customAbility")
	
	NetProps.SetPropFloat(player, "m_nextActivationTimer.m_timestamp", Time())
	NetProps.SetPropFloat(player, "m_nextActivationTimer.m_duration", 1.0)
	
	NetProps.SetPropFloat(player, "m_activationSupressedTimer.m_timestamp", Time())
	NetProps.SetPropFloat(player, "m_activationSupressedTimer.m_duration", 1.0)
	
	NetProps.SetPropFloat(player, "m_lungeAgainTimer.m_timestamp", Time())
	NetProps.SetPropFloat(player, "m_lungeAgainTimer.m_duration", 1.0)
	*/
	PlayScreenEffect(player, scrFx.classChange.infected)
}




// m_ghostSpawnClockCurrentDelay
// m_ghostSpawnClockMaxDelay
// m_ghostSpawnState
// m_flBecomeGhostAt
// m_zombieState
// m_usSolidFlags
// m_fEffects
// deadflag
// m_lifeState
// m_flMaxspeed
// m_fFlags
// m_iHideHUD
// m_flDeathTime




// Switch to survivors duh
// ----------------------------------------------------------------------------------------------------------------------------

::switchToSurvivors <- function(player){
	
	if(trainingActive){
		ClientPrint(null, 5, "Disable the training to use that command!")
		return
	}
	
	NetProps.SetPropInt(player, "m_isGhost", 0)
	NetProps.SetPropInt(player,"m_zombieState", 0)
	NetProps.SetPropInt(player, "m_iPlayerState", 0) // Fix for unusable melee
	
	removeAllParents(player)
	RemoveInfectedEntities(player)
	resetVictimAndAttackerFlags(player)
	
	
	if(player.IsDead() || player.IsDying()){
		NetProps.SetPropInt(player, "m_iTeamNum", TEAMS.INFECTED)
		local survDummyTable = { type = ZOMBIETYPES.HUNTER, pos = player.GetOrigin(), ang = QAngle(0,90,0) }
		ZSpawn(survDummyTable)
		switchToSurvivors(player)
	}
	
	NetProps.SetPropInt(player, "m_iVersusTeam", 1) // Might fix crashes?
	
	killEntireLoadout(player)
    NetProps.SetPropInt(player, "m_iTeamNum", TEAMS.SURVIVOR)
	NetProps.SetPropInt(player, "m_zombieClass", ZOMBIETYPES.SURVIVOR)
	SetModelPropertiesOfSurvivor(player)
	
	// Health
	player.SetHealth(100)
	player.SetMaxHealth(100)
	
	// Items
	GiveWeaponsNextTick()
	removeDeathModels()
	movementFix(player)
	ValidateSurvivor(player)
}




// Return true when player is infected ghost

::IsGhost <- function(ent){
	return NetProps.GetPropInt(ent, "m_isGhost")
}

::SetIsGhost <- function(ent, val){
	NetProps.SetPropInt(ent, "m_isGhost", val)
}

// Toggle between ghost / spawned mode as infected
// ----------------------------------------------------------------------------------------------------------------------------

::ToggleGhostMode <- function (player){
	
	if(player.IsSurvivor()){
		ClientPrint(null, 5, "Better use this function while being infected m8")
		return
	}
	
	if(player.GetZombieType() == ZOMBIETYPES.TANK){
		ClientPrint(null, 5, "That would be possible but usually there are no tank ghosts. Sorry m8!")
		return
	}
	
	if(player.IsDead() || player.IsDying()){
		ClientPrint(null, 5, "Current vital signs dont allow switching ghost mode!")
		return
	}
	
	if(IsGhost(player)){
		SetIsGhost(player, 0)
	}else{
		SetIsGhost(player, 1)
	}
}




// Sets world and viewmodel for survivors
// ----------------------------------------------------------------------------------------------------------------------------

::SetModelPropertiesOfSurvivor <- function(player){
	
	if(!player.IsSurvivor()){
		return
	}
	
	local SurvivorName = GetCharacterDisplayName(player).tolower()
	
	// Check for invalid value of m_survivorCharacter
	if(SurvivorName == "survivor"){
		if(Director.GetSurvivorSet() == 1){
			SurvivorName = "francis"
		}else{
			SurvivorName = "ellis"
		}
	}
	
	player.SetModel(survivorModelData[SurvivorName].w_model)
}




// Returns true when the player is part of the infected team
// ----------------------------------------------------------------------------------------------------------------------------

function IsInfected(player){
	if(NetProps.GetPropInt(player, "m_iTeamNum") == TEAMS.INFECTED){
		return true
	}
	return false
}




// Kills the ability entity and the entire loadout of the player
// ----------------------------------------------------------------------------------------------------------------------------

function killEntireLoadout(player){
	// Kill current ability
	local ability = null
	
	if(ability = NetProps.GetPropEntity(player, "m_customAbility")){
		NetProps.SetPropEntity(ability, "m_owner", null)
		ability.Kill();
	}
	// Kill complete loadout
	local invTable = {}
	GetInvTable(player, invTable)
	if("slot0" in invTable){
		player.DropItem(invTable.slot0.GetClassname());
	}
	foreach(slot, weapon in invTable){
		weapon.Kill()
	}	
}




// Iterates over all survivors and will give them a pistol to avoid t-posing
// ----------------------------------------------------------------------------------------------------------------------------

function GiveWeaponsNextTick(){
	EntFire("worldspawn", "RunScriptCode", "GiveWeaponsNextTick2()", 0.03)
}

::GiveWeaponsNextTick2 <- function(){
	local player = null
	while(player = Entities.FindByClassname(player, "player")){
		if(player.GetZombieType() == 9){
			if(player.GetActiveWeapon() == null){
				player.GiveItem("weapon_pistol_magnum")
				player.GiveItem("weapon_shotgun_chrome")
			}
		}
	}
}




// Returns true when the survivor is capped by ( charger, hunter, jockey or smoker )
// ----------------------------------------------------------------------------------------------------------------------------

function playerIsCapped(player){
	local infected = null;
	while(infected = Entities.FindByClassname(infected, "player")){
		if(infected.GetZombieType() != 9){
			foreach(key in victimKeys){
				if(NetProps.GetPropEntity(infected, key) == player){
					return true
				}
			}
		}
	}
	return false
}




// Returns true when the survivor got any victim as ( charger, hunter, jockey or smoker )
// ----------------------------------------------------------------------------------------------------------------------------

function playerGotAVictim(player){
	foreach(key in victimKeys){
		if(NetProps.GetPropEntity(player, key) != null){
			return true
		}
	}
	return false
}




// Returns true when player is using their ability
// ----------------------------------------------------------------------------------------------------------------------------

::ResetAbilityStates <- function(player){
	foreach(key in abilityStates){
		local ent = null
		if(ent = NetProps.GetPropEntity(player, "m_customAbility")){
			if(NetProps.GetPropInt(ent, key) == 1){
				NetProps.SetPropInt(ent, key, -1)
			}
		}
	}
}




// Returns true when theres any rock owned by the player
// ----------------------------------------------------------------------------------------------------------------------------

::TankRockActive <- function(ent){
	local rock = null
	while(rock = Entities.FindByClassname(rock, "tank_rock")){
		if(NetProps.GetPropEntity(rock, "m_hThrower") == ent){
			return true
		}
	}
	return false
}




// Remove all dead survivor bodies
// ----------------------------------------------------------------------------------------------------------------------------

function removeDeathModels(){
	local ent = null
	while(ent = Entities.FindByClassname(ent, "survivor_death_model")){
		ent.Kill()
	}
}




// Switching the infected class while charging with a charger causes the player being unable to move
// This can be fixed as following...
// Also removing parenting and setting movetype to default is important
// ----------------------------------------------------------------------------------------------------------------------------

function movementFix(ent){
	local players = [ent]
	
	local victim = null
	if(victim = getCurrentVictim(ent)){
		players.append(victim)
	}
	foreach(ent in players){
		NetProps.SetPropInt(ent,"m_fFlags", NetProps.GetPropInt(ent,"m_fFlags") & ~32)
		NetProps.SetPropInt(ent,"m_MoveType", 2)
	}
}




// Kills the human player
// ----------------------------------------------------------------------------------------------------------------------------

function killHumanPlayer(ent){
	
	if(trainingActive){
		ClientPrint(null, 5, ORANGE + "Disable the training to use this command!")
		return
	}
	if(HasGodModeEnabled(ent)){
		ClientPrint(null, 5, ORANGE + "You got godmode enabled. Disable it before you use this chat command.")
		return
	}
	
	if(NetProps.GetPropInt(ent, "movetype") == 8){
		NetProps.SetPropInt(ent, "movetype", 2)
	}
	if(ent.GetZombieType() == 9){
		NetProps.SetPropInt(ent, "m_isIncapacitated", 1)	
	}else{
		if(IsGhost(ent)){
			SetIsGhost(ent, 0)
		}
	}
	
	SetPlayerWantsToDie(ent, true)
	ent.TakeDamage(9999, 2, ent)
}




// Mark player as somebody who wants to die (we check that key in "hurt events")
// ----------------------------------------------------------------------------------------------------------------------------

function SetPlayerWantsToDie(ent, val){
	if(IsEntityValid(ent)){
		local scope = GetValidatedScriptScope(ent)
		if(!("wants2die" in scope)){
			scope["wants2die"] <- false
		}
		scope["wants2die"] <- val
	}
}




// Return true if player wants to die
// ----------------------------------------------------------------------------------------------------------------------------

function PlayerWantsToDie(ent){
	local scope = GetValidatedScriptScope(ent)
	if(!("wants2die" in scope)){
		scope["wants2die"] <- false
		return false
	}else{
		return scope["wants2die"]
	}
}




// Kills spitter_projectiles and tank rocks
// ----------------------------------------------------------------------------------------------------------------------------

::RemoveInfectedEntities <- function(player){
	local projectile = null
	while(projectile = Entities.FindByClassname(projectile, "spitter_projectile")){
		if(NetProps.GetPropEntity(projectile, "m_hThrower") == player){
			projectile.Kill()
		}
	}
	local rock = null
	while(rock = Entities.FindByClassname(rock, "tank_rock")){
		if(NetProps.GetPropEntity(rock, "m_hThrower") == player){
			NetProps.SetPropEntity(rock,"m_pParent", null)
			rock.Kill()
		}
	}
}




function resetVictimAndAttackerFlags(player){
	local players = [player]
	local victim = null
	if(victim = getCurrentVictim(player)){
		players.append(victim)
	}
	local flags =
	[
		"m_pummelAttacker", "m_pummelVictim",		// Charger pounding survivor into the ground
		"m_carryAttacker", "m_carryVictim",			// Charger having victim while charging
		"m_tongueOwner", "m_tongueVictim",			// Smoker
		"m_pounceAttacker", "m_pounceVictim",		// Hunter
		"m_jockeyAttacker", "m_jockeyVictim"		// Jockey
	]
	foreach(flag in flags){
		foreach(player in players){
			NetProps.SetPropEntity(player, flag, null)
		}
	}
}




function getCurrentVictim(player){
	foreach(key in victimKeys){
		if(NetProps.GetPropEntity(player, key) != null){
			return NetProps.GetPropEntity(player, key)
		}
	}
	return null
}




function removeAllParents(player){
	local players = [player]
	local victim = null
	if(victim = getCurrentVictim(player)){
		players.append(victim)
	}
	foreach(player in players){
		DoEntFire("!self", "clearparent", "", 0.03, player,player)
	}
}

function spectate(ent){
	if(IsSpectator(ent)){
		ClientPrint(null, 5, ORANGE + "You are already a spectator!")
		return
	}
	setGodMode(ent, false);
	killHumanPlayer(ent)
	NetProps.SetPropInt(ent, "m_iTeamNum", 1)
	NetProps.SetPropInt(ent, "m_bForcedObserverMode", 1)
	NetProps.SetPropInt(ent, "m_MoveType", 10)
	//NetProps.SetPropInt(ent, "m_iObserverMode", 1) // Dying state
	NetProps.SetPropInt(ent, "m_iObserverMode", 6) // Dying state
}

function SetPlayerFlashlightState(ent, val){
	if(val){
		NetProps.SetPropInt(ent, "m_fEffects", NetProps.GetPropInt(ent, "m_fEffects") | 4)
	}else{
		NetProps.SetPropInt(ent, "m_fEffects", NetProps.GetPropInt(ent, "m_fEffects") & ~4)
	}
}

function GetPlayerFlashlightState(ent){
	return NetProps.GetPropInt(ent, "m_fEffects") & 4 ? true : false
}




function IsSpectator(ent){
	return (NetProps.GetPropInt(ent, "m_iTeamNum") == 1)
}




function infectedToggle(ent){
	
	local infectedToggleOrder = 
	[
		ZOMBIETYPES.BOOMER,
		ZOMBIETYPES.SPITTER,
		ZOMBIETYPES.SMOKER,
		ZOMBIETYPES.CHARGER,
		ZOMBIETYPES.HUNTER,
		ZOMBIETYPES.JOCKEY
	]
	
	if(!IsEntityValid(ent)){
		return;
	}
	if(trainingActive){
		return;
	}
	if(ent.IsSurvivor()){
		return;
	}
	
	if(IsPlayerABot(ent)){
		return;
	}
	
	if(!IsGhost(ent)){
		return;
	}
	
	local scope = GetValidatedScriptScope(ent)
	
	if(!("last_changed_infected_class_timestemp" in scope)){
		scope["last_changed_infected_class_timestemp"] <- Time() - 0.53;
	}
	
	if(Time() < scope["last_changed_infected_class_timestemp"] + 0.5){
		return;
	}
	
	scope["last_changed_infected_class_timestemp"] = Time();
	
	local currentInfectedClass = ent.GetZombieType();
	
	local nextInfectedClass = 0;
	
	if(infectedToggleOrder.find(currentInfectedClass) == infectedToggleOrder.len()){
		nextInfectedClass = infectedToggleOrder[0];
	}else{
		nextInfectedClass = infectedToggleOrder.find(currentInfectedClass) + 1
	}
	
	becomeZombie(ent, nextInfectedClass)
}




::DebugNetPropsForEntity <- function(index){
	
	local ent = EntIndexToHScript(index)
	
	if(!IsEntityValid(ent)){
		return;
	}
	local props = [
		"m_iTeamNum",
		"m_iInitialTeamNum",
		"m_zombieClass",
		"m_iVersusTeam",
		"m_survivorCharacter"
		"m_Gender"
	]
	foreach(prop in props){
		local propvalue = NetProps.GetPropInt(ent, prop)
		printl(prop + ": " + propvalue);
	}
}

