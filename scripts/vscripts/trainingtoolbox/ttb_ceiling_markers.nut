
::SaveCeilingPosition <- function(ent){
	if(!ent){
		ent = Entities.FindByClassname(null, "player")
	}
	local eyeangles = ent.EyeAngles()
	local pos = ent.GetOrigin();
	local updir = Vector(-90,0,0);
	local eyeangles = ent.EyeAngles()
	local angle = "90" + " " + eyeangles.y + " " + "0";
	local startpos = pos;
	local endpos = pos + Vector(0,0,65535);

	local traceTable =
	{
		start = startpos,
		end = endpos, ignore = ent,
		mask = TRACE_MASK_SHOT
	}

	TraceLine(traceTable)

	//if("startsolid" in traceTable){
	//	return;
	//}

	if(!("hit" in traceTable)){
		return;
	}

	local hitpos = traceTable.pos;
	local middle = (pos + hitpos) * 0.5
	local distance = (pos + hitpos).Length()
	
	
	local model = SpawnEntityFromTable("prop_dynamic_override",
		{
			origin = hitpos + Vector(0,0,-2),
			model = "models/trainingtoolbox/signs/sign05.mdl",
			angles = angle,
			skin = 3
		}
	);
	
	local positionTable = 
	{
		signorigin = hitpos + Vector(0,0,-2),
		signangles = angle,
		standingposition = pos
	}
	
	ceilingPositions.append(positionTable)
}


::ceilingPositions <- [];


::GetVectorString <- function(obj){
	return "Vector(" + obj.x + "," + obj.y + "," + obj.z + ")";
}

::GetAngleString <- function(obj){
	return obj.x + " " + obj.y + " " + obj.z;
}



::UndoCeilingPosition <- function(){
	if(ceilingPositions.len() == 0){
		return
	}
	ceilingPositions.pop();
	ClientPrint(null, 5, "Removed Previous")
}

::PrintAll <- function(){
	foreach(obj in ceilingPositions){
		printl("[ " + GetVectorString(obj.signorigin) + ", " + "\"" + obj.signangles + "\"" +", " + GetVectorString(obj.standingposition) + " ]");
	}
}



::CeilingMarkers <-
{
	c1m1_hotel =
	[
		[ Vector(1947.6,5690.65,3581.97), "90 -179.786 0", Vector(1947.6,5690.65,3193.04) ]
	]
	c1m2_streets =
	[
		[ Vector(1843.25,5314.86,2269.97), "90 0 0", Vector(1843.25,5314.86,2048.03) ],
		[ Vector(-4585.28,3242.02,2045.97), "90 0 0", Vector(-4585.28,3242.02,1728.03) ],
		[ Vector(-5782.71,1106.01,1469.97), "90 -90 0", Vector(-5782.71,1106.01,1395.08) ],
		[ Vector(-7339.31,-4431.18,1469.97), "90 180 0", Vector(-7339.31,-4431.18,1224.7) ],
		[ Vector(-4829.53,-1848.57,1469.97), "90 180 0", Vector(-4829.53,-1848.57,1380.39) ]
	]
	c2m2_fairgrounds =
	[
		[ Vector(-3199.92,-395.042,765.969), "90 -90 0", Vector(-3199.92,-395.042,392.031) ],
		[ Vector(1999.89,-1023.84,765.969), "90 0 0", Vector(1999.89,-1023.84,520.031) ],
		[ Vector(480.688,886.079,765.969), "90 -90 0", Vector(480.688,886.079,440.031) ],
		[ Vector(-2568.15,-2071.53,765.969), "90 -90 0", Vector(-2568.15,-2071.53,592.031) ],
		[ Vector(-1328.61,-4400.03,765.969), "90 -180 0", Vector(-1328.61,-4400.03,352.595) ],
		[ Vector(-2239.37,-5376.93,765.969), "90 90 0", Vector(-2239.37,-5376.93,367.031) ],
		[ Vector(-3423.63,-6912.02,765.969), "90 0 0", Vector(-3423.63,-6912.02,362.981) ],
		[ Vector(-4214.03,-4773.88,765.969), "90 0 0", Vector(-4214.03,-4773.88,377.981) ],
		[ Vector(-4220.88,-6206.59,765.969), "90 0 0", Vector(-4220.88,-6206.59,385.732) ]
	]
	c3m1_plankcountry =
	[
		[ Vector(-3959.57,6359.72,1021.97), "90 0 0", Vector(-3959.57,6359.72,628.584) ],
		[ Vector(-4139.02,5860.74,1021.97), "90 0 0", Vector(-4139.02,5860.74,731.663) ],
		[ Vector(-3856.94,5574.98,1021.97), "90 0 0", Vector(-3856.94,5574.98,727.663) ],
		[ Vector(-3399.74,5242.26,1021.97), "90 90 0", Vector(-3399.74,5242.26,640.584) ],
		[ Vector(-3093.59,5539.27,1021.97), "90 180 0", Vector(-3093.59,5539.27,615.584) ]
	]
	c4m1_milltown_a =
	[
		[ Vector(-5404.05,5579.05,1533.97), "90 90 0", Vector(-5404.05,5579.05,1394.03) ],
		[ Vector(-3700.87,6485.38,1533.97), "90 90 0", Vector(-3700.87,6485.38,1392.03) ],
		[ Vector(-3255.3,8357.03,1533.97), "90 -90 0", Vector(-3255.3,8357.03,1392.03) ],
		[ Vector(-1277.59,5071.69,1533.97), "90 66.4712 0", Vector(-1277.59,5071.69,1394.03) ],
		[ Vector(-24.4222,3043.02,1533.97), "90 2.02218 0", Vector(-24.4222,3043.02,1394.03) ],
		[ Vector(4712.06,-1200.86,1533.97), "90 -178.788 0", Vector(4712.06,-1200.86,1392.03) ]
	]
	c4m2_sugarmill_a =
	[
		[ Vector(-16.8048,-5241.01,2526.22), "90 -60.89 0", Vector(-16.8048,-5241.01,2453.64) ],
		[ Vector(-1154,-9433.23,846.219), "90 167.854 0", Vector(-1154,-9433.23,793.22) ] 
	]
	c4m3_sugarmill_b =
	[
		[ Vector(-16.8048,-5241.01,2526.22), "90 -60.89 0", Vector(-16.8048,-5241.01,2453.64) ],
		[ Vector(-1154,-9433.23,846.219), "90 167.854 0", Vector(-1154,-9433.23,793.22) ] 
	]
	c4m4_milltown_b =
	[
		[ Vector(-5404.05,5579.05,1533.97), "90 92.2904 0", Vector(-5404.05,5579.05,1394.03) ],
		[ Vector(-3700.87,6485.38,1533.97), "90 90.2478 0", Vector(-3700.87,6485.38,1392.03) ],
		[ Vector(-3255.3,8357.03,1533.97), "90 -91.5034 0", Vector(-3255.3,8357.03,1392.03) ],
		[ Vector(-1277.59,5071.69,1533.97), "90 66.4712 0", Vector(-1277.59,5071.69,1394.03) ],
		[ Vector(-24.4222,3043.02,1533.97), "90 2.02218 0", Vector(-24.4222,3043.02,1394.03) ],
		[ Vector(4712.06,-1200.86,1533.97), "90 -178.788 0", Vector(4712.06,-1200.86,1392.03) ]
	]
	c4m5_milltown_escape =
	[
		[ Vector(-5404.05,5579.05,1533.97), "90 92.2904 0", Vector(-5404.05,5579.05,1394.03) ],
		[ Vector(-3700.87,6485.38,1533.97), "90 90.2478 0", Vector(-3700.87,6485.38,1392.03) ],
		[ Vector(-3255.3,8357.03,1533.97), "90 -91.5034 0", Vector(-3255.3,8357.03,1392.03) ],
		[ Vector(-1277.59,5071.69,1533.97), "90 66.4712 0", Vector(-1277.59,5071.69,1394.03) ],
		[ Vector(-24.4222,3043.02,1533.97), "90 2.02218 0", Vector(-24.4222,3043.02,1394.03) ],
		[ Vector(4712.06,-1200.86,1533.97), "90 -178.788 0", Vector(4712.06,-1200.86,1392.03) ]
	]
	c5m1_waterfront =
	[
		[ Vector(-326.977,-128.422,141.969), "90 179.773 0", Vector(-326.977,-128.422,40.0313) ],
		[ Vector(407.223,-1086.59,141.969), "90 90.1654 0", Vector(407.223,-1086.59,-127.969) ],
		[ Vector(-1503.46,-485.642,445.969), "90 -89.9647 0", Vector(-1503.46,-485.642,273.885) ],
		[ Vector(-3993.26,-1294.51,133.969), "90 0.742977 0", Vector(-3993.26,-1294.51,69.5931) ]
	]
	c5m2_park =
	[
		[ Vector(-4034.4,-1511.41,133.969), "90 0.276911 0", Vector(-4034.4,-1511.41,-15.9688) ]
	]
	c5m3_cemetery =
	[
		[ Vector(5631.82,6039.71,637.969), "90 89.9915 0", Vector(5631.82,6039.71,282.294) ],
		[ Vector(4470.59,7270.16,637.969), "90 0.716269 0", Vector(4470.59,7270.16,227.724) ],
		[ Vector(3261.14,4317.23,637.969), "90 0.194203 0", Vector(3261.14,4317.23,397.346) ],
		[ Vector(3195.88,587.082,637.969), "90 89.6993 0", Vector(3195.88,587.082,370.839) ],
		[ Vector(6339.42,-3042.48,957.969), "90 -91.251 0", Vector(6339.42,-3042.48,891.529) ],
		[ Vector(8767.98,-6591.48,957.969), "90 -90.1126 0", Vector(8767.98,-6591.48,756.031) ]
	]
	
	C12m1_hilltop =
	[
		[ Vector(-8391.1,-14562.1,2189.97), "90 152.49 0", Vector(-8391.1,-14562.1,1856.03) ],
		[ Vector(-9720.29,-9145.34,2189.97), "90 3.28775 0", Vector(-9720.29,-9145.34,1856.01) ]
	]

};



::SpawnCeilingMarkers <- function(){
	local mapname = Director.GetMapName();
	if(!(mapname in CeilingMarkers)){
		ClientPrint(null, 5, "There are no saved ceiling spots for this map");
		return;
	}
	
	foreach(arr in CeilingMarkers[mapname]){
		local signorigin = arr[0];
		local signangles = arr[1];
		local standingposition = arr[2];
		CreateBeam(standingposition, signorigin);
		local middle = (signorigin + standingposition) * 0.5
		local distance = (signorigin + standingposition).Length()
	
		local model = 
		SpawnEntityFromTable("prop_dynamic_override",
		{
			origin = signorigin + Vector(0,0,-2),
			model =	"models/trainingtoolbox/signs/sign05.mdl",
			angles = signangles,
			skin = 3
		})
	}
}


::CreateBeam <- function(from, to){
	
	local toEntity = SpawnEntityFromTable("info_target",
	{
		targetname = UniqueString("lasertarget_"),
		origin = to
	})
	
	local spawntable =
	{
		targetname = UniqueString("laser_"),
		damage = 0,
		dissolvetype = "",
		framestart = 0,
		NoiseAmplitude = 0,
		renderamt = 100,
		rendercolor = "200 0 0",
		width = 1,
		renderfx = 0,
		TextureScroll = 5, // 35
		spawnflags = 1,
		texture = "sprites/laserbeam_inf_only.spr",
		LaserTarget = toEntity.GetName(),
		origin = from
	}
	SpawnEntityFromTable("env_laser", spawntable);
}
