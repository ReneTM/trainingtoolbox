//****************************************************************************************
//																						//
//										ttb_nav_functions.nut							//
//																						//
//****************************************************************************************


NavFlags <-
{
	undefined 			= 1
	EMPTY				= 2
	STOP_SCAN			= 4
	obsolete			= 8
	obsolete			= 16
	BATTLESTATION		= 32
	FINALE				= 64
	PLAYER_START		= 128
	BATTLEFIELD			= 256
	IGNORE_VISIBILITY	= 512
	NOT_CLEARABLE		= 1024
	CHECKPOINT			= 2048
	OBSCURED			= 4096
	NO_MOBS				= 8192
	THREAT				= 16384
	RESCUE_VEHICLE		= 32768
	RESCUE_CLOSET		= 65536
	ESCAPE_ROUTE		= 131072
	DESTROYED_DOOR		= 262144
	NOTHREAT			= 524288
	LYINGDOWN			= 1048576
}

/*

1			- undefined
2			- EMPTY
4        - STOP_SCAN
8       - obsolete
16		- obsolete
32		- BATTLESTATION
64        - FINALE
128        - PLAYER_START
256        - BATTLEFIELD
512        - IGNORE_VISIBILITY
1024    - NOT_CLEARABLE
2048    - CHECKPOINT
4096    - OBSCURED
8192    - NO_MOBS
16384    - THREAT
32768    - RESCUE_VEHICLE
65536    - RESCUE_CLOSET
131072    - ESCAPE_ROUTE
262144    - DESTROYED_DOOR
524288    - NOTHREAT
1048576    - LYINGDOWN
*/


function MarkSaferoom(){
	
	Convars.SetValue("developer", 0)
	Convars.SetValue("r_portalsopenall", 1)
	Convars.SetValue("mat_monitorgamma_tv_enabled", 0)
	Convars.SetValue("mat_monitorgamma", 1.8)
	
	local nav = {}
	NavMesh.GetAllAreas(nav)

	foreach(index,area in nav){
		if(area.IsValid()){
			if(area.HasSpawnAttributes(NavFlags.CHECKPOINT)){
				area.DebugDrawFilled(85, 0, 240, 128, 32.0, true)
			}
		}
	}
}









