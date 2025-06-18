///@self obj_Server
function send_player_sync(_steam_id){
	var _b = buffer_create(1, buffer_grow, 1);
	
	buffer_write(_b, buffer_u8, NETWORK_PACKETS.SYNC_PLAYERS);
	buffer_write(_b, buffer_string, shrink_player_list())
	steam_net_packet_send(_steam_id, _b);
	buffer_delete(_b);
}

///@self obj_Server
function send_player_spawn(_steam_id, _slot){
	var _pos = grab_spawn_point(_slot);
	var _b = buffer_create(5,buffer_fixed,1)//fixed
	buffer_write(_b, buffer_u8, NETWORK_PACKETS.SPAWN_SELF);
	buffer_write(_b, buffer_u16, _pos.x);
	buffer_write(_b, buffer_u16, _pos.y);
	steam_net_packet_send(_steam_id,_b);
	buffer_delete(_b);
	server_player_spawn_at_pos(_steam_id, _pos);
	send_other_player_spawn(_steam_id, _pos);
}

///@self obj_Server
function shrink_player_list(){
	var _shrunkList = playerList;
	for(var i = 0;i<array_length(_shrunkList);i++){
		_shrunkList[i].character = undefined;	
	}
	return json_stringify(_shrunkList);
}

///@self obj_Server
function server_player_spawn_at_pos(_steam_id,_pos){
	var _layer = layer_get_id("Instances");
	
	for(var i = 0; i < array_length(playerList);i++){
		if(playerList[i].steamID == _steam_id){
			var inst = instance_create_layer(_pos.x,_pos.y,_layer,obj_Player,{
				steamName: playerList[i].steamName,
				steamID: _steam_id,
				lobbyMemberID: i,
			})
			playerList[i].character = _inst;
		}
	}
}

function send_other_player_spawn(_steam_id, _pos){
	var _b 	= buffer_create(13, buffer_fixed, 1);
	buffer_write(_b, buffer_u8, NETWORK_PACKETS.SPAWN_OTHER)
	buffer_write(_b, buffer_u16, _pos.x);
	buffer_write(_b, buffer_u16, _pos.y);
	buffer_write(_b, buffer_u64, _steam_id);
	for(var i = 0; i< array_length(playerList); i++){
		if(playerList[i].steamID != _steam_id){
			steam_net_packet_send(playerList[i].steamID, _b)	
		}
	}
	buffer_delete(_b);
}