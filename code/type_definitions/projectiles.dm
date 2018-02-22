

//-- Projectile Type Defs ------------------------------------------------------

game/map/mover/projectile
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