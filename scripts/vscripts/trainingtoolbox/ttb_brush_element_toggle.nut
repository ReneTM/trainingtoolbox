//****************************************************************************************
//																						//
//								ttb_brush_element_toggle.nut							//
//																						//
//****************************************************************************************

boundaryData <- 
{
	clip =
	{
		color = Vector(255,0,0),
		alpha = 255
	},
	playerclip =
	{
		color = Vector(255,0,255),
		alpha = 255
	},
	infectedclip =
	{
		color = Vector(105,0,255),
		alpha = 255
	}
	sky =
	{
		color = Vector(0,124,160),
		alpha = 255
	}
}


local modelpath = "models/trainingtoolbox/visualisation/";
local mapname = Director.GetMapName();



local savedBoundaryMaps = 
[
	"c1m1", "c1m2", "c1m3", "c1m4",
	"c2m1", "c2m2", "c2m3", "c2m4", "c2m5",
	"c3m1", "c3m2", "c3m3", "c3m4",
	"c4m1", "c4m2", "c4m3", "c4m4", "c4m5",
	"c5m1", "c5m2", "c5m3", "c5m4", "c5m5",
	"c6m1", "c6m2", "c6m3",
	"c7m1", "c7m2", "c7m3",
	"c8m1", "c8m2", "c8m3", "c8m4", "c8m5",
	"c9m1", "c9m2",
	"c10m1", "c10m2", "c10m3", "c10m4", "c10m5",
	"c11m1", "c11m2", "c11m3", "c11m4", "c11m5",
	"c12m1", "c12m2", "c12m3", "c12m4", "c12m5",
	"c13m1", "c13m2", "c13m3", "c13m4"
	"c14m1", "c14m2"
];

function setFogVisibility(player, val){
	
	local fogCommander = null
	fogCommander = Entities.FindByClassname(null, "point_broadcastclientcommand");
	if(!fogCommander){
		fogCommander = SpawnEntityFromTable("point_broadcastclientcommand", {
			targetname = "fog_commander"
		})
	}
	
	local ent = null
	while(ent = Entities.FindByClassname(ent, "env_fog_controller")){
		ent.ValidateScriptScope()
		local scope = ent.GetScriptScope()
		if(!("init_props" in scope)){
			scope["init_props"] <-
			{
				enabled = NetProps.GetPropInt(ent, "m_fog.enable"),
				farz = NetProps.GetPropInt(ent, "m_fog.farz")
			}
		}
		if(val){
			NetProps.SetPropInt(ent, "m_fog.enable", scope["init_props"].enabled);
			NetProps.SetPropInt(ent, "m_fog.farz", scope["init_props"].farz);
			DoEntFire("!self", "SetFarZ", "" + scope["init_props"].farz , 0.03, ent, ent)
			EntFire("fog_commander", "Command", "r_skyboxfogfactor 1.0", 0.03)
		}else{
			NetProps.SetPropInt(ent, "m_fog.enable", 0);
			NetProps.SetPropInt(ent, "m_fog.farz", 999999999);
			DoEntFire("!self", "SetFarZ", "999999999" , 0.03, ent, ent)
			EntFire("fog_commander", "Command", "r_skyboxfogfactor 0.0", 0.03)
			
			
		}
	}
}

function toggleBrushElement(ent, type){
	
	local mapname = Director.GetMapName()
	local mapname = split(mapname,"_")[0]
	local modelTypes = ["clip", "playerclip", "infectedclip", "sky"];
	
	if(savedBoundaryMaps.find(mapname) == null){
		ClientPrint(null, 5, "No saved clip models for current map!");
		return;
	}
	
	if(modelTypes.find(type) == null){
		ClientPrint(null, 5, "Invalid type has been passed!");
		return;
	}
	
	local modelName = "models/trainingtoolbox/visualisation/" + mapname + "_" + type + ".mdl"
	
	local targetName = type + "_brush_model"

	
	local ent = Entities.FindByName(null, targetName)
	if(ent){
		if(NetProps.GetPropInt(ent, "m_fEffects") & 32 ){
			NetProps.SetPropInt(ent, "m_fEffects", NetProps.GetPropInt(ent, "m_fEffects") & ~32) ;
		}else{
			local current = NetProps.GetPropInt(ent, "m_fEffects");
			NetProps.SetPropInt(ent, "m_fEffects", current | 32);
		}
		return;
	}
	
	
	local spawntable = 
	{
		targetname = targetName
		disableshadows = 1
		disablereceiveshadows = 1
		fadescale = 0.0
		angles = "0 270 0"
		origin = Vector(0,0,0)
		solid = 0
		rendercolor = boundaryData[type].color.ToKVString()
		renderamt = boundaryData[type].alpha			// Does not work for some reason
		renderfx = 0
		rendermode = 1
		model = modelName
		//model = (format("models/skybrush_models/%s.mdl", mapName))
	}
	local ent = SpawnEntityFromTable("prop_dynamic", spawntable)
	DoEntFire("!self", "alpha", "" + boundaryData.sky.alpha, 0.03, ent, ent)
}