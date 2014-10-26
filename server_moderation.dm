world{
	IsBanned(_key, _address, _computer_id){
		. = ..()
		if(.){ return .}
		if(!game){ return .}
		var/found_ckey = FALSE
		for(var/K in game.banned_ckeys){
			if(K == ckey(_key)){
				found_ckey = TRUE
				}
			}
		if(_address in game.banned_addresses || found_ckey){
			var/list/params = list()
			params["desc"] = {"The Server Host has restricted your access to this server. Please join a different server, or download your own from the website: http://byond.com/hub/iainperegrine/Casual_Quest"}
			return params
			}
		}
	}
game{
	var{
		list/banned_ckeys = list()
		list/banned_addresses = list()
		bans_file_name = "bans.txt"
		}
	New(){
		. = ..()
		load_bans()
		}
	proc{
		load_bans(){
			if(!fexists(bans_file_name)){ return}
			var/file_text = file2text(bans_file_name)
			var/ckeys_tag     = findtext(file_text, "ckeys:\n"    )
			var/addresses_tag = findtext(file_text, "addresses:\n")
			if(ckeys_tag){
				var/keys_text = copytext(file_text, ckeys_tag+length("ckeys:\n"), addresses_tag)
				for(var/key_line in text2list(keys_text,"\n")){
					var/equal_pos = findtext(key_line, "=")
					var/ckey     = copytext(key_line, 1, equal_pos)
					var/_address = copytext(key_line, equal_pos+1 )
					banned_ckeys[ckey]=_address
					}
				}
			if(addresses_tag){
				var/add_text = copytext(file_text, addresses_tag+length("addresses:\n"), 0)
				for(var/_address in text2list(add_text,"\n")){
					banned_addresses.Add(_address)
					}
				}
			}
		save_bans(){
			var/ban_text = {"ckeys:\n"}
			for(var/K in banned_ckeys){
				ban_text += "[K]=[banned_ckeys[K]]\n"
				}
			ban_text += "addresses:\n"
			for(var/A in banned_addresses){
				ban_text += "[A]\n"
				}
			if(fexists(bans_file_name)){
				fdel(bans_file_name)
				}
			text2file(ban_text, bans_file_name)
			}
		}
	}
client{
	verb{
		server_moderation(){
			set name = ".moderation"
			if(!host){ return}
			winshow(src, "server_moderation")
			}
		ban(){
			set name = ".ban"
			if(!host){ return}
			var/list/player_list = new()
			for(var/game/hero/H in game.heros){
				if(!H.player){ continue}
				var/list/hero_type = text2list("[H.type]", "/")
				hero_type = hero_type[hero_type.len]
				player_list["[H.player.key] ([hero_type])"] = H.player
				}
			for(var/client/C){
				if(C.hero){ continue}
				player_list["[C.key]"] = C
				}
			var/client/problem = input(src, "Choose a user to ban.", "Ban User") in player_list|null
			if(problem){
				problem = player_list[problem]
				game.banned_ckeys[problem.ckey] = problem.address
				game.banned_addresses.Add(problem.address)
				del problem
				game.save_bans()
				}
			}
		unban(){
			set name = ".unban"
			if(!host){ return}
			var/list/unban_list = new()
			for(var/K in game.banned_ckeys){
				unban_list["[K] ([game.banned_ckeys[K]])"] = K
				}
			for(var/A in game.banned_addresses){
				unban_list[A] = "# [A]"
				}
			if(!unban_list.len){
				alert(src, "There are currently no bans.")
				}
			var/client/problem = input(src, "Choose a Key or Address.", "Remove Ban") in unban_list|null
			if(problem){
				problem = unban_list[problem]
				if(copytext(problem, 1, 3) == "# "){
					problem = copytext(problem, 3)
					game.banned_addresses.Remove(problem)
					src << {"<b>The Address "[problem]" is no longer banned.</b>"}
					}
				else{
					var/banned_address = game.banned_ckeys[problem]
					game.banned_ckeys.Remove(problem)
					game.banned_addresses.Remove(banned_address)
					src << {"<b>The user "[problem]" is no longer banned.</b>"}
					src << {"<b>The Address "[banned_address]" is no longer banned.</b>"}
					}
				}
			}
		}
	}