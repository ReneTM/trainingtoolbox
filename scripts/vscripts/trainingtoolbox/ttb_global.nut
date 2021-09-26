//****************************************************************************************
//																						//
//										ttb_global.nut									//
//																						//
//****************************************************************************************


/*
	ClearSavedTables()
	SaveTable(string identifier, table)
	RestoreTable(string identifier, table)
*/


const GLOBAL_TABLE_NAME = "ttbGlobal"

::GetValidatedGlobalTable <- function(){
	if(!(GLOBAL_TABLE_NAME in getroottable())){
		getroottable()[GLOBAL_TABLE_NAME] <- {}
	}
	return getroottable()[GLOBAL_TABLE_NAME]
}

::WriteToGlobalTable <- function(key, val){
	getroottable()[GLOBAL_TABLE_NAME][key] <- val
	SaveTable(GLOBAL_TABLE_NAME, getroottable()[GLOBAL_TABLE_NAME])
}

::IsSetInGlobal <- function(key){
	if(key in getroottable()[GLOBAL_TABLE_NAME]){
		return true
	}
	return false
}

::RemoveFlag <- function(ent, val){
	NetProps.SetPropInt(ent, "m_fFlags", NetProps.GetPropInt(ent, "m_fFlags") | val)
}
::AddFlag <- function(ent, val){
	NetProps.SetPropInt(ent, "m_fFlags", NetProps.GetPropInt(ent, "m_fFlags") & ~flag)
}


GetValidatedGlobalTable()

RestoreTable(GLOBAL_TABLE_NAME, getroottable()[GLOBAL_TABLE_NAME])

