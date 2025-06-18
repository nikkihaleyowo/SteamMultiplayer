

// Recieving packets
while(steam_net_packet_receive()){
	var _sender = steam_net_packet_get_sender_id();
	steam_net_packet_get_data(inbuf);
	buffer_seek(inbuf, buffer_seek_start, 0);
	var _type = buffer_read(inbuf, buffer_u8);
	
	switch _type {
		case NETWORK_PACKETS.SYNC_PLAYERS:
			var _playerList = buffer_read(inbuf, buffer_string);
			_playerList = handle_parse(_playerList);
			sync_players(_playerList);
			break;
			
		case NETWORK_PACKETS.SPAWN_OTHER:
			var _layer = layer_get_id("Instances");
			var _x =buffer_read(inbuf, buffer_u16)
			var _y =buffer_read(inbuf, buffer_u16)
			var _steamID = buffer_read(inbuf,buffer_u16);
			var _num = array_length(playerList);
			var _inst = instance_create_layer(_x,_y,_layer,obj_Player, {
				steamName		: steam_get_user_persona_name(_steamID),
				steamID			: _steamID,
				lobbyMemberID	: _num,
			})
			
			array_push(playerList, {
				steamID			: _steamID,
				steamName		: steam_get_persona_name(_steamID),
				character		: _inst,
				lobbyMemberID	: _num,
			})
			
			break;
			
		case NETWORK_PACKETS.SPAWN_SELF:
			for(var i = 0;i<array_length(playerList);i++){
				if playerList[i].steamID == steamID then lobbyMemberID = playerList[i].lobbyMemberID;	
			}
			var _layer = layer_get_id("Instances");
			var _x =buffer_read(inbuf, buffer_u16)
			var _y =buffer_read(inbuf, buffer_u16)
			var _inst = instance_create_layer(_x,_y,_layer,obj_Player, {
				steamName		: steamName,
				steamID			: steamID,
				lobbyMemberID	: lobbyMemberID
			})
			playerList[0].character = _inst;
			character = _inst;
			break;
		
		default:
			show_debug_message("unknown packet type");
			break;
	}
	
}