//****************************************************************************************
//																						//
//									ttb_map_switcher.nut								//
//																						//
//****************************************************************************************

local knownMaps = [
		// DEAD CENTER
		"c1m1_hotel","c1m2_streets","c1m3_mall","c1m4_atrium",
		// DARK CARNIVAL
		"c2m1_highway","c2m2_fairgrounds","c2m3_coaster","c2m4_barns","c2m5_concert",
		// SWAMP FEVER
		"c3m1_plankcountry","c3m2_swamp","c3m3_shantytown","c3m4_plantation",
		// HARD RAIN
		"c4m1_milltown_a","c4m2_sugarmill_a","c4m3_sugarmill_b","c4m4_milltown_b","c4m5_milltown_escape",
		// THE PARISH
		"c5m1_waterfront","c5m2_park","c5m3_cemetery","c5m4_quarter","c5m5_bridge",
		// THE PASSING
		"c6m1_riverbank","c6m2_bedlam","c6m3_port",
		// THE SACRIFICE
		"c7m1_docks","c7m2_barge","c7m3_port",
		// NO MERCY
		"c8m1_apartment","c8m2_subway","c8m3_sewers","c8m4_interior","c8m5_rooftop",
		// CRASH COURSE
		"c9m1_alleys","c9m2_lots",
		// DEATH TOLL
		"c10m1_caves","c10m2_drainage","c10m3_ranchhouse","c10m4_mainstreet","c10m5_houseboat",
		// DEAD AIR
		"c11m1_greenhouse","c11m2_offices","c11m3_garage","c11m4_terminal","c11m5_runway",
		// BLOOD HARVEST
		"c12m1_hilltop","c12m2_traintunnel","c12m3_bridge","c12m4_barn","c12m5_cornfield",
		// COLD STREAM
		"c13m1_alpinecreek","c13m2_southpinestream","c13m3_memorialbridge","c13m4_cutthroatcreek",
		// THE LAST STAND
		"c14m1_junkyard","c14m2_lighthouse",
		// TTB
		"c17m17"
	]

function GetGuessedMapFromAbbreviation(mapAbbrev){
	foreach(mapname in knownMaps){
		if(mapname.find(mapAbbrev) != null){
			return mapname
		}
	}
	return ""
}

function MapChange(ent, mapAbbrev){
	
	if(GetListenServerHost() != ent){
		ClientPrint(null, 5, ORANGE + "Only the host is allowed to change the map!")
		return;
	}
	
	if(MapChangeInProgress){
		return;
	}
	
	local guessedMap = GetGuessedMapFromAbbreviation(mapAbbrev)
	local perfectMatch = false;
	if(mapAbbrev == guessedMap){
		perfectMatch = true;
	}

	if(guessedMap != ""){
		ChangeMap(guessedMap, true)
	}else{
		ClientPrint(null, 5, ORANGE + "This mapname is unknown to the mutation, but we gonna try...")
		ChangeMap(mapAbbrev, false)
	}
}




::MapChangeInProgress <- false

function ChangeMap(mapname, completedMapName){
	MapChangeInProgress = true
	
	if(completedMapName){
		EntFire("worldspawn", "RunScriptCode", "ClientPrint(null,5, \"Autocompleted mapname: " + mapname + "\")", 0.0)
	}
	
	EntFire("worldspawn", "RunScriptCode", "ClientPrint(null,5, \"3\")", 1.0)
	EntFire("worldspawn", "RunScriptCode", "ClientPrint(null,5, \"2\")", 2.0)
	EntFire("worldspawn", "RunScriptCode", "ClientPrint(null,5, \"1\")", 3.0)
	EntFire("worldspawn", "RunScriptCode", "SendToServerConsole(\"changelevel " + mapname + "\"" + ")", 4.0)
	EntFire("worldspawn", "RunScriptCode", "ClientPrint(null,5, \"Map has not been found!\")", 4.03)
	EntFire("worldspawn", "RunScriptCode", "MapChangeInProgress=false", 4.06)
}

