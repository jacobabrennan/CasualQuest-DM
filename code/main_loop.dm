var/game/game
game{
	var{
		speed = 0.33
		game/map/map
		area/trash_area
		list/heros = new()
		turf = /game/map/tile/floor
		stage = STAGE_EMPTY
		}
	New(){
		. = ..()
		world.tick_lag = speed
		trash_area = locate(/area)
		load_settings()
		status()
		}
	proc{
		load_settings(){
			var/server_settings = file("settings.txt")
			if(!server_settings){ return}
			server_settings = file2text(server_settings)
			var/list/settings = new()
			if(server_settings){
				for(var/setting in text2list(server_settings, "\n")){
					var/equal = findtext(setting,"="    )
					if(!equal){ continue}
					var/name  = copytext(setting,1,equal)
					var/value = copytext(setting,equal+1)
					settings[name] = value
					}
				}
			if("name" in settings){
				server_name = settings["name"]
				server_name = html_encode(server_name)
				server_name = copytext(server_name, 1, 17)
				}
			}
		status(){
			var/wave_text = ""
			if(map && map.wave){ wave_text = ", Wave [map.wave]"}
			var/server_text = ""
			if(server_name){ server_text = "Server: [server_name]. "}
			world.status = "[server_text]Version 1.[world.version][wave_text]"
			}
		pause(var/client/C){
			if(stage != STAGE_PLAY){ return}
			if(map.pause_hold){ return}
			if(map.pause){
				map.pause_hold = TRUE
				var/_who = {"[html_encode(C.key)]"}
				if(C.hero){
					_who = {"<img class="icon" src="\ref[C.hero.icon]" icondir="EAST" iconframe="2"> [_who]"}
					}
				world << "<b>Game Unpaused by [_who]</b>"
				world << "<b>Unpausing in 3</b>"
				sleep(10)
				world << "<b>Unpausing in 2</b>"
				sleep(10)
				world << "<b>Unpausing in 1</b>"
				sleep(10)
				world << "<b>Go!</b>"
				del map.pause_display
				map.pause = FALSE
				spawn(){
					map.iterate(map.wave)
					}
				}
			else{
				if(!C.hero || !(C.hero in heros)){ return}
				var/_icon = {"<img class="icon" src="\ref[C.hero.icon]" icondir="EAST" iconframe="2">"}
				var/_name = {"[html_encode(C.key)]"}
				world << "<b>Game Paused by [_icon] [_name]</b>"
				map.pause_display = new()
				map.pause_display.pause()
				map.pause = TRUE
				}
			}
		}
	map{
		parent_type = /area
		var{
			list/enemies = new()
			list/items = new()
			list/wave_sprites = new()
			game/map/region/region
			wave = 0
			score = 0
			list/next_map
			list/local_edge
			game/item/chest/chest
			game/card/card
			win_time
			showed_scores = FALSE
			game/map/score_display/score_display
			client/skin/wave_complete/wave_complete
			pause = FALSE
			pause_hold = FALSE
			game/map/score_display/pause_display
			list/treasures = list(
				TREASURE_1,
				TREASURE_2,
				TREASURE_3,
				TREASURE_4,
				TREASURE_5,
				TREASURE_6,
				TREASURE_7,
				)
			list/cards
			}
		New(){
			. = ..()
			wave = 0
			}
		proc{
			start(){
				//game.can_join = FALSE
				for(var/game/hero/H in game.heros){
					var/game/map/mover/intelligence/afk_check/_afk = H.intelligence
					if(!istype(_afk)){
						_afk = new()
						H.intelligence = _afk
						}
					H.no_attack = 2
					}
				pause_hold = FALSE
				iterate(wave)
				}
			iterate(_wave){
				if(pause){ return}
				if(game.stage == STAGE_EMPTY){ return}
				if(!(locate(/game/hero) in game.heros)){
					return loose()
					}
				for(var/game/hero/hero in game.heros){
					hero.take_turn()
					if(!hero){ continue}
					for(var/game/map/mover/projectile/P in hero.projectiles){
						P.take_turn()
						for(var/game/enemy/enemy in orange(COLLISION_RANGE, P)){
							if(enemy.invincible){ continue}
							if(!P){ break}
							if(!P.collision_check(enemy)){ continue}
							P.impact(enemy)
							}
						}
					if(hero.invulnerable){ continue}
					for(var/game/hero/other_hero in orange(COLLISION_RANGE, hero)){
						if(other_hero.invulnerable){ continue}
						var/_collision = FALSE
						if(    abs((hero.c.x+(hero.width /2)) - (other_hero.c.x+(other_hero.width /2))) < ((hero.width +other_hero.width )/2)-8){
							if(abs((hero.c.y+(hero.height/2)) - (other_hero.c.y+(other_hero.height/2))) < ((hero.height+other_hero.height)/2)-8){
								_collision = TRUE
								}
							}
						if(!_collision){ continue}
						var/delta_x = (other_hero.c.x+(other_hero.width /2)) - (hero.c.x+(hero.width /2))
						var/delta_y = (other_hero.c.y+(other_hero.height/2)) - (hero.c.y+(hero.height/2))
						var/over_x  = ((hero.width +other_hero.width )/2 - abs(delta_x)) * -sign(delta_x)
						var/over_y  = ((hero.height+other_hero.height)/2 - abs(delta_y)) * -sign(delta_y)
						hero.translate(        ceil(sign(over_x/2)),  round(sign(over_y/2)))
						other_hero.translate(-round(sign(over_x/2)),  -ceil(sign(over_y/2)))
						}
					}
				if(!(locate(/game/enemy) in enemies)){
					win()
					}
				else{
					for(var/game/enemy/enemy in enemies){
						enemy.take_turn()
						if(!enemy){ continue}
						for(var/game/map/mover/projectile/P in enemy.projectiles){
							P.take_turn()
							for(var/game/hero/hero in orange(COLLISION_RANGE, P)){
								if(hero.invincible){ continue}
								if(!P){ break}
								if(!P.collision_check(hero)){ continue}
								P.impact(hero)
								}
							}
						}
					for(var/game/enemy/enemy in enemies){
						if(!enemy.touch_damage){ continue}
						for(var/game/hero/hero in range(COLLISION_RANGE, enemy)){
							if(enemy.collision_check(hero)){
								if(hero.reverseDamage>0) { hero.attack(enemy, hero.reverseDamage)}
								else { enemy.attack(hero, enemy.touch_damage) }
								}
							}
						}
					}
				for(var/game/item/item in items){
					item.take_turn()
					for(var/game/hero/hero in range(COLLISION_RANGE, item)){
						if(item && item.collision_check(hero)){
							item.activate(hero)
							}
						}
					if(item && !item.no_collect){
						for(var/game/hero/projectile/P in range(COLLISION_RANGE, item)){
							if(!item){ break}
							if(!P.owner){ continue}
							if(P && item.collision_check(P)){
								item.activate(P.owner, P)
								break
								}
							}
						}
					if(item){
						item.redraw()
						}
					}
				for(var/game/map/mover/combatant/M in game.heros + enemies){
					M.redraw()
					for(var/game/map/mover/projectile/P in M.projectiles){
						P.redraw()
						}
					}
				spawn(game.speed){
					if(wave == _wave){
						iterate(_wave)
						}
					}
				}
			cleanup(){
				for(var/game/hero/H in game.heros){
					if(istype(H.player)){
						del card
						H.player.skin.hide_card()
						}
					}
				for(var/game/enemy/E in enemies){ del E}
				for(var/game/item/I in items){ del I}
				}
			win(){
				game.stage = STAGE_WIN
				// Fix Character Defects
				for(var/game/hero/H in game.heros){ H.endwave=TRUE}
				if(!wave_complete){
					wave_complete = new(locate(1,1,z))
					}
				// Show Scores
				if(!showed_scores){
					// Remove Inactive Players
					for(var/game/hero/H in game.heros){
						var/game/map/mover/intelligence/afk_check/_afk = H.intelligence
						if(istype(_afk)){
							_afk.increase_afk(H)
							}
						}
					// Award Scores
					var/wave_bonus = 2 * wave
					var/boss_bonus = (!((wave+1)%10))? (wave+1)*10 : 0
					var/total_score = score + wave_bonus + boss_bonus
					for(var/game/hero/H in game.heros){
						if(!H.player){ continue}
						if(wave > 200){ continue}
						H.award_score(total_score)
						H.player.award_wave(wave)
						}
					score_display = new()
					if(wave > 200){
						score_display.display(0, 0, 0)
						}
					else{
						score_display.display(score, wave_bonus, boss_bonus)
						}
					showed_scores = TRUE
					}
				if(score_display){ return}
				if(chest){
					if(!win_time){
						win_time = 96
						if(wave == 149){
							var/_award = TREASURE_8
							for(var/game/hero/H in game.heros){
								if(istype(H.player)){
									H.player.skin.award(_award)
									}
								}
							}
						else if(treasures.len){
							var/_award = treasures[1]
							treasures.Remove(_award)
							for(var/game/hero/H in game.heros){
								if(istype(H.player)){
									H.player.skin.award(_award)
									}
								}
							}
						}
					else if(win_time == 1){
						del chest
						for(var/game/hero/H in game.heros){
							if(istype(H.player)){
								H.player.skin.hide_award()
								}
							}
						}
					win_time--
					return
					}
				if(card){
					if(!win_time){
						win_time = 300
						display_card()
						}
					else if(win_time == 1){
						display_card(TRUE)
						}
					win_time--
					return
					}
				if(!win_time){
					win_time = WIN_TIME
					}
				else if(win_time == 1){
					// Award Scores
					cleanup()
					del wave_complete

					var/list/_dirs = list("[NORTH]"=0, "[SOUTH]"=0, "[EAST]"=0, "[WEST]"=0)
					var/highest_dir
					var/highest_vote = 0
					for(var/game/hero/H in game.heros){
						if(!H.voted) continue

						var/voted_index = "[H.voted]"
						if(voted_index in _dirs){
							if(++_dirs[voted_index] > highest_vote){
								highest_vote = _dirs[voted_index]
								highest_dir = H.voted
								}
							}
						}

					if(!highest_dir || !("[highest_dir]" in next_map)){
						highest_dir = text2num(pick(next_map)) //###
						}
					for(var/game/hero/H in game.heros) { H.endwave=FALSE}
					load(highest_dir)
					}
				win_time--
				}
			loose(){
				for(var/client/C){
					C.reset_score()
					C.update_hub()
					}
				wave = 0
				win_time = 0
				treasures = list(
					TREASURE_1,
					TREASURE_2,
					TREASURE_3,
					TREASURE_4,
					TREASURE_5,
					TREASURE_6,
					TREASURE_7,
					)
				card = null
				region = new /game/map/region/forest()
				game.stage = STAGE_LOOSE
				var/game/hero/tomb/last_hero = locate() in contents
				for(var/atom/A in contents-last_hero){
					A.icon = null
					}
				src.icon = null
				sleep(25)
				for(var/client/C in game.waiting + game.spectators){
					C.eye = locate("game_over_screen")
					}
				if(last_hero){
					del last_hero
					}
				cleanup()
				for(var/game/map/mover/M in enemies){
					del M
					}
				game.stage = STAGE_EMPTY
				for(var/client/C in game.waiting + game.spectators){
					C.eye = locate("title_screen")
					winset(C, null, "main.notify.is-visible='false';")
					}
				game.waiting.Cut()
				game.spectators.Cut()
				sleep(40)
				game.status()
				}
			display_card(hide){
				if(!hide){
					for(var/game/hero/H in game.heros){
						if(!istype(H.player)){ continue}
						H.player.skin.show_card(card)
						}
					}
				else{
					del card
					for(var/game/hero/H in game.heros){
						if(!istype(H.player)){ continue}
						H.player.skin.hide_card()
						}
					}
				}
			load(direction){
				showed_scores = FALSE
				score = 0
				if(!((wave+4)%6)){
					if(!cards || !cards.len){
						cards = (typesof(/game/card)-/game/card)-/game/card/card_gnome
						}
					var/card_type = pick(cards)
					cards.Remove(card_type)
					card = new card_type()
					}
				if(wave == 208){
					card = new /game/card/card_gnome
					}
				wave++
				game.status()
				var/boss = !((wave+1)%10)
				game.stage = STAGE_JOIN
				// Create Region
				if(!region){
					var/region_type = /game/map/region/forest
					region = new region_type()
					}
				// Delete old wave text
				for(var/client/skin/wave_text/W in src){
					del W
					}
				// Configure Map
				icon = region.icon
				var/z_level
				var/list/_dirs = list(NORTH, SOUTH, EAST, WEST)
				if(wave == 149){
					direction = NORTH
					z_level = 76
					}
				else if(wave == 209){
					direction = NORTH
					z_level = 77
					}
				else if(wave == 99){
					direction = NORTH
					z_level = 78
					}
				else if(!direction){
					direction = NORTH
					_dirs.Remove(NORTH)
					z_level = 3
					}
				else{
					z_level = next_map["[direction]"]
					}
				load_wave_text(z_level) // TODO
				for(var/game/map/tile/T in contents){
					game.trash_area.contents.Add(T)
					}
				for(var/game/map/tile/T in block(locate(1,1,z_level), locate(world.maxx,world.maxy,z_level))){
					T.icon = region.icon
					contents.Add(T)
					}
				game.map = src
				// Configure Next Maps
				next_map = new()
				var/game/map/tile/corner_ne = locate(world.maxx, world.maxy, z_level)
				var/game/map/tile/corner_nw = locate(         1, world.maxy, z_level)
				var/game/map/tile/corner_se = locate(world.maxx,          1, z_level)
				var/game/map/tile/corner_sw = locate(         1,          1, z_level)
				while(_dirs.len){
					var/_dir = pick(_dirs)
					_dirs.Remove(_dir)
					var/z_dir
					var/list/edge
					var/list/opposite_edge
					switch(_dir){
						if(NORTH){
							edge = block(corner_nw, corner_ne)
							opposite_edge = block(corner_sw, corner_se)
							}
						if(SOUTH){
							edge = block(corner_sw, corner_se)
							opposite_edge = block(corner_nw, corner_ne)
							}
						if(EAST ){
							edge = block(corner_se, corner_ne)
							opposite_edge = block(corner_sw, corner_nw)
							}
						if(WEST ){
							edge = block(corner_sw, corner_nw)
							opposite_edge = block(corner_se, corner_ne)
							}
						}
					if(_dir == turn(direction, 180)){
						local_edge = edge.Copy()
						continue
						}
					var/list/current_passages = edge.Copy()
					outer_while:{
						while(current_passages.len){
							var/game/map/tile/passage/P = pick(current_passages)
							current_passages.Remove(P)
							var/game/map/tile/o_p = opposite_edge[edge.Find(P)]
							if(!istype(P)){ continue}
							var/preboss = !((wave+2)%10)
							var/map_start = preboss? BOSS_Z_START : MAP_Z_START
							var/map_end   = preboss? BOSS_Z_END   : MAP_Z_END
							var/list/column = block(locate(o_p.x,o_p.y,map_start), locate(o_p.x,o_p.y,map_end))
							while(column.len){
								var/game/map/tile/passage/PP = pick(column)
								column.Remove(PP)
								if(!istype(PP)){ continue}
								next_map["[_dir]"] = PP.z
								z_dir = PP.z
								break outer_while
								}
							}
						}
					if(!("[_dir]" in next_map)){
						for(var/game/map/tile/passage/P in edge){
							if(wave!=209){
								P.icon_state = "wall"
								P.movement = MOVEMENT_WALL
								}
							}
						}
					else{
						var/list/channel
						switch(_dir){
							if(NORTH){ channel = block(locate(         1,         1,z_dir), locate(world.maxx,         1,z_dir))}
							if(SOUTH){ channel = block(locate(         1,world.maxy,z_dir), locate(world.maxx,world.maxy,z_dir))}
							if(EAST ){ channel = block(locate(         1,         1,z_dir), locate(         1,world.maxy,z_dir))}
							if(WEST ){ channel = block(locate(world.maxx,         1,z_dir), locate(world.maxx,world.maxy,z_dir))}
							}
						for(var/game/map/tile/T in edge){
							var/game/map/tile/passage/P = T
							var/game/map/tile/passage/O = channel[edge.Find(P)]
							if(wave == 209){ continue}
							if(istype(P) && istype(O)){
								P.icon_state = "floor"
								P.movement = MOVEMENT_LAND
								O.icon_state = "floor"
								O.movement = MOVEMENT_LAND
								}
							else if(istype(P)){
								P.icon_state = "wall"
								P.movement = MOVEMENT_WALL
								}
							else if(istype(O)){
								O.icon_state = "wall"
								O.movement = MOVEMENT_WALL
								}
							}
						}
					}
				// Load Enemies
				var/list/enemy_types = region.enemies(wave, boss)
				var/list/passages = new()
				for(var/game/map/tile/passage/P in src){
					if((P.movement == MOVEMENT_LAND) && !(P in local_edge)){
						passages.Add(P)
						}
					}
				var/small_enemies  = 9
				var/medium_enemies = rand(2,4)
				var/large_enemies  = rand(1,3)
				switch(wave){
					if(1  ){ small_enemies = 3; medium_enemies = 1; large_enemies = 1}
					if(2  ){ small_enemies = 4; medium_enemies = 1; large_enemies = 2}
					if(3  ){ small_enemies = 6; medium_enemies = 2; large_enemies = 2}
					if(4,5){ small_enemies = 6; medium_enemies = 2; large_enemies = 2}
					}
				for(var/weak_I = 1 to small_enemies){
					var/game/map/tile/passage/P = pick(passages)
					if(!P){ break}
					if(enemy_types.len < 3){ break}
					var/enemy_type = enemy_types[3]
					if(istype(enemy_type, /list)){
						enemy_type = pick(enemy_type)
						}
					var/game/enemy/E = new enemy_type()
					E.c = new(
						round((P.x-0.5)*TILE_WIDTH  - E.width /2),
						round((P.y-0.5)*TILE_HEIGHT - E.height/2),
						)
					}
				for(var/medium_I = 1 to medium_enemies){
					var/game/map/tile/passage/P = pick(passages)
					if(!P){ break}
					if(enemy_types.len < 2){ break}
					var/enemy_type = enemy_types[2]
					if(istype(enemy_type, /list)){
						enemy_type = pick(enemy_type)
						}
					var/game/enemy/E = new enemy_type()
					E.c = new(
						round((P.x-0.5)*TILE_WIDTH  - E.width /2),
						round((P.y-0.5)*TILE_HEIGHT - E.height/2),
						)
					}
				if(!boss){
					for(var/strong_I = 1 to large_enemies){
						var/game/map/tile/passage/P = pick(passages)
						if(!P){ break}
						var/enemy_type = enemy_types[1]
						if(istype(enemy_type, /list)){
							enemy_type = pick(enemy_type)
							}
						var/game/enemy/E = new enemy_type()
						E.c = new(
							round((P.x-0.5)*TILE_WIDTH  - E.width /2),
							round((P.y-0.5)*TILE_HEIGHT - E.height/2),
							)
						}
					}
				else{
					var/game/map/tile/boss/B = locate() in src
					if(B){
						var/enemy_type = enemy_types[1]
						if(istype(enemy_type, /list)){
							enemy_type = pick(enemy_type)
							}
						var/game/enemy/E = new enemy_type()
						E.boss = TRUE
						E.spam_attack_block = TRUE
						E.c = new(
							round((B.x-0.5)*TILE_WIDTH  - E.width /2),
							round((B.y-0.5)*TILE_HEIGHT - E.height/2),
							)
						}
					}
				if(!((wave+1)%20)){
					chest = new()
					chest.c.x = round(((world.maxx*TILE_WIDTH ) - chest.width )/2)
					chest.c.y = round(((world.maxy*TILE_HEIGHT) - chest.height)/2)
					chest.redraw()
					}
				// Final Player Prep
				game.eye.loc = locate(1,1,z_level)
				for(var/game/hero/H){
					H.voted = null // Disable voting
					prep_player(H, direction)
					}
				// Add Heros from waiting
				for(var/client/waiter in game.waiting){
					if(game.heros.len >= MAX_HEROS){ break}
					game.add_hero(waiter)
					}
				sleep(30)
				game.stage = STAGE_PLAY
				for(var/game/hero/H in game.heros){
					//H.overlays.Add(H.meter, H.meter_magic)
					H.adjust_health(0)
					H.adjust_aura(0)
					H.overlays.Remove(H.player_indicator)
					del H.player_indicator
					H.voted = 0 // Enable voting
					}
				start()
				}
			prep_player(var/game/hero/H, direction){
				/*if(H.player_indicator){
					H.redraw()
					return
					}*/
				overlays.Remove(H.player_indicator)
				del H.player_indicator
				for(var/datum/proj in H.projectiles){
					del proj
					}
				H.icon_state = ""
				var/placed = FALSE
				for(var/game/map/tile/passage/P in local_edge){
					if(P.movement != MOVEMENT_LAND){ continue}
					if(locate(/game/hero/) in P){ continue}
					placed = TRUE
					H.loc = P
					H.c.x = ((P.x-0.5)*TILE_WIDTH ) - H.width/2
					H.c.y = ((P.y-0.5)*TILE_HEIGHT) - H.height/2
					break
					}
				if(!placed){
					for(var/game/map/tile/passage/P in local_edge){
						if(P.movement != MOVEMENT_LAND){ continue}
						H.loc = P
						H.c.x = ((P.x-0.5)*TILE_WIDTH ) - H.width/2
						H.c.y = ((P.y-0.5)*TILE_HEIGHT) - H.height/2
						break
						}
					}
				H.dir = direction || SOUTH
				H.invisibility = 0
				H.invulnerable = INVULNERABLE_TIME
				H.overlays.Remove(H.meter, H.meter_magic)
				H.player_indicator = image('rectangles.dmi', H, "indicator", H.layer+1)
				H.player_indicator.pixel_y += TILE_HEIGHT
				H.player << H.player_indicator
				H.redraw() //###
				}
			load_wave_text(_z_level){
				if(!(wave%10)){
					var region_types = typesof(/game/map/region) - /game/map/region
					region_types -= region.type
					region_types -= /game/map/region/pagota
					region_types -= /game/map/region/gnome
					region_types -= /game/map/region/ice
					var/region_type = pick(region_types)
					if(wave == 90){
						region_type = /game/map/region/ice
						}
					if(wave == 140){
						region_type = /game/map/region/pagota
						}
					if(wave == 200){
						region_type = /game/map/region/gnome
						}
					region = new region_type()
					}
				icon = region.icon
				var/client/skin/wave_text/_w = new(locate(1,1,_z_level))
				var/client/skin/wave_text/av = new(locate(2,1,_z_level))
				var/client/skin/wave_text/e_ = new(locate(3,1,_z_level))
				var/client/skin/wave_text/cap = new()
				_w.icon_state = "wave_1"
				av.icon_state = "wave_2"
				e_.icon_state = "wave_3"
				cap.icon_state = "spacer"
				var/number_text = num2text(wave)
				for(var/I = 1; I <= length(number_text); I++){
					var/client/skin/wave_text/digit = new()
					digit.icon_state = copytext(number_text, I, I+1)
					digit.pixel_x = (I-1)*8
					digit.loc = locate(4,1,_z_level)
					if(I == length(number_text)){
						cap.loc = locate(4,1,_z_level)
						cap.pixel_x = I*8
						}
					}
				}
			}
		}
	}
game/map/proc/award_score(var/amount){
	score += amount
	}
game/map/score_display{
	parent_type = /datum
	var{
		list/sprites
		}
	proc{
		pause(){
			set waitfor = FALSE
			sprites = new()
			var/_score = " Paused (Shift+P) "
			for(var/I = 1 to length(_score)){
				var/game/map/score_display/sprite/S = new()
				sprites.Add(S)
				S.icon_state = copytext(_score, I, I+1)
				S.loc = locate(1, 8, game.map.z)
				S.x = 4 + round((I-1)/2)
				S.pixel_y = 4
				if(!(I % 2)){
					S.pixel_x = 8
					}
				}
			}
		display(var/score, wave_bonus, boss_bonus){
			set waitfor = FALSE
			var/boss_offset = 1
			sprites = new()
			var/_score = "Score:"
			for(var/I = 1 to length(_score)){
				var/game/map/score_display/sprite/S = new()
				sprites.Add(S)
				S.icon_state = copytext(_score, I, I+1)
				S.loc = locate(I, 12+boss_offset, game.map.z)
				S.x = 2 + round((I-1)/2)
				if(!(I % 2)){
					S.pixel_x = 8
					}
				}
			_score = num2text(score)
			for(var/I = length(_score) to 1 step -1){
				var/game/map/score_display/sprite/S = new()
				sprites.Add(S)
				S.icon_state = copytext(_score, I, I+1)
				S.loc = locate(7, 11+boss_offset, game.map.z)
				S.pixel_x = (-length(_score) + (I-1))*8
				}
			sleep(8)
			if(game.stage != STAGE_WIN){ Del()}
			var/_wave_bonus = "Wave Bonus:"
			for(var/I = 1 to length(_wave_bonus)){
				var/game/map/score_display/sprite/S = new()
				sprites.Add(S)
				S.icon_state = copytext(_wave_bonus, I, I+1)
				S.loc = locate(I, 10+boss_offset, game.map.z)
				S.x = 2 + round((I-1)/2)
				if(!(I % 2)){
					S.pixel_x = 8
					}
				}
			_wave_bonus = num2text(wave_bonus)
			for(var/I = length(_wave_bonus) to 1 step -1){
				var/game/map/score_display/sprite/S = new()
				sprites.Add(S)
				S.icon_state = copytext(_wave_bonus, I, I+1)
				S.loc = locate(7, 9+boss_offset, game.map.z)
				S.pixel_x = (-length(_wave_bonus) + (I-1))*8
				}
			if(boss_bonus){
				sleep(8)
				if(game.stage != STAGE_WIN){ Del()}
				var/_boss_bonus = "Boss Bonus:"
				for(var/I = 1 to length(_boss_bonus)){
					var/game/map/score_display/sprite/S = new()
					sprites.Add(S)
					S.icon_state = copytext(_boss_bonus, I, I+1)
					S.loc = locate(I, 8+boss_offset, game.map.z)
					S.x = 2 + round((I-1)/2)
					if(!(I % 2)){
						S.pixel_x = 8
						}
					}
				_boss_bonus = num2text(boss_bonus)
				for(var/I = length(_boss_bonus) to 1 step -1){
					var/game/map/score_display/sprite/S = new()
					sprites.Add(S)
					S.icon_state = copytext(_boss_bonus, I, I+1)
					S.loc = locate(7, 7+boss_offset, game.map.z)
					S.pixel_x = (-length(_boss_bonus) + (I-1))*8
					}
				}
			boss_offset -= 2
			sleep(8)
			if(game.stage != STAGE_WIN){ Del()}
			var/_total = "Total:"
			for(var/I = 1 to length(_total)){
				var/game/map/score_display/sprite/S = new()
				sprites.Add(S)
				S.icon_state = copytext(_total, I, I+1)
				S.loc = locate(I, 8+boss_offset, game.map.z)
				S.x = 2 + round((I-1)/2)
				if(!(I % 2)){
					S.pixel_x = 8
					}
				}
			_total = num2text(score + wave_bonus + boss_bonus)
			for(var/I = length(_total) to 1 step -1){
				var/game/map/score_display/sprite/S = new()
				sprites.Add(S)
				S.icon_state = copytext(_total, I, I+1)
				S.loc = locate(7, 7+boss_offset, game.map.z)
				S.pixel_x = (-length(_total) + (I-1))*8
				}
			sleep(8)
			if(game.stage != STAGE_WIN){ Del()}
			var/heros_displayed = 0
			for(var/hero_number = 1 to game.heros.len){
				var/game/hero/H = game.heros[hero_number]
				if(!H){ continue}
				if(!H.scoring){ continue}
				if(!H.player){ continue}
				heros_displayed++
				if(heros_displayed > 5){ break}
				var/_your_total = "[H.player.key]"
				if(length(_your_total) > 14){
					_your_total = copytext(_your_total, 1, 15)
					}
				for(var/I = 1 to length(_your_total)){
					var/game/map/score_display/sprite/S = new()
					sprites.Add(S)
					S.icon_state = copytext(_your_total, I, I+1)
					S.loc = locate(I, 13-(heros_displayed-1)*2, game.map.z)
					S.x = 8 + round((I-1)/2)
					if(!(I % 2)){
						S.pixel_x = 8
						}
					}
				_your_total = num2text(H.player.score)
				for(var/I = length(_your_total) to 1 step -1){
					var/game/map/score_display/sprite/S = new()
					sprites.Add(S)
					S.icon_state = copytext(_your_total, I, I+1)
					S.loc = locate(15, 12-(heros_displayed-1)*2, game.map.z)
					S.pixel_x = (-length(_your_total) + (I-1))*8
					}
				}
			//var/_wave_bonus = "Wave Bonus:"
			sleep(40)
			Del()
			}
		}
	Del(){
		for(var/datum/D in sprites){
			del D
			}
		. = ..()
		}
	sprite{
		parent_type = /obj
		icon = 'alphabet.dmi'
		layer = FLY_LAYER
		}
	}
