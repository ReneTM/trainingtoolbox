//****************************************************************************************
//																						//
//								ttb_damage_controll.nut 								//
//																						//
//****************************************************************************************


lastDamageDealer <- null
lastDamageVictim <- null
::printDamageToChat <- false

function AllowTakeDamage(damageTable){
	
	//ClientPrint(null, 5, "FIX: WITCH WRONG TARGET ISSUE")
	//ClientPrint(null, 5, "ADD: TANK FRUSTRATION NOTICE")
	
	//foreach(k,v in damageTable){
	//	printl(k + v)
	//}
	
	local victim = damageTable["Victim"]
	local attacker = damageTable["Attacker"]
	local damageType = damageTable["DamageType"]
	local damageDone = damageTable["DamageDone"]
	
	
	/*
	Set commons being non solid after killing (blunt melees)
	if(attacker && attacker.GetClassname() == "player" && victim && victim.GetClassname() == "infected"){
		if(damageDone >= victim.GetHealth()){
			NetProps.SetPropInt(victim, "m_Collision.m_usSolidFlags", 4);
			NetProps.SetPropInt(victim, "m_Collision.m_nSolidType", 0);
		}
	}
	*/

	if(victim.IsPlayer() && attacker.IsPlayer()){
		lastDamageDealer = attacker
		lastDamageVictim = victim
	}
	
	// God mode
	if(victim.IsPlayer()){
		if(HasGodModeEnabled(victim)){
			return false
		}
	}
	
	if(printDamageToChat){
		if(attacker.IsPlayer() && !IsPlayerABot(attacker)){
			// m_hitGroup
			local hitgroup = NetProps.GetPropInt(victim, "m_LastHitGroup")
			local hitgroupname = GetHitGroupNameFromValue(hitgroup);
			local hitgrouptext = " Hitgroup: " + hitgroupname + "(" + hitgroup + ")"
			local maxhealth = victim.GetMaxHealth();
			local health = victim.GetHealth();
			local healthtext = " Health: " + health + "/" + maxhealth;
			local attackerName = attacker.GetPlayerName()
			local victimEntIndex = victim.GetEntityIndex()
			
			
			//local text = format("%green %attackername %white did %damageDone to %victim", GREEN, attackerName, WHITE)
			
			switch(victim.GetClassname()){
				case "witch" :
				ClientPrint(null, 5, GREEN + attackerName + WHITE + " did " + damageDone + " to " + victim + hitgrouptext + healthtext)
				break;
				case "player" :
				ClientPrint(null, 5, GREEN + attackerName + WHITE + " did " + damageDone + " to " + victim.GetPlayerName() + " [" + victim.GetEntityIndex() + "]" + hitgrouptext + healthtext)
				break;	
				case "infected" :
				ClientPrint(null, 5, GREEN + attackerName + WHITE + " did " + damageDone + " to " + victim + hitgrouptext + healthtext)
				break;
			}
		}
	}
	
	
	// TANK ROCK
	if(damageTable.Victim.GetClassname() == "tank_rock"){
		if(attacker != null && attacker.IsPlayer() && attacker.GetZombieType() == 9){
			
			victim.ValidateScriptScope()
			if(!("dealtDamage" in victim.GetScriptScope())){
				victim.GetScriptScope()["dealtDamage"] <- damageDone
			}else{
				victim.GetScriptScope()["dealtDamage"] += damageDone
			}
			if(victim.GetScriptScope()["dealtDamage"] >= 50){
				victim.GetScriptScope()["dealtDamage"] <- -500

				if(particlesEnabled){
					if(attacker.GetActiveWeapon().GetClassname() != "weapon_melee"){
						local rockSkeetParticle = SpawnEntityFromTable("info_particle_system", rockSkeetParticleTable)
						rockSkeetParticle.SetOrigin(victim.GetOrigin())
						fireParticle("rock_skeet_particle")
						if(!trainingActive){
							local distance = (attacker.GetOrigin() - victim.GetOrigin()).Length()
							ClientPrint(null, 5, WHITE + "Tankrock skeeted! Distance: " + BLUE + distance + " units")
						}
					}
				}
			}
		}
	return true
	}
	
	// Disable fall damage for bots
	if(victim.IsPlayer()){
		if(damageType == 32){
			if(victim.GetZombieType() == 9){
				if(IsPlayerABot(victim)){
					return false
				}
			}
		}
	}
	
	// Allow damage for killHumanPlayer()
	if(victim.IsPlayer() && attacker.IsPlayer()){
		if(victim == attacker){
			return true
		}
	}
	
	// Disable Friendly Fire
	if(attacker.IsPlayer()){
		if(victim.IsPlayer()){
			if(attacker.GetZombieType() == 9 && victim.GetZombieType() == 9){
				return false
			}

		}
	}
	return true
}


// m_hitGroup
hitgroups <-
{
	HITGROUP_GENERIC = 0
	HITGROUP_HEAD = 1
	HITGROUP_CHEST = 2
	HITGROUP_STOMACH = 3
	HITGROUP_LEFTARM = 4
	HITGROUP_RIGHTARM = 5
	HITGROUP_LEFTLEG = 6
	HITGROUP_RIGHTLEG = 7
	HITGROUP_GEAR = 10
}

function GetHitGroupNameFromValue(hitgroupValue){
	foreach(k,v in hitgroups){
		if(v == hitgroupValue){
			return k;
		}
	}
	return "Unknown Hitgroup";
}
