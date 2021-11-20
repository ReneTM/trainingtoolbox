//****************************************************************************************
//																						//
//									ttb_key_listener.nut								//
//																						//
//****************************************************************************************


Keys <- {
	ATTACK = 1
	JUMP = 2
	DUCK = 4
	FORWARD = 8
	BACKWARD = 16
	USE = 32
	CANCEL = 64
	LEFT = 128
	RIGHT = 256
	MOVELEFT = 512
	MOVERIGHT = 1024
	ATTACK2 = 2048
	RUN = 4096
	RELOAD = 8192
	ALT1 = 16384
	ALT2 = 32768
	SHOWSCORES = 65536
	SPEED = 131072
	WALK = 262144
	ZOOM = 524288
	WEAPON1 = 1048576
	WEAPON2 = 2097152
	BULLRUSH = 4194304
	GRENADE1 = 8388608
	GRENADE2 = 16777216
	LOOKSPIN = 33554432
}




// Validates and returns entity script scope
// ----------------------------------------------------------------------------------------------------------------------------
function ValidateKeyInScope(ent, key, val){
	ent.ValidateScriptScope()
	local scope = ent.GetScriptScope()
	if(!(key in scope)){
		scope[key] <- val
	}
}




// Key functions
// ----------------------------------------------------------------------------------------------------------------------------

function ValidateDisabledButtonKey(ent){
	local scope = GetValidatedScriptScope(ent)
	if(!("buttonsDisabled" in scope)){
		scope["buttonsDisabled"] <- 0
	}
}

function AddDisabledButton(ent, button){
	local scope = GetValidatedScriptScope(ent)
	ValidateDisabledButtonKey(ent)
	scope["buttonsDisabled"] <- scope["buttonsDisabled"] | button
}

function RemoveDisabledButton(ent, button){
	local scope = GetValidatedScriptScope(ent)
	ValidateDisabledButtonKey(ent)
	scope["buttonsDisabled"] <- scope["buttonsDisabled"] & ~button
}

function SetDisabledButtons(ent, mask){
	local scope = GetValidatedScriptScope(ent)
	ValidateDisabledButtonKey(ent)
	scope["buttonsDisabled"] <- mask
}

function GetDisabledButtons(ent){
	local scope = GetValidatedScriptScope(ent)
	ValidateDisabledButtonKey(ent)
	return scope["buttonsDisabled"]
}

function HasDisabledButton(ent, button){
	local scope = GetValidatedScriptScope(ent)
	ValidateDisabledButtonKey(ent)
	return scope["buttonsDisabled"] & button
}

function KeyListener(){
	foreach(ent in GetHumanPlayers()){
		if(IsEntityValid(ent)){
			if(PlayerIsDisplayingKeys(ent)){
				ReadKey(ent, Keys.ATTACK, "Attack")
				ReadKey(ent, Keys.JUMP, "Jump")
				ReadKey(ent, Keys.DUCK, "Crouch")
				ReadKey(ent, Keys.FORWARD, "Forward")
				ReadKey(ent, Keys.BACKWARD, "Backward")
				ReadKey(ent, Keys.USE, "Use")
				ReadKey(ent, Keys.CANCEL, "Cancel")
				ReadKey(ent, Keys.LEFT, "Left")
				ReadKey(ent, Keys.RIGHT, "Right")
				ReadKey(ent, Keys.MOVELEFT, "MoveLeft")
				ReadKey(ent, Keys.MOVERIGHT, "MoveRight")
				ReadKey(ent, Keys.ATTACK2, "Attack2")
				ReadKey(ent, Keys.RUN, "Run")
				ReadKey(ent, Keys.RELOAD, "Reload")
				ReadKey(ent, Keys.ALT1, "Alt1")
				ReadKey(ent, Keys.ALT2, "Alt2")
				ReadKey(ent, Keys.SHOWSCORES, "Showscores")
				ReadKey(ent, Keys.SPEED, "Speed")
				ReadKey(ent, Keys.WALK, "Walk")
				ReadKey(ent, Keys.ZOOM, "Zoom")
				ReadKey(ent, Keys.WEAPON1, "Weapon1")
				ReadKey(ent, Keys.WEAPON2, "Weapon2")
				ReadKey(ent, Keys.BULLRUSH, "Bullrush")
				ReadKey(ent, Keys.GRENADE1, "Grenade1")
				ReadKey(ent, Keys.GRENADE2, "Grenade2")
				ReadKey(ent, Keys.LOOKSPIN, "Lookspin")
			}
		}
	}
}




function ReadKey(ent, val, keyName){
	// Accept Key and lock it untill it got released once
	if((ent.GetButtonMask() & val) && !(HasDisabledButton(ent, val))){
		AddDisabledButton(ent, val)
		PlayerPressedKey(ent, keyName)
	}
	// Unlock Key when unpressed
	if(HasDisabledButton(ent, val)){
		if(!(ent.GetButtonMask() & val)){
			RemoveDisabledButton(ent, val)
			PlayerUnpressedKey(ent, keyName)
		}
	}
}




// Events for button presses
// ----------------------------------------------------------------------------------------------------------------------------

function PlayerPressedKey(ent, key){
	PrintCurrentKeys(ent)
}

function PlayerUnpressedKey(ent, key){
	PrintCurrentKeys(ent)
}




// Mark player as somebody who wants to show key presses
// ----------------------------------------------------------------------------------------------------------------------------

function ShowMyKeys(ent){
	
	if(trainingActive){
		ClientPrint(null, 5, "Disable the training to enable this feature!")
		return
	}
	
	foreach(player in GetHumanPlayers()){
		local scope = GetValidatedScriptScope(player)
		if(!("showingKeys" in scope)){
			scope["showingKeys"] <- false
		}else{
			if(scope["showingKeys"]){
				if(ent != player){
					ClientPrint(null, 5, ORANGE + player.GetPlayerName() + "is already showing his keys")
					return
				}
			}
		}
	}
	
	// Check if anybody else is showing key inputs already
	local scope = GetValidatedScriptScope(ent)
	if("showingKeys" in scope){
		scope.showingKeys = !scope.showingKeys
		ClientPrint(null, 5, WHITE + "Displaying " + GREEN + ent.GetPlayerName() + "'s " + WHITE + " key inputs is " + (scope.showingKeys ? GREEN + "enabled" : ORANGE + "disabled") + WHITE + " now")
	}
}




// Return true if displaying key inputs is enabled for this player
// ----------------------------------------------------------------------------------------------------------------------------

function PlayerIsDisplayingKeys(ent){
	local scope = GetValidatedScriptScope(ent)
	if(!("showingKeys" in scope)){
		scope["showingKeys"] <- false
	}
	return scope["showingKeys"]
}




// Print keys to chat (Max: 57 chars x 7 lines)
// ----------------------------------------------------------------------------------------------------------------------------

function PrintCurrentKeys(ent){
	local mask = ent.GetButtonMask()
	local W = (mask & Keys.FORWARD) ? ORANGE + "W" : WHITE + "W"
	local A = (mask & Keys.MOVELEFT) ? ORANGE + "A" : WHITE + "A"
	local S = (mask & Keys.BACKWARD) ? ORANGE + "S" : WHITE + "S"
	local D = (mask & Keys.MOVERIGHT) ? ORANGE + "D" : WHITE + "D"
	local E = (mask & Keys.USE) ? ORANGE + "E" : WHITE + "E"
	local R = (mask & Keys.RELOAD) ? ORANGE + "R" : WHITE + "R"
	local SPACE = (mask & Keys.JUMP) ? ORANGE + "SPACE" : WHITE + "SPACE"
	local SHIFT = (mask & Keys.SPEED) ? ORANGE + "SHIFT" : WHITE + "SHIFT"
	local CTRL = (mask & Keys.DUCK) ? ORANGE + "CTRL" : WHITE + "CTRL"
	local LMB = (mask & Keys.ATTACK) ? ORANGE + "LMB" : WHITE + "LMB"
	local RMB = (mask & Keys.ATTACK2) ? ORANGE + "RMB" : WHITE + "RMB"
	local MWB = (mask & Keys.ZOOM) ? ORANGE + "MWB" : WHITE + "MWB"
	ClientPrint(null, 5, "  " + W + " " + E + " " + R + "      " + LMB + "   " + RMB + "                                   ")
	ClientPrint(null, 5, A + " " + S + " " + D + "           " + MWB + "                                      ")
	ClientPrint(null, 5, "                                                         ")
	ClientPrint(null, 5, "                                                         ")
	ClientPrint(null, 5, SHIFT + "                                                    ")
	ClientPrint(null, 5, CTRL + "  " + SPACE + "                                              ")
	ClientPrint(null, 5, "                                                         ")
}






