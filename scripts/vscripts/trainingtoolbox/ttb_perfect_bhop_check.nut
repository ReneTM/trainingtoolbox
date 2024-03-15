// Toggle checking for perfect bhops
// ----------------------------------------------------------------------------------------------------------------------------

PrecacheSound("ui/menu_accept.wav")

function toggleBhopCheck(ent){
	
	if(ent in bunnyPlayers){
		ClientPrint(null, 5, "Disable autobhop first!");
		return;
	}
	
	ent.ValidateScriptScope();
	local scope = ent.GetScriptScope();
	
	if(!("perfect_bhop_check" in scope)){
		scope["perfect_bhop_check"] <- false
	}
	
	if(!("perfect_bhop_count" in scope)){
		scope["perfect_bhop_count"] <- 0
	}
	
	scope["perfect_bhop_check"] = !scope["perfect_bhop_check"];
	
	ClientPrint(null, 5, BLUE + "Checking for perfect bhops " + (scope["perfect_bhop_check"] ? "enabled" : "disabled" ) )
}




// Check for perfect bhops
// ----------------------------------------------------------------------------------------------------------------------------

function perfectBhopCheck(){
	
	local ent = null
	
	while(ent = Entities.FindByClassname(ent, "player")){
		
		if(ent.IsValid()){
			
			ent.ValidateScriptScope()
			
			local scope = ent.GetScriptScope()
			
			if(!("perfect_bhop_check" in scope) || !scope["perfect_bhop_check"]){
				return;
			}
			
			if(!("on_ground_ticks" in scope)){
				scope["on_ground_ticks"] <- 0
			}
			
			if(PlayerIsOnGround(ent)){
				if(scope["on_ground_ticks"] < 30){
					scope["on_ground_ticks"] ++
				}else{
					scope["on_ground_ticks"] = 0
				}
			}else{
				if(scope["on_ground_ticks"] == 1){
					scope["on_ground_ticks"] = 0
					scope["perfect_bhop_count"] = scope["perfect_bhop_count"]+1
					ClientPrint(ent, 5, BLUE + "Perfect bunnyhops: " + scope["perfect_bhop_count"])
					
					EmitAmbientSoundOn( "ui/menu_accept.wav", 0.5, 100, 120, ent)
				}else{
					scope["on_ground_ticks"] = 0
				}
			}
		}
	}
}