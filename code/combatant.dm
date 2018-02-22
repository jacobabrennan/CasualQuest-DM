

//-- Projectile ----------------------------------------------------------------

game/map/mover/projectile
	parent_type = /game/map/mover
	icon = 'projectiles.dmi'
	movement = MOVEMENT_ALL

	var
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

	New(var/game/map/mover/combatant/_owner)
		if(sound)
			game.audio.play_sound(sound)
		. = ..()
		owner = _owner
		owner.projectiles.Add(src)
		c.x = owner.c.x
		c.y = owner.c.y

	Del()
		if(owner && owner.projectiles)
			owner.projectiles.Remove(src)
		. = ..()

	behavior()
		/*vel.x += pick(0, rand(-1,1))
		vel.y += pick(0, rand(-1,1))*/
		. = ..()
		if(max_range)
			if(current_range >= max_range)
				if(terminal_explosion)
					explode()
				else
					del src
			current_range += max(abs(vel.x), abs(vel.y))
		if(max_time)
			if(current_time  >= max_time )
				if(terminal_explosion)
					explode()
				else
					del src
			current_time++
		translate(vel.x, vel.y)

	vertical_stop()
		if(explosive) explode()
		else del src
	horizontal_stop()
		if(explosive) explode()
		else del src

	proc
		impact(var/game/map/mover/combatant/target)
			owner.attack(target, potency, src)
			if(!persistent)
				if(explosive)
					explode()
				else
					del src
		explode()
			del src


//-- Combatant -----------------------------------------------------------------

game/map/mover/combatant
	parent_type = /game/map/mover/gridded
	layer = MOB_LAYER
	movement = MOVEMENT_LAND

	var
		health = 0
		max_health = 2
		list/projectiles = new()
		front_protection = FALSE
		invulnerable = 0
		invincible = FALSE
		spam_attack_block = FALSE

	New()
		. = ..()
		adjust_health(max_health)
	Del()
		for(var/datum/P in projectiles)
			del P
		. = ..()

	take_turn()
		if(invulnerable)
			invulnerable--
			if((invulnerable%5)%2)
				invisibility = 100
			else
				invisibility = 0
		else if(invisibility)
			invisibility = 0
		. = ..()

	proc
		adjust_health(amount)
			var old_health = health
			health = max(0, min(max_health, health+amount))
			if(!health){
				spawn(){
					die()
					}
				}
			var delta_health = health - old_health
			return delta_health

		die()
			del src

		attack(var/game/map/mover/combatant/target, amount, var/game/map/mover/projectile/proxy)
			target.hurt(amount, src, proxy)

		hurt(damage, var/game/map/mover/combatant/attacker, var/game/map/mover/projectile/proxy)
			if(invulnerable) return
			if(spam_attack_block)
				invulnerable = INVULNERABLE_TIME
			else
				invulnerable = 6
			var old_health = health
			adjust_health(-damage)
			. = old_health - health
			if(health && attacker)
				var recoil_dir = attacker.dir_to(src)
				var trans_x = 0
				var trans_y = 0
				switch(recoil_dir)
					if(NORTH) trans_y += TILE_HEIGHT
					if(SOUTH) trans_y -= TILE_HEIGHT
					if( EAST) trans_x += TILE_WIDTH
					if( WEST) trans_x -= TILE_WIDTH
				translate(trans_x, trans_y, dir)


//-- Enemy ---------------------------------------------------------------------

game/enemy
	parent_type = /game/map/mover/combatant
	icon = 'enemies.dmi'
	max_health = 1

	var
		boss = FALSE
		score = 0

	New()
		. = ..()
		game.map.enemies.Add(src)

	hurt(amount, attacker, proxy)
		if(front_protection)
			if(dir_to(attacker) == dir)
				game.audio.play_sound("defend")
				return
		. = ..()
		if(. && health > 0)
			game.audio.play_sound("small_hurt")

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
		if(boss)
			for(var/I = 1 to rand(5,9))
				var/item_type = pick(item_types)
				var/game/item/new_item = new item_type(src)
				new_item.c.x += rand(-9,9)
				new_item.c.y += rand(-9,9)
				new_item.redraw()
		else if(rand() <= ITEM_PERCENT)
			var item_type = pick(item_types)
			new item_type(src)
		game.audio.play_sound("small_die")
		. = ..()
		}


//-- Hero ----------------------------------------------------------------------

game/hero
	parent_type = /game/map/mover/combatant

	var
		no_attack = 2
		image/player_indicator
		aura_rate = 256 // -1 for disabled, n>=0 for ticks to regen one aura
		voted = null //### null = disabled, 0 = unassigned, 1-2-4-8 = selection
		trapable = TRUE

	spam_attack_block = TRUE

	take_turn()
		if(no_attack)
			no_attack--
			if(istype(player))
				player.clear_keys()
			return
		if(aura_rate > 0 && aura < max_aura)
			aura_rate--
		else if(!aura_rate)
			adjust_aura(1)
			aura_rate = initial(aura_rate)
		. = ..()
		//if(voted){ return}
		//if(!loc){ return}

	px_move(x_amo, y_amo)
		if(game.stage != STAGE_WIN)
			return ..()
		var/new_x = c.x + x_amo
		var/new_y = c.y + y_amo
		if(voted!=null) //### If not disabled
			if(     new_x        < 0                     ) voted = WEST //; CRASH("WEST: ([c.x],[c.y])") }
			else if(new_x+width  > world.maxx*TILE_WIDTH ) voted = EAST //; CRASH("EAST: ([c.x],[c.y])") }
			else if(new_y        < 0                     ) voted = SOUTH//; CRASH("SOUTH: ([c.x],[c.y])")}
			else if(new_y+height > world.maxy*TILE_HEIGHT) voted = NORTH//; CRASH("NORTH: ([c.x],[c.y])")}
			else
				. = ..()

	redraw()
		if(voted)
			pixel_x = 0
			pixel_y = 0
			loc = null
			return
		. = ..()

	max_health = 4
	icon = '_blank.dmi'
	icon_state = ""
	width = TILE_WIDTH
	height = TILE_HEIGHT
	front_protection = FALSE

	var
		projectile_type = /game/hero/projectile/wood_sword
		game/map/mover/projectile/projectile
		meter
		meter_magic
		aura
		max_aura = 0

	New()
		. = ..()
		game.heros.Add(src)
		aura = max_aura
		adjust_aura(0)
		if(!max_aura)
			aura_rate = -1

	proc/shoot()
		if(projectile) return
		projectile = new projectile_type(src)

	hurt(amount, attacker, proxy)
		if(proxy && front_protection && !projectile)
			if(dir_to(proxy) == dir)
				game.audio.play_sound("defend")
				return
		. = ..()
		if(. && health)
			game.audio.play_sound("player_hurt")

	adjust_health(amount)
		if(amount < 0 && game.map.win_time > 0) return
		. = ..()
		overlays.Remove(meter)
		var/meter_index = round((health/max_health)*METER_WIDTH)
		meter_index = max(1, min(METER_WIDTH, meter_index))
		meter = game.meters[meter_index]
		overlays.Add(meter)

	proc/adjust_aura(amount)
		if(!max_aura)
			overlays.Remove(meter_magic)
			return
		var/old_aura = aura
		aura = max(0, min(max_aura, aura+amount))
		. = aura - old_aura
		overlays.Remove(meter_magic)
		var/meter_index = round((aura/max_aura)*METER_WIDTH)
		meter_index = max(1, min(METER_WIDTH, meter_index))
		meter_magic = game.meters_magic[meter_index]
		overlays.Add(meter_magic)


//-- Item ----------------------------------------------------------------------

game/item
	parent_type = /game/map/mover
	width = 8
	height = 8
	icon = 'items.dmi'

	var
		lifespan = 256
		no_collect = 5

	New(var/game/map/mover/combatant/dead)
		. = ..()
		if(!game.map) del src
		game.map.items.Add(src)
		if(istype(dead))
			c.x = round(dead.c.x + (dead.width  - width )/2)
			c.y = round(dead.c.y + (dead.height - height)/2)
			loc = dead.loc
			redraw()

	redraw()
		if(!lifespan--)
			del src
		if(no_collect > 0) no_collect--
		.=..()

	proc/activate()
		del src
