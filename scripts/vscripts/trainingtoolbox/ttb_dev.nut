
//****************************************************************************************
//																						//
//										ttb_dev.nut										//
//																						//
//****************************************************************************************




// This is just some dev stuff. Used to get a valid position for a node and the informational props
// ----------------------------------------------------------------------------------------------------------------------------




SendToConsole("bind P \"script getNodePos()\"")
SendToConsole("bind L \"script createSign(null)\"")

::getNodePos <- function(){
	local player = Entities.FindByClassname(null, "player")
	local pos = player.EyePosition() + Vector(0,0,32)
	local mapName = Director.GetMapName()
	local posxnum = split(pos.x.tostring(), ".")[0].tointeger()
	local posynum = split(pos.y.tostring(), ".")[0].tointeger()
	local posznum = split(pos.z.tostring(), ".")[0].tointeger()
	local posx = split(pos.x.tostring(), ".")[0]
	local posy = split(pos.y.tostring(), ".")[0]
	local posz = split(pos.z.tostring(), ".")[0]
	local finalpos = Vector(posxnum,posynum,posznum)
	local stringforfile = "Vector(" + posx + "," + posy + "," + posz + "),"
	StringToFile(mapName+"_NodePosition.txt", stringforfile)	
	Say(null, "" + finalpos, false)
	DebugDrawBox( finalpos, Vector(16,8,16), Vector(-16,-8,-16), 255, 100, 10, 140, 7)
}

::createSign<-function(overridepos){
	local player = Entities.FindByClassname(null, "player")
	
	//Kill previous sign
	local sign = null;
	while(sign = Entities.FindByModel(sign,"models/trainingtoolbox/signs/sign04.mdl")){
		sign.Kill()
	}
	//GetZ of player view
	local centerz = player.EyePosition().z
	
	local data = getPointerPos(player)
	local pos = data.pos
	local angles = data.ang
	
	local origin = Vector(pos.x,pos.y,centerz)
	
	if(overridepos != null){
		origin = overridepos
	}
	
	Say(null,""+origin,false)
	local sign = SpawnEntityFromTable("prop_dynamic",{origin = origin, model = "models/trainingtoolbox/signs/sign04.mdl", angles = angles})
	writeSignData(("origin = " + origin + ", angles = " + angles).tostring())
}




// Returns information about the players view angle and the wall hes looking at
// ----------------------------------------------------------------------------------------------------------------------------

::getPointerPos<-function(player){
	local startPt = player.EyePosition();
	local endPt = startPt + player.EyeAngles().Forward().Scale(2048);
	local m_trace1 = { start = startPt, end = endPt, ignore = player, mask = TRACE_MASK_SHOT };
	local m_trace2 = { start = startPt, end = endPt + Vector(64,64,64), ignore = player, mask = TRACE_MASK_SHOT };
	local angle = null
	
	DebugDrawLine(startPt, endPt+Vector(64,64,64), 0, 255, 0, false, 7)
	DebugDrawLine(startPt, endPt, 0, 255, 0, false, 7)
	TraceLine(m_trace1);
	TraceLine(m_trace2);
	
	//Is wall following the Y-Axis?
	if(m_trace1.pos.x == m_trace2.pos.x){
		if((player.GetOrigin()).x > m_trace1.pos.x){
			angle = "0 0 0"
		}
		else
		{
			angle = "0 180 0"
		}
	}
	//Is wall following the X-Axis?
	else if(m_trace1.pos.y == m_trace2.pos.y){
		if((player.GetOrigin()).y > m_trace1.pos.y){
			angle = "0 90 0"
		}
		else
		{
			angle = "0 -90 0"
		}
	}
	else
	{
		angle = "0 0 0"
	}
	
	return {pos = m_trace1.pos, ang = angle}
}




// Write the file
// ----------------------------------------------------------------------------------------------------------------------------
::writeSignData <- function(data){
	local mapName = Director.GetMapName()
	StringToFile(mapName + ".txt",data)
}


