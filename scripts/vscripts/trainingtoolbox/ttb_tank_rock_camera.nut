//****************************************************************************************
//																						//
//									ttb_tank_rock_camera.nut							//
//																						//
//****************************************************************************************


watchedRocks <- {};
cameraHeight <- 512;
enabledGlobally <- false;

// Returns an array containing all current tankrocks
function GetTankRocks(){
    local ent = null;
    local ents = [];
    while(ent = Entities.FindByClassname(ent, "tank_rock")){
        if(!ent || !ent.IsValid()) continue;
        ents.push(ent);
    }
    return ents;
}

// Think function which
// validates a rocks camera
// synchronizes its position with its rock
// kills camera when rock is not existent anymore
function Think(){
    foreach(rock in GetTankRocks()){
        
        // Validate scope and save initial position
        local scope = GetValidatedScriptScope(rock)
        if(!("initial_pos" in scope)){
            scope["initial_pos"] <- rock.GetOrigin();
        }
        local initialPos = scope["initial_pos"];
        
        if((rock.GetOrigin() - initialPos).Length() < 32) continue;
        
        // Create camera when it does not have one yet
        local thrower = NetProps.GetPropEntity(rock, "m_hThrower");
        local throwerscope = GetValidatedScriptScope(thrower);
        
        if(!(rock in watchedRocks)){
            
            if((!("tank_rock_camera" in throwerscope) || !throwerscope["tank_rock_camera"]) && !enabledGlobally) continue;
            if(!rock || !rock.IsValid()) continue;
            if("camera_attached" in scope) continue;
            
            
            local cameraname = UniqueString("player_camera");
            local camera = SpawnEntityFromTable("point_viewcontrol_multiplayer",{
                targetname = cameraname,
                origin = rock.GetOrigin() + Vector(0, 0, cameraHeight),
                angles = "90 0 0"
            });
            DoEntFire("!self", "AddPlayer", "", 0.03, camera, thrower);
            DoEntFire("!self", "Enable", "", 0.06, camera, camera);
            watchedRocks[rock] <- { camera = camera, thrower = thrower};
            scope["camera_attached"] <- true;
            TimeScaler.setTimeScale(thrower, 0.5, false);
        }
    }

    // Check for rocks stopped existing and delete camera if needed
    foreach(rock,table in watchedRocks){
        
        local thrower = table["thrower"]
        local camera = table["camera"]
        
        if(!rock || !rock.IsValid()){
            RefreshPov();
            watchedRocks.rawdelete(rock);
            camera.Kill();
            TimeScaler.setTimeScale(thrower, 1.0, false);
        }else{
            rock.ValidateScriptScope()
            camera.__KeyValueFromVector("origin", rock.GetOrigin() + Vector(0, 0, cameraHeight))
            local angles = thrower.EyeAngles()
            camera.SetAngles(QAngle(90, angles.y, 0))
        }
    }
}


// Fallback to fix the players POV when the camera gets killed
// before the player gets removed as a watcher from the entity
function RefreshPov(){
    local cameraDummy = SpawnEntityFromTable("point_viewcontrol_multiplayer",{});
    local player = null;
    while(player = Entities.FindByClassname(player, "player")){
        DoEntFire("!self", "AddPlayer", "", 0.0, cameraDummy, player);
        DoEntFire("!self", "Enable", "", 0.03, cameraDummy, cameraDummy);
        DoEntFire("!self", "Disable", "", 0.06, cameraDummy, cameraDummy);
        DoEntFire("!self", "RemovePlayer", "", 0.09, cameraDummy, player);
        DoEntFire("!self", "Kill", "", 0.12, cameraDummy, cameraDummy);
    }
}

// Creates the think timer which calls "Think()" every tick
// ----------------------------------------------------------------------------------------------------------------------------
function createCamThinkTimer(){
	local ent = null;
	while (ent = Entities.FindByName(null, "camera_think")){
		ent.Kill();
	}
	ent = SpawnEntityFromTable("logic_timer", { targetname = "camera_think", RefireTime = 0 });
	ent.ValidateScriptScope();
	ent.GetScriptScope()["scope"] <- this;

	ent.GetScriptScope()["func"] <- function (){
		scope.Think();
	}
	ent.ConnectOutput("OnTimer", "func");
	EntFire("!self", "Enable", null, 0, ent);
}

function toggleTankCamera(ent){
    local scope = GetValidatedScriptScope(ent)
    if(!("tank_rock_camera" in scope)){
        scope["tank_rock_camera"] <- false;
    }
    scope["tank_rock_camera"] = !scope["tank_rock_camera"];
    local playername = ent.GetPlayerName();
    ClientPrint(null, 5, WHITE + playername + GREEN + (scope["tank_rock_camera"] ? " enabled " : " disabled ") + WHITE + "their tankrockcamera");

}

createCamThinkTimer();
