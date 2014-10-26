game/hero/subscriber/williferd{
	icon = 'williferd.dmi'
	max_health = 7
	max_aura = 16
	aura_rate = 32
	projectile_type = /game/hero/subscriber/williferd/umbrella
	skill1_cost = 8
	skill2_cost = 3
	skill1 = /game/hero/skill/willi_cast
	skill2 = /game/hero/skill/willi_leaf

	umbrella{
		parent_type = /game/map/mover/projectile/sword
		icon = 'williferd.dmi'
		impact(var/game/map/mover/combatant/target){
			owner.attack(target, potency)
			}
		potency = 1
		state_name = "umbrella"
		behavior(){
			stage++
			dir = owner.dir
			owner.icon_state = "attack"
			switch(stage){
				if(1,5){
					icon_state = "[state_name]_6"
					switch(dir){
						if(NORTH, SOUTH){
							height = 6
							width  = 5
							}
						if( EAST,  WEST){
							height = 5
							width  = 6
							}
						}
					}
				if(2,4){
					icon_state = "[state_name]_11"
					switch(dir){
						if(NORTH, SOUTH){
							height = 11
							width  = 11
							}
						if( EAST,  WEST){
							height = 11
							width  = 11
							}
						}
					}
				if(3){
					icon_state = "[state_name]_16"
					switch(dir){
						if(NORTH, SOUTH){
							height = 16
							width  = 15
							}
						if( EAST,  WEST){
							height = 15
							width  = 16
							}
						}
					}
				if(6){
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
		}
	small{
		parent_type = /game/hero/projectile
		icon = 'williferd.dmi'
		icon_state = "small"
		width = 7
		height = 9
		persistent = TRUE
		var{
			walking
			speed = 1
			}
		New(){
			. = ..()
			c.x = pick(1, (world.maxx-1)*TILE_HEIGHT)
			c.y = pick(1, (world.maxy-1)*TILE_HEIGHT)
			}
		behavior(){
			if(!owner){ del src}
			var/home = collision_check(owner)
			if(walking && home){
				walking = FALSE
				return
				}
			if(!home && (walking || rand()*48 > 47)){
				walking = TRUE
				var/trans_x = sign((owner.c.x+(owner.width /2)) - (c.x+(width /2)))
				var/trans_y = sign((owner.c.y+(owner.height/2)) - (c.y+(height/2)))
				px_move(trans_x * speed, trans_y * speed)
				}
			}
		}
	tiny{
		parent_type = /game/hero/projectile
		icon = 'williferd.dmi'
		icon_state = "tiny"
		width = 5
		height = 7
		persistent = TRUE
		var{
			walking
			speed = 1
			}
		New(){
			. = ..()
			c.x = pick(1, (world.maxx-1)*TILE_HEIGHT)
			c.y = pick(1, (world.maxy-1)*TILE_HEIGHT)
			}
		behavior(){
			if(!owner){ del src}
			var/home = collision_check(owner)
			if(walking && home){
				walking = FALSE
				return
				}
			if(!home && (walking || rand()*48 > 47)){
				walking = TRUE
				var/trans_x = sign((owner.c.x+(owner.width /2)) - (c.x+(width /2)))
				var/trans_y = sign((owner.c.y+(owner.height/2)) - (c.y+(height/2)))
				px_move(trans_x * speed, trans_y * speed)
				}
			}
		}
	leaf{
		parent_type = /game/hero/projectile
		icon = 'williferd.dmi'
		icon_state = "leaf"
		width = 12
		height = 5
		max_time = 32
		var{
			speed = 2
			}
		New(){
			. = ..()
			c.y += TILE_HEIGHT
			var/angle = rand(0,360)
			vel.x = cos(angle)*speed
			vel.y = sin(angle)*speed
			}
		}
	}
game/hero/subscriber/dracula{
	name="Dracula"
	icon = 'dracula.dmi'
	projectile_type = /game/hero/projectile/wood_sword
	max_aura = 256
	aura_rate = 1
	max_health = 8
	skill1 = /game/hero/skill/drac_bat

	adjust_aura(amo){
		if(bat){
			if(amo > 0){ return}
			else{
				. = ..()
				if(aura <= 0){
					bat = FALSE
					projectile_type = initial(projectile_type)
					icon_state = null
					height = initial(height)
					movement = MOVEMENT_LAND
					speed = initial(speed)
					}
				}
			return
			}
		. = ..()
		}
	behavior(){
		. = ..()
		if(bat){
			adjust_aura(-1)
			}
		}
	}