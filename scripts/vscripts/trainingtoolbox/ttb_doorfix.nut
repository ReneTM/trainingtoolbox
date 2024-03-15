//****************************************************************************************
//																						//
//										ttb_doorfix.nut									//
//																						//
//****************************************************************************************

mapData <- {
	c2m1_highway =
	[
		Vector(2416.000, 5584.000, -968.000),
		Vector(2552.000, 6008.000, -968.000)
	]
}


mapName <- Director.GetMapName();
local ent = null;
local findMDL = "models/props_downtown/metal_door_112_dm04_01.mdl";


doorModels <-
[
	"models/props_downtown/metal_door_112.mdl",
	"models/props_downtown/metal_door_112_DM01_01.mdl",
	"models/props_downtown/metal_door_112_DM02_01.mdl",
	"models/props_downtown/metal_door_112_DM03_01.mdl",
	"models/props_downtown/metal_door_112_dm04_01.mdl"
];

dmgModelHealth <- 
[
	1000,
	799,
	599,
	399,
	199
];

function setDamageDoorModel(ent,level){
	local damage = (1000 - dmgModelHealth[level]);
	local model = doorModels[level];
	ent.TakeDamage(damage, 0, null);
	ent.SetModel(model);
}


function DoorFix(){
	if(mapName in mapData){
		foreach(pos in mapData[mapName]){
			if(ent = Entities.FindByClassnameWithin(ent, "prop_door_rotating", pos, 4.0)){
				if(ent.GetModelName() == findMDL && ent.GetHealth() == 1000){
					local entCenter = ent.GetCenter();
					local entOrigin = ent.GetOrigin();
					setDamageDoorModel(ent, 4);
					DebugDrawBoxAngles(entOrigin, Vector(2.0,2.0,2.0), Vector(-2.0,-2.0,-2.0), QAngle(0,0,0), Vector(0,255,0), 123, 65535);
					DebugDrawText(entOrigin, "origin", false, 65535);
					DebugDrawBoxAngles(entCenter, Vector(2.0,2.0,2.0), Vector(-2.0,-2.0,-2.0), QAngle(0,0,0), Vector(255,0,0), 123, 65535);
					DebugDrawText(entCenter, "center", false, 65535);
				}
			}
		}
	}	
}



/*

while(ent = Entities.FindByClassname(ent, "prop_door_rotating")){
	setDamageDoorModel(ent, RandomInt(0,4))
}

*/




// Does not seem to be needed
// ----------------------------------------------------------------------------------------------------------------------------
/*
	NetProps.SetPropInt(ent, "m_iszBreakableModel", -1)
	NetProps.SetPropInt(ent, "m_iBreakableSkin", 0)
	NetProps.SetPropInt(ent, "m_iBreakableCount", 0)
	NetProps.SetPropInt(ent, "m_iMaxBreakableSize", 6)
	NetProps.SetPropInt(ent, "m_iszBasePropData", -1)
	NetProps.SetPropInt(ent, "m_iInteractions", 0)
	NetProps.SetPropInt(ent, "m_iNumBreakableChunks", 5)
*/




// A scratch on a door seems to make 375 dmg
// ----------------------------------------------------------------------------------------------------------------------------
/*
	1000	-	Full health
	625		-	After one scratch		// dmg Model 1
	250		-	After second scratch	// dmg Model 3
	3rd		-	Scratch breaks it
*/