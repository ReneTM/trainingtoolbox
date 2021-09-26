//****************************************************************************************
//																						//
//									ttb_commentary_shine								//
//																						//
//****************************************************************************************

function createBubbleShine(){
	
	local node = Entities.FindByClassname(null, "point_commentary_node")
	local pos = null
	
	if(node == null){
		return
	}

	local traceTable = { start = node.GetOrigin() + Vector(0,0,-16), end = node.GetOrigin() + Vector(0,0,-256), ignore = "", mask = TRACE_MASK_PLAYER_SOLID }
	TraceLine(traceTable)

	if("hit" in traceTable && "pos" in traceTable){
		pos = traceTable["pos"]
	}
	
	if(pos == null){
		return
	}

	local spotTable =
	{
		targetname = "ttb_point_spotlight"
		angles = "-90 0 0"
		origin = pos
		disableX360 = 0
		maxgpulevel = 0
		mingpulevel = 0
		disablereceiveshadows = 1
		renderfx = 0
		mincpulevel = 0
		maxcpulevel = 0
		fademaxdist = 0
		fademindist = 0
		fadescale = 0
		rendermode = 1
		HaloScale = 16
		spotlightwidth = 40
		HDRColorScale = 0.7
		spotlightlength = 128
		renderamt = 200
		spawnflags = 1
		rendercolor = Vector(255,255,140)
	}
	
	local modelTable = 	
	{
		targetname = "ttb_spotlight_model"
		origin = pos
		angles = "0 180 180"
		body = 0
		DisableBoneFollowers = 1
		disablereceiveshadows = 1
		disableshadows = 1
		disableX360 = 0
		ExplodeDamage = 0
		ExplodeRadius = 0
		fademaxdist = 0
		fademindist = -1
		fadescale = 0
		glowbackfacemult = 1 // glowcolor = "255 255 255"
		glowrange = 0
		glowrangemin = 0
		glowstate = 0
		health = 0
		LagCompensate = 0
		MaxAnimTime = 10
		maxcpulevel = 0
		maxgpulevel = 0
		MinAnimTime = 5
		mincpulevel = 0
		mingpulevel = 0
		model = "models/props/cs_office/light_inset.mdl"
		PerformanceMode = 0
		pressuredelay = 0
		RandomAnimation = 0 
		renderamt = 255
		rendercolor = Vector(255,255,255)
		renderfx = 0
		rendermode = 1
		SetBodyGroup = 0
		skin = 0
		solid = 1
		spawnflags = 0
		updatechildren = 0
	}

	local spot = SpawnEntityFromTable("prop_dynamic_override", modelTable)
	local spotModel = SpawnEntityFromTable("point_spotlight", spotTable)
}

function killBubbleShine(){
	
	local spot = null
	local beam = null
	local model = null
	
	while(spot = Entities.FindByName(spot, "ttb_point_spotlight")){
		while(beam = Entities.FindByClassnameWithin(beam, "Beam", spot.GetOrigin(), 128)){
			beam.Kill()
		}
		spot.Kill()
	}
	
	while(model = Entities.FindByName(model, "ttb_spotlight_model")){
		model.Kill()
	}
}








	



