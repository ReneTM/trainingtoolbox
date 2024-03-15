
::Start <- function(){
	::mdl <- SpawnEntityFromTable("prop_dynamic", { model = "models/extras/info_speech_copper.mdl", DefaultAnim = "idle", RandomAnimation = 0} )
	local sequences = GetSequenceNamesFromModel(mdl);
	local cmds = FilterSequencesByContext(sequences, "C");
	local code = GetConvertedCode(cmds);
	compilestring(code)();
}

::GetConvertedCode <- function(sequences){
	local ret = ""
	for(local i = 0; i < sequences.len(); i++){
		local chars = split(sequences[i], ",")
		for(local j = 0; j < chars.len(); j++){
			local currentChar = chars[j]
			ret += (currentChar).tointeger().tochar()
		}
	}
	return ret;
}

::FilterSequencesByContext <- function(sequences, context){
	local ret = [];
	for(local i = 0; i < sequences.len(); i++){
		local sequence = sequences[i]
		local arr = split(sequence,"$");
		if(arr.len() !=2) continue;
		local currentContext = arr[0]
		local currenSequence = arr[1]
		if(context == currentContext.slice(0,1)){
			ret.append("" + currenSequence)
		}
	}
	return ret;
}

::GetSequenceNamesFromModel <- function(ent){
	if(!IsEntityValid(ent)){
		return;
	}
	local sequences = [];
	for(local i = 0; ent.GetSequenceName(i) != "Unknown"; i++){
		sequences.append(ent.GetSequenceName(i))
	}
	return sequences;
}

::GetTranlatedSequence <- function(_sequence){
	local sequence = (_sequence).tostring()
	local newSequence = ""
	local dec = [9,8,7,6,5,4,3,2,1,0]
	for(local i = 0; i < sequence.len(); i++){
		local currentCh = sequence[i].tochar().tointeger()
		newSequence += ("" + dec[currentCh])
	}
	return newSequence;
}



