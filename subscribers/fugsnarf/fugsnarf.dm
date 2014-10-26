game/hero/subscriber/fugsnarf{
	icon = 'fugsnarf.dmi'
	x_offset = -4
	y_offset = -4
	max_health = 7
	max_aura = 4
	aura_rate = 100
	projectile_type = /game/hero/subscriber/fugsnarf/club
	skill1_cost = 4
	skill2_cost = 4
	skill1 = /game/hero/skill/fug_pounder
	skill2 = /game/hero/skill/fug_charger
	club{
		parent_type = /game/hero/projectile/sword
		icon = 'fugsnarf.dmi'
		icon_state = "club"
		height = 18
		width  = 18
		persistent = TRUE
		potency = 1
		state_name = "club"
		sound = "axe"
		redraw(){}
		behavior(){
			stage++
			owner.icon_state = "attack"
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
					potency = 2
					c.x = owner.c.x+(24+6)
					c.y = owner.c.y    +2
					pixel_x = owner.pixel_x+24
					pixel_y = owner.pixel_y
					}
				if(SOUTHEAST){
					potency = 1
					c.x = owner.c.x+(24+3)
					c.y = owner.c.y-(24+3)
					pixel_x = owner.pixel_x+18
					pixel_y = owner.pixel_y-18
					}
				if(SOUTH    ){
					potency = 2
					c.x = owner.c.x+2
					c.y = owner.c.y-(24+6)
					pixel_x = owner.pixel_x
					pixel_y = owner.pixel_y-24
					}
				if(SOUTHWEST){
					potency = 1
					c.x = owner.c.x-(24+3)
					c.y = owner.c.y-(24+3)
					pixel_x = owner.pixel_x-18
					pixel_y = owner.pixel_y-18
					}
				if(WEST     ){
					potency = 2
					c.x = owner.c.x-(24+6)
					c.y = owner.c.y    +2
					pixel_x = owner.pixel_x-24
					pixel_y = owner.pixel_y
					}
				if(NORTHWEST){
					potency = 1
					c.x = owner.c.x-(24+3)
					c.y = owner.c.y+ 24+3
					pixel_x = owner.pixel_x-18
					pixel_y = owner.pixel_y+18
					}
				if(NORTH    ){
					potency = 2
					c.x = owner.c.x+2
					c.y = owner.c.y+(24+6)
					pixel_x = owner.pixel_x
					pixel_y = owner.pixel_y+24
					}
				if(NORTHEAST){
					potency = 1
					c.x = owner.c.x+(24+3)
					c.y = owner.c.y+(24+3)
					pixel_x = owner.pixel_x+18
					pixel_y = owner.pixel_y+18
					}
				}
			for(var/game/hero/subscriber/fugsnarf/boulder/B){
				if(collision_check(B)){
					B.persistent = TRUE
					B.max_time = 0
					switch(dir){
						if(NORTH    ){ B.vel.x =  0; B.vel.y =  4}
						if(SOUTH    ){ B.vel.x =  0; B.vel.y = -4}
						if(EAST     ){ B.vel.x =  4; B.vel.y =  0}
						if(WEST     ){ B.vel.x = -4; B.vel.y =  0}
						if(NORTHEAST){ B.vel.x =  4; B.vel.y =  4}
						if(NORTHWEST){ B.vel.x = -4; B.vel.y =  4}
						if(SOUTHEAST){ B.vel.x =  4; B.vel.y = -4}
						if(SOUTHWEST){ B.vel.x = -4; B.vel.y = -4}
						}
					}
				}
			}
		}

	var{
		pounding = 0
		charging = 0
		}

	vertical_stop(){
		. = ..()
		var/game/hero/subscriber/fugsnarf/charger/charge = intelligence
		if(istype(charge) && dir&(NORTH|SOUTH)){ charge.Del(); icon_state = null}
		}

	horizontal_stop(){
		. = ..()
		var/game/hero/subscriber/fugsnarf/charger/charge = intelligence
		if(istype(charge) && dir&(EAST |WEST )){ charge.Del(); icon_state = null}
		}
	hurt(){
		var/game/hero/subscriber/fugsnarf/charger/charge = intelligence
		if(istype(charge)){ return}
		. = ..()
		}
	charger{
		parent_type = /game/map/mover/intelligence
		intelligence(var/game/hero/slave){
			slave.icon_state = "charging"
			switch(slave.dir){
				if(NORTH){ slave.px_move( 0, 3)}
				if(SOUTH){ slave.px_move( 0,-3)}
				if(EAST ){ slave.px_move( 3, 0)}
				if(WEST ){ slave.px_move(-3, 0)}
				}
			for(var/game/enemy/enemy in orange(COLLISION_RANGE, slave)){
				slave.c.x += slave.x_offset
				slave.c.y += slave.y_offset
				slave.width  -= slave.x_offset*2
				slave.height -= slave.y_offset*2
				var/collide = slave.collision_check(enemy)
				slave.c.x -= slave.x_offset
				slave.c.y -= slave.y_offset
				slave.width  += slave.x_offset*2
				slave.height += slave.y_offset*2
				if(!collide){ continue}
				slave.attack(enemy, 2)
				}
			return
			}
		}
	pounder{
		parent_type = /game/map/mover/intelligence
		var{
			pounding = 45
			}
		intelligence(var/game/hero/slave){
			slave.icon_state = "pound"
			if(!((pounding--)%9)){
				var/theta = rand(1,359)
				var/game/hero/subscriber/fugsnarf/boulder/B = new(slave)
				B.c.x = (slave.c.x+(slave.width /2) + round(cos(theta)*20)) - B.width /2
				B.c.y = (slave.c.y+(slave.height/2) + round(sin(theta)*20)) - B.height/2
				}
			if(pounding == 0){
				slave.icon_state = null
				Del()
				}
			}
		}
	boulder{
		parent_type = /game/hero/projectile
		icon = 'fugsnarf.dmi'
		icon_state = "boulder"
		width = 16
		height = 16
		y_offset = 16
		max_time = 200
		behavior(){
			if(y_offset > 0){
				y_offset -= 2
				}
			. = ..()
			}
		}

	}