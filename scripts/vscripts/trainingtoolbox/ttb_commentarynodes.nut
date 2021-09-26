
//****************************************************************************************
//																						//
//									ttb_commentarynodes.nut								//
//																						//
//****************************************************************************************

/*
	Using Commentary Nodes in non-commentary-mode 

	1st Method:
	-	map_commentary.txt with "update"-flag set | entities unusable |
	-	map_commentary.txt without "update"-flag | commentary mode needed -> AI Disabled
	-	Editing every single commentary.txt would be needed and custom maps would be "unsuported"
	
	2nd	Method:
	-	Custom FGD-File for Hammer | No usability
	
	3rd	Method:
	-	Create the entity from table via vscript. The "usability" is not given neither but we dont need to edit any commentary.txt-files.
	-	We just need to (A) recreate the "use" -> start/stop-mechanic from any distance and B. to give those nodes an ID like the game usually does automaticly

	This script will recreate the functionality of the point_commentary_nodes as close as possible.
	There are multiple ways to create those entities. The major problem is that the A.I gets modified once a map gets started in commentary mode
	The human player will be ignored.
*/




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




// Return players aim target
// ----------------------------------------------------------------------------------------------------------------------------

function getPointerEnt(player){
	local startPt = player.EyePosition();
	local endPt = startPt + player.EyeAngles().Forward().Scale(999999);
	local m_trace = { start = startPt, end = endPt, ignore = player, mask = TRACE_MASK_PLAYER_SOLID };
	TraceLine(m_trace);
	if("hit" in m_trace && "enthit" in m_trace){
		return m_trace.enthit
	}else{
		return null
	}
}




// Create a commentary node from table
// ----------------------------------------------------------------------------------------------------------------------------

function createCommentaryNode(pos, commentaryfile, speaker){
	local commentaryTable = 
	{
		targetname = "custom_node"
		start_disabled = 0
		origin = pos
		angles = "0 0 0"
		commentaryfile = commentaryfile
		speakers = "Speaker: " + speaker
		precommands = ""
		postcommands = ""
		viewposition = ""
		viewtarget = ""
		prevent_movement = 0
	}
	return SpawnEntityFromTable("point_commentary_node", commentaryTable)
}


// Create a solid but invisible dummy we can shoot tracers to
// ----------------------------------------------------------------------------------------------------------------------------

function createCommentaryDummy(pos){
	local dummy = SpawnEntityFromTable("prop_dynamic", { targetname = "commentary_aim_dummy", model = "models/\\items\\l4d_gift.mdl", origin = pos + Vector(0,0,-8), angles = "0 0 0", solid = 6 })
	NetProps.SetPropInt(dummy, "m_fEffects", 32)
	return dummy
}




// Count commentary nodes and set "node-ID / counted nodes"
// ----------------------------------------------------------------------------------------------------------------------------

function updateNodeData(){
	local node = null;
	local nodeCount = 0;
	local num = 1;
		while(node = Entities.FindByClassname(node, "point_commentary_node")){
		nodeCount++;
	}
	while(node = Entities.FindByClassname(node, "point_commentary_node")){
		NetProps.SetPropInt(node, "m_iNodeNumber", num)
		NetProps.SetPropInt(node, "m_iNodeNumberMax", nodeCount)
		num++;
	}
}




// Saves a set of commentary node and dummy
// ----------------------------------------------------------------------------------------------------------------------------

::commentaryNodes <- {}
function createCustomCommentaryNode(pos, file, speaker){
	local node = createCommentaryNode(pos, file, speaker)
	convertToAustralium(node);
	local dummy = createCommentaryDummy(pos)
	commentaryNodes[node] <- dummy
}

function changeCommentary(file,ent){
	local node = Entities.FindByClassname(null, "point_commentary_node")
	
	if(!(NetProps.GetPropInt(node, "m_bActive") & 1)){
		NetProps.SetPropString(node, "m_iszCommentaryFile", file)	
	}else{
		ClientPrint(ent, 5, "Dont change the commentary file while playback")
	}
}




// Spawns point_commentary_node and plays the given file it gets killed after playing
// ----------------------------------------------------------------------------------------------------------------------------

function playInvisibleCommentary(file, speaker){
	local node = null;
	
	if(!trainingActive){
		if(!anyCommentaryNodeActive()){
			killAllNodes();
			node = createCommentaryNode(Vector(0,0,0), file, speaker)
			node.ValidateScriptScope()
			node.GetScriptScope()["scope"] <- this
			
			node.GetScriptScope()["func"] <- function()
			{
				scope.killAllNodes()
			}
			NetProps.SetPropInt(node, "m_iNodeNumber", 1)
			NetProps.SetPropInt(node, "m_iNodeNumberMax", 1)
			NetProps.SetPropInt(node, "m_fEffects", 32)
			node.ConnectOutput("OnCommentaryStopped", "killAllNodes")
			DoEntFire("!self", "StartCommentary", "", 0, node, node)
		}else{
			sendWarning(speaker, "A commentary node is already active.")
		}
	}else{
		sendWarning(speaker, "Disable the training to play a guide file.")
	}
}




// Remove all nodes and their dummys also
// ----------------------------------------------------------------------------------------------------------------------------

::killAllNodes <- function(){
	local node = null;
	local dummy = null;
	while(node = Entities.FindByClassname(node, "point_commentary_node")){
		node.Kill()
	}
	while(dummy = Entities.FindByName(dummy, "commentary_aim_dummy")){
		dummy.Kill()
	}
	commentaryNodes.clear()
}




// Change worldmodel of one particular commentary node to gold or for all of them
// ----------------------------------------------------------------------------------------------------------------------------

function convertToAustralium(node){
	if(node == null){
		while(node = Entities.FindByClassname(node, "point_commentary_node")){
			node.PrecacheModel("models/extras/info_speech_australium.mdl")
			node.SetModel("models/extras/info_speech_australium.mdl")
		}
	}else{
		node.PrecacheModel("models/extras/info_speech_australium.mdl")
		node.SetModel("models/extras/info_speech_australium.mdl")
	}
}




// Prevent canceling commentary playback
// ----------------------------------------------------------------------------------------------------------------------------

function anyCommentaryNodeActive(){
	local node = null;
	while(node = Entities.FindByClassname(node, "point_commentary_node")){
		if(NetProps.GetPropInt(node, "m_bActive") & 1){
			return true
		}
	}
	return false
}


