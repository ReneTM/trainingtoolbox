//****************************************************************************************
//																						//
//									ttb_skin_switch.nut									//
//																						//
//****************************************************************************************

// player.GiveItemWithSkin(string weaponclass, int index)

weaponSkinData <-
{
	weapon_autoshotgun		= { index_max = 1 },
	weapon_hunting_rifle	= { index_max = 1 },
	weapon_pistol_magnum	= { index_max = 2 },
	weapon_pumpshotgun		= { index_max = 1 },
	weapon_shotgun_chrome	= { index_max = 1 },
	weapon_rifle_ak47		= { index_max = 2 },
	weapon_rifle			= { index_max = 2 },
	weapon_smg_silenced		= { index_max = 1 },
	weapon_smg				= { index_max = 1 },
	cricket_bat				= { index_max = 1 },
	crowbar					= { index_max = 1 }
}




// Returns classname of current weapon, the name of the current melee or null
// ----------------------------------------------------------------------------------------------------------------------------

function GetCurrentWeaponString(player){
	local currentWeapon = player.GetActiveWeapon()
	if(currentWeapon == null){
		return null;
	}
	if(currentWeapon.GetClassname() == "weapon_melee"){
		return NetProps.GetPropString(currentWeapon, "m_strMapSetScriptName")
	}else{
		return currentWeapon.GetClassname()
	}
}




// Iterates of the skins of current weapon/melee
// ----------------------------------------------------------------------------------------------------------------------------

function SkinSwitch(player){
	if(player.GetActiveWeapon() != null){
		if(GetCurrentWeaponString(player) in weaponSkinData){
			local currentWeapon = player.GetActiveWeapon()
			local currentWeaponString = GetCurrentWeaponString(player)
			local currentSkinIndex = NetProps.GetPropInt(currentWeapon, "m_nSkin")
			if(currentSkinIndex == weaponSkinData[currentWeaponString].index_max){
				NetProps.SetPropInt(currentWeapon, "m_nSkin", 0)
			}else{
				NetProps.SetPropInt(currentWeapon, "m_nSkin", currentSkinIndex + 1)
			}
			if(currentWeaponString == "cricket_bat"){
				ClientPrint(null, 5, BLUE + "Seems you got the 'cricket_bat'. Make sure to remove -lv from launchoptions when the skin didnt switch.")	
			}else{
				ClientPrint(null, 5, BLUE + "Skin switched! Switch weapons, shoot or shove once if the skin did not get updated.")	
			}
		}else{
			ClientPrint(null, 5, WHITE + "Current weapon/melee" + ORANGE + " does not " + WHITE + "have any other skins")
		}
	}
}




// Instead of having just the entity "weapon_melee" in slot1 it will also contain "melee_name"
// ----------------------------------------------------------------------------------------------------------------------------

function GetPlayerInventory(player){
	local invTable = {}
	GetInvTable(player, invTable)
	if("slot1" in invTable){
		if(invTable["slot1"].GetClassname() == "weapon_melee"){
			invTable["melee_name"] <- NetProps.GetPropString(invTable["slot1"], "m_strMapSetScriptName")
		}
	}
	return invTable;
}






