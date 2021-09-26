//****************************************************************************************
//																						//
//									ttb_ai_dmg_fix.nut									//
//																						//
//****************************************************************************************




function PlayerGenerator(){
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){
		yield ent
	}
}


function hurtChargers(){
	local damage = 180
	local player = null;
	while(player = Entities.FindByClassname(player, "player")){
		if(player.GetZombieType() == 6 && IsPlayerABot(player)){
			if(player.GetHealth() > NetProps.GetPropInt(player, "m_iMaxHealth") - damage){
				player.TakeDamage(damage, 0, null)
			}
		}
	}
}


storagetable	<- {}
local SkeetDmg	= 150

function skeetFix(){
	foreach(hunter in PlayerGenerator()){
		if((hunter.GetZombieType() == 3) && (IsPlayerABot(hunter))){
			if(hunter in storagetable){
				if(NetProps.GetPropInt(NetProps.GetPropEntity(hunter, "m_customAbility"), "m_isLunging") == 0){
					storagetable[hunter].append(hunter.GetHealth())
				}
				if(NetProps.GetPropInt(NetProps.GetPropEntity(hunter, "m_customAbility"), "m_isLunging") == 1){
					if(storagetable[hunter][(storagetable[hunter].len() - 1)] >= SkeetDmg){
						local DmgDealtAIR = (storagetable[hunter][(storagetable[hunter].len() - 1)] - hunter.GetHealth());
						if(DmgDealtAIR >= SkeetDmg){
							hunter.TakeDamage(9999, 0, lastDamageDealer);
						}
					}
				}
				if(NetProps.GetPropInt(hunter, "m_lifeState") == 1){
					delete storagetable[hunter];
				}
			}else{
				storagetable[hunter] <- [NetProps.GetPropInt(hunter, "m_iHealth"), NetProps.GetPropInt(hunter, "m_iHealth")];
			}
		}
	}
}