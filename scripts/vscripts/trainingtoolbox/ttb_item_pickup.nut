//****************************************************************************************
//																						//
//									ttb_item_pickup.nut									//
//																						//
//****************************************************************************************


function OnGameEvent_entity_shoved(params){
	
	local player, ent, scope = null
	
	if("entityid" in params && "attacker" in params && params.entityid != 0){
		player = GetPlayerFromUserID(params.attacker)
		ent = EntIndexToHScript(params.entityid)
		local allowedClasses = [ "prop_physics", "prop_car_alarm" ]

		if(allowedClasses.find(ent.GetClassname()) != null){
			if(!IsPlayerABot(player)){
				player.ValidateScriptScope()
				scope = player.GetScriptScope()
				if(!("last_pickup_time" in scope)){
					scope["last_pickup_time"] <- Time()
				}
				if(Time() > scope["last_pickup_time"] + 1){
					PickupObject(player, ent)
					scope["last_pickup_time"] <- Time()
					// "m_nPhysgunState" changes to 2 !
				}
			}
		}
	}
}




function g_ModeScript::CanPickupObject(object){
	return true
}