//****************************************************************************************
//																						//
//									ttb_weaponstats.nut									//
//																						//
//****************************************************************************************


/*
	HSTM / TrainingToolbox-Weapon-Statistics
	---------------------------------
	This script will print all important weapon statistics of the active weapon/melee to the console
*/


weaponStats <-
{
	weapon_smg_silenced =
	{
		name = "smg_silenced",type = "primary",slot = 0,tier = 1,
		magCap = 50,totalCap = 700,shotDMG = 25,magDMG = 1250,totalDMG = 17500,
		bulletPerSecond = 16,emptyMagTime = 3.16,reloadTime = 2.26,
		VertPunch = 1,SpreadPerShot = 0.4,MaxSpread = 30,SpreadDecay = 5,MinDuckingSpread = 0.85,MinStandingSpread = 1.2,MinInAirSpread = 1.7,MaxMovementSpread = 3,
		PeneNumLayers = 2,PenePower = 30,PeneMaxDist = 0,Range = 2200,RangeMod = 0.84
	},
	weapon_smg =
	{
		name = "smg",type = "primary",slot = 0,tier = 1,
		magCap = 50,totalCap = 700,shotDMG = 20,magDMG = 1000,totalDMG = 14000,
		bulletPerSecond = 16,emptyMagTime = 3.16,reloadTime = 2.26,
		VertPunch = 0.9,SpreadPerShot = 0.32,MaxSpread = 30,SpreadDecay = 5,MinDuckingSpread = 0.7,MinStandingSpread = 1.0,MinInAirSpread = 1.7,MaxMovementSpread = 3,
		PeneNumLayers = 2,PenePower = 30,PeneMaxDist = 0,Range = 2500,RangeMod = 0.84
	}
	weapon_smg_mp5 =
	{
		name = "smg_mp5",type = "primary",slot = 0,tier = 1,
		magCap = 50,totalCap = 650,shotDMG = 24,magDMG = 1200,totalDMG = 16800,
		bulletPerSecond = 13.1,emptyMagTime = 3.8,reloadTime = 3.06,
		VertPunch = 1,SpreadPerShot = 0.35,MaxSpread = 30,SpreadDecay = 5,MinDuckingSpread = 0.75,MinStandingSpread = 1.1,MinInAirSpread = 1.7,MaxMovementSpread = 3,
		PeneNumLayers = 2,PenePower = 30,PeneMaxDist = 0,Range = 2500,RangeMod = 0.84
	}
	weapon_rifle_sg552 =
	{
		name = "sg_552",type = "primary",slot = 0,tier = 2,
		magCap = 50,totalCap = 360,shotDMG = 33,magDMG = 1650,totalDMG = 13530,
		bulletPerSecond = 11.9,bulletPerSecondScoped = 7.4,emptyMagTime = 4.23,emptyMagTimeScoped = 6.76,reloadTime = 3.4,
		VertPunch = 1.2,SpreadPerShot = 0.75,MaxSpread = 30,SpreadDecay = 5,MinDuckingSpread = 0.05,MinInAirSpread = 1.5,MaxMovementSpread = 5,
		PeneNumLayers = 2,PenePower = 50,PeneMaxDist = 0,Range = 3000,RangeMod = 0.97
	}
	weapon_rifle =
	{
		name = "rifle",type = "primary",slot = 0,tier = 2,
		magCap = 50,totalCap = 410,shotDMG = 33,magDMG = 1650,totalDMG = 13530,
		bulletPerSecond = 11.4,emptyMagTime = 4.43,reloadTime = 2.2,
		VertPunch = 1.2,SpreadPerShot = 0.75,MaxSpread = 30,SpreadDecay = 5,MinStandingSpread = 0.4,MinInAirSpread = 1.5,MaxMovementSpread = 5,
		PeneNumLayers = 2,PenePower = 50,PeneMaxDist = 0,Range = 3000,RangeMod = 0.97
	}
	weapon_rifle_desert =
	{
		name = "rifle_desert",type = "primary",slot = 0,tier = 2,
		magCap = 60,totalCap = 420,shotDMG = 44,magDMG = 2640,totalDMG = 18480,
		bulletPerSecond = 8.37,emptyMagTime = 7.26,reloadTime = 3.3,
		VertPunch = 1.0,SpreadPerShot = 0.6,MaxSpread = 25,SpreadDecay = 4,MinDuckingSpread = 0.05,MinStandingSpread = 0.35,MinInAirSpread = 1.25,MaxMovementSpread = 4,
		PeneNumLayers = 2,PenePower = 50,PeneMaxDist = 0,Range = 3000,RangeMod = 0.97
	}
	weapon_rifle_ak47 =
	{
		name = "rifle_ak47",type = "primary",slot = 0,tier = 2,
		magCap = 40,totalCap = 400,shotDMG = 58,magDMG = 2320,totalDMG = 23200,
		bulletPerSecond = 7.69,emptyMagTime = 5.3,reloadTime = 2.4,
		VertPunch = 2,SpreadPerShot = 1.6,MaxSpread = 35,SpreadDecay = 7,MinDuckingSpread = 0.5,MinStandingSpread = 1,MinInAirSpread = 3,MaxMovementSpread = 6,
		PenePower = 50,Range = 3000,RangeMod = 0.97
	}
	weapon_rifle_m60 =
	{
		name = "rifle_m60",type = "primary",slot = 0,tier = "special",
		magCap = 150,totalCap = 0,shotDMG = 50,magDMG = 7500,totalDMG = 7500,
		bulletPerSecond = 9.16,emptyMagTime = 16.36,reloadTime = "no reload possible",
		VertPunch = 2,SpreadPerShot = 1.6,MaxSpread = 35,SpreadDecay = 7,MinStandingSpread = 1,MinInAirSpread = 3,MaxMovementSpread = 6,
		PeneNumLayers = 2,PenePower = 50,PeneMaxDist = 0,Range = 3000,RangeMod = 0.97
	}
	weapon_autoshotgun =
	{
		name = "autoshotgun",type = "primary",slot = 0,tier = 2,
		magCap = 10,totalCap = 100,shotDMG = 286,magDMG = 2860,pelletCount = 11,pelletDMG = 26,totalDMG = 38896,
		shotIntervalHOLDM1 = 0.46,emptyMagTimeHOLDM1 = 4.46,shotIntervalTIMED = 0.26,emptyMagTimeTIMED = 2.66,
		VertPunch = 3,SpreadPerShot = 20,MaxSpread = 5,SpreadDecay = 5,MinDuckingSpread = 0,MinStandingSpread = 0.8,MinInAirSpread = 2.5,MaxMovementSpread = 1.5,
		PeneNumLayers = 2,PenePower = 30,PeneMaxDist = 500,CharacterPeneMaxDist = 300,Range = 3000,RangeMod = 0.7
	}
	weapon_shotgun_spas =
	{
		name = "spas",type = "primary",slot = 0,tier = 2,
		magCap = 10,totalCap = 100,shotDMG = 252,pelletCount = 9,pelletDMG = 28, magDMG = 2520,totalDMG = 25200
		shotIntervalHOLDM1 = 0.46,emptyMagTimeHOLDM1 = 4.46,shotIntervalTIMED = 0.26,emptyMagTimeTIMED = 2.66,
		VertPunch = 3,SpreadPerShot = 22,SpreadDecay = 6,MinDuckingSpread = 0,MinStandingSpread = 0.75,MaxMovementSpread = 1.5,
		PeneNumLayers = 2,PenePower = 30,PeneMaxDist = 500,CharacterPeneMaxDist = 300,Range = 3000,RangeMod = 0.7
	}
	weapon_pumpshotgun =
	{
		name = "pumpshotgun",type = "primary",slot = 0,tier = 1,
		magCap = 8,totalCap = 80,shotDMG = 250,pelletCount = 10,pelletDMG = 25,magDMG = 2000,totalDMG = 16000,
		shotInterval = 0.9,reloadTime = 4.2,shotIntervalExploit = 0.73,
		VertPunch = 4,SpreadPerShot = 1,MaxSpread = 5,SpreadDecay = 5,MinDuckingSpread = 0,MinStandingSpread = 0.8,MinInAirSpread = 2.5,MaxMovementSpread = 1.5,
		PeneNumLayers = 2,PenePower = 30,PeneMaxDist = 500,CharacterPeneMaxDist = 300,Range = 3000,RangeMod = 0.7
	}
	weapon_shotgun_chrome =
	{
		name = "shotgun_chrome",type = "primary",slot = 0,tier = 1,
		magCap = 8,totalCap = 80,shotDMG = 248,pelletCount = 8,pelletDMG = 31,magDMG = 1984,totalDMG = 15872,
		shotInterval = 0.9,reloadTime = 4.2,shotIntervalExploit = 0.73,
		VertPunch = 4,SpreadPerShot = 1,MaxSpread = 5,SpreadDecay = 5,MinDuckingSpread = 0,MinStandingSpread = 0.8,MinInAirSpread = 2.5,MaxMovementSpread = 1.5,
		PeneNumLayers = 2,PenePower = 30,PeneMaxDist = 500,CharacterPeneMaxDist = 300,Range = 3000,RangeMod = 0.7
	}
	weapon_hunting_rifle =
	{
		name ="hunting_rifle",type = "primary",slot = 0,tier = 2,
		magCap = 15,totalCap = 165,shotDMG = 90,magDMG = 1350,totalDMG = 14850
		shotInterval = 0.26,emptyMagTime = 4,reloadTime = 3.13,
		VertPunch = 1.5,SpreadPerShot = 1,MaxSpread = 15,SpreadDecay = 8,MinDuckingSpread = 0,MinStandingSpread = 0.1,MinInAirSpread = 1.5,MaxMovementSpread = 3,
		PeneNumLayers = 2,PenePower = 50,CharacterPeneMaxDist = 8192,Range = 8192,RangeMod = 1.0
	}
	weapon_sniper_military =
	{
		name = "military_sniper",type = "primary",slot = 0,tier = 2,
		magCap = 30,totalCap = 210,shotDMG = 90,totalDMG = 18900
		magDMG = 2700,shotInterval = 0.26,emptyMagTime = 8,reloadTime = 3.33,
		VertPunch = 1.5,SpreadPerShot = 1,MaxSpread = 15,SpreadDecay = 8,MinDuckingSpread = 0.05,MinStandingSpread = 0.5,MinInAirSpread = 1.5,MaxMovementSpread = 5,
		PeneNumLayers = 2,PenePower = 50,PeneMaxDist = 0,CharacterPeneMaxDist = 8192,Range = 8192,RangeMod = 1.0
	}
	weapon_sniper_scout =
	{
		name = "sniper_scout",type = "primary",slot = 0,tier = 2,
		magCap = 15,totalCap = 180,shotDMG = 90,magDMG = 1350,totalDMG = 17550
		emptyMagTime = 13.5,shotInterval = 0.9,shotIntervalExploit = 0.73,reloadTime = 2.9,
		VertPunch = 1.5,SpreadPerShot = 1,MaxSpread = 15,SpreadDecay = 8,MinDuckingSpread = 0,MinStandingSpread = 0.1,MinInAirSpread = 1.5,MaxMovementSpread = 3,
		PeneNumLayers = 2,PenePower = 50,PeneMaxDist = 0,CharacterPeneMaxDist = 8192,Range = 8192,RangeMod = 1.0
	}
	weapon_sniper_awp =
	{
		name = "sniper_awp",type = "primary",slot = 0,tier = 2,
		magCap = 20,totalCap = 180,shotDMG = 115,magDMG = 2300,totalDMG = 23000
		emptyMagTime = 21.9,shotInterval = 1.066,shotIntervalExploit = 0.73,reloadTime = 3.66,
		VertPunch = 1.5,SpreadPerShot = 1,MaxSpread = 15,SpreadDecay = 8,MinDuckingSpread = 0,MinStandingSpread = 0.1,MinInAirSpread = 1.5,MaxMovementSpread = 3,
		PeneNumLayers = 2,PenePower = 50,PeneMaxDist = 0,CharacterPeneMaxDist = 8192,Range = 8192,RangeMod = 1.0
	}
	weapon_pistol =
	{
		name = "pistol",type = "primary",slot = 0,tier = "sidearm",
		magCap = 15,totalCap = "infinite",emptyMagTime = 3,shotDMG = 36,magDMG = 540,totalDMG = "infinite"
		emptyReloadTime = 2.0,fastReloadTime = 1.6,
		VertPunch = 2.0,SpreadPerShot = 1,SpreadDecay = 5,MinDuckingSpread = 0.5,MinStandingSpread = 1.5,MinInAirSpread = 3.0,MaxMovementSpread = 3.0,
		PeneNumLayers = 2,PenePower = 30,PeneMaxDist = 0,Range = 2500,RangeMod = 0.75
	}
	weapon_pistols =
	{
		name = "double pistol",type = "secondary",slot = 1,tier = "sidearm",
		magCap = 30,totalCap = "infinite",emptyMagTime = 3,shotDMG = 36,magDMG = 1080,totalDMG = "infinite",
		emptyReloadTime = 2.5,fastReloadTime = 2.33,
		VertPunch = 2.0,SpreadPerShot = 1,SpreadDecay = 5,MinDuckingSpread = 0.5,MinStandingSpread = 1.5,MinInAirSpread = 3.0,MaxMovementSpread = 3.0,
		PeneNumLayers = 2,PenePower = 30,PeneMaxDist = 0,Range = 2500,RangeMod = 0.75
	}
	weapon_pistol_magnum =
	{
		name = "pistol_magnum",type = "secondary",slot = 1,tier = "sidearm",
		magCap = 8,totalCap = "infinite",shotDMG = 80,magDMG = 640,totalDMG = "infinite",
		emptyMagTime = 2.56,emptyReloadTime = 2.0,fastReloadTime = 1.6,
		VertPunch = 4.0,SpreadPerShot = 2,MaxSpread = 30,SpreadDecay = 5,MinDuckingSpread = 0.5,MinStandingSpread = 1.25,MinInAirSpread = 3.0,MaxMovementSpread = 3.0,
		PeneNumLayers = 2,PenePower = 50,PeneMaxDist = 0,Range = 3500,RangeMod = 0.75
	}
	
	weapon_grenade_launcher =
	{
		shotInterval = "1 grenade every 4.1 seconds",reloadTime = 3.3,type = "primary",slot = 0,tier = "special",
	}
	
	fireaxe =
	{
		name = "fireaxe",damageType = "Sharp",swingInterval = 0.93,type = "secondary",slot = 1,Range = "All melees got a range of 70 units"
	}
	katana =
	{
		name = "katana",damageType = "Sharp",swingInterval = "0.83/0.73",type = "secondary",slot = 1,Range = "All melees got a range of 70 units"
	}
	machete =
	{
		name = "machete",damageType = "Sharp",swingInterval = "0.73/0.6",type = "secondary",slot = 1,Range = "All melees got a range of 70 units"
	}
	knife =
	{
		name = "knife",damageType = "Sharp",swingInterval = "0.7/0.73",type = "secondary",slot = 1,Range = "All melees got a range of 70 units"
	}
	crowbar =
	{
		name = "crowbar",damageType = "Sharp",swingInterval = "0.96/0.9",type = "secondary",slot = 1,Range = "All melees got a range of 70 units"
	}
	baseball_bat =
	{
		name = "baseball_bat",damageType = "Blunt",swingInterval = 0.86,type = "secondary",slot = 1,Range = "All melees got a range of 70 units"
	}
	cricket_bat =
	{
		name = "cricket_bat",damageType = "Blunt",swingInterval = 0.86,type = "secondary",slot = 1,Range = "All melees got a range of 70 units"
	}
	golfclub =
	{
		name = "golfclub",damageType = "Blunt",swingInterval = "0.73/0.83",type = "secondary",slot = 1,Range = "All melees got a range of 70 units"
	}
	tonfa =
	{
		name = "tonfa",damageType = "Blunt",swingInterval = "0.73/0.6",type = "secondary",slot = 1,Range = "All melees got a range of 70 units"
	}
	electric_guitar =
	{
		name = "electric_guitar",damageType = "Blunt",swingInterval = 0.93,type = "secondary",slot = 1,Range = "All melees got a range of 70 units"
	}
	frying_pan =
	{
		name = "frying_pan",damageType = "Blunt",swingInterval = "0.8/1.0",type = "secondary",slot = 1,Range = "All melees got a range of 70 units"
	}
	riot_shield =
	{
		name = "riot_shield",damageType = "Blunt",swingInterval = "0.5/0.73",type = "secondary",slot = 1,Range = "All melees got a range of 70 units"
	}
	shovel =
	{
		name = "shovel", damageType = "Blunt", swingInterval = "0.9/1.06", type = "secondary", slot = 1,Range = "All melees got a range of 70 units"
	}
	pitchfork =
	{
		name = "pitchfork", damageType = "Sharp", swingInterval = "0.8/1.0", type = "secondary", slot = 1,Range = "All melees got a range of 70 units"
	}
	chainsaw =
	{
		name = "chainsaw", damageType = "Sharp", swingInterval = "0.1", totalCap = "30 seconds duration", type = "secondary", slot = 1, Range = "50"
	}
}




local meleeArray=

[
	"fireaxe",
	"crowbar",
	"katana",
	"machete",
	"hunting_knife",
	"baseball_bat",
	"cricket_bat",
	"golfclub",
	"tonfa",
	"electric_guitar",
	"riot_shield",
	"frying_pan",
	"shovel",
	"pitchfork"
]


function GetPlayersActiveWeapon(player){
	local activeWeapon = player.GetActiveWeapon()
	local activeWeaponClass = activeWeapon.GetClassname()
	
	if(meleeArray.find(NetProps.GetPropString(activeWeapon, "m_strMapSetScriptName")) != null){
		return NetProps.GetPropString(activeWeapon, "m_strMapSetScriptName")
	}else if(NetProps.GetPropString(activeWeapon,"m_ModelName") == "models/v_models/v_knife_t.mdl"){
		return "knife"
	}else if(NetProps.GetPropString(activeWeapon,"m_ModelName") == "models/weapons/melee/v_riotshield.mdl"){
		return "copthingy"
	}else if(NetProps.GetPropString(activeWeapon,"m_ModelName") == "models/weapons/melee/v_shovel.mdl"){
		return "shovel"
	}else if(NetProps.GetPropString(activeWeapon,"m_ModelName") == "models/weapons/melee/v_pitchfork.mdl"){
		return "pitchfork"
	}else{
		if(activeWeaponClass == "weapon_pistol"){
			if(NetProps.GetPropInt(activeWeapon,"m_isDualWielding") == 1){
				return "weapon_pistols"
			}
		}
		return activeWeapon.GetClassname()
	}
}

function writeKeyVal(text,table,key,player){
	if(key in table){
		local keylen = text.len()
		local toappend = 22 - keylen
		local space = ""
		for(local i = 0 ; i< toappend; i++){
			space = space + " ";
		}
		text = text + space; 
		ClientPrint(player,1,text+" = "+table[key])
	}
}



function outputWeaponStats(player, weapon){

	if(!(weapon in weaponStats)){
		ClientPrint(null, 5, "Active item / weapon is not part of the statistic data " + weapon)
		return
	}

	local weaponTable = weaponStats[weapon]

	ClientPrint(player,1," ")
	ClientPrint(player,1,"--------------- GENERAL -------------")
	ClientPrint(player,1," ")
	writeKeyVal("Name",weaponTable,"name",player)
	writeKeyVal("Tier",weaponTable,"tier",player)
	writeKeyVal("Type",weaponTable,"type",player)
	writeKeyVal("Slot",weaponTable,"slot",player)
	writeKeyVal("Damage Type",weaponTable,"damageType",player)
	ClientPrint(player,1," ")
	ClientPrint(player,1,"---------------- AMMO ---------------")
	ClientPrint(player,1," ")
	writeKeyVal("Mag.Capacity",weaponTable,"magCap",player)
	writeKeyVal("Total.Capacity",weaponTable,"totalCap",player)
	ClientPrint(player,1," ")
	ClientPrint(player,1,"--------------- DAMAGE --------------")
	ClientPrint(player,1," ")
	writeKeyVal("Damage (shot)",weaponTable,"shotDMG",player)
	writeKeyVal("Damage (mag)",weaponTable,"magDMG",player)
	writeKeyVal("Damage (total)",weaponTable,"totalDMG",player)
	ClientPrint(player,1," ")
	ClientPrint(player,1,"-------------- TIMINGS --------------")
	ClientPrint(player,1," ")
	writeKeyVal("Shot Interval",weaponTable,"shotInterval",player)
	writeKeyVal("Bullets Per Second",weaponTable,"bulletPerSecond",player)
	writeKeyVal("Bullets Per Second (scoped)",weaponTable,"bulletPerSecondScoped",player)
	writeKeyVal("Empty mag. Time",weaponTable,"emptyMagTime",player)
	writeKeyVal("Empty mag. HoldM1",weaponTable,"emptyMagTimeHOLDM1",player)
	writeKeyVal("Empty mag. Timed",weaponTable,"emptyMagTimeTIMED",player)
	writeKeyVal("Reload Time",weaponTable,"reloadTime",player)
	writeKeyVal("Empty reload Time",weaponTable,"emptyReloadTime",player)
	writeKeyVal("Fast reload Time",weaponTable,"fastReloadTime",player)
	writeKeyVal("Swing Interval",weaponTable,"swingInterval",player)
	ClientPrint(player,1," ")
	ClientPrint(player,1,"--------------- SPREAD --------------")
	ClientPrint(player,1," ")
	writeKeyVal("Vertical Punch",weaponTable,"VertPunch",player)
	writeKeyVal("Spread per Shot",weaponTable,"SpreadPerShot",player)
	writeKeyVal("Max. Spread",weaponTable,"MaxSpread",player)
	writeKeyVal("Spread Decay",weaponTable,"SpreadDecay",player)
	writeKeyVal("Min Ducking Spread",weaponTable,"MinDuckingSpread",player)
	writeKeyVal("Min Standing Spread",weaponTable,"MinStandingSpread",player)
	writeKeyVal("Min In Air Spread",weaponTable,"MinInAirSpread",player)
	writeKeyVal("Max Movement Spread",weaponTable,"MaxMovementSpread",player)
	ClientPrint(player,1," ")
	ClientPrint(player,1,"-------- PENETRATION & RANGE --------")
	ClientPrint(player,1," ")
	writeKeyVal("Pen. Num Layers",weaponTable,"PeneNumLayers",player)
	writeKeyVal("Pen. Power",weaponTable,"PenePower",player)
	writeKeyVal("Pen. Max Distance",weaponTable,"PeneMaxDist",player)
	writeKeyVal("Range",weaponTable,"Range",player)
	writeKeyVal("Range Modifier",weaponTable,"RangeMod",player)
	ClientPrint(player, 5, BLUE + "Weaponstats got printed to console")
}

