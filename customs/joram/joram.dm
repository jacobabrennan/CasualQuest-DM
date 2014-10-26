game/hero/custom/joram{
	icon = 'joram.dmi'
	max_health = 8
	max_aura = 4
	aura_rate = 225
	speed = 2
	projectile_type = /game/hero/custom/joram/knife
	skill1_cost = 2
	skill2_cost = 3
	skill3_cost = 4
	skill1 = /game/hero/skill/joram_needle
	skill2 = /game/hero/skill/joram_darter
	skill3 = /game/hero/skill/joram_chakram
	darter{
		parent_type = /game/map/mover/intelligence
		var{
			time = 24
			}
		intelligence(var/game/map/mover/mover){
			if(time-- <= 0){
				if(istype(mover, /game/hero)){
					mover.icon_state = initial(mover.icon_state)
					}
				Del()
				}
			if(!(time % 4)){
				var/d_x_off = 0
				var/d_y_off = 0
				switch(mover.dir){
					if(EAST ){ d_y_off = -TILE_HEIGHT}
					if(WEST ){ d_y_off =  TILE_HEIGHT}
					if(NORTH){ d_x_off = -TILE_WIDTH }
					if(SOUTH){ d_x_off =  TILE_WIDTH }
					}
				var/game/hero/custom/joram/dart/D = new(mover)
				switch(time){
					if(20, 8){
						D.c.x +=  d_x_off
						D.c.y +=  d_y_off
						}
					if(12, 0){
						D.c.x += -d_x_off
						D.c.y += -d_y_off
						}
					}
				}
			}
		}
	knife{
		parent_type = /game/hero/custom/joram/dart
		max_range = 64
		icon_state = "knife"
		behavior(){
			if(current_time == 5){
				owner.icon_state = null
				}
			. = ..()
			}
		New(){
			. = ..()
			spawn(){
				var/game/hero/O = owner
				if(O && O.projectile == src){ O.projectile = null}
				}
			var/game/hero/custom/joram/knife/first_arrow
			for(var/game/hero/custom/joram/knife/A in owner.projectiles){
				if(!first_arrow){ first_arrow = A}
				else{
					del first_arrow
					break
					}
				}
			}
		Del(){
			if(current_time <= 5){
				owner.icon_state = null
				}
			. = ..()
			}
		}
	needle{
		parent_type = /game/hero/custom/joram/dart
		max_range = 0
		icon_state = "needle"
		long_width = 9
		impact(var/game/enemy/target){
			target.intelligence = new /game/map/mover/intelligence.freezer(48)
			. = ..()
			}
		}
	chakram{
		parent_type = /game/hero/projectile
		icon = 'joram.dmi'
		icon_state = "chakram"
		height = 12
		width  = 12
		x_offset = -1
		y_offset = -1
		persistent = TRUE
		max_time = 176
		potency = 1
		movement = MOVEMENT_WATER | MOVEMENT_LAND
		var{
			hurting = 0
			speed = 5
			bounced = FALSE
			}
		New(){
			. = ..()
			c.x = owner.c.x + (owner.width -width )/2
			c.y = owner.c.y + (owner.height-height)/2
			switch(owner.dir){
				if(NORTH){ vel.y =  speed}
				if(SOUTH){ vel.y = -speed}
				if(EAST ){ vel.x =  speed}
				if(WEST ){ vel.x = -speed}
				}
			}
		impact(var/game/enemy/target){
			if(hurting){
				hurting--
				return
				}
			hurting = 3
			var/coord/t_c = new(target.c.x + target.width/2, target.c.y + target.height/2)
			var/coord/o_c = new(c.x + width/2, c.y + height/2)
			if(!bounced){
				first_bounce()
				}
			else{
				if(abs(t_c.x - o_c.x) >= abs(t_c.y - o_c.y)){
					horizontal_stop()
					}
				else{
					vertical_stop()
					}
				}
			. = ..()
			}
		horizontal_stop(){
			if(!bounced){
				first_bounce()
				}
			else{
				vel.x *= -1
				}
			}
		vertical_stop(){
			if(!bounced){
				first_bounce()
				}
			else{
				vel.y *= -1
				}
			}
		proc{
			first_bounce(){
				bounced = TRUE
				var/angle = 0
				switch(dir){
					if(NORTH){ angle = rand(210, 330)}
					if(SOUTH){ angle = rand( 30, 150)}
					if(EAST ){ angle = rand(120, 240)}
					if(WEST ){ angle = rand( 60, -60)}
					}
				vel.x = cos(angle)*speed
				vel.y = sin(angle)*speed
				}
			}
		}
	dart{
		parent_type = /game/hero/projectile
		max_time = 32
		icon = 'joram.dmi'
		icon_state = "dart"
		height = 3
		width  = 3
		persistent = FALSE
		potency = 1
		var{
			long_width = 8
			short_width = 3
			speed = 6
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
					height = long_width
					width = short_width
					}
				if(SOUTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = -speed
					height = long_width
					width = short_width
					}
				if(EAST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = speed
					vel.y = 0
					height = short_width
					width = long_width
					}
				if(WEST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = -speed
					vel.y = 0
					height = short_width
					width = long_width
					}
				}
			}
		}
	shoot(){
		icon_state = "attack"
		. = ..()
		}
	}