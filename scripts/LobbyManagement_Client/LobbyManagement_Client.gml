///self obj_Client
function sync_player(_new_list){
	var _steamIDs = [];
	for(var i = 0; i<array_length(playerList); i++){
		array_push(_steamIDs, playerList[i].steamID)	
	}
	
	for(var i = 0; i<array_length(_new_list);i++){
		var _newSteamID = _new_list[i].steamID
		if(!array_contains(_steamIDs, _newSteamID)){
			var _inst = client_player_spawn_at_pos(_new_list[i]);
			_new_list[i].character = _inst;
			array_push(playerList, _new_list[i])
		}else{
			for(var k =0;k<array_length(playerList);k++){
				if(playerList[k].steamID == _newSteamID){
					playerList[k].startPos = _new_list[i].startPos;
					playerList[k].lobbyMemberID = _new_list[i].lobbyMemberID;
					if(playerList[k].character == undefined && playerList[k].steamID != _newSteamID){
						var _inst = client_player_spawn_at_pos(playerList[k]);
						playerList[k].character = _inst;
					}
				}
			}
		}
	}
}

function client_player_spawn_at_pos(_player_info){
	var _layer = layer_get_id("Instances")
	var _name = _player_info.steamName;
	var _steamID = _player_info.steamID;
	var _num = _player_info.lobbyMemberID;
	var _loc = _player_info.startPos;
	var _inst = instance_create_layer(_loc.x,_loc.y,_layer, obj_Player, {
		steamName		: _name,
		steamID			: _steamId,
		lobbyMemberID	: _num,	
	})
	return _inst;
}