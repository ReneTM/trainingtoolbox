//****************************************************************************************
//																						//
//										ttb_director.nut								//
//																						//
//****************************************************************************************



MutationOptions <-
{
	//CI
    CommonLimit = 16,MegaMobSize = 0, MaxSpecials = 8, WanderingZombieDensityModifier = 0,
 	//SI(Capper)
	ChargerLimit = 0, HunterLimit = 0, JockeyLimit = 0, SmokerLimit = 0,
 	//SI(Support)
	BoomerLimit = 0, SpitterLimit = 0,
 	//Boss Infected
	TankLimit = 4, WitchLimit = 8
	
	ActiveChallenge			= 1
	cm_CommonLimit			= 0
	cm_NoSurvivorBots		= 0
	ProhibitBosses			= true
	MobMaxSize				= 0
	MobSpawnMinTime			= 99999
	MobSpawnMaxTime			= 99999
	SpecialRespawnInterval	= 99999
	ZombieSpawnRange		= 4096

	weaponsToPreserve =
	{
		upgrade_item = 1
	}

	function AllowWeaponSpawn( classname ){
		if ( classname in weaponsToPreserve ){
			return true
		}
		return false
	}

	DefaultItems =
	[
		"weapon_shotgun_chrome",
		getAvailableMelee("Sharp")
	]

	function GetDefaultItem( idx ){
		if ( idx < DefaultItems.len() ){
			return DefaultItems[idx];
		}
		return 0;
	}
}
