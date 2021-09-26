//****************************************************************************************
//																						//
//									ttb_signplacement.nut								//
//																						//
//****************************************************************************************


// This will place the info panels and the point_commentary_nodes in the saferoom or atleast close to it.
// When the current map is not one of the following theres only a message printed to all players.
// ----------------------------------------------------------------------------------------------------------------------------

function createInformationalEnts(){
	
	local currentMap = Director.GetMapName().tolower()
	
	if((currentMap in signData) && (currentMap in customCommentaryData)){
		// Spawn custom commentary_node
		local file = "#commentary/trainingtoolbox/com-TTB-intro.wav"
		local speaker = "ReneTM"
		createCustomCommentaryNode(customCommentaryData[currentMap], file, speaker)
		// Create the info prop
		SpawnEntityFromTable("prop_dynamic",{ origin = signData[currentMap].origin, model = "models/trainingtoolbox/signs/sign04.mdl", angles = signData[currentMap].angles })
	}else{
		ClientPrint(null, 5, "!commands in chat for further information")
	}
}



