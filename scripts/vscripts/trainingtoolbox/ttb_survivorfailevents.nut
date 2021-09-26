//****************************************************************************************
//																						//
//								ttb_survivorfailevents.nut								//
//																						//
//****************************************************************************************

function OnGameEvent_jockey_ride(param){
	if(infectedFastClearModeActive){
		local attacker = GetPlayerFromUserID(param.userid)
		local victim = GetPlayerFromUserID(param.victim)
		local victimName = victim.GetPlayerName()
		EntFire("worldspawn", "RunScriptCode", "killInfectedDelayed(" + param.userid + ")", 0.5)	
	}
}

function OnGameEvent_charger_carry_start(param){
	if(infectedFastClearModeActive){
		local attacker = GetPlayerFromUserID(param.userid)
		local victim = GetPlayerFromUserID(param.victim)
		local victimName = victim.GetPlayerName()
		EntFire("worldspawn", "RunScriptCode", "killInfectedDelayed(" + param.userid + ")", 0.3)
	}
}

function OnGameEvent_tongue_grab(param){
	if(infectedFastClearModeActive){
		local attacker = GetPlayerFromUserID(param.userid)
		local victim = GetPlayerFromUserID(param.victim)
		local victimName = victim.GetPlayerName()
		EntFire("worldspawn", "RunScriptCode", "killInfectedDelayed(" + param.userid + ")", 0.5)	
	}
}

function OnGameEvent_lunge_pounce(param){
	if(infectedFastClearModeActive){
		local attacker = GetPlayerFromUserID(param.userid)
		local victim = GetPlayerFromUserID(param.victim)
		local victimName = victim.GetPlayerName()
		EntFire("worldspawn", "RunScriptCode", "killInfectedDelayed(" + param.userid + ")", 0.3)
	}
}

infectedFastClearModeActive <- false
function infectedFastClearMode(){
	if(!trainingActive){
		infectedFastClearModeActive = !infectedFastClearModeActive
		ClientPrint(null, 5, WHITE + "Fast clearing infected " + GREEN + ( infectedFastClearModeActive ? "Enabled" : "Disabled" ))
	}else{
		ClientPrint(null, 5, "Disable the training to toggle this setting")
	}
}


::killInfectedDelayed <- function(ent){
	local infected = GetPlayerFromUserID(ent)
	if(infected != null){
		if(infected.IsValid()){
			if(!infected.IsDead()){
				infected.Kill()
			}
		}
	}
}
