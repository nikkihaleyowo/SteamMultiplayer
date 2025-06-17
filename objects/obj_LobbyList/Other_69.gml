

switch(async_load[?"event_type"]){
	case "lobby_list":
		resetLobbyList();
		if (steam_lobby_list_get_count() == 0){
			lobbyList[0] = instance_create_depth(x, bbox_top+40,-20,obj_LobbyItem);
		}else{
			for(var i = 0;i<steam_lobby_list_get_count();i++){
				var inst = instance_create_depth(x,bbox_top+40+80*i,-20,obj_LobbyItem ,{
					lobby_index : i,
					lobby_id : steam_lobby_list_get_lobby_id(i),
					lobby_creator : steam_lobby_list_get_data(i, "Creator"),
				});
				array_push(lobbyList,inst);
			}
		}
		break;
}