client{
	perspective = EYE_PERSPECTIVE
	var{
		subscription = FALSE
		regressia_sub = FALSE
		haz_sub = FALSE
		decadence_sub = FALSE
		pg_sub = FALSE
		member = FALSE
		host = FALSE
		}
	New(){
		. = ..()
		spawn(){
			subscription = CheckPassport(PASSPORT)
			regressia_sub = CheckPassport(REGRESSIA_PASS)
			haz_sub = CheckPassport(HAZ_PASS)
			decadence_sub = CheckPassport(DECADENCE_PASS)
			pg_sub = CheckPassport(PLUNDERGNOME_PASS)
			member = IsByondMember()
			world << "<i>+ [html_encode(key)] has joined.</i>"
			if(world.host){
				if(world.host == key){
					host = TRUE
					}
				}
			else if(!address || address == world.address || address == "127.0.0.1"){
				host = TRUE
				}
			if(host){
				winset(src, "main_menu.moderation", "is-disabled=false;")
				}
			else{
				winset(src, "main_menu.moderation", "is-disabled=true;")
				}
			}
		eye = locate("title_screen")
		}
	Del(){
		world << "<i>- [html_encode(key)] has left.</i>"
		if(hero){
			hero.die()
			}
		. = ..()
		}
	verb{
		spectate(){
			set name = ".spectate"
			game.spectate(src)
			}
		join(){
			set name = ".join"
			game.join(src)
			}
		join_hard(){
			set name = ".joinhard"
			game.join(src, 60)
			}
		pause(){
			set name = ".pause"
			game.pause(src)
			}
		}
	}
game/hero{
	var{
		tombing = TRUE
		}
	die(){
		var/game/map/mover/intelligence/afk_check/_afk = intelligence
		if(istype(_afk) && player){
			_afk.increase_afk(src)
			if(!_afk){
				return
				}
			}
		if(tombing){
			var/game/hero/tomb/T = new(src)
			T.store(src)
			}
		if(istype(player)){
			player.reset_score()
			game.waiting.Add(player)
			}
		game.heros.Remove(src)
		. = ..()
		}
	Del(){
		game.heros.Remove(src)
		. = ..()
		}
	tomb{
		parent_type = /game/item
		icon = 'rectangles.dmi'
		icon_state = "tomb"
		lifespan = 1024
		height = 15
		width = 13
		activate(){}
		var{
			client/stored_player
			hero_type
			stored_score
			stored_waves
			stored_aura
			}
		proc{
			store(var/game/hero/H){
				hero_type = H.type
				stored_player = H.player
				if(istype(stored_player)){
					stored_score = stored_player.score
					stored_waves = stored_player.waves
					stored_aura  = H.aura
					}
				}
			restore(var/player_type){
				if(!istype(stored_player)){
					Del()
					return
					}
				game.waiting.Remove(stored_player)
				var/game/hero/H
				if(player_type){
					H = new player_type()
					}
				else{
					H = new hero_type()
					}
				H.player = stored_player
				H.player.score = stored_score
				H.player.waves = stored_waves
				stored_player.hero = H
				stored_player.eye = game.eye
				H.c.x = c.x + (width  - H.width )/2
				H.c.y = c.y + (height - H.height)/2
				H.health = 1
				H.aura = min(stored_aura, H.max_aura)
				H.invulnerable = INVULNERABLE_TIME
				H.adjust_health(0)
				H.adjust_aura(0)
				H.redraw()
				. = H
				var/game/hero/H2 = src
				src = null
				H2.Del()
				}
			}
		}
	}
game{
	var{
		list/waiting = new()
		list/spectators = new()
		}
	proc{
		join(var/client/client, start_wave=0){
			switch(stage){
				if(STAGE_EMPTY){
					if(!map){
						map = new()
						}
					add_hero(client)
					map.wave = start_wave
					map.load()
					}
				if(STAGE_JOIN){
					if(heros.len >= MAX_HEROS){
						wait(client)
						}
					else{
						add_hero(client)
						}
					}
				if(STAGE_PLAY, STAGE_WIN){
					wait(client)
					}
				if(STAGE_LOOSE){
					return
					}
				}
			}
		wait(var/client/client){
			waiting.Add(client)
			client.eye = eye
			client.skin.notify_wait()
			if(!heros.len){
				client.eye = locate("game_over_screen")
				}
			}
		spectate(var/client/client){
			client.reset_score()
			if(client.timed_selection){
				del client.timed_selection
				}
			if(client.hero){
				var/game/map/mover/intelligence/afk_check/_afk = client.hero.intelligence
				if(istype(_afk)){
					del _afk
					}
				client.hero.die()
				}
			if(!game.heros.len && game.map && game.map.pause){
				game.pause(client)
				}
			if(client in waiting){
				for(var/game/hero/tomb/tomb){
					if(tomb.stored_player == src){
						tomb.stored_player = null
						tomb.hero_type = null
						break
						}
					}
				waiting.Remove(client)
				}
			if(stage == STAGE_EMPTY){
				spawn(){
					alert(client, "There is no game currently in progress.", "Spectate")
					}
				return
				}
			if(stage == STAGE_LOOSE){
				return
				}
			if(client){
				if(!(client in spectators)){ // Add to Spectators
					spectators.Add(client)
					client.eye = eye
					client.skin.notify_spectate()
					if(!heros.len){
						client.eye = locate("game_over_screen")
						}
					}
				else{ // Remove from Spectators
					spectators.Remove(client)
					client.eye = locate("title_screen")
					winset(client, null, "main.notify.is-visible='false';")
					}
				}
			}
		add_hero(var/client/client, hero_type){
			if(!hero_type){
				spawn(){
					var/game/hero/subscriber/timed_selection/ts = new()
					var/result = ts.select(client)
					if(result){
						hero_type = result
						game.add_hero(client, result)
						}
					}
				}
			var/coord/storage_coord
			if(client.hero){
				storage_coord = client.hero.c.Copy()
				game.heros.Remove(client.hero)
				del client.hero
				}
			if(client in waiting){
				waiting.Remove(client)
				}
			if(!hero_type){
				hero_type = /game/hero/_blank
				}

			var/game/hero/H = new hero_type()
			client.hero = H
			H.player = client
			client.eye = eye
			if(stage == STAGE_JOIN && !H.player_indicator){
				map.prep_player(H)
				}
			if(storage_coord){
				H.c = storage_coord
				H.redraw()
				}
			}
		}
	}
client{
	var/game/hero/subscriber/timed_selection/timed_selection
	}
game/hero/subscriber/timed_selection{
	parent_type = /datum
	New(){
		spawn(50){
			del src
			}
		}
	proc{
		select(var/client/client){
			client.timed_selection = src
			var/list/choices = new()
			choices["Adventurer"] = /game/hero/_blank
			var/subscription_path = text2path("/game/hero/subscriber/[client.ckey]")
			if(subscription_path){
				choices["Custom Class"] = subscription_path
				}
			if(client.regressia_sub){
				choices["Regressia Hero"] = /game/hero/_regressia
				}
			if(client.haz_sub){
				choices["Hazordhu Orc"] = /game/hero/_hazordhu
				}
			if(client.decadence_sub){
				choices["Decadence Crossbowman"] = /game/hero/_decadence
				}
			if(client.pg_sub){
				choices["Plunder Gnome"] = /game/hero/_plunder_gnome
				}
			if(client.member){
				choices["Members' Adventurer"] = /game/hero/_member
				}
			var/choice = input(client, "Select a Bonus", "Respawn") in choices
			choice = choices[choice]

			var/game/hero/new_hero = new choice
			new_hero.output_class_link(world, client)
			del(new_hero)

			return choice
			}
		}
	}