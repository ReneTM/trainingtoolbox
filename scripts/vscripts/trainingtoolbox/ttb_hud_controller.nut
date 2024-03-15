//****************************************************************************************
//																						//
//									ttb_hud_controller.nut								//
//																						//
//****************************************************************************************




// Flag and position tables
// ----------------------------------------------------------------------------------------------------------------------------

::HUDFlags <- {
	PRESTR = 1
	POSTSTR = 2
	BEEP = 4
	BLINK = 8
	AS_TIME = 16
	COUNTDOWN_WARN = 32
	NOBG = 64
	ALLOWNEGTIMER = 128
	ALIGN_LEFT = 256
	ALIGN_CENTER = 512
	ALIGN_RIGHT = 768
	TEAM_SURVIVORS = 1024
	TEAM_INFECTED = 2048
	TEAM_MASK = 3072
	NOTVISIBLE = 16384
}

::HUDPositions <- {
	LEFT_TOP = 0
	LEFT_BOT = 1
	MID_TOP = 2
	MID_BOT = 3
	RIGHT_TOP = 4
	RIGHT_BOT = 5
	TICKER = 6
	FAR_LEFT = 7
	FAR_RIGHT = 8
	MID_BOX = 9
	SCORE_TITLE = 10
	SCORE_1 = 11
	SCORE_2 = 12
	SCORE_3 = 13
	SCORE_4 = 14
}




// Returns
// ----------------------------------------------------------------------------------------------------------------------------

::Func <- function(){
	if(jump){
		return jmpstr;
	}
	return ""
}


// Apendix ticker hud
// ----------------------------------------------------------------------------------------------------------------------------


local msg = "" +
"---------- Welcome to TrainingToolbox ----------\n" +
"type !commands in chat for a list of all commands\n"
HudData <-
{
	Fields =
	{
		ticker =
		{
			slot = HUDPositions.TICKER,
			name = "ticker",
			flags = HUDFlags.ALIGN_CENTER | HUDFlags.BLINK
		}
		
		misc =
		{
			slot = HUDPositions.MID_BOX,
			flags = HUDFlags.ALIGN_CENTER | HUDFlags.NOTVISIBLE,
			name = "misc",
			datafunc = @()Func()
		}
	}
}



// Enable / disable the hud
// ----------------------------------------------------------------------------------------------------------------------------

function EnableHud(hud){
	if(!(slot in HudData.Fields)){
		return;
	}
	HudData.Fields.misc.flags <- HudData.Fields.misc.flags & ~HUDFlags.NOTVISIBLE
	HUDPlace(HUDPositions.MID_BOX, 0.0, 0.0, 1.0, 0.05)
}

function DisableTimerHud(){
	if(!(slot in HudData.Fields)){
		return;
	}
	HudData.Fields.misc.flags <- HudData.Fields.misc.flags | HUDFlags.NOTVISIBLE
}










// Checks if the timer hud is currently visible
// ----------------------------------------------------------------------------------------------------------------------------

function IsHudActive(hud){
	return !(HudData.Fields[hud].flags & HUDFlags.NOTVISIBLE)
}


Ticker_AddToHud( HudData, msg )
Ticker_SetTimeout(20);
Ticker_SetBlink(1);
Ticker_SetBlinkTime(5);
HUDPlace( HUDPositions.TICKER, 0.25, 0.04, 0.5, 0.08 );


HUDSetLayout(HudData);
















