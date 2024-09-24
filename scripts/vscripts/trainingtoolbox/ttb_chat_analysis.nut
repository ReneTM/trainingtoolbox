//****************************************************************************************
//																						//
//									ttb_chat_analysis.nut								//
//																						//
//****************************************************************************************


local arsenal =
[
	// Sniper Rifles
	"huntingrifle","autosniper",				
	// Handguns
	"deagle","pistol",
	// Rifles
	"ak","scar","rifle",
	// Shotguns
	"chrome","pump","autoshotty","spas",
	// SMGs
	"silenced","smg",
	// CSS-Weapons
	"scout","awp","sg","mp5",
	// Special
	"m60","grenadelauncher","chainsaw",
	// Carried
	"cola","gnome",
	// Carry
	"propane","gascan","oxygen"
	// Health Items
	"adrenaline","pills","defib","medkit",
	// Throwables
	"bile","pipe","molo",
	// Ubgrade Items
	"explosive","incendiary","laser","explosives","incendiaries","fuelbarrel","rocklauncher","undorocklaunchers","rocklauncherdir",
	// Blunt Melees
	"golfclub","pan","bat","cricket","tonfa","guitar","riotshield",
	// Sharp Melees
	"machete","fireaxe","katana","crowbar","shovel","pitchfork","knife",
	// Become infected
	"becomejockey","becomehunter","becomecharger","becomesmoker","becomespitter","becomeboomer","becometank","becomesurvivor","toggleghostmode","kill","tankrockselector","god","map","showmykeys",
	"spectate","dummy","bots","removebots","addbot","showdamage","respawntanktoys","showtanktoys", "tanktoysalwaysvisible",
	"strip", "stripall", "infectedtoggle", "checkbhops","timescale","movebot","movebots","botsholdpositions","savebotposition","camera","lockview","unlockview","distancetest","weaponspawndebug","tankrockcamera"

]

local validCommands =
[
	// General
	"training","commands",
	// Infected
	"hunter","jockey","charger","smoker","boomer","spitter","tank","witch","common","savepreset","loadpreset",
	// Uncommon
	"riot",	"ceda","mud","roadcrew","jimmy","clown","fallen",
	// Movement & position related
	"startposition","savepos","loadpos", "noclip","toggledaytime","tankthrowslogs",
	// Infected spawns
	"undo", "redo", "undoall",
	// Items
	"ammo", "health","healthall",
	//Commands
	"spawns","weapons","melees","misc","debug","version","guides","saferoomtoggle",
	// Debug
	"falldamagedebug", "penetrationtest", "boomerdebug", "smokerdebug", "tankdebug",
	"infernodebug", "meleedebug", "hitboxdebug", "fastclear", "escaperoute", "eventdebug",
	// Commentary files
	"skeeting","leveling","crowning","tonguecutting","deadstopping","intro","stopcommentary",
	// Misc
	"weaponstats","toggleparticles","toggledummyangles","frags","lerp","autobhop","skinswitch",
	"infammo","burninginfected","thirdperson","firstperson"
	// Infected Variants
	"witchvariant","tankvariant","huntervariant","smokervariant", "boomervariant", "infected","cvar","ceiling","ceilingspots",
	// Squirrel
	"script", "raw", "squirreldebug", "stattrack","examplerock","distancetoexamplerock","togglenadeprediction","showsaferoom","sky", "clips", "playerclips", "infectedclips", "fogon", "fogoff",
	"listenclass"

]




function isNumeric(value){
	local newValue
	local numbers = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" ]
	for(local i = 0; i < value.len(); i++){
		local checkChar = value.slice(i, i+1)
		if(numbers.find(checkChar) == null){
			return false
		}
	}
	return true
}




// Returns a table with command and parameter
// ----------------------------------------------------------------------------------------------------------------------------

function getCommandData(text){
	
	local command = null
	local parameter = null
	
	if(text.len() > 1)
	{
		if(text.slice(0, 1) == "!")														// "!" indicator for command
		{
			text = text.slice(1, text.len())											// Chat message just without "!"
			
			command = split(text, " ")[0]												// Command with no argument
			
			if(validCommands.find(command) != null || arsenal.find(command) != null)
			{			
				if(split(text, " ").len() == 2)											// Parameter
				{
					parameter = split(text, " ")[1]
					//parameter = strip(text.slice(command.len(),text.len()))
				}
			}
			else
			{
				command = null
				ClientPrint(null, 5, "Unknown command")
			}
		}
	}
	return { command = command, parameter = parameter }
}







