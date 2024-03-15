//****************************************************************************************
//																						//
//										ttb_time_scaler.nut								//
//																						//
//****************************************************************************************




// Create a func_timescale entity for the "bullet time"
// ----------------------------------------------------------------------------------------------------------------------------

function createBulletTimerEntity(){
	local ent = null;
	while (ent = Entities.FindByName(null, "timeScaler")){
		ent.Kill()
	}
	
	local entTable = 
	{
		targetname = "timeScaler",
		acceleration = 0.05,
		angles = "0 0 0",
		origin = Vector(0, 0, 0),
		blendDataMultiplier = 3.0,
		minBlendRate = 0.1,
		desiredTimescale = 0.25	
	}
	
	ent = SpawnEntityFromTable("func_timescale", entTable)
}

function setTimeScale(ent, speedValue){
	
	
	if(ent != GetListenServerHost()){
		ClientPrint(ent, 5, "Only the local host is allowed to change the time scale!");
		return;
	}
	
	local speed = 0
	
	try{
		speed = speedValue.tofloat();
	}catch(err){
		ClientPrint(null, 5, "Invalid Parameter for timescale!");
		return;
	}
	
	if(!OnLocalServer()){
		ClientPrint(null, 5, "Setting the timescale is only allowed while hosting locally!");
		return;
	}
	
	if(speed > 2 || speed < 0.25){
		ClientPrint(null, 5, "Allowed time scale values are between 2 and 0.25!");
		return;
	}
	
	local scaler = Entities.FindByName(null, "timeScaler");
	
	if(!scaler){
		ClientPrint(null, 5, "func_timescale of mutation could not be found!");
		return;
	}
	
	if(speed == 1.0){
		DoEntFire("!self", "Stop", "", 0.03, scaler, scaler);
		ClientPrint(null, 5, "Time scale has been set to default.")
		return;
	}else{
		DoEntFire("!self", "Stop", "", 0.03, scaler, scaler);
		NetProps.SetPropFloat(scaler, "m_flDesiredTimescale", speed);
		DoEntFire("!self", "Start", "", 0.06, scaler, scaler);
		ClientPrint(null, 5, "Time scale has been set to " + speed);		
	}
}

/*
- m_flDesiredTimescale (Save|Key)(4 Bytes) - desiredTimescale
- m_flAcceleration (Save|Key)(4 Bytes) - acceleration
- m_flMinBlendRate (Save|Key)(4 Bytes) - minBlendRate
- m_flBlendDeltaMultiplier (Save|Key)(4 Bytes) - blendDeltaMultiplier
*/