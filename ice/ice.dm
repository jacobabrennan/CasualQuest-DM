game/map/region{
	tower{
		parent_type = /game/map/region/castle
		icon = 'tower.dmi'
		enemies(wave, boss){
			var/list/E
			switch(wave){
				if(89 to 92){
					E = list(/game/map/region/ice/enemy/berserker, /game/map/region/ice/enemy/berserker, /game/map/region/ice/enemy/adventurer)
					}
				if(93 to 95){
					E = list(/game/map/region/ice/enemy/druid, /game/map/region/ice/enemy/berserker, /game/map/region/ice/enemy/adventurer)
					}
				if(96 to 98){
					E = list(/game/map/region/ice/enemy/sorcerer, /game/map/region/ice/enemy/berserker, /game/map/region/ice/enemy/adventurer)
					}
				if(99 to 100){
					E = list(/game/map/region/ice/enemy/high_priest, /game/map/region/ice/enemy/sorcerer, /game/map/region/ice/enemy/berserker)
					}
				}
				/*
				Officer: crab2, mole, gnome
				Cavalry: bubble, bubble, mole
				Infantry: crab1, crab1, crab2

				Ice Theme: Freeze, Shiny, Large Crystals

				Adventurer
				Berserker (Knight)
				Acolyte
				Mage (Freeze Sorcerer)
				Rogue
				*/
			return E
			}
		}
	}
	ice{
		parent_type = /game/map/region/pagota
		icon = 'ice.dmi'
		enemies(wave, boss){
			var/list/E
			switch(wave){
				if(89 to 92){
					E = list(/game/map/region/ice/enemy/berserker, /game/map/region/ice/enemy/berserker, /game/map/region/ice/enemy/adventurer)
					}
				if(93 to 95){
					E = list(/game/map/region/ice/enemy/druid, /game/map/region/ice/enemy/berserker, /game/map/region/ice/enemy/adventurer)
					}
				if(96 to 98){
					E = list(/game/map/region/ice/enemy/sorcerer, /game/map/region/ice/enemy/berserker, /game/map/region/ice/enemy/adventurer)
					}
				if(99 to 100){
					E = list(/game/map/region/ice/enemy/high_priest, /game/map/region/ice/enemy/sorcerer, /game/map/region/ice/enemy/berserker)
					}
				}
				/*
				Officer: crab2, mole, gnome
				Cavalry: bubble, bubble, mole
				Infantry: crab1, crab1, crab2

				Ice Theme: Freeze, Shiny, Large Crystals

				Adventurer
				Berserker (Knight)
				Acolyte
				Mage (Freeze Sorcerer)
				Rogue
				*/
			return E
			}
		}
	}
game/map/region/ice/projectile{
	parent_type = /game/map/mover/projectile
	ice_bolt{
		parent_type = /game/map/mover/projectile/seeker_1
		explosive = TRUE
		max_range = 64
		impact(var/game/map/mover/combatant/target){
			c = target.c
			width = target.width
			height = target.height
			explode();
			}
		explode(){
			new /game/map/region/ice/projectile/ice_trap(owner, src)
			. = ..()
			}
		}
	note{
		parent_type = /game/map/mover/projectile/magic_1
		icon_state = "note"
		potency = 1
		max_range = 96
		speed = 6
		y_offset = -1
		width = 12
		height = 12
		}
	ice_trap{
		height = 30
		width = 30
		x_offset = -1
		y_offset = -1
		icon = 'ice_large.dmi'
		icon_state = "ice_block"
		layer = MOB_LAYER+2;
		potency = 0
		max_time = 96
		var{
			last_impact = 0
			freeze_hero
			}
		New(_owner, var/game/map/mover/projectile/caster){
			. = ..()
			if(caster){
				c.x = caster.c.x + (caster.width  - width )/2
				c.y = caster.c.y + (caster.height - height)/2
				}
			}
		impact(var/game/map/mover/combatant/target){
			if(freeze_hero && (freeze_hero != target)){ return}
			if(target.invulnerable){ return}
			var/game/hero/H = target
			if(istype(H)){
				freeze_hero = H
				H.intelligence = new /game/map/mover/intelligence/freezer(2)
				last_impact = 0
				}
			}
		behavior(){
			if(last_impact++ > 3){
				del src
				}
			. = ..()
			}
		}
	wood_axe{
		icon = 'projectiles.dmi'
		icon_state = "wood_axe"
		impact(var/game/map/mover/combatant/target){
			owner.attack(target, potency)
			}
		height = 16
		width  = 16
		persistent = TRUE
		potency = 1
		redraw(){}
		var{
			stage = 0
			}
		behavior(){
			stage++
			owner.icon_state = initial(owner.icon_state)+"_attack"
			loc = owner.loc
			switch(stage){
				if(1,2){ dir = turn(owner.dir, -45)}
				if(3,4){ dir =      owner.dir      }
				if(5,6){ dir = turn(owner.dir,  45)}
				if(7){
					owner.icon_state = initial(owner.icon_state)
					del src
					}
				}
			switch(dir){
				if(EAST     ){
					c.x = owner.c.x+(16)
					c.y = owner.c.y
					pixel_x = owner.pixel_x+16
					pixel_y = owner.pixel_y
					}
				if(SOUTHEAST){
					c.x = owner.c.x+(16)
					c.y = owner.c.y-(16)
					pixel_x = owner.pixel_x+13
					pixel_y = owner.pixel_y-13
					}
				if(SOUTH    ){
					c.x = owner.c.x+2
					c.y = owner.c.y-(16)
					pixel_x = owner.pixel_x
					pixel_y = owner.pixel_y-16
					}
				if(SOUTHWEST){
					c.x = owner.c.x-(16)
					c.y = owner.c.y-(16)
					pixel_x = owner.pixel_x-13
					pixel_y = owner.pixel_y-13
					}
				if(WEST     ){
					c.x = owner.c.x-(16)
					c.y = owner.c.y
					pixel_x = owner.pixel_x-16
					pixel_y = owner.pixel_y
					}
				if(NORTHWEST){
					c.x = owner.c.x-(16)
					c.y = owner.c.y+ 16
					pixel_x = owner.pixel_x-13
					pixel_y = owner.pixel_y+13
					}
				if(NORTH    ){
					c.x = owner.c.x+2
					c.y = owner.c.y+(16)
					pixel_x = owner.pixel_x
					pixel_y = owner.pixel_y+16
					}
				if(NORTHEAST){
					c.x = owner.c.x+(16)
					c.y = owner.c.y+(16)
					pixel_x = owner.pixel_x+13
					pixel_y = owner.pixel_y+13
					}
				}
			redraw()
			}
		}
	wood_sword{
		parent_type = /game/map/mover/projectile
		icon = 'projectiles.dmi'
		impact(var/game/map/mover/combatant/target){
			owner.attack(target, potency)
			}
		height = 3
		width  = 3
		persistent = TRUE
		potency = 1
		var{
			stage = 0
			state_name = "wood"
			}
		New(){
			. = ..()
			owner.icon_state = "[initial(owner.icon_state)]_attack"
			}
		behavior(){
			stage++
			dir = owner.dir
			switch(stage){
				if(1,2){
					return
					}
				if(3,7){
					icon_state = "[state_name]_6"
					switch(dir){
						if(NORTH, SOUTH){
							height = 6
							width  = 4
							}
						if( EAST,  WEST){
							height = 4
							width  = 6
							}
						}
					}
				if(4,6){
					icon_state = "[state_name]_11"
					switch(dir){
						if(NORTH, SOUTH){
							height = 11
							width  = 4
							}
						if( EAST,  WEST){
							height = 4
							width  = 11
							}
						}
					}
				if(5){
					icon_state = "[state_name]_16"
					switch(dir){
						if(NORTH, SOUTH){
							height = 16
							width  = 4
							}
						if( EAST,  WEST){
							height = 4
							width  = 16
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
	ice_snake{
		icon = 'ice_enemies.dmi'
		icon_state = "ice_cube"
		max_time = 192
		potency = 2
		persistent = TRUE
		var{
			list/body = new()
			length = 3
			body_radius = 16
			list/old_positions
			body_state = "ice_cube"
			tail_state
			speed = 3
			}
		New(){
			. = ..()
			owner.intelligence = src
			layer++
			old_positions = new()
			var/game/map/mover/projectile/lead = src
			dir = pick(NORTHEAST, SOUTHEAST, NORTHWEST, SOUTHWEST);
			for(var/I = 1 to length){
				var/game/map/region/ice/projectile/ice_snake/body/B = new(owner)
				B.icon = icon
				B.potency = potency
				B.c.x = c.x+(width -B.width )/2
				B.c.y = c.y+(height-B.height)/2
				body.Add(B)
				if(lead != src){
					var/game/map/region/ice/projectile/ice_snake/body/leader = lead
					leader.follower = B
					}
				B.lead = lead
				lead = B
				B.head = src
				if(I == length && tail_state){
					B.icon_state = tail_state
					}
				else{
					B.icon_state = body_state
					}
				B.height = body_radius
				B.width = body_radius
				}
			}
		impact(var/game/map/mover/combatant/target){
			new /game/map/region/ice/projectile/ice_trap(owner, target)
			}
		horizontal_stop(){
			switch(dir){
				if(NORTHEAST){
					dir = NORTHWEST
					}
				if(NORTHWEST){
					dir = NORTHEAST
					}
				if(SOUTHEAST){
					dir = SOUTHWEST
					}
				if(SOUTHWEST){
					dir = SOUTHEAST
					}
				}
			}
		vertical_stop(){
			switch(dir){
				if(NORTHEAST){
					dir = SOUTHEAST
					}
				if(NORTHWEST){
					dir = SOUTHWEST
					}
				if(SOUTHEAST){
					dir = NORTHEAST
					}
				if(SOUTHWEST){
					dir = NORTHWEST
					}
				}
			}
		behavior(){
			owner.intelligence = src
			owner.icon_state = initial(owner.icon_state)+"_cast"
			switch(dir){
				if(NORTHEAST){
					vel.x = speed
					vel.y = speed
					}
				if(NORTHWEST){
					vel.x = -speed
					vel.y = speed
					}
				if(SOUTHEAST){
					vel.x = speed
					vel.y = -speed
					}
				if(SOUTHWEST){
					vel.x = -speed
					vel.y = -speed
					}
				}
			var/coord/old_c = c.Copy()
			old_c.x += (width -body_radius)/2
			old_c.y += (height-body_radius)/2
			old_positions.Insert(1, old_c)
			old_positions[old_c] = dir
			. = ..()
			for(var/I = 1 to body.len){
				var/old_index = round(I * body_radius/speed)
				if(old_index <= old_positions.len){
					var/game/enemy/archetype/snaking/body/B = body[I]
					if(!B){ continue}
					var/coord/new_c = old_positions[old_index]
					B.dir = old_positions[new_c]
					B.c.x = new_c.x
					B.c.y = new_c.y
					}
				}
			old_positions.len = min(old_positions.len, round(body.len*body_radius/speed))
			}
		Del(){
			for(var/game/map/mover/projectile/P in body){
				del P
				}
			owner.icon_state = initial(owner.icon_state)
			. = ..()
			}
		body{
			parent_type = /game/map/mover/projectile
			persistent = TRUE
			var{
				game/map/region/ice/projectile/ice_snake/head
				game/map/mover/projectile/lead
				game/map/mover/projectile/follower
				}
			impact(var/game/map/mover/combatant/target){
				new /game/map/region/ice/projectile/ice_trap(owner, target)
				}
			}
		}
	}
game/map/region/ice/enemy{
	parent_type = /game/enemy/archetype/normal
	adventurer{
		parent_type = /game/enemy/delayed
		icon = 'ice_enemies.dmi'
		icon_state = "adventurer"
		score = 20
		touch_damage = 1
		max_health = 5
		shoot_frequency = 48
		move_toggle = -1
		var{
			game/hero/saved_target
			}
		projectile_type = /game/map/region/ice/projectile/wood_sword
		behavior(){
			if(started){
				if(projectiles.len){
					return
					}
				if(rand()*(10) > (10)-1){
					if(!saved_target){
						saved_target = pick(game.heros)
						}
					dir = dir_to(saved_target)
					switch(dir){
						if(NORTH){ bearing =  90}
						if(SOUTH){ bearing = 270}
						if(EAST ){ bearing =   0}
						if(WEST ){ bearing = 180}
						}
					}
				if(saved_target && !collision_check(saved_target)){
					. = ..()
					}
				}
			}
		}
	berserker{
		icon = 'ice_enemies.dmi'
		icon_state = "berserker"
		score = 50
		touch_damage = 1
		max_health = 5
		shoot_frequency = 16
		var{
			hero_state = "berserker"
			game/hero/saved_target
			}
		projectile_type = /game/map/region/ice/projectile/wood_axe
		behavior(){
			if(projectiles.len){
				return
				}
			if(rand()*(10) > (10)-1){
				if(!saved_target){
					saved_target = pick(game.heros)
					}
				dir = dir_to(saved_target)
				switch(dir){
					if(NORTH){ bearing =  90}
					if(SOUTH){ bearing = 270}
					if(EAST ){ bearing =   0}
					if(WEST ){ bearing = 180}
					}
				}
			if(saved_target && !collision_check(saved_target)){
				. = ..()
				}
			}
		}
	druid{
		icon = 'ice_enemies.dmi'
		icon_state = "druid"
		max_health = 6
		score = 75
		move_toggle = -1
		shoot_frequency = 64
		projectile_type = /game/map/region/ice/projectile/ice_bolt
		var{
			game/enemy/friend
			heal_rate = 102
			}
		behavior(){
			if(icon_state != "druid"){
				icon_state = "druid"
				}
			if(!friend || friend == src){
				var/game/map/region/ice/P = game.map.region
				if(istype(P) && P.ninja.len >= 2){
					friend = pick(P.ninja - src)
					}
				if(!friend){
					friend = src
					}
				}
			if(friend && rand()*(20/3) > (20/3)-1){
				dir = dir_to(friend)
				switch(dir){
					if(NORTH){ bearing =  90}
					if(SOUTH){ bearing = 270}
					if(EAST ){ bearing =   0}
					if(WEST ){ bearing = 180}
					}
				}
			if(friend && rand()*heal_rate > heal_rate-1){
				heal()
				}
			if(!collision_check(friend) || friend == src){
				. = ..()
				}
			}
		proc{
			heal(){
				intelligence = new /game/map/mover/intelligence/freezer(9)
				icon_state = icon_state+"_cast"
				var/heal_range = 32
				var/potency = 3
				for(var/I = 1 to 4){
					var/game/hero/projectile/healing/H = new(src)
					H.icon_state = "heal_2"
					H.c.x = c.x + (width -H.width )/2
					H.c.y = c.y + (height-H.height)/2
					switch(I){
						if(1){ H.vel.x =  3; H.vel.y =  3}
						if(2){ H.vel.x = -3; H.vel.y =  3}
						if(3){ H.vel.x = -3; H.vel.y = -3}
						if(4){ H.vel.x =  3; H.vel.y = -3}
						}
					}
				for(var/game/enemy/H in range(COLLISION_RANGE, src)){
					var/d_x = abs((c.x+(width /2)) - (H.c.x+(H.width /2)))
					var/d_y = abs((c.y+(height/2)) - (H.c.y+(H.height/2)))
					if(min(d_x, d_y) <= heal_range){
						H.adjust_health(potency, src)
						if(H != src){
							H.invulnerable = max(H.invulnerable, 6)
							}
						}
					}
				}
			}
		}
	sorcerer{
		icon = 'ice_enemies.dmi'
		icon_state = "sorcerer"
		max_health = 6
		score = 125
		shoot_frequency = 128
		projectile_type = /game/map/region/ice/projectile/ice_snake
		behavior(){
			if(icon_state != "sorcerer"){
				icon_state = "sorcerer"
				}
			else{
				. = ..()
				}
			}
		}
	high_priest{
		icon = 'ice_enemies.dmi'
		icon_state = "hp"
		max_health = 6
		score = 300
		var{
			game/enemy/friend
			heal_rate = 32
			spawn_buddy = FALSE
			count_down = 6
			}
		behavior(){
			if(icon_state != "hp"){
				icon_state = "hp"
				}
			if(!spawn_buddy && (count_down--) <= 0){
				spawn_buddy = TRUE
				var /game/map/region/ice/enemy/bard/buddy = new(loc)
				c.x += 8
				buddy.c.x = c.x -16
				buddy.c.y = c.y
				}
			if(!friend || friend == src){
				friend = pick(game.map.enemies - src)
				if(!friend){
					friend = src
					}
				}
			if((friend && rand()*(20/3) > (20/3)-1 && friend != src) || rand()*16 < 1){
				dir = dir_to(friend)
				switch(dir){
					if(NORTH){ bearing =  90}
					if(SOUTH){ bearing = 270}
					if(EAST ){ bearing =   0}
					if(WEST ){ bearing = 180}
					}
				}
			if(friend && rand()*heal_rate > heal_rate-1){
				heal()
				}
			if(!collision_check(friend) || friend == src){
				. = ..()
				}
			}
		proc{
			heal(){
				intelligence = new /game/map/mover/intelligence/freezer(9)
				icon_state = icon_state+"_cast"
				var/heal_range = 32
				var/potency = 1
				for(var/I = 1 to 4){
					var/game/hero/projectile/healing/H = new(src)
					H.icon_state = "heal_2"
					H.c.x = c.x + (width -H.width )/2
					H.c.y = c.y + (height-H.height)/2
					switch(I){
						if(1){ H.vel.x =  3; H.vel.y =  3}
						if(2){ H.vel.x = -3; H.vel.y =  3}
						if(3){ H.vel.x = -3; H.vel.y = -3}
						if(4){ H.vel.x =  3; H.vel.y = -3}
						}
					}
				for(var/game/enemy/H in range(COLLISION_RANGE, src)){
					var/d_x = abs((c.x+(width /2)) - (H.c.x+(H.width /2)))
					var/d_y = abs((c.y+(height/2)) - (H.c.y+(H.height/2)))
					if(min(d_x, d_y) <= heal_range){
						H.adjust_health(potency, src)
						if(H != src){
							H.invulnerable = max(H.invulnerable, 6)
							}
						}
					}
				}
			}
		}
	bard{
		icon = 'ice_enemies.dmi'
		icon_state = "bard"
		max_health = 6
		score = 200
		shoot_frequency = 64
		move_toggle = -1
		projectile_type = /game/map/region/ice/projectile/note
		var{
			game/enemy/friend
			shield_rate = 512
			}
		behavior(){
			if(icon_state != "bard"){
				icon_state = "bard"
				}
			if(!friend || friend == src || rand()*16 < 1){
				friend = pick(game.map.enemies - src)
				if(!friend){
					friend = src
					}
				}
			if(friend != src && friend && rand()*(20/3) > (20/3)-1){
				dir = dir_to(friend)
				switch(dir){
					if(NORTH){ bearing =  90}
					if(SOUTH){ bearing = 270}
					if(EAST ){ bearing =   0}
					if(WEST ){ bearing = 180}
					}
				}
			if(friend && rand()*shield_rate > shield_rate-1){
				shield()
				}
			if(!collision_check(friend) || friend == src){
				. = ..()
				}
			}
		proc{
			shield(){
				intelligence = new /game/map/mover/intelligence/freezer(9)
				icon_state = icon_state+"_cast"
				var/heal_range = 32
				for(var/I = 1 to 4){
					var/game/hero/projectile/healing/H = new(src)
					H.icon = 'items.dmi'
					H.icon_state = "shield"
					H.width = 8
					H.height = 8
					H.max_range = 0
					H.max_time = 10
					H.c.x = c.x + (width -H.width )/2
					H.c.y = c.y + (height-H.height)/2
					var/angle = (I-1)*(360/8)
					H.vel.x = cos(angle)*4
					H.vel.y = sin(angle)*4
					}
				for(var/game/enemy/H in range(COLLISION_RANGE, src)){
					var/d_x = abs((c.x+(width /2)) - (H.c.x+(H.width /2)))
					var/d_y = abs((c.y+(height/2)) - (H.c.y+(H.height/2)))
					if(min(d_x, d_y) <= heal_range){
						H.invulnerable = max(H.invulnerable, 150)
						}
					}
				}
			}
		}
	}