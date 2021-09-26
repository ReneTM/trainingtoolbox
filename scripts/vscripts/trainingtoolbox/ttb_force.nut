//=========================================================
// called from C++ when you try and kick off a mode to
// decide whether scriptmode wants to handle it
//=========================================================
function ScriptMode_Init( modename, mapname )
{
    ::g_RoundState <- {}
    ::g_MapScript <- getroottable().DirectorScript.MapScript
    ::g_ModeScript <- getroottable().DirectorScript.MapScript.ChallengeScript

    // Just for convenience, so we don't have to keep checking if it's there
    if ( !("MapState" in g_MapScript) )
        g_MapScript.MapState <- {}

    IncludeScript( "sm_utilities", g_MapScript )  // so we have constants and such when we load the map...
    IncludeScript( "sm_spawn", g_MapScript )      // and the spawning system

    ::SessionState <- {}
    SessionState.MapName <- mapname
    SessionState.ModeName <- modename
	//   SessionState.StartActive <- true // moved below to prevent exception

    // Add to the spawn array
    MergeSessionSpawnTables()
    MergeSessionStateTables()
    SessionState.StartActive <- true
    MergeSessionOptionTables()

    // go ahead and call all the precache elements - the MapSpawn table ones then any explicit OnPrecache's
    ScriptedPrecache()
    ScriptMode_SystemCall("Precache")

    return true; // whats the worst that could happen
}

