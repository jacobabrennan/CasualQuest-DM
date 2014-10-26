game/map/mover/projectile{
	parent_type = /game/map/mover
	icon = 'projectiles.dmi'
	movement = MOVEMENT_ALL
	var{
		coord/vel = new(0,0)
		game/map/mover/combatant/owner
		potency = 1
		persistent = FALSE
		explosive = FALSE
		terminal_explosion = FALSE
		max_range
		max_time
		current_range
		current_time
		sound
		description = "(~p)"
		}
	New(var/game/map/mover/combatant/_owner){
		if(sound){
			game.audio.play_sound(sound)
			}
		. = ..()
		owner = _owner
		owner.projectiles.Add(src)
		c.x = owner.c.x
		c.y = owner.c.y
		}
	Del(){
		if(owner && owner.projectiles){
			owner.projectiles.Remove(src)
			}
		. = ..()
		}
	behavior(){
		/*vel.x += pick(0, rand(-1,1))
		vel.y += pick(0, rand(-1,1))*/
		. = ..()
		if(max_range){
			if(current_range >= max_range){
				if(terminal_explosion){
					explode()
					}
				else{
					del src
					}
				}
			current_range += max(abs(vel.x), abs(vel.y))
			}
		if(max_time){
			if(current_time  >= max_time ){
				if(terminal_explosion){
					explode()
					}
				else{
					del src
					}
				}
			current_time++
			}
		translate(vel.x, vel.y)
		}
	vertical_stop(){
		if(explosive){ explode()}
		else{ del src}
		}
	horizontal_stop(){
		if(explosive){ explode()}
		else{ del src}
		}
	proc{
		impact(var/game/map/mover/combatant/target){
			owner.attack(target, potency, src)
			if(!persistent){
				if(explosive){
					explode()
					}
				else{
					del src
					}
				}
			}
		explode(){
			del src
			}
		}
	spear{
		icon_state = "spear"
		height = 3
		width  = 3
		persistent = FALSE
		var{
			speed = 2
			}
		New(){
			. = ..()
			dir = owner.dir
			switch(dir){
				if(NORTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = speed
					height = 16
					width = 3
					}
				if(SOUTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = -speed
					height = 16
					width = 3
					}
				if(EAST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = speed
					vel.y = 0
					height = 3
					width = 16
					}
				if(WEST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = -speed
					vel.y = 0
					height = 3
					width = 16
					}
				}
			}
		}
	radish{
		parent_type = /game/map/mover/projectile/magic_1
		movement = MOVEMENT_ALL
		icon = 'gnome_enemies.dmi'
		icon_state = "radish"
		height = 4
		width = 4
		y_offset = -1
		potency = 3
		max_range = 96
		}
	fire_1{
		parent_type = /game/map/mover/projectile/magic_1
		movement = MOVEMENT_LAND | MOVEMENT_WATER
		sound = "fire_magic"
		sound = null
		icon_state = "fire_ball"
		height = 6
		width = 6
		}
	fire_2{
		parent_type = /game/map/mover/projectile/fire_1
		sound = "fire_magic"
		icon_state = "fire_ball_2"
		potency = 2
		}
	fire_large{
		parent_type = /game/map/mover/projectile/fire_1
		sound = "fire_magic"
		height = 16
		width = 16
		icon_state = "fire_large"
		potency = 2
		}
	stationary_fire{
		sound = "fire_magic"
		height = 16
		width = 16
		icon = 'enemies.dmi'
		icon_state = "fire_2"
		potency = 2
		New(){
			. = ..()
			c.x = owner.c.x + (owner.width -width )/2
			c.y = owner.c.y + (owner.height-height)/2
			}
		}
	wind{
		height = 16
		width = 16
		icon = 'rectangles.dmi'
		icon_state = "smoke"
		sound = "wind"
		potency = 0
		movement = MOVEMENT_ALL
		max_range = 80
		persistent = TRUE
		impact(var/game/map/mover/combatant/target){
			if(target.invulnerable){ return}
			var/delta_x = (target.c.x + target.width /2) - (owner.c.x + owner.width /2)
			var/delta_y = (target.c.y + target.height/2) - (owner.c.y + owner.height/2)
			if(abs(delta_x) > abs(delta_y)){
				target.px_move(sign(delta_x)*3, sign(delta_y)  , target.dir)
				}
			else{
				target.px_move(sign(delta_x)  , sign(delta_y)*3, target.dir)
				}
			}
		}
	sand_trap{
		height = 30
		width = 30
		x_offset = -1
		y_offset = -1
		icon = 'large.dmi'
		icon_state = "sand_trap"
		potency = 0
		New(){
			. = ..()
			c.x = owner.c.x + (owner.width -width )/2
			c.y = owner.c.y + (owner.height-height)/2
			}
		impact(var/game/map/mover/combatant/target){
			var/delta_x = (target.c.x + target.width /2) - (owner.c.x + owner.width /2)
			var/delta_y = (target.c.y + target.height/2) - (owner.c.y + owner.height/2)
			if(abs(delta_x) > abs(delta_y)){
				target.px_move(sign(delta_x)*-1/2, sign(delta_y)*-1/2, target.dir)
				}
			else{
				target.px_move(sign(delta_x)*-1/2, sign(delta_y)*-1/2, target.dir)
				}
			}
		}
	magic_2{
		parent_type = /game/map/mover/projectile/magic_1
		potency = 2
		icon_state = "enemy_magic_2"
		}
	magic_1{
		icon_state = "enemy_magic_1"
		height = 8
		width  = 8
		persistent = FALSE
		sound = "magic"
		var{
			speed = 2
			}
		New(){
			. = ..()
			dir = owner.dir
			switch(dir){
				if(NORTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = speed
					}
				if(SOUTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = -speed
					}
				if(EAST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = speed
					vel.y = 0
					}
				if(WEST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = -speed
					vel.y = 0
					}
				}
			}
		}
	seeker_2{
		parent_type = /game/map/mover/projectile/seeker_1
		icon_state = "enemy_magic_2"
		potency = 2
		}
	seeker_1{
		icon_state = "enemy_magic_1"
		potency = 1
		height = 8
		width  = 8
		persistent = FALSE
		sound = "magic"
		max_range = 64
		var{
			speed = 1
			}
		New(){
			. = ..()
			dir = owner.dir
			switch(dir){
				if(NORTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = speed
					}
				if(SOUTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = -speed
					}
				if(EAST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = speed
					vel.y = 0
					}
				if(WEST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = -speed
					vel.y = 0
					}
				}
			}
		behavior(){
			var/game/hero/closest
			var/close_dist
			for(var/game/hero/E in range(COLLISION_RANGE*2, src)){
				var/dist = (c.x+(width/2)) - (E.c.x+(E.width/2))
				if(!closest){
					closest = E
					close_dist = dist
					continue
					}
				if(dist < close_dist){
					closest = E
					close_dist = dist
					}
				}
			if(!closest){
				.=..()
				return
				}
			vel.x += sign((closest.c.x+(closest.width /2)) - (c.x+(width /2)))
			vel.y += sign((closest.c.y+(closest.height/2)) - (c.y+(height/2)))
			vel.x = min(speed, max(-speed, vel.x))
			vel.y = min(speed, max(-speed, vel.y))
			. = ..()
			}
		}
	bone{
		icon_state = "bone"
		height = 12
		width = 12
		var{
			speed = 2
			}
		New(){
			. = ..()
			dir = owner.dir
			switch(dir){
				if(NORTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = speed
					}
				if(SOUTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = -speed
					}
				if(EAST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = speed
					vel.y = 0
					}
				if(WEST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = -speed
					vel.y = 0
					}
				}
			}
		}
	acid{
		icon = 'large.dmi'
		icon_state = "acid"
		height = 28
		width = 28
		x_offset = -2
		y_offset = -2
		var{
			life_span = 128
			}
		behavior(){
			if(life_span-- <= 0){
				del src
				}
			. = ..()
			}
		New(){
			. = ..()
			dir = owner.dir
			c.x = owner.c.x + round((owner.width -width )/2)
			c.y = owner.c.y + round((owner.height-height)/2)
			}
		}
	silk{
		parent_type = /game/map/mover/projectile/magic_1
		icon_state = "silk"
		sound = "gooey"
		height = 6
		width = 6
		movement = MOVEMENT_LAND
		explosive = TRUE
		terminal_explosion = TRUE
		max_range = 96
		sound = null
		New(){
			. = ..()
			vel.x += pick(-1,0,1)*(speed/2)
			vel.y += pick(-1,0,1)*(speed/2)
			}
		impact(var/game/map/mover/combatant/target){
			var/coord/old_c = target.c.Copy()
			. = ..()
			target.c = old_c
			}
		explode(){
			new /game/map/mover/projectile/web(owner, src)
			. = ..()
			}
		}
	silk_small{
		parent_type = /game/map/mover/projectile/magic_1
		icon_state = "silk"
		sound = "gooey"
		height = 6
		width = 6
		movement = MOVEMENT_LAND
		explosive = TRUE
		terminal_explosion = TRUE
		max_range = 96
		sound = null
		New(){
			. = ..()
			vel.x += pick(-1,0,1)*(speed/2)
			vel.y += pick(-1,0,1)*(speed/2)
			}
		impact(var/game/map/mover/combatant/target){
			var/coord/old_c = target.c.Copy()
			. = ..()
			target.c = old_c
			}
		explode(){
			new /game/map/mover/projectile/web_small(owner, src)
			. = ..()
			}
		}
	web{
		icon = 'large.dmi'
		icon_state = "web"
		height = 32
		width = 32
		New(_owner, var/game/map/mover/projectile/silk){
			. = ..()
			if(silk){
				c.x = silk.c.x + (silk.width  - width )/2
				c.y = silk.c.y + (silk.height - height)/2
				}
			}
		impact(var/game/map/mover/combatant/target){
			if(target.invulnerable){ return}
			var/game/hero/H = target
			if(istype(H)){
				H.intelligence = new /game/map/mover/intelligence/freezer(48)
				var/game/enemy/tarantula/T = owner
				if(T){
					T.target = coord(target.c.x + target.width/2, target.c.y + target.height/2)
					T.target_time = initial(T.target_time)
					}
				}
			del src
			}
		}
	web_small{
		icon = 'projectiles.dmi'
		icon_state = "web"
		height = 16
		width = 16
		New(_owner, var/game/map/mover/projectile/silk){
			. = ..()
			if(silk){
				c.x = silk.c.x + (silk.width  - width )/2
				c.y = silk.c.y + (silk.height - height)/2
				}
			}
		impact(var/game/map/mover/combatant/target){
			if(target.invulnerable){ return}
			var/game/hero/H = target
			if(istype(H)){
				H.intelligence = new /game/map/mover/intelligence/freezer(48)
				var/game/enemy/tarantula/T = owner
				if(T){
					T.target = coord(target.c.x + target.width/2, target.c.y + target.height/2)
					T.target_time = initial(T.target_time)
					}
				}
			del src
			}
		}
	bomb{
		icon = 'items.dmi'
		icon_state = "bomb_live"
		layer = MOB_LAYER+1
		width = 6
		height = 6
		persistent = TRUE
		max_time = 48
		potency = 0
		terminal_explosion = TRUE
		var{
			blast_range = 32
			}
		explode(){
			max_time = 32
			current_time = 0
			terminal_explosion = FALSE
			icon = null
			for(var/I = 1 to 7){
				var/image/II = image('rectangles.dmi', src, "smoke")
				switch(I){
					if(1){
						II.pixel_x = 3-8
						II.pixel_y = 3-8
						}
					if(2){
						II.pixel_x = -5 + 16
						II.pixel_y = -5
						}
					if(3){
						II.pixel_x = -5 + 8
						II.pixel_y = -5 + 16
						}
					if(4){
						II.pixel_x = -5 - 8
						II.pixel_y = -5 + 16
						}
					if(5){
						II.pixel_x = -5 - 16
						II.pixel_y = -5
						}
					if(6){
						II.pixel_x = -5 - 8
						II.pixel_y = -5 - 16
						}
					if(7){
						II.pixel_x = -5 + 8
						II.pixel_y = -5 - 16
						}
					}
				underlays.Add(II)
				}
			for(var/game/hero/C in orange(COLLISION_RANGE, src)){
				var/dist = max(
					abs((C.c.x+(C.width /2)) - (c.x+(width /2))),
					abs((C.c.y+(C.height/2)) - (c.y+(height/2))),
					)
				if(dist <= blast_range){
					C.hurt(2, src)
					}
				}
			}
		}
	sword{
		icon = 'large.dmi'
		sound = "sword"
		impact(var/game/map/mover/combatant/target){
			owner.attack(target, potency)
			}
		height = 5
		width  = 5
		persistent = TRUE
		potency = 4
		var{
			stage = 0
			state_name = "sword"
			}
		New(){
			. = ..()
			owner.icon_state = "[owner.icon_state]_attack"
			}
		behavior(){
			stage++
			dir = owner.dir
			switch(stage){
				if(1,2){
					return
					}
				if(3,7){
					icon_state = "[state_name]_8"
					switch(dir){
						if(NORTH, SOUTH){
							height = 8
							width  = 5
							}
						if( EAST,  WEST){
							height = 5
							width  = 8
							}
						}
					}
				if(4,6){
					icon_state = "[state_name]_16"
					switch(dir){
						if(NORTH, SOUTH){
							height = 16
							width  = 5
							}
						if( EAST,  WEST){
							height = 5
							width  = 16
							}
						}
					}
				if(5){
					icon_state = "[state_name]_24"
					switch(dir){
						if(NORTH, SOUTH){
							height = 24
							width  = 5
							}
						if( EAST,  WEST){
							height = 5
							width  = 24
							}
						}
					}
				if(8){
					owner.icon_state = initial(owner.icon_state)
					del src
					}
				}
			switch(dir){
				if(NORTH){
					c.x = owner.c.x + (owner.width-width)/2
					c.y = owner.c.y + owner.height
					}
				if(SOUTH){
					c.x = owner.c.x + (owner.width-width)/2
					c.y = owner.c.y - height
					}
				if( EAST){
					c.x = owner.c.x + owner.width
					c.y = owner.c.y + (owner.height-height)/2
					}
				if( WEST){
					c.x = owner.c.x - width
					c.y = owner.c.y + (owner.height-height)/2
					}
				}
			}
		redraw(){
			loc = owner.loc
			switch(dir){
				if(NORTH){ pixel_x = owner.pixel_x            ; pixel_y = owner.pixel_y+owner.height}
				if(SOUTH){ pixel_x = owner.pixel_x            ; pixel_y = owner.pixel_y-owner.height}
				if( EAST){ pixel_x = owner.pixel_x+owner.width; pixel_y = owner.pixel_y             }
				if( WEST){ pixel_x = owner.pixel_x-owner.width; pixel_y = owner.pixel_y             }
				}
			}
		}
	}
game/map/mover/combatant{
	parent_type = /game/map/mover/gridded
	layer = MOB_LAYER
	movement = MOVEMENT_LAND
	var{
		health = 0
		max_health = 2
		list/projectiles = new()
		front_protection = FALSE
		invulnerable = 0
		invincible = FALSE
		spam_attack_block = FALSE
		}
	New(){
		. = ..()
		adjust_health(max_health)
		}
	Del(){
		for(var/datum/P in projectiles){
			del P
			}
		. = ..()
		}
	take_turn(){
		if(invulnerable){
			invulnerable--
			if((invulnerable%5)%2){
				invisibility = 100
				}
			else{
				invisibility = 0
				}
			}
		else if(invisibility){
			invisibility = 0
			}
		. = ..()
		}
	proc{
		adjust_health(amount){
			var/old_health = health
			health = max(0, min(max_health, health+amount))
			if(!health){
				spawn(){
					die()
					}
				}
			var/delta_health = health - old_health
			return delta_health
			}
		die(){
			del src
			}
		attack(var/game/map/mover/combatant/target, amount, var/game/map/mover/projectile/proxy){
			target.hurt(amount, src, proxy)
			}
		hurt(damage, var/game/map/mover/combatant/attacker, var/game/map/mover/projectile/proxy){
			if(invulnerable){
				return
				}
			if(spam_attack_block){
				invulnerable = INVULNERABLE_TIME
				}
			else{
				invulnerable = 6
				}
			var/old_health = health
			adjust_health(-damage)
			. = old_health - health
			if(health && attacker){
				var/recoil_dir = attacker.dir_to(src)
				var/trans_x = 0
				var/trans_y = 0
				switch(recoil_dir){
					if(NORTH){ trans_y += TILE_HEIGHT}
					if(SOUTH){ trans_y -= TILE_HEIGHT}
					if( EAST){ trans_x += TILE_WIDTH}
					if( WEST){ trans_x -= TILE_WIDTH}
					}
				translate(trans_x, trans_y, dir)
				}

			}
		}
	}
game/enemy{
	parent_type = /game/map/mover/combatant
	icon = 'enemies.dmi'
	max_health = 1
	var{
		boss = FALSE
		score = 0
		}
	New(){
		. = ..()
		game.map.enemies.Add(src)
		}
	hurt(amount, attacker, proxy){
		if(front_protection){
			if(dir_to(attacker) == dir){
				game.audio.play_sound("defend")
				return
				}
			}
		. = ..()
		if(. && health > 0){
			game.audio.play_sound("small_hurt")
			}
		}
	die(){
		game.map.award_score(score)
		var/list/item_types = list(
			/game/item/cherry, /game/item/cherry, /game/item/cherry, /game/item/cherry,
			/game/item/cherry, /game/item/cherry, /game/item/cherry, /game/item/cherry,
			/game/item/cherry, /game/item/cherry, /game/item/cherry, /game/item/cherry,
			/game/item/cherry, /game/item/cherry, /game/item/cherry, /game/item/cherry,
			/game/item/cherry, /game/item/cherry, /game/item/cherry, /game/item/cherry,
			/game/item/bottle, /game/item/bottle,
			/game/item/shield, /game/item/shield,
			/game/item/shield, /game/item/shield,
			/game/item/plum, /game/item/plum,
			/game/item/coin_silver, /game/item/coin_silver, /game/item/coin_silver,
			/game/item/coin_silver, /game/item/coin_silver, /game/item/coin_silver,
			/game/item/coin_silver, /game/item/coin_silver, /game/item/coin_silver,
			/game/item/coin_gold,
			)
		if(boss){
			for(var/I = 1 to rand(5,9)){
				var/item_type = pick(item_types)
				var/game/item/new_item = new item_type(src)
				new_item.c.x += rand(-9,9)
				new_item.c.y += rand(-9,9)
				new_item.redraw()
				}
			}
		else if(rand() <= ITEM_PERCENT){
			var/item_type = pick(item_types)
			new item_type(src)
			}
		game.audio.play_sound("small_die")
		. = ..()
		}
	}
game/hero{
	parent_type = /game/map/mover/combatant
	var{
		no_attack = 2
		image/player_indicator
		aura_rate = 256 // -1 for disabled, n>=0 for ticks to regen one aura
		voted = null //### null = disabled, 0 = unassigned, 1-2-4-8 = selection
		trapable = TRUE
		}
	spam_attack_block = TRUE
	take_turn(){
		if(no_attack){
			no_attack--
			if(istype(player)){
				player.clear_keys()
				}
			return
			}
		if(aura_rate > 0 && aura < max_aura){
			aura_rate--
			}
		else if(!aura_rate){
			adjust_aura(1)
			aura_rate = initial(aura_rate)
			}
		. = ..()
		//if(voted){ return}
		//if(!loc){ return}
		}
	px_move(x_amo, y_amo){
		if(game.stage != STAGE_WIN){
			return ..()
			}
		var/new_x = c.x + x_amo
		var/new_y = c.y + y_amo
		if(voted!=null){ //### If not disabled
			if(     new_x        < 0                     ){ voted = WEST }//; CRASH("WEST: ([c.x],[c.y])") }
			else if(new_x+width  > world.maxx*TILE_WIDTH ){ voted = EAST }//; CRASH("EAST: ([c.x],[c.y])") }
			else if(new_y        < 0                     ){ voted = SOUTH}//; CRASH("SOUTH: ([c.x],[c.y])")}
			else if(new_y+height > world.maxy*TILE_HEIGHT){ voted = NORTH}//; CRASH("NORTH: ([c.x],[c.y])")}
			else{
				. = ..()
				}
			}
		}
	redraw(){
		if(voted){
			pixel_x = 0
			pixel_y = 0
			loc = null
			return
			}
		. = ..()
		}
	max_health = 4
	icon = '_blank.dmi'
	icon_state = ""
	width = TILE_WIDTH
	height = TILE_HEIGHT
	front_protection = FALSE
	var{
		projectile_type = /game/hero/projectile/wood_sword
		game/map/mover/projectile/projectile
		meter
		meter_magic
		aura
		max_aura = 0
		}
	New(){
		. = ..()
		game.heros.Add(src)
		aura = max_aura
		adjust_aura(0)
		if(!max_aura){
			aura_rate = -1
			}
		}
	proc{
		shoot(){
			if(projectile){ return}
			projectile = new projectile_type(src)
			}
		}
	hurt(amount, attacker, proxy){
		if(proxy && front_protection && !projectile){
			if(dir_to(proxy) == dir){
				game.audio.play_sound("defend")
				return
				}
			}
		. = ..()
		if(. && health){
			game.audio.play_sound("player_hurt")
			}
		}
	adjust_health(amount){
		if(amount < 0 && game.map.win_time > 0){ return}
		. = ..()
		overlays.Remove(meter)
		var/meter_index = round((health/max_health)*METER_WIDTH)
		meter_index = max(1, min(METER_WIDTH, meter_index))
		meter = game.meters[meter_index]
		overlays.Add(meter)
		}
	proc{
		adjust_aura(amount){
			if(!max_aura){
				overlays.Remove(meter_magic)
				return
				}
			var/old_aura = aura
			aura = max(0, min(max_aura, aura+amount))
			. = aura - old_aura
			overlays.Remove(meter_magic)
			var/meter_index = round((aura/max_aura)*METER_WIDTH)
			meter_index = max(1, min(METER_WIDTH, meter_index))
			meter_magic = game.meters_magic[meter_index]
			overlays.Add(meter_magic)

			}
		}
	}
game/item{
	parent_type = /game/map/mover
	width = 8
	height = 8
	icon = 'items.dmi'
	var{
		lifespan = 256
		no_collect = 5
		}
	New(var/game/map/mover/combatant/dead){
		. = ..()
		if(!game.map){ del src}
		game.map.items.Add(src)
		if(istype(dead)){
			c.x = round(dead.c.x + (dead.width  - width )/2)
			c.y = round(dead.c.y + (dead.height - height)/2)
			loc = dead.loc
			redraw()
			}
		}
	redraw(){
		if(!lifespan--){
			del src
			}
		if(no_collect > 0){ no_collect--}
		.=..()
		}
	proc{
		activate(){
			del src
			}
		}
	cherry{
		icon_state = "cherry"
		var{
			potency = 1
			}
		activate(var/game/hero/hero){
			var/result = hero.adjust_health(potency)
			if(result){
				.=..()
				}
			}
		}
	plum{
		icon_state = "plum"
		var{
			potency = 5
			}
		activate(var/game/hero/hero){
			var/result = hero.adjust_health(potency)
			if(result){
				.=..()
				}
			}
		}
	bottle{
		icon_state = "bottle"
		var{
			potency = 5
			}
		activate(var/game/hero/hero){
			var/result = hero.adjust_aura(hero.max_aura)
			if(result){
				.=..()
				}
			}
		}
	shield{
		icon_state = "shield"
		var{
			potency = 150
			}
		activate(var/game/hero/hero){
			hero.invulnerable = max(potency, hero.invulnerable)
			. = ..()
			}
		}
	coin_gold{
		parent_type = /game/item/coin_silver
		icon_state = "coin_gold"
		value = 100
		}
	coin_silver{
		icon_state = "coin_silver"
		var{
			value = 25
			}
		activate(var/game/hero/hero){
			for(var/game/hero/H in game.heros){
				if(H.player){
					var/game/item/coin_silver/score_marker/S = new(H)
					S.setup(H, value)
					H.player.award_score(value)
					}
				}
			. = ..()
			}
		score_marker{
			parent_type = /game/map/mover/projectile
			icon = 'rectangles.dmi'
			potency = 0
			layer = FLY_LAYER
			width = 16
			height = 16
			var{
				activated = TRUE
				lifespan = 32
				}
			impact(){}
			behavior(){
				. = ..()
				y_offset++
				lifespan--
				if(lifespan <= 0){
					Del()
					}
				}
			proc{
				setup(var/game/hero/H, value){
					icon_state = "score_[value]"
					c.x = H.c.x
					c.y = H.c.y
					redraw()
					}
				}
			}
		}
	chest{
		icon = 'rectangles.dmi'
		icon_state = "chest"
		lifespan = 10000000000000000000000
		behavior(){}
		activate(){}
		}
	weapon{
		icon = 'projectiles.dmi'
		dir = NORTH
		width = 16
		height = 16
		var{
			weapon_type = /game/hero/projectile/wood_sword
			}
		activate(var/game/hero/hero){
			hero.projectile_type = weapon_type
			. = ..()
			}
		gold_axe{
			icon_state = "gold_axe"
			weapon_type = /game/hero/projectile/gold_axe
			}
		}
	}