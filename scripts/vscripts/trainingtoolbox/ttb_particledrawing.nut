//****************************************************************************************
//																						//
//									ttb_particledrawing.nut								//
//																						//
//****************************************************************************************
//
// PRECACHE PARTICLES
//
hitParticleTable <- { classname="info_particle_system", targetname="headshot_particle", effect_name="crit_text", start_active=1, render_in_front=0, angles="0 270 0"}
PrecacheEntityFromTable(hitParticleTable);
//
levelParticleTable <- { classname="info_particle_system", targetname="level_particle", effect_name="level", start_active=1, render_in_front=0, angles="0 270 0"}
PrecacheEntityFromTable(levelParticleTable);
//
crownParticleTable <- { classname = "info_particle_system", targetname="crown_particle", effect_name="crown", start_active=1, render_in_front=0, angles="0 270 0"}
PrecacheEntityFromTable(crownParticleTable);
//
meleeCrownParticleTable <- { classname = "info_particle_system", targetname="melee_crown_particle", effect_name="melee_crown", start_active=1, render_in_front=0, angles="0 270 0"}
PrecacheEntityFromTable(meleeCrownParticleTable);
//
perfectCrownParticleTable <- { classname = "info_particle_system", targetname="perfect_crown_particle", effect_name="perfect_crown", start_active=1, render_in_front=0, angles="0 270 0"}
PrecacheEntityFromTable(perfectCrownParticleTable);
//
tongueCutParticleTable <- { classname = "info_particle_system", targetname="tonguecut_particle", effect_name="tongue_cut", start_active=1, render_in_front=0, angles="0 270 0"}
PrecacheEntityFromTable(tongueCutParticleTable);
//
skeetParticleTable <- { classname = "info_particle_system", targetname="skeet_particle", effect_name="skeet", start_active=1, render_in_front=0, angles="0 270 0"}
PrecacheEntityFromTable(skeetParticleTable);
//
meleeSkeetParticleTable <- { classname = "info_particle_system", targetname="melee_skeet_particle", effect_name="melee_skeet", start_active=1, render_in_front=0, angles="0 270 0"}
PrecacheEntityFromTable(meleeSkeetParticleTable);
//
headshotSkeetParticleTable <- { classname = "info_particle_system", targetname="headshot_skeet_particle", effect_name="headshot_skeet", start_active=1, render_in_front=0, angles="0 270 0"}
PrecacheEntityFromTable(headshotSkeetParticleTable);
//
spawnParticleTable <- { classname = "info_particle_system", targetname="spawn_particle", effect_name="spawn_effect", start_active=1, render_in_front=0, angles="0 270 0"}
PrecacheEntityFromTable(spawnParticleTable);
//
rockSkeetParticleTable <- { classname = "info_particle_system", targetname="rock_skeet_particle", effect_name="rock_skeet", start_active=1, render_in_front=0, angles="0 270 0"}
PrecacheEntityFromTable(rockSkeetParticleTable);




// Creates a circle effect under the infected
// ----------------------------------------------------------------------------------------------------------------------------

function createInfectedSpawnCircle(pos){
	local spawnParticle = SpawnEntityFromTable("info_particle_system", spawnParticleTable)
	spawnParticle.SetOrigin(pos)
	fireParticle("spawn_particle")
}




// Toggle function which makes the particle effects optional
// ----------------------------------------------------------------------------------------------------------------------------

::particlesEnabled <- true

::toggleParticles <- function(){
	particlesEnabled = !particlesEnabled
	ClientPrint(null, 5, BLUE + "Additional particle effects " + particlesEnabled ? "enabled" : "disabled")
}




// Creates particle effect for Hunters & Chargers on non-ability usage and for all other special infected
// ----------------------------------------------------------------------------------------------------------------------------

function createCritParticle(victimVector, params){
	local hsParticle = SpawnEntityFromTable("info_particle_system", hitParticleTable)
	hsParticle.SetOrigin(victimVector)
	fireParticle("headshot_particle")
	doDingDong(params)
}




// Main analysis which infected got killed and how to handle that
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_player_death(params){
	recordSurvivorFrags(params)
	if("userid" in params){
		if(PlayerWantsToDie(GetPlayerFromUserID(params["userid"]))){
			SetPlayerWantsToDie(GetPlayerFromUserID(params["userid"]), false)
		}
	}

	if(particlesEnabled && ! ("attackerentid" in params) && ("victimisbot" in params) && params.victimisbot == 1)
	{
		if(params.victimname != "Infected")
		{
			local victimVector = Vector(params.victim_x,params.victim_y,params.victim_z)

			// Charger got killed
			if(params.victimname == "Charger")
			{
				if(params.headshot == 1)
				{
					local victim = GetPlayerFromUserID(params.userid)
					if(getLastChargingState(victim) == 1 && params.weapon == "melee")
					{
						local lvlParticle = SpawnEntityFromTable("info_particle_system", levelParticleTable)
						lvlParticle.SetOrigin(victimVector)
						fireParticle("level_particle")
						doDingDong(params)
					}
					else
					{	
						createCritParticle(victimVector, params)
					}
				}
			}
			// Hunter got killed
			else if(params.victimname == "Hunter")
			{
				local victim = GetPlayerFromUserID(params.userid)
				if(getLastGroundState(victim) == 0)
				{
					if(params.headshot == 1)
					{
						local headshotSkeetParticle = SpawnEntityFromTable("info_particle_system", headshotSkeetParticleTable)
						headshotSkeetParticle.SetOrigin(victimVector)
						fireParticle("headshot_skeet_particle")
						doDingDong(params)
					}
					else
					{
						if(params.weapon == "melee")
						{
							local meleeSkeetParticle = SpawnEntityFromTable("info_particle_system", meleeSkeetParticleTable)
							meleeSkeetParticle.SetOrigin(victimVector)
							fireParticle("melee_skeet_particle")
							doDingDong(params)
						}
						else
						{
							local skeetParticle = SpawnEntityFromTable("info_particle_system", skeetParticleTable)
							skeetParticle.SetOrigin(victimVector)
							fireParticle("skeet_particle")
							doDingDong(params)
						}
					}
				}
				else if(params.headshot == 1)
				{ 
					createCritParticle(victimVector, params)
				}
			}
			// Witch got killed
			else if(params.victimname == "Witch")
			{
				if(params.weapon == "melee")
				{
					local meleeCrownParticle = SpawnEntityFromTable("info_particle_system", meleeCrownParticleTable)
					meleeCrownParticle.SetOrigin(victimVector)
					fireParticle("melee_crown_particle")
					doDingDong(params)	
				}
				else if(GetWeaponType(params.weapon) == "shotgun")
				{
					if(params.headshot == 1)
					{
						local perfectCrownParticle = SpawnEntityFromTable("info_particle_system", perfectCrownParticleTable)
						perfectCrownParticle.SetOrigin(victimVector)
						fireParticle("perfect_crown_particle")
						doDingDong(params)
					}
					else
					{
						local crownParticle = SpawnEntityFromTable("info_particle_system", crownParticleTable)
						crownParticle.SetOrigin(victimVector)
						fireParticle("crown_particle")
						doDingDong(params)
					}
				}
			}
			// Any other special infected got killed with a headshot
			else if(params.headshot == 1)
			{
				createCritParticle(victimVector, params)
			}
		}	
	}
}




// Return the weapon type of a given string
// ----------------------------------------------------------------------------------------------------------------------------

function GetWeaponType(weapon){
	local snipers = ["hunting_rifle","sniper_military","sniper_scout","sniper_awp"]
	local shotguns = ["shotgun_chrome","pumpshotgun","autoshotgun","shotgun_spas"]
	local pistols = ["pistol","pistol_magnum"]
	local rifles = ["rifle_ak47","rifle_desert","rifle","rifle_sg552","rifle_m60"]
	local smgs = ["smg","smg_silenced","smg_mp5"]
	
	if(snipers.find(weapon) != null){
		return "sniper"
	}
	else if(shotguns.find(weapon) != null){
		return "shotgun"
	}
	else if(pistols.find(weapon) !=null){
		return "pistol"
	}
	else if(rifles.find(weapon) !=null){
		return "rifle"
	}
	else if(smgs.find(weapon) !=null){
		return "smg"
	}
	else if(weapon == "melee"){
		return "melee"
	}
}




// Called when a survivor cuts the smoker tongue
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_tongue_pull_stopped(params){
	
	local smoker = GetPlayerFromUserID(params.smoker)
	local smokerPos = smoker.EyePosition();
	local player = GetPlayerFromUserID(params.userid)

	if(params.userid == params.victim)
	{
		if( NetProps.GetPropInt(smoker, "m_lifeState") == 0)
		{
			if(params.release_type == 4)
			{
				EmitAmbientSoundOn( "ui/littlereward.wav", 1, 100, 100, player)
				local tongueCutParticle = SpawnEntityFromTable("info_particle_system", tongueCutParticleTable)
				tongueCutParticle.SetOrigin(smokerPos)
				fireParticle("tonguecut_particle")
			}
		}
	}
}


function fireParticle(entname){
	EntFire(entname, "start", null, 0, null)
	EntFire(entname, "stop", null, 0.75, null)
	EntFire(entname, "kill", null, 0.8, null)
}


function doDingDong(params){
	local victim = null
	if("entityid" in params){
		victim = EntIndexToHScript(params.entityid)
	}else{
		victim = GetPlayerFromUserID(params.userid)
	}
	EmitAmbientSoundOn("level/bell_impact.wav", 80, 100, 100, victim)
}




__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)










