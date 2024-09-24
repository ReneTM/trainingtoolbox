function OnGameEvent_weapon_reload(params){
    local ent = GetPlayerFromUserID(params["userid"])
    local manual = params["manual"]
    if(!manual) return;
    local currentWeapon = ent.GetActiveWeapon();
    if(!currentWeapon) return;
    local maxclip1 = currentWeapon.GetMaxClip1();
    local currentclip1 = currentWeapon.Clip1();
    
    local targetPosition = ent.EyePosition() + (ent.EyeAngles().Forward() * 1024)
	local weaponSpawnPos = ent.EyePosition() + (ent.EyeAngles().Forward() * 64)
    
    local weaponname = NetProps.GetPropString(currentWeapon, "m_strMapSetScriptName")
    local modelName = currentWeapon.GetModelName()
    if(modelName == "") return;
    EntFire("explision_effect","Explode",null,1.0);
    local explosion = SpawnEntityFromTable("env_explosion",{origin = weaponSpawnPos, targetname = "explision_effect"});
    local weaponModel = SpawnEntityFromTable("prop_physics",{ model = "models/w_models/weapons/w_smg_uzi.mdl", origin = ent.GetOrigin() + Vector(0,0,128), spawnflags = 8192|512})
    weaponModel.SetVelocity(targetPosition)

    currentWeapon.Kill();
    ent.GiveItem(weaponname) // Do this delayed
    // Spawn a weapon model
    // Attach an explosion on it
    // Accelerate the módel
    // Explode
    // kill both
    
}

function GetModelData(activeweapon, type){
    // Declare all weapons
    // Return viewmodel or worldmodel dependent on type
}

::CurrentPlayer <- function(){
    return Entities.FindByClassname(null,"player");
}


::SetGravity <- function(model,value){
    NetProps.SetPropFloat(model, "m_flGravity", value);
}

function GetGrenadeLauncherProjectileForPlayer(){
    // Create class for Explosion effect?
    local grenade = SpawnEntityFromTable("grenade_launcher_projectile",{});
    NetProps.SetPropInt(grenade, "m_takedamage", 1);
    grenade.TakeDamage(1337, 2, null);
}






__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)