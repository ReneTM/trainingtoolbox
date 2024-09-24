//****************************************************************************************
//																						//
//										ttb_weapon_spawn_debug.nut						//
//																						//
//****************************************************************************************

::weaponSpawnDebug <-
{
	
	State = false,
	
	WeaponDebugIsActive = function(){
		if(Convars.GetFloat("director_must_create_all_scavenge_items") == 0.0) return false
		if(Convars.GetFloat("director_debug_scavenge_items") == 0.0) return false
		return true;
	}

	SetWeaponDebugState = function(val){
		Convars.SetValue("director_must_create_all_scavenge_items", val ? 1.0 : 0.0)
		Convars.SetValue("director_debug_scavenge_items", val ? 1.0 : 0.0)
	}
	
	ToggleWeaponDebugState = function(){
		SetWeaponDebugState(!State)
		State = !State;
	}
	
}



// Note: remove experimental tediore scripts