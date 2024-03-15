//****************************************************************************************
//																						//
//									ttb_alarmcar.nut									//
//																						//
//****************************************************************************************

class AlarmCar
{
	carModel = null;
	
	glassModel = null;
	glassModelAlarmed = null;
	
	brakelight_Left = null;
	brakelight_Right = null;
	
	indicator_Left = null;
	indicator_Right = null;
	
	headlight_Left = null;
	headlight_Right = null;
	
	timer = null;
	chirp = null;
	alarm = null;
	remarkable = null;
	relay_alarm_on = null;
	relay_alarm_off = null;
	
	origin = null;
	angles = null;
	
	colors =
	[
		"182 92 68",
		"182 122 68",
		"114 80 52",
		"153 65 29"
	];
	
	function GetRandomColor(){
		local randomIndex = RandomInt(0, colors.len() - 1);
		return colors[randomIndex];
	}
	
	function Kill(){
		if(carModel) carModel.Kill();
		if(glassModel) glassModel.Kill();
		if(glassModelAlarmed) glassModelAlarmed.Kill();
		if(brakelight_Left) brakelight_Left.Kill();
		if(brakelight_Right) brakelight_Right.Kill();
		if(indicator_Left) indicator_Left.Kill();
		if(indicator_Right) indicator_Right.Kill();
		if(headlight_Left) headlight_Left.Kill();
		if(headlight_Right) headlight_Right.Kill();
		
		if(timer) timer.Kill();
		if(chirp) chirp.Kill();
		if(alarm) alarm.Kill();
		if(remarkable) remarkable.Kill();
		if(relay_alarm_on) relay_alarm_on.Kill();
		if(relay_alarm_off) relay_alarm_off.Kill();
	}
	
	
	function SetOrigin(pos){
		carModel.SetOrigin(pos);
	}
	
	function SetAngles(angles){
		carModel.SetAngles(angles);
	}
	
	constructor(position, angles){
		
		angles = angles
		position = position
		
		
		// Targetnames
		
		// Props
		
		local ID = UniqueString();
		
		local t_name_car_model = "caralarm_car_model_" + ID;
		local t_name_glass = "caralarm_glass_" + ID;
		local t_name_glass_alarmed = "caralarm_glass_alarmed_" + ID;
		
		// Back
		local t_name_breaklight_left = "car_alarm_breaklight_left_" + ID;
		local t_name_breaklight_right = "car_alarm_breaklight_right_" + ID;
	
		// Front
		local t_name_indicator_left = "car_alarm_indicator_left_" + ID;
		local t_name_indicator_right = "car_alarm_indicator_right_" + ID;
	
		// Headlights
		local t_name_head_light_left = "car_alarm_head_light1_" + ID;
		local t_name_head_light_right = "car_alarm_head_light2_" + ID;
		
		// Logic
		local t_name_alarm_car_timer = "caralarm_timer_" + ID;
		local t_name_chirp = "car_alarm_chirp_" + ID;
		local t_name_alarm = "car_alarm_alarm_" + ID;
		local t_name_relay_on = "car_alarm_relay_on_" + ID;
		local t_name_relay_off = "car_alarm_relay_off_" + ID;
		local t_name_remarkable = "car_alarm_remarkable_" + ID;
	
	
		remarkable = SpawnEntityFromTable("info_remarkable",{
			angles = Vector(-0, -60, 0)
			contextsubject = "remark_caralarm"
			origin = Vector(-10, -9, -5)
			targetname = t_name_remarkable
		});
			
		carModel = SpawnEntityFromTable("prop_car_alarm",{
			model = "models/props_vehicles/cara_95sedan.mdl"
			targetname = t_name_car_model
			rendercolor = GetRandomColor()
			origin = position
			angles = "0 0 0"
			connections =
			{
				OnCarAlarmStart =
				{
					cmd1 = t_name_alarm_car_timer + "Enable0-1"
					cmd2 = t_name_alarm + "PlaySound0-1"
					cmd3 = t_name_glass + "Disable0-1"
					cmd4 = t_name_glass_alarmed + "Enable0-1"
				}
				OnCarAlarmChirpStart =
				{
					cmd1 = t_name_chirp + "PlaySound0.2-1"
					cmd2 = t_name_breaklight_left + "ShowSprite0.2-1"
					cmd3 = t_name_breaklight_right + "ShowSprite0.2-1"
					cmd4 = t_name_indicator_left + "ShowSprite0.2-1"
					cmd5 = t_name_indicator_left+ "ShowSprite0.2-1"
				}
				OnCarAlarmEnd =
				{
					cmd1 = t_name_alarm_car_timer + "Disable0-1"
					cmd2 = t_name_alarm + "StopSound0-1"
					cmd3 = t_name_relay_off + "Trigger0-1"
					cmd4 = t_name_breaklight_left + "HideSprite0-1"
					cmd5 = t_name_breaklight_right + "HideSprite0-1"
					cmd6 = t_name_indicator_left + "HideSprite0-1"
					cmd7 = t_name_indicator_left+ "HideSprite0-1"
					cmd8 = t_name_head_light_left + "LightOff0-1"
					cmd9 = t_name_head_light_right + "LightOff0-1"
					cmd10 = "Admin_caralarm_game_eventKill0-1"
					cmd11 = t_name_remarkable + "Kill0-1"
				}
				OnCarAlarmChirpEnd =
				{
					cmd1 = t_name_breaklight_left + "HideSprite0.7-1"
					cmd2 = t_name_breaklight_right + "HideSprite0.7-1"
					cmd3 = t_name_indicator_left + "HideSprite0.7-1"
					cmd4 = t_name_indicator_left+ "HideSprite0.7-1"
				}
			}
		});
		
		brakelight_Left = SpawnEntityFromTable("env_sprite",{
			targetname = t_name_breaklight_left
			model = "sprites/glow.vmt"
			rendercolor = "255 13 19"
			renderamt = 255
			renderfx = 0
			rendermode = 9
			scale = 0.5
			disablereceiveshadows = 0
			GlowProxySize = 5
			fademindist = -1
			fademaxdist = 0
			fadescale = 1
			HDRColorScale = 0.7
			framerate = 10.0
			origin = Vector(-107, 27, 32) + position
			angles = "0 0 0"
			parentname = t_name_car_model
		});

		brakelight_Right = SpawnEntityFromTable("env_sprite",{
			targetname = t_name_breaklight_right
			model = "sprites/glow.vmt"
			rendercolor = "255 13 19"
			renderamt = 255
			renderfx = 0
			rendermode = 9
			scale = 0.5
			disablereceiveshadows = 0
			GlowProxySize = 5
			fademindist = -1
			fademaxdist = 0
			fadescale = 1
			HDRColorScale = 0.7
			framerate = 10.0
			origin = Vector(-107, -27, 32) + position
			angles = "0 0 0"
			parentname = t_name_car_model
		});


		indicator_Left = SpawnEntityFromTable("env_sprite",{
			targetname = t_name_indicator_left
			model = "sprites/glow.vmt"
			rendercolor = "224 162 44"
			renderamt = 255
			renderfx = 0
			rendermode = 9
			scale = 0.5
			disablereceiveshadows = 0
			GlowProxySize = 5
			fademindist = -1
			fademaxdist = 0
			fadescale = 1
			HDRColorScale = 0.7
			framerate = 10.0
			origin = Vector(97, -39, 29) + position
			angles = "0 0 0"
			parentname = t_name_car_model
		});

		indicator_Right = SpawnEntityFromTable("env_sprite",{
			targetname = t_name_indicator_right
			model = "sprites/glow.vmt"
			rendercolor = "224 162 44"
			renderamt = 255
			renderfx = 0
			rendermode = 9
			scale = 0.5
			disablereceiveshadows = 0
			GlowProxySize = 5
			fademindist = -1
			fademaxdist = 0
			fadescale = 1
			HDRColorScale = 0.7
			framerate = 10.0
			origin = Vector(97, 39, 29) + position
			angles = "0 0 0"
			parentname = t_name_car_model
		});
		
		
		timer = SpawnEntityFromTable("logic_timer",{
			angles = Vector( -0, -60, 0 )
			RefireTime = 0.75
			spawnflags = 0
			StartDisabled = 1
			targetname = t_name_alarm_car_timer
			UseRandomTime = 0
			origin = Vector(-6, -15, 19)
			connections =
			{
				OnTimer =
				{
					cmd1 = t_name_breaklight_left + "ShowSprite0-1"
					cmd2 = t_name_breaklight_left + "HideSprite0.5-1"
					
					cmd3 = t_name_breaklight_right + "ShowSprite0-1"
					cmd4 = t_name_breaklight_right + "HideSprite0.5-1"
					
					cmd5 = t_name_indicator_left + "ShowSprite0-1"
					cmd6 = t_name_indicator_left + "HideSprite0.5-1"
					
					cmd7 = t_name_indicator_right + "ShowSprite0-1"
					cmd8 = t_name_indicator_right + "HideSprite0.5-1"
					
					cmd9 = t_name_head_light_left + "LightOn0-1"
					cmd10 = t_name_head_light_left + "LightOff0.5-1"
					
					cmd11 = t_name_head_light_right + "LightOn0-1"
					cmd12 = t_name_head_light_right + "LightOff0.5-1"
				}
			}	
		});

		glassModelAlarmed = SpawnEntityFromTable("prop_car_glass",{
			model = "models/props_vehicles/cara_95sedan_glass.mdl"			// no blink
			targetname = t_name_glass_alarmed
			parentname = t_name_car_model
			origin = position
			solid = 6
			MinAnimTime = 5
			MaxAnimTime = 10
			StartDisabled = 1
			angles = "0 0 0"
		});
		

		glassModel = SpawnEntityFromTable("prop_car_glass",{
			model = "models/props_vehicles/cara_95sedan_glass_alarm.mdl"	// blink
			targetname = t_name_glass
			parentname = t_name_car_model
			origin = position
			solid = 6
			MinAnimTime = 5
			MaxAnimTime = 10
			angles = "0 0 0"
		});
		

		

		
		// NetProps.SetPropEntity(carModel, "m_hMoveChild", glassModelAlarmed, "m_hMoveParent")
		// NetProps.SetPropEntity(glassModel, "m_hMoveChild", glassModel, "m_hMoveParent")
		
		headlight_Left = SpawnEntityFromTable("beam_spotlight",{
			targetname = t_name_head_light_left
			angles = "0 0 0"
			fademindist = -1
			fadescale = 1
			HDRColorScale = 0.5
			maxspeed = 100
			parentname = t_name_car_model
			renderamt = 150
			rendercolor = "252 243 226"
			rendermode = 5
			spawnflags = 2
			spotlightlength = 256
			spotlightwidth = 32
			origin = Vector(102, -30, 30) + position
		});
		
		headlight_Right = SpawnEntityFromTable("beam_spotlight",{
			targetname = t_name_head_light_right
			angles = "0 0 0"
			fademindist = -1
			fadescale = 1
			HDRColorScale = 0.5
			maxspeed = 100
			parentname = t_name_car_model
			renderamt = 150
			rendercolor = "252 243 226"
			rendermode = 5
			spawnflags = 2
			spotlightlength = 256
			spotlightwidth = 32
			origin = Vector(102, 30, 30) + position
		});
		
		chirp = SpawnEntityFromTable("ambient_generic",{
			angles = Vector( -0, -60, 0 )
			cspinup = 0
			fadeinsecs = 0
			fadeoutsecs = 0
			health = 10
			lfomodpitch = 0
			lfomodvol = 0
			lforate = 0
			lfotype = 0
			message = "Car.Alarm.Chirp2"
			pitch = 100
			pitchstart = 100
			preset = 0
			radius = 4000
			SourceEntityName = t_name_car_model
			spawnflags = 48
			spindown = 0
			spinup = 0
			targetname = t_name_chirp
			volstart = 0
			origin = Vector(-32, 8, 16)	
		});
		
		alarm = SpawnEntityFromTable("ambient_generic",{
			angles = Vector( -0, -60, 0 )
			cspinup = 0
			fadeinsecs = 0
			fadeoutsecs = 0
			health = 10
			lfomodpitch = 0
			lfomodvol = 0
			lforate = 0
			lfotype = 0
			message = "Car.Alarm"
			pitch = 100
			pitchstart = 100
			preset = 0
			radius = 4000
			SourceEntityName = t_name_car_model
			spawnflags = 16
			spindown = 0
			spinup = 0
			targetname = t_name_alarm
			volstart = 0
			origin = Vector(-32, -16, 16)
		});
		
		relay_alarm_on = SpawnEntityFromTable("logic_relay",{
			angles = Vector(-0, -60, 0)
			spawnflags = 0
			StartDisabled = 0
			targetname = t_name_relay_on
			origin = Vector(6, -32, 60)
			connections =
			{
				OnTrigger =
				{
					//cmd1 = "Admin_maker_alarm_onForceSpawn0.01-1"
					cmd2 = t_name_car_model + "Enable0-1"
					cmd3 = t_name_relay_on + "Disable0.02-1"
					cmd4 = t_name_relay_off + "Enable0.02-1"
					cmd5 = t_name_glass + "Enable0-1"
					cmd6 = t_name_glass_alarmed + "Disable0-1"
				}
			}
		});
		
		
		relay_alarm_off = SpawnEntityFromTable("logic_relay",{
			classname = "logic_relay"
			angles = Vector(-0, -60, 0)
			spawnflags = 0
			StartDisabled = 0
			targetname = t_name_relay_off
			origin = Vector(-26, -24, 60)
			connections =
			{
				OnTrigger =
				{
					//cmd1 = "Admin_caralarm_game_eventKill0-1"
					cmd2 = t_name_car_model + "Disable0-1"
					cmd3 = t_name_relay_on + "Enable0.02-1"
					cmd4 = t_name_relay_off + "Disable0.02-1"
					cmd5 = t_name_remarkable + "Kill0-1"
					
					cmd6 = t_name_glass_alarmed + "Enable0-1"
					cmd7 = t_name_glass + "Disable0-1"
					
					cmd8 = t_name_head_light_left + "LightOff0-1"
					cmd9 = t_name_head_light_right + "LightOff0-1"
					
					cmd10 = t_name_breaklight_left + "HideSprite0-1"
					cmd11 = t_name_breaklight_right + "HideSprite0-1"
					cmd12 = t_name_breaklight_left + "HideSprite0-1"
					cmd13 = t_name_breaklight_right + "HideSprite0-1"
				}
			}
		});
		

		// Doesnt work dunno why
		
		/*
		NetProps.SetPropEntity(glassModelAlarmed, "m_hMoveParent", carModel)
		NetProps.SetPropEntity(glassModel, "m_hMoveParent", carModel)
		NetProps.SetPropEntity(brakelight_Left, "m_hMoveParent", carModel)
		NetProps.SetPropEntity(brakelight_Right, "m_hMoveParent", carModel)
		NetProps.SetPropEntity(headlight_Left, "m_hMoveParent", carModel)
		NetProps.SetPropEntity(headlight_Right, "m_hMoveParent", carModel)
		NetProps.SetPropEntity(indicator_Left, "m_hMoveParent", carModel)
		NetProps.SetPropEntity(indicator_Right, "m_hMoveParent", carModel)
		*/
		
		
		
		EntFire(t_name_head_light_left, "SetParent", t_name_car_model, 0.03)
		EntFire(t_name_head_light_right, "SetParent", t_name_car_model, 0.03)
		
		EntFire(t_name_breaklight_left, "SetParent", t_name_car_model, 0.03)
		EntFire(t_name_breaklight_right, "SetParent", t_name_car_model, 0.03)
		
		EntFire(t_name_indicator_left, "SetParent", t_name_car_model, 0.03)
		EntFire(t_name_indicator_right, "SetParent", t_name_car_model, 0.03)
		
		EntFire(t_name_glass, "SetParent", t_name_car_model , 0.03)
		EntFire(t_name_glass_alarmed, "SetParent", t_name_car_model , 0.03)
		

		// NetProps.SetPropInt(carModel, "m_MoveType", 0)
		// NetProps.SetPropInt(carModel, "m_Collision.m_usSolidFlags", 4)
		//ClientPrint(null, 5, "" + NetProps.GetPropInt(carModel, "m_Collision.m_CollisionGroup"))
		
		
		//AddOutput(t_name_car_model, string outputName, string targetName, string inputName, string parameter, float delay, int timesToFire)
	}
	
}



::SetCarPosition <- function(pos, angles){
	local ent = Entities.FindByClassnameNearest("prop_car_alarm", pos, 128.0)
	if(!ent){
		ClientPrint(null, 5, "No car found!");
		return;
	}
	ent.SetOrigin(pos);
	ent.SetAngles(angles);
}
