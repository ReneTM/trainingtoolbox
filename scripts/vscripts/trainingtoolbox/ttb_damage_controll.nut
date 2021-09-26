//****************************************************************************************
//																						//
//								ttb_damage_controll.nut 								//
//																						//
//****************************************************************************************


lastDamageDealer <- null
lastDamageVictim <- null
::printDamageToChat <- false

function AllowTakeDamage(damageTable){
	
	local victim = damageTable["Victim"]
	local attacker = damageTable["Attacker"]
	local damageType = damageTable["DamageType"]
	local damageDone = damageTable["DamageDone"]
	
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
			switch(victim.GetClassname()){
				case "witch"	:
				ClientPrint(null, 5, GREEN + attacker.GetPlayerName() + WHITE + " did " + damageDone + " to " + victim + " " + victim.GetEntityIndex() )
				break;
				case "player"	:
				ClientPrint(null, 5, GREEN + attacker.GetPlayerName() + WHITE + " did " + damageDone + " to " + victim.GetPlayerName() + " " + victim.GetEntityIndex() )
				break;	
				case "infected"	:
				ClientPrint(null, 5, GREEN + attacker.GetPlayerName() + WHITE + " did " + damageDone + " to " + victim + " " + victim.GetEntityIndex() )
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
