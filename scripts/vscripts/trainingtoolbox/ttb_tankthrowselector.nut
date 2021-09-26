//****************************************************************************************
//																						//
//								ttb_tankthrowselector.nut								//
//																						//
//****************************************************************************************




const USE = 32
const RELOAD = 8192
const ATTACK2 = 2048

const THROW_SEQUENCE_BASE = 48

enum TankThrows {
	INVALID = -1,
	ONE_HAND_OVERHAND = 1,
	UNDERHAND = 2,
	TWO_HAND_OVERHAND = 3
}


tankrockSelectorEnabled <- false

function toggletankrockselector(){
	tankrockSelectorEnabled = !tankrockSelectorEnabled
	ClientPrint(null, 5, WHITE + "Tankrockselector has been " + GREEN + ( tankrockSelectorEnabled ? "enabled" : "disabled" ))
	if(tankrockSelectorEnabled){
		ClientPrint(null, 5, BLUE + "RMB" + WHITE + " - One hand overhand")
		ClientPrint(null, 5, BLUE + "E" + WHITE + " - Underhand throw")
		ClientPrint(null, 5, BLUE + "R" + WHITE + " - Two Hand Overhand")
		ClientPrint(null, 5, ORANGE + "Sidenote: Curverocks are only possible with 'One hand overhand' and 'Underhand throw'. It is a custom server exclusive feature.")
	}
}




function TankThrowSelector(){
	
	if(!tankrockSelectorEnabled){
		return
	}
	
	foreach(ent in GetHumanInfected()){
		ent.ValidateScriptScope()
		if(ent.GetZombieType() == 8){
			if(Time() >= NetProps.GetPropFloat(NetProps.GetPropEntity(ent, "m_customAbility"), "m_nextActivationTimer.m_timestamp")){
				if(NetProps.GetPropInt(ent, "m_afButtonForced") & ATTACK2){
					NetProps.SetPropInt(ent, "m_afButtonForced", NetProps.GetPropInt(ent, "m_afButtonForced") & ~ATTACK2)
				} else {
					if(ent.GetButtonMask() & USE){
						ent.GetScriptScope()["queued_throw"] <- TankThrows.UNDERHAND
						NetProps.SetPropInt(ent, "m_afButtonForced", NetProps.GetPropInt(ent, "m_afButtonForced") | ATTACK2)
					} else if(ent.GetButtonMask() & RELOAD){
						ent.GetScriptScope()["queued_throw"] <- TankThrows.TWO_HAND_OVERHAND
						NetProps.SetPropInt(ent, "m_afButtonForced", NetProps.GetPropInt(ent, "m_afButtonForced") | ATTACK2)
					}
				}
			}
		}
	}
}




function OnGameEvent_ability_use(params){
	
	if(!tankrockSelectorEnabled){
		return
	}
	
	local ent = GetPlayerFromUserID(params.userid)
	local ability = params.ability
	ent.ValidateScriptScope()
	if(ability == "ability_throw"){
		if("queued_throw" in ent.GetScriptScope() && ent.GetScriptScope()["queued_throw"] != TankThrows.INVALID){
			NetProps.SetPropInt(ent, "m_nSequence", THROW_SEQUENCE_BASE + ent.GetScriptScope()["queued_throw"])
			ent.GetScriptScope()["queued_throw"] = TankThrows.INVALID
		} else {
			NetProps.SetPropInt(ent, "m_nSequence", THROW_SEQUENCE_BASE + TankThrows.ONE_HAND_OVERHAND)
		}
		NetProps.SetPropInt(ent, "m_afButtonForced", NetProps.GetPropInt(ent, "m_afButtonForced") & ~ATTACK2)
	}
}
