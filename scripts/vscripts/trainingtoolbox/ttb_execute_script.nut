//****************************************************************************************
//																						//
//									ttb_execute_script.nut								//
//																						//
//****************************************************************************************

// Stops L4D2 from tracking any stats
// ----------------------------------------------------------------------------------------------------------------------------

function TrackStatsToggle(ent){
	if(GetListenServerHost() != ent){
		return
	}
	Convars.SetValue("l4d_stats_nogameplaycheck", Convars.GetFloat("l4d_stats_nogameplaycheck") == 1.0 ? 0.0 : 1.0 )
	ClientPrint(null, 5, "Tracking L4D2 Stats has been " + ( Convars.GetFloat("l4d_stats_nogameplaycheck") == 1.0 ? "enabled" : "disabled" ))
	return
}




// Execute the named script
// ----------------------------------------------------------------------------------------------------------------------------

function executeScript(scriptname, ent){
	
	if(GetListenServerHost() != ent){
		return
	}

	try{
		IncludeScript(scriptname, getroottable());
	}catch(exception){
		ClientPrint(null, 5, ORANGE + "Exception: " + exception)
	}
	
	ClientPrint(null, 5, BLUE + scriptname + ".nut has been executed")
}

