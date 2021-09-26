//****************************************************************************************
//																						//
//									ttb_script_buttons.nut								//
//																						//
//****************************************************************************************



/*
local impactTimestamp = Time();

function OnGameEvent_bullet_impact(params){
	local impact = Vector(params.x,params.y,params.z)
	
	if(Time() > impactTimestamp + 0.33){
	
		ClientPrint(null, 5, "" + impact)
		impactTimestamp = Time()
	}
}

__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)

*/

// Applies a decal with texture X on position Y
// ----------------------------------------------------------------------------------------------------------------------------

::applyDecalAt <- function (pos, tex){
	local decal = SpawnEntityFromTable( "infodecal", { targetname = "rd_decal", texture = tex, LowPriority = 0, origin = pos } )
	DoEntFire( "!self", "Activate", "", 0.0, decal, decal )
}


::createTargetAt <- function (pos ,name){
	local target = SpawnEntityFromTable( "info_target", { targetname = name, origin = pos })
}


::getPointerPos <- function(player){
	local startPt = player.EyePosition();
	local endPt = startPt + player.EyeAngles().Forward().Scale(999999);
	local m_trace = { start = startPt, end = endPt, ignore = player, mask = TRACE_MASK_SHOT };
	TraceLine(m_trace);
	return m_trace.pos;
}

::placeButton <- function(pos, texture, name){
	local player =  Entities.FindByClassname(null, "player")
	local pointer = getPointerPos(player)
	applyDecalAt(pos, texture)
	createTargetAt(pos, name)
}


local buttonsData =
{
	blood1 = { pos = Vector(1600.428589, 3001.968750, 64.942833), texture = "decals/blood1" , name = "button1" }
	blood2 = { pos = Vector(1632.428589, 3001.968750, 64.942833), texture = "decals/blood1" , name = "button2" }
	blood3 = { pos = Vector(1664.428589, 3001.968750, 64.942833), texture = "decals/blood1" , name = "button3" }
}

foreach(button in buttonsData){
	placeButton(button.pos, button.texture, button.name)
}





// Think
// ----------------------------------------------------------------------------------------------------------------------------

function Think(){
	getHeldPlayerButtons()
	playerIsHittingUSE()
}




// +Use on dummy in point_commentary_node 
// ----------------------------------------------------------------------------------------------------------------------------

function playerIsHittingUSE(){
	foreach(player,buttonArray in getHeldPlayerButtons()){

		if(buttonArray.find("USE") != null){
			player.ValidateScriptScope()
			local scope = player.GetScriptScope()
			if(!("button_use_timestamp" in scope)){
				scope["button_use_timestamp"] <- ( Time() - 10 )
			}
			local pointer = getPointerPos(player)
			if( (pointer - player.EyePosition()).Length() <= 96 ){
				if( Time() > scope["button_use_timestamp"] + 1 ){
					scope["button_use_timestamp"] <- Time()
					ScriptButtonUse(player, pointer)
				}
			}
		}
	}
}

function ScriptButtonUse(ent, pointer){

	local target = Entities.FindByClassnameNearest("info_target", pointer, 8.0)
	if(target == null){
		return;
	}
	
	switch(target.GetName()){
		case "button1" : ClientPrint(null, 5, "Button1");		break;
		case "button2" : ClientPrint(null, 5, "Button2");		break;
		case "button3" : ClientPrint(null, 5, "Button3");		break;
		default:												break;
	}


}




Keys <-
{
	// Key		// Value	// Bitshift

	ATTACK 		= 1 		// 0
	JUMP 		= 2			// 1
	DUCK 		= 4			// 2
	FORWARD 	= 8			// 3
	BACKWARD 	= 16		// 4
	USE 		= 32		// 5
	CANCEL 		= 64		// 6
	LEFT 		= 128		// 7
	RIGHT 		= 256		// 8
	MOVELEFT 	= 512		// 9
	MOVERIGHT 	= 1024		// 10
	ATTACK2 	= 2048		// 11
	RUN 		= 4096		// 12
	RELOAD 		= 8192		// 13
	ALT1 		= 16384		// 14
	ALT2 		= 32768		// 15
	SHOWSCORES 	= 65536		// 16
	SPEED 		= 131072	// 17
	WALK 		= 262144	// 18
	ZOOM 		= 524288	// 19
	WEAPON1 	= 1048576	// 20
	WEAPON2 	= 2097152	// 21
	BULLRUSH	= 4194304	// 22
	GRENADE1 	= 8388608	// 23
	GRENADE2 	= 16777216	// 24
	LOOKSPIN 	= 33554432	// 25
}




// Get player held buttons every tick
// ----------------------------------------------------------------------------------------------------------------------------

function getHeldPlayerButtons(){
	local SurvivorHeldButtons = {}
	local playerKeys = []
	
	foreach(survivor in GetHumanSurvivors()){
		foreach(key,val in Keys){
			if(survivor.GetButtonMask() & val){
				playerKeys.append(key.tostring())
			}
		}
		SurvivorHeldButtons[survivor] <- playerKeys
	}
	return SurvivorHeldButtons;
}


function GetHumanSurvivors(){
	local player = null
	local players = []
	while(player = Entities.FindByClassname(player, "player")){
		if(player.GetZombieType() == 9 && !IsPlayerABot(player)){
			players.append(player)
		}
	}
	return players;
}




// Creates the think timer which calls "Think()" every tick
// ----------------------------------------------------------------------------------------------------------------------------

function createThinkTimer(){
	local timer = null;
	while (timer = Entities.FindByName(null, "thinkTimer")){
		timer.Kill()
	}
	timer = SpawnEntityFromTable("logic_timer", { targetname = "thinkTimer", RefireTime = 0.01 })
	timer.ValidateScriptScope()
	timer.GetScriptScope()["scope"] <- this

	timer.GetScriptScope()["func"] <- function (){
		scope.Think()
	}
	timer.ConnectOutput("OnTimer", "func")
	EntFire("!self", "Enable", null, 0, timer)
}

createThinkTimer();



::getPointer <- function(){
	local player = Entities.FindByClassname(null, "player")
	local startPt = player.EyePosition();
	local endPt = startPt + player.EyeAngles().Forward().Scale(999999);
	local m_trace = { start = startPt, end = endPt, ignore = player, mask = TRACE_MASK_SHOT };
	TraceLine(m_trace);
	ClientPrint(null, 5,  "" + m_trace.pos)
}


